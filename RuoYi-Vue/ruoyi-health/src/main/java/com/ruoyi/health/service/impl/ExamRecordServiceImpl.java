package com.ruoyi.health.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.health.mapper.AiAssessmentMapper;
import com.ruoyi.health.mapper.ExamItemMapper;
import com.ruoyi.health.mapper.ExamRecordMapper;
import com.ruoyi.health.domain.ExamItem;
import com.ruoyi.health.domain.ExamRecord;
import com.ruoyi.health.service.IAppointmentService;
import com.ruoyi.health.service.IExamRecordService;
import com.ruoyi.health.service.IAiAssessmentService;
import com.ruoyi.health.service.IHealthArchiveService;

/**
 * 体检记录Service业务层处理
 *
 * @author shang
 * @date 2026-11-11
 */
@Service
public class ExamRecordServiceImpl implements IExamRecordService
{
    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private ExamItemMapper examItemMapper;

    @Autowired
    private IAppointmentService appointmentService;

    @Autowired
    private IHealthArchiveService healthArchiveService;

    /**
     * 同一学生同一天只能有一条体检记录。
     *
     * 为什么业务层要查一遍：数据库虽然有 student_id + exam_date 唯一索引兜底，
     * 但撞索引抛的是底层 DuplicateKeyException，用户看到的是一堆英文堆栈。
     * 先在业务层拦住，才能给出"该学生当天已有体检记录"这种说得清的提示。
     *
     * @param studentId 学生ID
     * @param examDate  体检日期
     * @param excludeId 修改时要排除的记录ID（新增传 null）
     */
    private void checkDuplicate(Long studentId, java.util.Date examDate, Long excludeId)
    {
        if (studentId == null || examDate == null)
        {
            return;
        }
        ExamRecord query = new ExamRecord();
        query.setStudentId(studentId);
        query.setExamDate(examDate);
        for (ExamRecord exists : examRecordMapper.selectExamRecordList(query))
        {
            if (!exists.getId().equals(excludeId))
            {
                throw new ServiceException("该学生当天已有体检记录，请勿重复登记；如需修改请在历史体检记录中编辑");
            }
        }
    }

    @Autowired
    private IAiAssessmentService aiAssessmentService;

    @Autowired
    private AiAssessmentMapper aiAssessmentMapper;

    /**
     * 查询体检记录
     * 
     * @param id 体检记录主键
     * @return 体检记录
     */
    @Override
    public ExamRecord selectExamRecordById(Long id)
    {
        return examRecordMapper.selectExamRecordById(id);
    }

    /**
     * 查询体检记录列表
     * 
     * @param examRecord 体检记录
     * @return 体检记录
     */
    @Override
    // 学生角色数据权限为"仅本人"，必须给 userAlias，否则 DataScopeAspect 拼出 s.dept_id=0，学生查不到自己的记录
    @DataScope(deptAlias = "s", userAlias = "s")
    public List<ExamRecord> selectExamRecordList(ExamRecord examRecord)
    {
        return examRecordMapper.selectExamRecordList(examRecord);
    }

    /**
     * 新增体检记录
     *
     * 加事务：体检记录落库和"预约状态置为已完成"必须一起成功，
     * 否则会出现"体检录了但学生那边还显示待体检"。
     *
     * @param examRecord 体检记录
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertExamRecord(ExamRecord examRecord)
    {
        if (examRecord.getStudentId() == null)
        {
            throw new ServiceException("请选择学生");
        }
        // 同一学生同一天只能登记一次：业务层先拦，给人话提示（数据库唯一索引兜底）
        checkDuplicate(examRecord.getStudentId(), examRecord.getExamDate(), null);

        // BMI 自动计算 + 异常标记自动判定
        autoCalculate(examRecord);

        // 记录状态：前端点"暂存"传 1（录入中），正常保存一律视为已完成
        if (examRecord.getRecordStatus() == null || examRecord.getRecordStatus().isEmpty())
        {
            examRecord.setRecordStatus("2");
        }

        // 体检人员 = 当前登录账号（文档表5 examiner_id）
        // 由后端从登录态取，前端传什么都不采信，避免"谁录的"被伪造
        examRecord.setExaminerId(SecurityUtils.getUserId());

        examRecord.setCreateTime(DateUtils.getNowDate());
        int rows = examRecordMapper.insertExamRecord(examRecord);

        // 流程闭环①：体检录完 → 对应预约「已预约」变「已完成」（没有预约记录时内部直接跳过）
        appointmentService.finishByExamRecord(examRecord.getStudentId(), examRecord.getBatchId());

        // 流程闭环②：档案快照跟着重算，次数/最近日期/摘要/状态一次更新到位
        healthArchiveService.refresh(examRecord.getStudentId());

        // 流程闭环③：录完的体检记录挂一条「待评估」AI 任务（暂存的不挂，数据还没录完）
        if ("2".equals(examRecord.getRecordStatus()))
        {
            aiAssessmentService.createPendingTask(examRecord.getStudentId(), examRecord.getId());
        }
        return rows;
    }


    /**
     * 修改体检记录
     * 
     * @param examRecord 体检记录
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateExamRecord(ExamRecord examRecord)
    {
        // 改学生或改日期都可能撞上"同学生同日期已有记录"，同样要查（排除自己）
        checkDuplicate(examRecord.getStudentId(), examRecord.getExamDate(), examRecord.getId());

        // 修改时同样重算，防止改了身高体重后 BMI / 异常标记还是旧值
        autoCalculate(examRecord);

        // 修改不改"体检人员"：谁录的就是谁，后面另一个校医改了也不能顶替
        examRecord.setExaminerId(null);

        examRecord.setUpdateTime(DateUtils.getNowDate());
        int rows = examRecordMapper.updateExamRecord(examRecord);

        // 修改弹窗不一定回传 batchId，用库里的值兜底，保证状态回写不会漏
        ExamRecord saved = examRecordMapper.selectExamRecordById(examRecord.getId());
        if (saved != null)
        {
            appointmentService.finishByExamRecord(saved.getStudentId(), saved.getBatchId());
            healthArchiveService.refresh(saved.getStudentId());
            // 体检数据变了，基于旧数据的 AI 报告就"过期"了：把已完成的报告打回待评估，
            // 待评估/评估中的任务本来就会重跑。放在 createPendingTask 之前，两条逻辑互补。
            aiAssessmentService.invalidateIfAssessed(saved.getId());
            // 从"录入中"改成"已完成"时补挂待评估任务（已经有任务的内部会跳过）
            if (!"1".equals(saved.getRecordStatus()))
            {
                aiAssessmentService.createPendingTask(saved.getStudentId(), saved.getId());
            }
        }
        return rows;
    }

    /**
     * 自动计算：BMI 指数、BMI 等级（中国成人标准）、异常标记
     * 
     * 异常判定分两条路：
     * 1. 有体检项目配置时，按「体检项目管理」里配的参考范围判 —— 改配置，判定结果就跟着变；
     * 2. 表里一条配置都没有时（比如刚导入空库），回退到内置阈值 BMI≥24 / 收缩压≥140 / 舒张压≥90，
     *    保证系统不会因为少配了数据就"永远不报异常"。
     */
    private void autoCalculate(ExamRecord examRecord)
    {
        if (examRecord.getHeight() == null || examRecord.getWeight() == null)
        {
            throw new ServiceException("身高和体重不能为空");
        }
        double h = examRecord.getHeight().doubleValue() / 100;          // cm 转 m
        double bmiValue = examRecord.getWeight().doubleValue() / (h * h);
        examRecord.setBmi(BigDecimal.valueOf(bmiValue).setScale(1, RoundingMode.HALF_UP));

        String bmiLevel;
        if (bmiValue < 18.5)
        {
            bmiLevel = "0";   // 偏低
        }
        else if (bmiValue < 24)
        {
            bmiLevel = "1";   // 正常
        }
        else if (bmiValue < 28)
        {
            bmiLevel = "2";   // 超重
        }
        else
        {
            bmiLevel = "3";   // 肥胖
        }
        examRecord.setBmiLevel(bmiLevel);

        // BMI 先算好再判异常：判定要拿 bmi 字段的值去比参考范围，顺序不能反
        List<ExamItem> items = examItemMapper.selectEnabledExamItemList();
        boolean abnormal = items.isEmpty()
                ? judgeByDefaultThreshold(examRecord)
                : judgeByItemConfig(examRecord, items);
        examRecord.setAbnormalFlag(abnormal ? "1" : "0");
    }

    /**
     * 按体检项目配置判定异常。
     * 
     * 规则说明（abnormal_rule）：
     * 0 高于上限算异常 / 1 低于下限算异常 / 2 超出上下限任一算异常 / 3 仅展示不判定。
     * 所以把 BMI 或血压项目停用、或者把规则改成 3，这个指标就不再影响异常标记 —— 这是"配置驱动"的直接体现。
     *
     * @param examRecord 体检记录（BMI 已算好）
     * @param items      启用的体检项目
     * @return 是否存在异常
     */
    private boolean judgeByItemConfig(ExamRecord examRecord, List<ExamItem> items)
    {
        boolean abnormal = false;
        for (ExamItem item : items)
        {
            BigDecimal value = pickValue(examRecord, item.getFieldKey());
            if (value == null)
            {
                // 这条记录没录这个指标（比如没量视力），跳过，不能当成异常
                continue;
            }

            String rule = item.getAbnormalRule();
            BigDecimal min = item.getReferenceMin();
            BigDecimal max = item.getReferenceMax();
            boolean over = max != null && value.compareTo(max) > 0;
            boolean under = min != null && value.compareTo(min) < 0;

            if ("0".equals(rule) && over)
            {
                abnormal = true;
            }
            else if ("1".equals(rule) && under)
            {
                abnormal = true;
            }
            else if ("2".equals(rule) && (over || under))
            {
                abnormal = true;
            }
            // rule = 3：只展示，不参与判定
        }
        return abnormal;
    }

    /**
     * 取体检记录里某个字段的值。
     * 用 field_key 而不是列序号，是为了配置表里能一眼看出"这个项目对应哪个字段"。
     *
     * @param record   体检记录
     * @param fieldKey 字段名
     * @return 指标值，字段不存在或没录入时返回 null
     */
    private BigDecimal pickValue(ExamRecord record, String fieldKey)
    {
        if (fieldKey == null)
        {
            return null;
        }
        switch (fieldKey)
        {
            case "height":
                return record.getHeight();
            case "weight":
                return record.getWeight();
            case "bmi":
                return record.getBmi();
            case "systolic_pressure":
                return toDecimal(record.getSystolicPressure());
            case "diastolic_pressure":
                return toDecimal(record.getDiastolicPressure());
            case "heart_rate":
                return toDecimal(record.getHeartRate());
            case "vision_left":
                return record.getVisionLeft();
            case "vision_right":
                return record.getVisionRight();
            default:
                return null;
        }
    }

    private BigDecimal toDecimal(Long value)
    {
        return value == null ? null : BigDecimal.valueOf(value);
    }

    /**
     * 兜底判定：体检项目表为空时使用原有的硬编码阈值
     * 规则：BMI 达到超重(2)/肥胖(3)，或收缩压 ≥ 140mmHg，或舒张压 ≥ 90mmHg
     */
    private boolean judgeByDefaultThreshold(ExamRecord examRecord)
    {
        String bmiLevel = examRecord.getBmiLevel();
        return "2".equals(bmiLevel) || "3".equals(bmiLevel)
                || (examRecord.getSystolicPressure() != null && examRecord.getSystolicPressure() >= 140)
                || (examRecord.getDiastolicPressure() != null && examRecord.getDiastolicPressure() >= 90);
    }

    /**
     * 批量删除体检记录
     * 
     * @param ids 需要删除的体检记录主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteExamRecordByIds(Long[] ids)
    {
        // 先记下这些记录属于哪些学生，删完才能重算档案（删完就查不到归属了）
        java.util.Set<Long> studentIds = new java.util.HashSet<>();
        for (Long id : ids)
        {
            ExamRecord r = examRecordMapper.selectExamRecordById(id);
            if (r != null && r.getStudentId() != null)
            {
                studentIds.add(r.getStudentId());
            }
        }
        int rows = examRecordMapper.deleteExamRecordByIds(ids);
        // 评估结果挂在体检记录上，记录删了必须一起清掉，否则 AI 报告页会出现"找不到体检记录"的孤儿行
        for (Long id : ids)
        {
            aiAssessmentMapper.deleteAiAssessmentByRecordId(id);
        }
        for (Long studentId : studentIds)
        {
            healthArchiveService.refresh(studentId);
        }
        return rows;
    }

    /**
     * 删除体检记录信息
     * 
     * @param id 体检记录主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteExamRecordById(Long id)
    {
        ExamRecord r = examRecordMapper.selectExamRecordById(id);
        int rows = examRecordMapper.deleteExamRecordById(id);
        aiAssessmentMapper.deleteAiAssessmentByRecordId(id);
        if (r != null && r.getStudentId() != null)
        {
            healthArchiveService.refresh(r.getStudentId());
        }
        return rows;
    }
}
