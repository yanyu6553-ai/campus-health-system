package com.ruoyi.health.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 体检批次对象 ch_exam_batch
 * 
 * @author shang
 * @date 2026-11-11
 */
public class ExamBatch extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 批次ID */
    private Long id;

    /** 批次名称 */
    @Excel(name = "批次名称")
    private String batchName;

    /** 批次开始时间（文档表3 start_time） */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 批次结束时间（文档表3 end_time） */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /**
     * 体检日期
     * 由 startTime 的日期部分派生，不需要人工填写；
     * 保留这一列是为了预约列表、体检记录、首页统计都能直接按"哪一天"过滤。
     */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "体检日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date examDate;

    /** 体检地点 */
    @Excel(name = "体检地点")
    private String location;

    /** 名额上限 */
    @Excel(name = "名额上限")
    private Long capacity;

    /** 已预约人数 */
    @Excel(name = "已预约人数")
    private Long bookedCount;

    /** 状态（0未开始 1预约中 2已结束） */
    @Excel(name = "状态", readConverterExp = "0=未开始,1=预约中,2=已结束")
    private String status;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setBatchName(String batchName) 
    {
        this.batchName = batchName;
    }

    public String getBatchName() 
    {
        return batchName;
    }

    public void setStartTime(Date startTime) 
    {
        this.startTime = startTime;
    }

    public Date getStartTime() 
    {
        return startTime;
    }

    public void setEndTime(Date endTime) 
    {
        this.endTime = endTime;
    }

    public Date getEndTime() 
    {
        return endTime;
    }

    public void setExamDate(Date examDate) 
    {
        this.examDate = examDate;
    }

    public Date getExamDate() 
    {
        return examDate;
    }

    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }

    public void setCapacity(Long capacity) 
    {
        this.capacity = capacity;
    }

    public Long getCapacity() 
    {
        return capacity;
    }

    public void setBookedCount(Long bookedCount) 
    {
        this.bookedCount = bookedCount;
    }

    public Long getBookedCount() 
    {
        return bookedCount;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("batchName", getBatchName())
            .append("startTime", getStartTime())
            .append("endTime", getEndTime())
            .append("examDate", getExamDate())
            .append("location", getLocation())
            .append("capacity", getCapacity())
            .append("bookedCount", getBookedCount())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
