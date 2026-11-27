package com.ruoyi.health.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 学生信息对象 Student
 * 
 * @author ruoyi
 * @date 2026-11-10
 */
public class Student extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联若依用户ID */
    @Excel(name = "关联若依用户ID")
    private Long userId;

    /** 学号 */
    @Excel(name = "学号")
    private String studentNo;

    /** 姓名 */
    @Excel(name = "姓名")
    private String studentName;

    /** 性别（0男 1女 2未知） */
    @Excel(name = "性别", readConverterExp = "0=男,1=女,2=未知")
    private String gender;

    /** 出生日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "出生日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date birthday;

    /** 学院 */
    @Excel(name = "学院")
    private String college;

    /** 专业 */
    @Excel(name = "专业")
    private String major;

    /** 班级 */
    @Excel(name = "班级")
    private String className;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String phone;

    /** 入学年份 */
    @Excel(name = "入学年份")
    private String enrollYear;

    /** 归属部门（班级）：用于辅导员的数据范围过滤 */
    private Long deptId;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /**
     * 新增时是否同时开登录账号（非表字段）
     *
     * 文档 2.2 的学生字段里没有"关联若依用户ID"，那是技术字段，不该让用户填。
     * 改成勾选"同时创建登录账号"：账号 = 学号，初始密码 = 123456，
     * 由后端建 sys_user 并分配学生角色，再把 user_id 回写到学生身上。
     */
    private Boolean createAccount;

    /** 开通的账号名（非表字段，仅返回给前端提示用） */
    private String accountName;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
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

    public void setGender(String gender) 
    {
        this.gender = gender;
    }

    public String getGender() 
    {
        return gender;
    }

    public void setBirthday(Date birthday) 
    {
        this.birthday = birthday;
    }

    public Date getBirthday() 
    {
        return birthday;
    }

    public void setCollege(String college) 
    {
        this.college = college;
    }

    public String getCollege() 
    {
        return college;
    }

    public void setMajor(String major) 
    {
        this.major = major;
    }

    public String getMajor() 
    {
        return major;
    }

    public void setClassName(String className) 
    {
        this.className = className;
    }

    public String getClassName() 
    {
        return className;
    }

    public void setPhone(String phone) 
    {
        this.phone = phone;
    }

    public String getPhone() 
    {
        return phone;
    }

    public String getEnrollYear()
    {
        return enrollYear;
    }

    public void setEnrollYear(String enrollYear)
    {
        this.enrollYear = enrollYear;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }
    public String getStatus() 
    {
        return status;
    }

    public void setCreateAccount(Boolean createAccount)
    {
        this.createAccount = createAccount;
    }

    public Boolean getCreateAccount()
    {
        return createAccount;
    }

    public void setAccountName(String accountName)
    {
        this.accountName = accountName;
    }

    public String getAccountName()
    {
        return accountName;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("userId", getUserId())
            .append("studentNo", getStudentNo())
            .append("studentName", getStudentName())
            .append("gender", getGender())
            .append("birthday", getBirthday())
            .append("college", getCollege())
            .append("major", getMajor())
            .append("className", getClassName())
            .append("phone", getPhone())
            .append("enrollYear", getEnrollYear())
            .append("deptId", getDeptId())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
