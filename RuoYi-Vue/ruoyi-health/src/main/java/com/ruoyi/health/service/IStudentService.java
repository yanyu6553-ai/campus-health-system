package com.ruoyi.health.service;

import java.util.List;
import com.ruoyi.health.domain.Student;

/**
 * 学生信息Service接口
 * 
 * @author ruoyi
 * @date 2026-11-10
 */
public interface IStudentService 
{
    /**
     * 查询学生信息
     * 
     * @param id 学生信息主键
     * @return 学生信息
     */
    public Student selectStudentById(Long id);

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
     * 批量删除学生信息
     * 
     * @param ids 需要删除的学生信息主键集合
     * @return 结果
     */
    public int deleteStudentByIds(Long[] ids);

    /**
     * 删除学生信息信息
     * 
     * @param id 学生信息主键
     * @return 结果
     */
    public int deleteStudentById(Long id);

    /**
     * 导入学生数据
     * 
     * @param studentList   学生数据列表（从 Excel 解析出来的）
     * @param isUpdateSupport 是否允许覆盖已存在的学号
     * @param operName      操作人（写进 create_by / update_by，方便追责）
     * @return 导入结果提示
     */
    public String importStudent(List<Student> studentList, boolean isUpdateSupport, String operName);

    /**
     * 取当前登录账号绑定的学生档案
     *
     * 学生端接口统一用它来确定"我是谁"：先由登录态拿 userId，再反查 ch_student。
     * 好处是前端即使伪造 studentId 也越不了权 —— 后端根本不看这个参数。
     *
     * @return 学生信息
     * @throws com.ruoyi.common.exception.ServiceException 当前账号未绑定学生档案时抛出
     */
    public Student selectCurrentStudent();
}
