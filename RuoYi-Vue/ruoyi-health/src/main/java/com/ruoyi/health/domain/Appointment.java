package com.ruoyi.health.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 体检预约对象 ch_appointment
 * 
 * @author shang
 * @date 2026-11-11
 */
public class Appointment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 预约ID */
    private Long id;

    /** 学生ID（ch_student.id） */
    @Excel(name = "学生ID", readConverterExp = "c=h_student.id")
    private Long studentId;

    /** 批次ID（ch_exam_batch.id） */
    @Excel(name = "批次ID", readConverterExp = "c=h_exam_batch.id")
    private Long batchId;

    /** 预约提交时间（文档表4 appointment_time） */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "预约提交时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date appointmentTime;

    /** 状态（0待审核 1已通过 2已拒绝 3已取消） */
    @Excel(name = "状态", readConverterExp = "0=待审核,1=已通过,2=已拒绝,3=已取消")
    private String status;

    /** 审核人员（sys_user.user_id，文档表4 audit_user） */
    private Long auditUser;

    /** 审核人员姓名（联表查询，非表字段） */
    @Excel(name = "审核人")
    private String auditUserName;

    /** 审核时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "审核时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date auditTime;

    /** 审核备注（拒绝时写原因，通过时也可留说明；文档表4 audit_remark） */
    @Excel(name = "审核备注")
    private String auditRemark;

    /** 学号（联表查询，非表字段） */
    @Excel(name = "学号")
    private String studentNo;

    /** 学生姓名（联表查询，非表字段） */
    @Excel(name = "学生姓名")
    private String studentName;

    /** 批次名称（联表查询，非表字段） */
    @Excel(name = "体检批次")
    private String batchName;

    /** 体检日期（联表查询，非表字段） */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "体检日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date examDate;

    /** 批次容量（联表查询，非表字段） */
    private Long batchCapacity;

    /** 批次已约人数（联表查询，非表字段） */
    private Long batchBooked;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setStudentId(Long studentId) 
    {
        this.studentId = studentId;
    }

    public Long getStudentId() 
    {
        return studentId;
    }

    public void setBatchId(Long batchId) 
    {
        this.batchId = batchId;
    }

    public Long getBatchId() 
    {
        return batchId;
    }

    public void setAppointmentTime(Date appointmentTime) 
    {
        this.appointmentTime = appointmentTime;
    }

    public Date getAppointmentTime() 
    {
        return appointmentTime;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setAuditUser(Long auditUser) 
    {
        this.auditUser = auditUser;
    }

    public Long getAuditUser() 
    {
        return auditUser;
    }

    public void setAuditUserName(String auditUserName) 
    {
        this.auditUserName = auditUserName;
    }

    public String getAuditUserName() 
    {
        return auditUserName;
    }

    public void setAuditTime(Date auditTime) 
    {
        this.auditTime = auditTime;
    }

    public Date getAuditTime() 
    {
        return auditTime;
    }

    public void setAuditRemark(String auditRemark) 
    {
        this.auditRemark = auditRemark;
    }

    public String getAuditRemark() 
    {
        return auditRemark;
    }

    public void setStudentNo(String studentNo) 
    {
        this.studentNo = studentNo;
    }

    public String getStudentNo() 
    {
        return studentNo;
    }

    public void setStudentName(String studentName) 
    {
        this.studentName = studentName;
    }

    public String getStudentName() 
    {
        return studentName;
    }

    public void setBatchName(String batchName) 
    {
        this.batchName = batchName;
    }

    public String getBatchName() 
    {
        return batchName;
    }

    public void setExamDate(Date examDate) 
    {
        this.examDate = examDate;
    }

    public Date getExamDate() 
    {
        return examDate;
    }

    public void setBatchCapacity(Long batchCapacity) 
    {
        this.batchCapacity = batchCapacity;
    }

    public Long getBatchCapacity() 
    {
        return batchCapacity;
    }

    public void setBatchBooked(Long batchBooked) 
    {
        this.batchBooked = batchBooked;
    }

    public Long getBatchBooked() 
    {
        return batchBooked;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("studentId", getStudentId())
            .append("batchId", getBatchId())
            .append("appointmentTime", getAppointmentTime())
            .append("status", getStatus())
            .append("auditUser", getAuditUser())
            .append("auditTime", getAuditTime())
            .append("auditRemark", getAuditRemark())
            .append("studentNo", getStudentNo())
            .append("studentName", getStudentName())
            .append("batchName", getBatchName())
            .append("examDate", getExamDate())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
