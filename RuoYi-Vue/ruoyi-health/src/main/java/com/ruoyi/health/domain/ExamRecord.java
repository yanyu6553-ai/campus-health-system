package com.ruoyi.health.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 体检记录对象 ch_exam_record
 * 
 * @author shang
 * @date 2026-11-11
 */
public class ExamRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long id;

    /** 学生ID（关联ch_student.id） */
    @Excel(name = "学生ID", readConverterExp = "关=联ch_student.id")
    private Long studentId;

    /** 体检批次ID（关联ch_exam_batch.id） */
    private Long batchId;

    /** 体检日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "体检日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date examDate;

    /** 身高(cm) */
    @Excel(name = "身高(cm)")
    private BigDecimal height;

    /** 体重(kg) */
    @Excel(name = "体重(kg)")
    private BigDecimal weight;

    /** BMI指数（自动计算） */
    @Excel(name = "BMI指数", readConverterExp = "自=动计算")
    private BigDecimal bmi;

    /** BMI等级（0偏低 1正常 2超重 3肥胖） */
    @Excel(name = "BMI等级", readConverterExp = "0=偏低,1=正常,2=超重,3=肥胖")
    private String bmiLevel;

    /** 收缩压(mmHg) */
    @Excel(name = "收缩压(mmHg)")
    private Long systolicPressure;

    /** 舒张压(mmHg) */
    @Excel(name = "舒张压(mmHg)")
    private Long diastolicPressure;

    /** 心率(次/分)（文档表5 heart_rate） */
    @Excel(name = "心率(次/分)")
    private Long heartRate;

    /** 左眼视力 */
    @Excel(name = "左眼视力")
    private BigDecimal visionLeft;

    /** 右眼视力 */
    @Excel(name = "右眼视力")
    private BigDecimal visionRight;

    /** 异常标记（0正常 1异常，系统自动判定） */
    private String abnormalFlag;

    /** 记录状态（0未登记 1录入中 2已完成） */
    @Excel(name = "记录状态", readConverterExp = "0=未登记,1=录入中,2=已完成")
    private String recordStatus;

    /** 体检小结 */
    @Excel(name = "体检小结")
    private String conclusion;

    /** 体检人员（sys_user.user_id，文档表5 examiner_id；录入时自动取当前登录账号） */
    private Long examinerId;

    /** 体检人员姓名（列表展示用，来自关联查询） */
    @Excel(name = "体检人员")
    private String examinerName;

    /** 学生姓名（列表展示用，来自关联查询） */
    private String studentName;

    /** 批次名称（列表展示用，来自关联查询） */
    private String batchName;

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

    public void setExamDate(Date examDate) 
    {
        this.examDate = examDate;
    }

    public Date getExamDate() 
    {
        return examDate;
    }

    public void setHeight(BigDecimal height) 
    {
        this.height = height;
    }

    public BigDecimal getHeight() 
    {
        return height;
    }

    public void setWeight(BigDecimal weight) 
    {
        this.weight = weight;
    }

    public BigDecimal getWeight() 
    {
        return weight;
    }

    public void setBmi(BigDecimal bmi) 
    {
        this.bmi = bmi;
    }

    public BigDecimal getBmi() 
    {
        return bmi;
    }

    public void setBmiLevel(String bmiLevel) 
    {
        this.bmiLevel = bmiLevel;
    }

    public String getBmiLevel() 
    {
        return bmiLevel;
    }

    public void setSystolicPressure(Long systolicPressure) 
    {
        this.systolicPressure = systolicPressure;
    }

    public Long getSystolicPressure() 
    {
        return systolicPressure;
    }

    public void setDiastolicPressure(Long diastolicPressure) 
    {
        this.diastolicPressure = diastolicPressure;
    }

    public Long getDiastolicPressure() 
    {
        return diastolicPressure;
    }

    public void setHeartRate(Long heartRate) 
    {
        this.heartRate = heartRate;
    }

    public Long getHeartRate() 
    {
        return heartRate;
    }

    public void setVisionLeft(BigDecimal visionLeft) 
    {
        this.visionLeft = visionLeft;
    }

    public BigDecimal getVisionLeft() 
    {
        return visionLeft;
    }

    public void setVisionRight(BigDecimal visionRight) 
    {
        this.visionRight = visionRight;
    }

    public BigDecimal getVisionRight()
    {
        return visionRight;
    }

    public void setAbnormalFlag(String abnormalFlag)
    {
        this.abnormalFlag = abnormalFlag;
    }

    public String getAbnormalFlag()
    {
        return abnormalFlag;
    }

    public String getRecordStatus()
    {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus)
    {
        this.recordStatus = recordStatus;
    }

    public void setConclusion(String conclusion) 
    {
        this.conclusion = conclusion;
    }

    public String getConclusion()
    {
        return conclusion;
    }

    public void setExaminerId(Long examinerId)
    {
        this.examinerId = examinerId;
    }

    public Long getExaminerId()
    {
        return examinerId;
    }

    public void setExaminerName(String examinerName)
    {
        this.examinerName = examinerName;
    }

    public String getExaminerName()
    {
        return examinerName;
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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("studentId", getStudentId())
            .append("batchId", getBatchId())
            .append("examDate", getExamDate())
            .append("height", getHeight())
            .append("weight", getWeight())
            .append("bmi", getBmi())
            .append("bmiLevel", getBmiLevel())
            .append("systolicPressure", getSystolicPressure())
            .append("diastolicPressure", getDiastolicPressure())
            .append("heartRate", getHeartRate())
            .append("visionLeft", getVisionLeft())
            .append("visionRight", getVisionRight())
            .append("abnormalFlag", getAbnormalFlag())
            .append("recordStatus", getRecordStatus())
            .append("conclusion", getConclusion())
            .append("examinerId", getExaminerId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
