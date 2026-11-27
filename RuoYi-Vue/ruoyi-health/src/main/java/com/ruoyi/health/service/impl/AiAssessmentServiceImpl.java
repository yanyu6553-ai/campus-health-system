package com.ruoyi.health.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.health.domain.AiAssessment;
import com.ruoyi.health.domain.ExamRecord;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.mapper.AiAssessmentMapper;
import com.ruoyi.health.mapper.ExamRecordMapper;
import com.ruoyi.health.service.IAiAssessmentService;
import com.ruoyi.health.service.IStudentService;

/**
 * AI健康评估Service业务层处理
 * 
 * 设计原则（对应设计文档 2.7）：
 * 1. 指标是否异常由后端按固定标准判定，大模型只负责"解释数据 + 给建议"，不参与诊断；
 * 2. 发给模型的数据做脱敏处理，不含姓名、学号等身份信息；
 * 3. 风险等级由后端根据异常项数量决定，模型的回答只作参考，避免模型自行拔高或降低风险；
 * 4. 评估结果落库，保留模型名称与生成时间，可追溯。
 * 
 * @author ruoyi
 */
@Service
public class AiAssessmentServiceImpl implements IAiAssessmentService
{
    private static final Logger log = LoggerFactory.getLogger(AiAssessmentServiceImpl.class);

    /** 收缩压异常阈值（mmHg） */
    private static final long SYSTOLIC_LIMIT = 140L;

    /** 舒张压异常阈值（mmHg） */
    private static final long DIASTOLIC_LIMIT = 90L;

    /** 遇到偶发失败时的最多尝试次数（含首次）。免费路由落到劣质 provider 时靠重试换一家 */
    private static final int MAX_ATTEMPTS = 3;

    @Autowired
    private AiAssessmentMapper aiAssessmentMapper;

    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private IStudentService studentService;

    /**
     * ChatClient.Builder 由 Spring AI 自动配置提供。
     * 这里用 ObjectProvider 而不是直接注入：模型密钥没配时不至于让整个应用启动失败，
     * 只是"AI 评估"这一个功能不可用，其他业务模块照常运行。
     */
    @Autowired
    private ObjectProvider<ChatClient.Builder> chatClientBuilderProvider;

    /** 记录实际使用的模型名称，便于追溯（配置值兜底，调用成功后以响应里的真实模型为准） */
    @Value("${spring.ai.openai.chat.options.model:openrouter/free}")
    private String modelName;

    /**
     * 查询AI健康评估
     * 
     * @param id AI健康评估主键
     * @return AI健康评估
     */
    @Override
    public AiAssessment selectAiAssessmentById(Long id)
    {
        return aiAssessmentMapper.selectAiAssessmentById(id);
    }

    /**
     * 按体检记录查询评估结果
     * 
     * @param examRecordId 体检记录主键
     * @return AI健康评估
     */
    @Override
    public AiAssessment selectAiAssessmentByRecordId(Long examRecordId)
    {
        return aiAssessmentMapper.selectAiAssessmentByRecordId(examRecordId);
    }

    /**
     * 查询AI健康评估列表
     * 
     * @param aiAssessment AI健康评估
     * @return AI健康评估
     */
    @Override
    public List<AiAssessment> selectAiAssessmentList(AiAssessment aiAssessment)
    {
        return aiAssessmentMapper.selectAiAssessmentList(aiAssessment);
    }

    /**
     * 学生查看自己的评估记录
     *
     * 只按登录态里的学生主键过滤，不接受外部传入 studentId；
     * 未绑定学生档案的账号会由 selectCurrentStudent 抛出可读提示。
     */
    @Override
    public List<AiAssessment> selectMyAssessmentList()
    {
        Student me = studentService.selectCurrentStudent();
        AiAssessment query = new AiAssessment();
        query.setStudentId(me.getId());
        return aiAssessmentMapper.selectAiAssessmentList(query);
    }

    /**
     * 对指定体检记录生成AI健康评估
     * 
     * @param examRecordId 体检记录主键
     * @return 评估结果
     */
    @Override
    public AiAssessment assess(Long examRecordId)
    {
        if (examRecordId == null)
        {
            throw new ServiceException("请选择要评估的体检记录");
        }

        // ① 取体检数据
        ExamRecord record = examRecordMapper.selectExamRecordById(examRecordId);
        if (record == null)
        {
            // 体检记录被删了（清理演示数据 / 删学生连带删记录），评估任务却还留着。
            // 这种任务永远生成不出结果，直接清掉，别让用户反复点到同一条报错。
            aiAssessmentMapper.deleteAiAssessmentByRecordId(examRecordId);
            throw new ServiceException("该任务对应的体检记录已被删除，这条无效任务已自动清理，刷新列表即可");
        }

        // ② 模型不可用时给出明确提示，不让用户看到一堆堆栈
        ChatClient.Builder builder = chatClientBuilderProvider.getIfAvailable();
        if (builder == null)
        {
            throw new ServiceException("AI 服务未配置：请设置环境变量 OPENROUTER_API_KEY 后重启后端服务");
        }

        // ③ 后端先按固定标准判定异常，再交给模型解释
        //    风险等级也在这里就算好：它是异常项数量的直接推论，不需要等模型回答，
        //    提前算出来还能写进提示词，让模型的措辞和系统结论保持一致（否则会出现
        //    "系统判高风险、模型说轻度异常"这种自相矛盾的报告）。
        ExamFacts facts = buildFacts(record);
        String riskLevel = judgeRiskLevel(facts.abnormal.size());

        // 提示词只依赖体检数据，循环外构造一次即可，重试时复用
        String prompt = buildPrompt(facts, riskLevel);

        // ③.5 状态流转：先把这条记录标成「评估中」，页面立刻能看到"正在生成"；
        //      失败就回退——原来没有结果的回「待评估」，原来有结果的保持「评估完成」。
        AiAssessment before = aiAssessmentMapper.selectAiAssessmentByRecordId(examRecordId);
        String rollbackStatus = (before != null && before.getRiskLevel() != null) ? "2" : "0";
        markStatus(record, "1", SecurityUtils.getUsername());

        // ④ 调用大模型
        //    OpenRouter 的免费路由每次落到哪个模型、哪个 provider 由平台决定，由此带来两类偶发问题：
        //    ① 个别 provider 返回的响应体 SDK 解析不了；② 个别模型会在 JSON 前后额外写解释文字。
        //    这两类换个模型重来一次通常就好了，所以统一重试；密钥错误、超时重试也没用，直接抛给用户。
        JSONObject json = null;
        String actualModel = modelName;
        try
        {
            for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)
            {
                try
                {
                    ChatResponse response = callModel(builder, prompt, examRecordId);

                    // 免费路由每次实际落到哪个模型由平台决定，把响应里的真实模型名记下来，结果才可追溯
                    if (response.getMetadata() != null && StringUtils.isNotEmpty(response.getMetadata().getModel()))
                    {
                        actualModel = response.getMetadata().getModel();
                    }

                    json = parseJson(response.getResult().getOutput().getText(), examRecordId);
                    break;
                }
                catch (ServiceException e)
                {
                    if (attempt >= MAX_ATTEMPTS || !isRetryable(e))
                    {
                        throw e;
                    }
                    log.warn("第 {}/{} 次获取评估结果失败，重试。examRecordId={}，原因：{}",
                            attempt, MAX_ATTEMPTS, examRecordId, e.getMessage());
                }
            }
        }
        catch (ServiceException e)
        {
            // 模型不可用/返回不合格：状态回退，用户可以在页面上重试
            markStatus(record, rollbackStatus, SecurityUtils.getUsername());
            throw e;
        }

        // ⑤ 解析结构化结果
        JSONArray abnormalItems = json.getJSONArray("abnormalItems");
        JSONArray suggestions = json.getJSONArray("suggestions");

        // ⑥ 风险等级已在上一步算好，这里只落库；模型的 riskLevel 字段不采信

        String username = SecurityUtils.getUsername();
        AiAssessment bean = new AiAssessment();
        bean.setStudentId(record.getStudentId());
        bean.setExamRecordId(examRecordId);
        bean.setAssessStatus("2");
        bean.setRiskLevel(riskLevel);
        bean.setAssessmentResult(json.getString("summary"));
        bean.setAbnormalItems(abnormalItems == null ? "[]" : abnormalItems.toJSONString());
        bean.setSuggestions(suggestions == null ? "[]" : suggestions.toJSONString());
        bean.setModelName(actualModel);
        bean.setRemark(json.getString("notice"));
        bean.setUpdateBy(username);
        bean.setUpdateTime(DateUtils.getNowDate());

        // ⑦ 一条体检记录只保留一份评估结果：已有则覆盖，没有则新增
        AiAssessment old = aiAssessmentMapper.selectAiAssessmentByRecordId(examRecordId);
        if (old != null)
        {
            bean.setId(old.getId());
            aiAssessmentMapper.updateAiAssessment(bean);
        }
        else
        {
            bean.setCreateBy(username);
            bean.setCreateTime(DateUtils.getNowDate());
            aiAssessmentMapper.insertAiAssessment(bean);
        }

        return aiAssessmentMapper.selectAiAssessmentById(bean.getId());
    }

    /**
     * 体检登记后挂一条待评估任务：已存在评估记录就不重复插，避免一条体检记录挂多条任务
     */
    @Override
    public void createPendingTask(Long studentId, Long examRecordId)
    {
        if (examRecordId == null)
        {
            return;
        }
        AiAssessment exists = aiAssessmentMapper.selectAiAssessmentByRecordId(examRecordId);
        if (exists != null)
        {
            return;
        }
        AiAssessment task = new AiAssessment();
        task.setStudentId(studentId);
        task.setExamRecordId(examRecordId);
        task.setAssessStatus("0");
        task.setCreateBy(currentUsernameQuietly());
        task.setCreateTime(DateUtils.getNowDate());
        aiAssessmentMapper.insertAiAssessment(task);
    }

    /**
     * 体检记录被编辑后调用：已有「评估完成」的报告打回「待评估」。
     * 只改状态不碰结果字段——重新评估时 assess() 会整体覆盖，
     * 打回后页面上这条记录会重新出现在"待评估"列表里，校医重跑即可。
     */
    @Override
    public void invalidateIfAssessed(Long examRecordId)
    {
        if (examRecordId == null)
        {
            return;
        }
        AiAssessment exists = aiAssessmentMapper.selectAiAssessmentByRecordId(examRecordId);
        if (exists == null || !"2".equals(exists.getAssessStatus()))
        {
            return;
        }
        aiAssessmentMapper.updateAssessStatus(examRecordId, "0", currentUsernameQuietly());
    }

    /** 没有登录态时（比如脚本调用）不因为取用户名失败而中断业务 */
    private String currentUsernameQuietly()
    {
        try
        {
            return SecurityUtils.getUsername();
        }
        catch (Exception e)
        {
            return "system";
        }
    }

    /**
     * 写入评估状态。记录已存在就只改状态，不存在则先落一条空记录，
     * 这样"待评估 / 评估中 / 评估完成"三种状态在列表里都查得到。
     */
    private void markStatus(ExamRecord record, String status, String username)
    {
        AiAssessment old = aiAssessmentMapper.selectAiAssessmentByRecordId(record.getId());
        if (old != null)
        {
            aiAssessmentMapper.updateAssessStatus(record.getId(), status, username);
            return;
        }
        AiAssessment placeholder = new AiAssessment();
        placeholder.setStudentId(record.getStudentId());
        placeholder.setExamRecordId(record.getId());
        placeholder.setAssessStatus(status);
        placeholder.setCreateBy(username);
        placeholder.setCreateTime(DateUtils.getNowDate());
        aiAssessmentMapper.insertAiAssessment(placeholder);
    }

    /**
     * 批量删除AI健康评估
     * 
     * @param ids 需要删除的AI健康评估主键
     * @return 结果
     */
    @Override
    public int deleteAiAssessmentByIds(Long[] ids)
    {
        return aiAssessmentMapper.deleteAiAssessmentByIds(ids);
    }

    /**
     * 删除AI健康评估信息
     * 
     * @param id AI健康评估主键
     * @return 结果
     */
    @Override
    public int deleteAiAssessmentById(Long id)
    {
        return aiAssessmentMapper.deleteAiAssessmentById(id);
    }

    /**
     * 发起一次模型调用。
     * 网络异常、返回空内容在这里直接抛出，不再重试（重试也大概率一样慢、一样失败）；
     * 只有"内容格式不合格"由调用方决定是否再来一次。
     */
    private ChatResponse callModel(ChatClient.Builder builder, String prompt, Long examRecordId)
    {
        ChatResponse response;
        try
        {
            response = builder.build()
                    .prompt()
                    .user(prompt)
                    .call()
                    .chatResponse();
        }
        catch (Exception e)
        {
            log.error("调用大模型失败，examRecordId={}", examRecordId, e);
            // SDK 解析不了响应体（OpenRouter 个别免费 provider 会返回非标准结构），
            // 这类错误换一家 provider 重来通常就好了，单独归类以便上层重试
            if ("OpenAIInvalidDataException".equals(e.getClass().getSimpleName()))
            {
                throw new ServiceException("AI 返回数据无法解析，请重试");
            }
            throw new ServiceException("AI 服务调用失败，请稍后重试：" + e.getMessage());
        }

        if (response == null || response.getResult() == null
                || StringUtils.isEmpty(response.getResult().getOutput().getText()))
        {
            throw new ServiceException("AI 返回内容为空，请重试");
        }
        return response;
    }

    /**
     * 判断这次失败值不值得重试。
     * 只有"这次调用的运气不好"类问题才重试：响应体无法解析、内容格式不合格、返回空内容。
     * 密钥无效、网络超时、服务不可用这类重试也一样的，直接抛给用户看更省时间。
     */
    private boolean isRetryable(ServiceException e)
    {
        String msg = e.getMessage();
        if (msg == null)
        {
            return false;
        }
        return msg.contains("无法解析") || msg.contains("格式异常") || msg.contains("内容为空");
    }

    /**
     * 把体检记录整理成"系统判定后的客观事实"。
     * 注意：只输出指标值 + 系统判定结论，不输出姓名、学号等身份信息。
     */
    private ExamFacts buildFacts(ExamRecord r)
    {
        ExamFacts facts = new ExamFacts();
        StringBuilder sb = new StringBuilder();

        sb.append("身高：").append(num(r.getHeight(), "cm")).append("\n");
        sb.append("体重：").append(num(r.getWeight(), "kg")).append("\n");

        if (r.getBmi() != null)
        {
            String judge = "正常（成人参考 18.5-23.9）";
            if ("3".equals(r.getBmiLevel()))
            {
                judge = "肥胖（成人参考 ≥28）";
                facts.abnormal.add("BMI 肥胖");
            }
            else if ("2".equals(r.getBmiLevel()))
            {
                judge = "超重（成人参考 24-27.9）";
                facts.abnormal.add("BMI 超重");
            }
            else if ("0".equals(r.getBmiLevel()))
            {
                judge = "偏低（成人参考 <18.5，未达异常标准，仅作提示）";
            }
            sb.append("BMI：").append(r.getBmi()).append("（系统判定：").append(judge).append("）\n");
        }
        else
        {
            sb.append("BMI：未提供\n");
        }

        boolean bpHigh = false;
        if (r.getSystolicPressure() != null)
        {
            boolean high = r.getSystolicPressure() >= SYSTOLIC_LIMIT;
            bpHigh = bpHigh || high;
            sb.append("收缩压：").append(num(r.getSystolicPressure(), "mmHg"))
              .append("（系统判定：").append(high ? "偏高（参考 <140）" : "正常").append("）\n");
        }
        else
        {
            sb.append("收缩压：未提供\n");
        }

        if (r.getDiastolicPressure() != null)
        {
            boolean high = r.getDiastolicPressure() >= DIASTOLIC_LIMIT;
            bpHigh = bpHigh || high;
            sb.append("舒张压：").append(num(r.getDiastolicPressure(), "mmHg"))
              .append("（系统判定：").append(high ? "偏高（参考 <90）" : "正常").append("）\n");
        }
        else
        {
            sb.append("舒张压：未提供\n");
        }
        if (bpHigh)
        {
            facts.abnormal.add("血压偏高");
        }

        if (r.getHeartRate() != null)
        {
            sb.append("心率：").append(num(r.getHeartRate(), "次/分")).append("\n");
        }
        else
        {
            sb.append("心率：未提供\n");
        }

        if (r.getVisionLeft() != null || r.getVisionRight() != null)
        {
            sb.append("视力：左 ").append(num(r.getVisionLeft(), "")).append("，右 ")
              .append(num(r.getVisionRight(), "")).append("\n");
        }
        else
        {
            sb.append("视力：未提供\n");
        }

        if (StringUtils.isNotEmpty(r.getConclusion()))
        {
            sb.append("校医体检小结：").append(r.getConclusion()).append("\n");
        }

        sb.append("\n系统异常判定：")
          .append(facts.abnormal.isEmpty() ? "本次未发现异常指标" : "存在异常指标 —— " + String.join("、", facts.abnormal));

        facts.text = sb.toString();
        return facts;
    }

    /**
     * 构造提示词。要求写在提示词里而不是依赖模型"自觉"，这样输出才能稳定入库。
     * 系统已判定的风险等级也写进去，让模型的措辞和系统结论对得上。
     */
    private String buildPrompt(ExamFacts facts, String riskLevel)
    {
        return "你是一名校园健康管理辅助助手，请根据下面提供的学生体检数据进行健康信息解释。\n\n"
                + "【体检数据】（已脱敏，不含姓名、学号等身份信息）\n"
                + facts.text + "\n\n"
                + "【系统结论】本次共判定 " + facts.abnormal.size() + " 项异常，风险等级为 " + riskLevel
                + "（" + riskLevelText(riskLevel) + "）。这是系统的固定判定结果，你的解释必须与它保持一致，"
                + "不得自行调高或调低风险等级，也不要使用与之矛盾的措辞。\n\n"
                + "【要求】\n"
                + "1. 只分析上面提供的数据，不得编造不存在的体检指标。\n"
                + "2. 不得给出疾病诊断，不得判断学生是否患病。\n"
                + "3. 对系统判定为异常的指标，用通俗语言解释它意味着什么。\n"
                + "4. 提供具体、可执行的日常健康建议（饮食、运动、作息）。\n"
                + "5. 数据缺失时明确指出，不要猜测。\n"
                + "6. 若存在明显风险，应建议咨询专业医生。\n"
                + "7. 只输出一个 JSON 对象，不要输出任何解释文字，不要使用 Markdown 代码块。\n\n"
                + "【输出格式】\n"
                + "{\"summary\":\"一句话总体结论\","
                + "\"riskLevel\":\"" + riskLevel + "\","
                + "\"abnormalItems\":[{\"item\":\"指标名\",\"value\":\"实测值\",\"reference\":\"参考范围\",\"explanation\":\"通俗解释\"}],"
                + "\"suggestions\":[\"建议1\",\"建议2\",\"建议3\"],"
                + "\"notice\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\"}";
    }

    /** 把风险等级转成中文，写进提示词里引导模型用词 */
    private String riskLevelText(String riskLevel)
    {
        if ("HIGH".equals(riskLevel))
        {
            return "高风险，存在多项异常指标";
        }
        if ("MEDIUM".equals(riskLevel))
        {
            return "中风险，存在一项异常指标";
        }
        return "低风险，本次未发现异常指标";
    }

    /**
     * 解析模型返回的 JSON。模型偶尔会多包一层 ```json，这里做容错处理。
     */
    private JSONObject parseJson(String raw, Long examRecordId)
    {
        String text = raw.trim();
        if (text.startsWith("```"))
        {
            int firstLine = text.indexOf('\n');
            if (firstLine > 0)
            {
                text = text.substring(firstLine + 1);
            }
            int lastFence = text.lastIndexOf("```");
            if (lastFence >= 0)
            {
                text = text.substring(0, lastFence);
            }
            text = text.trim();
        }
        int start = text.indexOf('{');
        int end = text.lastIndexOf('}');
        if (start >= 0 && end > start)
        {
            text = text.substring(start, end + 1);
        }
        try
        {
            return JSON.parseObject(text);
        }
        catch (Exception e)
        {
            log.error("AI 返回内容无法解析为 JSON，examRecordId={}，原文={}", examRecordId, raw);
            throw new ServiceException("AI 返回内容格式异常，请重试");
        }
    }

    /**
     * 风险等级由系统按异常项数量判定，不让模型自行决定
     */
    private String judgeRiskLevel(int abnormalCount)
    {
        if (abnormalCount >= 2)
        {
            return "HIGH";
        }
        if (abnormalCount == 1)
        {
            return "MEDIUM";
        }
        return "LOW";
    }

    private String num(BigDecimal value, String unit)
    {
        if (value == null)
        {
            return "未提供";
        }
        return StringUtils.isEmpty(unit) ? value.stripTrailingZeros().toPlainString()
                : value.stripTrailingZeros().toPlainString() + " " + unit;
    }

    private String num(Long value, String unit)
    {
        if (value == null)
        {
            return "未提供";
        }
        return StringUtils.isEmpty(unit) ? String.valueOf(value) : value + " " + unit;
    }

    /**
     * 系统判定结果的载体
     */
    private static class ExamFacts
    {
        /** 给模型看的客观指标文本 */
        private String text;

        /** 系统判定的异常项名称 */
        private final List<String> abnormal = new ArrayList<>();
    }
}
