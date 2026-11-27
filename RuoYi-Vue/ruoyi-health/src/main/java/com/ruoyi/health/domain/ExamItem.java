package com.ruoyi.health.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 体检项目对象 ch_exam_item
 * 
 * 这张表是「指标配置」：项目名称、单位、参考范围都配在这里，
 * 体检登记时后端按 field_key 找到对应配置，用参考范围判断指标是否异常。
 * 
 * @author shang
 * @date 2026-11-11
 */
public class ExamItem extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 项目ID */
    private Long id;

    /** 项目编码 */
    @Excel(name = "项目编码")
    private String itemCode;

    /** 项目名称 */
    @Excel(name = "项目名称")
    private String itemName;

    /** 项目分类（字典 ch_exam_category） */
    @Excel(name = "项目分类", readConverterExp = "1=一般检查,2=循环系统,3=眼科,9=其他")
    private String category;

    /** 计量单位 */
    @Excel(name = "计量单位")
    private String unit;

    /** 对应体检记录字段名（height/weight/bmi/...） */
    @Excel(name = "对应字段")
    private String fieldKey;

    /** 参考下限 */
    @Excel(name = "参考下限")
    private BigDecimal referenceMin;

    /** 参考上限 */
    @Excel(name = "参考上限")
    private BigDecimal referenceMax;

    /** 异常判定（0高于上限 1低于下限 2超出任一 3仅展示） */
    @Excel(name = "异常判定", readConverterExp = "0=高于上限算异常,1=低于下限算异常,2=超出上下限算异常,3=仅展示不判定")
    private String abnormalRule;

    /** 项目说明 */
    @Excel(name = "项目说明")
    private String description;

    /** 状态（0启用 1停用） */
    @Excel(name = "状态", readConverterExp = "0=启用,1=停用")
    private String status;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setItemCode(String itemCode) 
    {
        this.itemCode = itemCode;
    }

    public String getItemCode() 
    {
        return itemCode;
    }

    public void setItemName(String itemName) 
    {
        this.itemName = itemName;
    }

    public String getItemName() 
    {
        return itemName;
    }

    public void setCategory(String category) 
    {
        this.category = category;
    }

    public String getCategory() 
    {
        return category;
    }

    public void setUnit(String unit) 
    {
        this.unit = unit;
    }

    public String getUnit() 
    {
        return unit;
    }

    public void setFieldKey(String fieldKey) 
    {
        this.fieldKey = fieldKey;
    }

    public String getFieldKey() 
    {
        return fieldKey;
    }

    public void setReferenceMin(BigDecimal referenceMin) 
    {
        this.referenceMin = referenceMin;
    }

    public BigDecimal getReferenceMin() 
    {
        return referenceMin;
    }

    public void setReferenceMax(BigDecimal referenceMax) 
    {
        this.referenceMax = referenceMax;
    }

    public BigDecimal getReferenceMax() 
    {
        return referenceMax;
    }

    public void setAbnormalRule(String abnormalRule) 
    {
        this.abnormalRule = abnormalRule;
    }

    public String getAbnormalRule() 
    {
        return abnormalRule;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
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
            .append("itemCode", getItemCode())
            .append("itemName", getItemName())
            .append("category", getCategory())
            .append("unit", getUnit())
            .append("fieldKey", getFieldKey())
            .append("referenceMin", getReferenceMin())
            .append("referenceMax", getReferenceMax())
            .append("abnormalRule", getAbnormalRule())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
