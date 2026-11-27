package com.ruoyi.health.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 健康档案对象 HealthArchive（对应设计文档 3.2 第 8 张表 ch_health_archive）
 *
 * 档案不是体检记录的副本，而是"一名学生的健康概况快照"：
 * 体检次数、最近体检日期、一段人话摘要、档案状态。
 * 明细仍然查 ch_exam_record，这里只存汇总口径，避免每打开一次档案就做一遍聚合计算。
 *
 * @author shang
 * @date 2026-11-11
 */
public class HealthArchive extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 学生ID */
    private Long studentId;

    /** 体检次数 */
    private Integer totalExamCount;

    /** 最近体检日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date lastExamDate;

    /** 健康摘要 */
    private String healthSummary;

    /** 档案状态（0正常 1存在异常） */
    private String archiveStatus;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public Integer getTotalExamCount()
    {
        return totalExamCount;
    }

    public void setTotalExamCount(Integer totalExamCount)
    {
        this.totalExamCount = totalExamCount;
    }

    public Date getLastExamDate()
    {
        return lastExamDate;
    }

    public void setLastExamDate(Date lastExamDate)
    {
        this.lastExamDate = lastExamDate;
    }

    public String getHealthSummary()
    {
        return healthSummary;
    }

    public void setHealthSummary(String healthSummary)
    {
        this.healthSummary = healthSummary;
    }

    public String getArchiveStatus()
    {
        return archiveStatus;
    }

    public void setArchiveStatus(String archiveStatus)
    {
        this.archiveStatus = archiveStatus;
    }
}
