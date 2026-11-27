package com.ruoyi.health.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI健康评估对象 ch_ai_assessment
 * 
 * @author ruoyi
 */
public class AiAssessment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 学生ID */
    @Excel(name = "学生ID")
    private Long studentId;

    /** 体检记录ID */
    @Excel(name = "体检记录ID")
    private Long examRecordId;

    /** 辅助风险等级（LOW/MEDIUM/HIGH） */
    @Excel(name = "辅助风险等级", readConverterExp = "LOW=低风险,MEDIUM=中风险,HIGH=高风险")
    /** 评估状态（0待评估 1评估中 2评估完成） */
    private String assessStatus;

    private String riskLevel;

    /** 评估摘要 */
    @Excel(name = "评估摘要")
    private String assessmentResult;

    /** 异常项目（JSON数组） */
    private String abnormalItems;

    /** 健康建议（JSON数组） */
    private String suggestions;

    /** 模型名称 */
    @Excel(name = "模型名称")
    private String modelName;

    /** 关联展示字段：学号 */
    private String studentNo;

    /** 关联展示字段：学生姓名 */
    @Excel(name = "学生姓名")
    private String studentName;

    /** 关联展示字段：体检日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "体检日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date examDate;

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

    public void setExamRecordId(Long examRecordId) 
    {
        this.examRecordId = examRecordId;
    }

    public Long getExamRecordId() 
    {
        return examRecordId;
    }

    public String getAssessStatus()
    {
        return assessStatus;
    }

    public void setAssessStatus(String assessStatus)
    {
        this.assessStatus = assessStatus;
    }

    public void setRiskLevel(String riskLevel) 
    {
        this.riskLevel = riskLevel;
    }

    public String getRiskLevel() 
    {
        return riskLevel;
    }

    public void setAssessmentResult(String assessmentResult) 
    {
        this.assessmentResult = assessmentResult;
    }

    public String getAssessmentResult() 
    {
        return assessmentResult;
    }

    public void setAbnormalItems(String abnormalItems) 
    {
        this.abnormalItems = abnormalItems;
    }

    public String getAbnormalItems() 
    {
        return abnormalItems;
    }

    public void setSuggestions(String suggestions) 
    {
        this.suggestions = suggestions;
    }

    public String getSuggestions() 
    {
        return suggestions;
    }

    public void setModelName(String modelName) 
    {
        this.modelName = modelName;
    }

    public String getModelName() 
    {
        return modelName;
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

    public void setExamDate(Date examDate) 
    {
        this.examDate = examDate;
    }

    public Date getExamDate() 
    {
        return examDate;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("studentId", getStudentId())
            .append("examRecordId", getExamRecordId())
            .append("riskLevel", getRiskLevel())
            .append("assessmentResult", getAssessmentResult())
            .append("abnormalItems", getAbnormalItems())
            .append("suggestions", getSuggestions())
            .append("modelName", getModelName())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
