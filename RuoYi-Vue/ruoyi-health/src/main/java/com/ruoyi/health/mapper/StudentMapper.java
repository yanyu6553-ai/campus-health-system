package com.ruoyi.health.mapper;

import java.util.List;
import com.ruoyi.health.domain.Student;

/**
 * 学生信息Mapper接口
 * 
 * @author ruoyi
 * @date 2026-11-10
 */
public interface StudentMapper 
{
    /**
     * 查询学生信息
     * 
     * @param id 学生信息主键
     * @return 学生信息
     */
    public Student selectStudentById(Long id);

    /**
     * 按系统账号ID查询学生档案
     * 学生端所有"我的数据"都先经过这一步：由登录态拿到 userId，再反查学生，
     * 而不是采信前端传来的 studentId
     *
     * @param userId 系统用户ID
     * @return 学生信息，未绑定时返回 null
     */
    public Student selectStudentByUserId(Long userId);

    /** 按班级名查归属部门（辅导员数据范围用），没有对应部门返回 null */
    public Long selectDeptIdByClassName(String className);

    /**
     * 查询学生信息列表
     * 
     * @param student 学生信息
     * @return 学生信息集合
     */
    public List<Student> selectStudentList(Student student);

    /**
     * 新增学生信息
     * 
     * @param student 学生信息
     * @return 结果
     */
    public int insertStudent(Student student);

    /**
     * 修改学生信息
     * 
     * @param student 学生信息
     * @return 结果
     */
    public int updateStudent(Student student);

    /**
     * 删除学生信息
     * 
     * @param id 学生信息主键
     * @return 结果
     */
    public int deleteStudentById(Long id);

    /**
     * 批量删除学生信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteStudentByIds(Long[] ids);
}
