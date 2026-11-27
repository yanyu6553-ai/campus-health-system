package com.ruoyi.health.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.health.domain.ExamItem;
import com.ruoyi.health.domain.ExamRecord;
import com.ruoyi.health.domain.HealthArchive;
import com.ruoyi.health.mapper.ExamItemMapper;
import com.ruoyi.health.mapper.ExamRecordMapper;
import com.ruoyi.health.mapper.HealthArchiveMapper;
import com.ruoyi.health.service.IHealthArchiveService;

/**
 * 健康档案Service业务层处理
 *
 * 设计要点：档案表只存"汇总口径"，不存指标明细。
 * 体检记录一变就重算一次，所以档案永远不会出现"次数对不上"的情况；
 * 明细仍然以 ch_exam_record 为准，档案只负责让列表页和首页少做聚合查询。
 *
 * @author shang
 * @date 2026-11-11
 */
@Service
public class HealthArchiveServiceImpl implements IHealthArchiveService
{
    private static final Logger log = LoggerFactory.getLogger(HealthArchiveServiceImpl.class);

    @Autowired
    private HealthArchiveMapper healthArchiveMapper;

    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private ExamItemMapper examItemMapper;

    @Override
    public HealthArchive selectByStudentId(Long studentId)
    {
        return healthArchiveMapper.selectByStudentId(studentId);
    }

    /**
     * 重算档案快照
     *
     * 异常项名称是按「体检项目管理」里配的判定方式和参考范围推出来的，
     * 所以改了项目配置，摘要里的措辞会跟着变（和体检记录的异常标记同一套口径）。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void refresh(Long studentId)
    {
        if (studentId == null)
        {
            return;
        }

        ExamRecord query = new ExamRecord();
        query.setStudentId(studentId);
        List<ExamRecord> records = examRecordMapper.selectExamRecordList(query);

        // 只统计"已完成"的记录：暂存（录入中）的还不算一次体检，
        // 否则校医刚点一下暂存，档案里就多出一次"完成"的体检
        List<ExamRecord> completed = new ArrayList<>();
        int draftCount = 0;
        for (ExamRecord r : records)
        {
            if ("1".equals(r.getRecordStatus()))
            {
                draftCount++;
            }
            else
            {
                completed.add(r);
            }
        }

        HealthArchive archive = new HealthArchive();
        archive.setStudentId(studentId);

        if (completed.isEmpty())
        {
            archive.setTotalExamCount(0);
            archive.setHealthSummary(draftCount > 0
                    ? "有 " + draftCount + " 条体检记录正在录入中，尚未完成。"
                    : "尚未进行体检，暂无健康数据。");
            archive.setArchiveStatus("0");
        }
        else
        {
            // 日期最新的排前面；同一天按 id 倒序，保证"最近一次"取的就是最后录入的那条
            completed.sort(Comparator
                    .comparing(ExamRecord::getExamDate, Comparator.nullsLast(Comparator.reverseOrder()))
                    .thenComparing(ExamRecord::getId, Comparator.reverseOrder()));

            ExamRecord latest = completed.get(0);
            List<String> abnormalNames = collectAbnormalItemNames(latest);
            archive.setTotalExamCount(completed.size());
            archive.setLastExamDate(latest.getExamDate());
            archive.setArchiveStatus(abnormalNames.isEmpty() ? "0" : "1");
            archive.setHealthSummary(buildSummary(completed.size(), latest, abnormalNames));
        }

        String username = currentUsername();
        archive.setCreateBy(username);
        archive.setUpdateBy(username);
        healthArchiveMapper.saveOrUpdate(archive);
    }

    /** 摘要：一段人话，档案列表和详情直接展示，不用前端再拼 */
    private String buildSummary(int total, ExamRecord latest, List<String> abnormalNames)
    {
        StringBuilder sb = new StringBuilder();
        sb.append("累计体检 ").append(total).append(" 次，最近一次 ")
          .append(DateUtils.parseDateToStr("yyyy-MM-dd", latest.getExamDate())).append("。");

        if (latest.getBmi() != null)
        {
            sb.append("BMI ").append(latest.getBmi())
              .append("（").append(bmiLevelText(latest.getBmiLevel())).append("）；");
        }
        if (latest.getSystolicPressure() != null || latest.getDiastolicPressure() != null)
        {
            sb.append("血压 ").append(nvl(latest.getSystolicPressure())).append("/")
              .append(nvl(latest.getDiastolicPressure())).append(" mmHg；");
        }
        if (latest.getHeartRate() != null)
        {
            sb.append("心率 ").append(latest.getHeartRate()).append(" 次/分；");
        }
        if (latest.getVisionLeft() != null || latest.getVisionRight() != null)
        {
            sb.append("视力 ").append(nvl(latest.getVisionLeft())).append("/")
              .append(nvl(latest.getVisionRight())).append("；");
        }

        if (abnormalNames.isEmpty())
        {
            sb.append("本次未发现异常指标。");
        }
        else
        {
            sb.append("本次判定 ").append(abnormalNames.size()).append(" 项异常：")
              .append(String.join("、", abnormalNames)).append("。");
        }
        if (latest.getConclusion() != null && !latest.getConclusion().isEmpty())
        {
            sb.append("体检小结：").append(latest.getConclusion());
        }
        return sb.toString();
    }

    /**
     * 按体检项目配置挑出异常项名称。
     * 和体检登记保存时的异常判定用同一套规则（abnormal_rule + 参考上下限），
     * 配置里设为「仅展示不判定」的项目不会出现在这里。
     */
    private List<String> collectAbnormalItemNames(ExamRecord record)
    {
        List<String> names = new ArrayList<>();
        List<ExamItem> items = examItemMapper.selectEnabledExamItemList();
        for (ExamItem item : items)
        {
            BigDecimal value = pickValue(record, item.getFieldKey());
            if (value == null)
            {
                continue;
            }
            BigDecimal min = item.getReferenceMin();
            BigDecimal max = item.getReferenceMax();
            boolean over = max != null && value.compareTo(max) > 0;
            boolean under = min != null && value.compareTo(min) < 0;

            String rule = item.getAbnormalRule();
            if ("0".equals(rule) && over)
            {
                names.add(item.getItemName());
            }
            else if ("1".equals(rule) && under)
            {
                names.add(item.getItemName());
            }
            else if ("2".equals(rule) && (over || under))
            {
                names.add(item.getItemName());
            }
        }
        return names;
    }

    /** 按 field_key 取实测值，未录入返回 null（而不是 0，避免"没量视力"被当异常） */
    private BigDecimal pickValue(ExamRecord r, String fieldKey)
    {
        if (fieldKey == null)
        {
            return null;
        }
        switch (fieldKey)
        {
            case "height":
                return r.getHeight();
            case "weight":
                return r.getWeight();
            case "bmi":
                return r.getBmi();
            case "systolic_pressure":
                return r.getSystolicPressure() == null ? null : BigDecimal.valueOf(r.getSystolicPressure());
            case "diastolic_pressure":
                return r.getDiastolicPressure() == null ? null : BigDecimal.valueOf(r.getDiastolicPressure());
            case "heart_rate":
                return r.getHeartRate() == null ? null : BigDecimal.valueOf(r.getHeartRate());
            case "vision_left":
                return r.getVisionLeft();
            case "vision_right":
                return r.getVisionRight();
            default:
                return null;
        }
    }

    private String bmiLevelText(String level)
    {
        if (level == null)
        {
            return "未判定";
        }
        switch (level)
        {
            case "0":
                return "偏低";
            case "1":
                return "正常";
            case "2":
                return "超重";
            case "3":
                return "肥胖";
            default:
                return "未判定";
        }
    }

    private Object nvl(Object v)
    {
        return v == null ? "-" : v;
    }

    /** 定时任务/后台线程调用时可能没有登录态，取不到就记成 system，不让档案刷新因为这点小事失败 */
    private String currentUsername()
    {
        try
        {
            return SecurityUtils.getUsername();
        }
        catch (Exception e)
        {
            log.debug("刷新健康档案时没有登录态，用户名记为 system");
            return "system";
        }
    }
}
