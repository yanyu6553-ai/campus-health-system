package com.ruoyi.health.service.impl;

import java.util.List;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.health.mapper.StudentMapper;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.service.IStudentService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;

/**
 * 学生信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2026-11-10
 */
@Service
public class StudentServiceImpl implements IStudentService 
{
    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private ISysUserService sysUserService;

    @Autowired
    private ISysRoleService sysRoleService;

    /** 学生自助登录账号的初始密码，学生首次登录后应修改 */
    private static final String DEFAULT_PASSWORD = "123456";

    /** 学生角色在 sys_role 里的标识 */
    private static final String STUDENT_ROLE_KEY = "student";

    /**
     * 查询学生信息
     * 
     * @param id 学生信息主键
     * @return 学生信息
     */
    @Override
    public Student selectStudentById(Long id)
    {
        return studentMapper.selectStudentById(id);
    }

    /**
     * 查询学生信息列表
     * 
     * @param student 学生信息
     * @return 学生信息
     */
    @Override
    @DataScope(deptAlias = "s")
    public List<Student> selectStudentList(Student student)
    {
        return studentMapper.selectStudentList(student);
    }

    /**
     * 新增学生信息
     * 
     * @param student 学生信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertStudent(Student student)
    {
        // 1. 校验学号是否重复
        Student query = new Student();
        query.setStudentNo(student.getStudentNo());
        List<Student> exists = studentMapper.selectStudentList(query);
        if (!exists.isEmpty())
        {
            throw new ServiceException("学号 " + student.getStudentNo() + " 已存在，请勿重复录入");
        }

        // 2. 按班级归到对应部门（辅导员的数据范围就是按它过滤的）
        applyDeptByClassName(student);

        // 3. 勾了「同时创建登录账号」就先开号，再把 user_id 写进学生档案
        //    加事务：开号成功但学生入库失败会留下一个孤儿账号，下次同学号就再也开不了
        if (Boolean.TRUE.equals(student.getCreateAccount()))
        {
            student.setUserId(createStudentAccount(student));
        }

        // 4. 正常入库
        student.setCreateTime(DateUtils.getNowDate());
        return studentMapper.insertStudent(student);
    }


    /**
     * 修改学生信息
     * 
     * @param student 学生信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateStudent(Student student)
    {
        // 换了班级就跟着换部门，否则数据权限会按旧班级过滤
        applyDeptByClassName(student);

        // 老学生补开号：还没绑定账号、又勾了「同时创建登录账号」，这里补一个
        if (Boolean.TRUE.equals(student.getCreateAccount()) && student.getUserId() == null)
        {
            student.setUserId(createStudentAccount(student));
        }

        student.setUpdateTime(DateUtils.getNowDate());
        return studentMapper.updateStudent(student);
    }

    /**
     * 给学生开一个若依登录账号
     *
     * 规则：
     *   账号 = 学号（学生记得住，管理员也不用再想名字）
     *   初始密码 = 123456（演示方便，正式环境应改成随机密码 + 首次登录强制修改）
     *   角色 = student（只看得到「我的健康」那一组菜单）
     *
     * 复用若依的 ISysUserService，而不是自己写 INSERT：
     * 用户名查重、密码 BCrypt 加密、用户-角色关联这些若依都已经做好了。
     *
     * @param student 学生信息（此时学号、姓名、部门已就绪）
     * @return 新建的 sys_user.user_id
     */
    private Long createStudentAccount(Student student)
    {
        String userName = student.getStudentNo();
        if (StringUtils.isEmpty(userName))
        {
            throw new ServiceException("学号为空，无法创建登录账号");
        }

        // 账号名全局唯一：sys_user 里已经有同名账号就不能再开，否则登录时分不清是谁
        if (sysUserService.selectUserByUserName(userName) != null)
        {
            throw new ServiceException("登录账号 " + userName + " 已被占用，请先处理该账号，或取消勾选「同时创建登录账号」");
        }

        // 找到「学生」角色。角色被删/改名时给出明确提示，而不是插一个没有角色的账号
        SysRole roleQuery = new SysRole();
        roleQuery.setRoleKey(STUDENT_ROLE_KEY);
        List<SysRole> roles = sysRoleService.selectRoleList(roleQuery);
        SysRole studentRole = null;
        for (SysRole role : roles)
        {
            // selectRoleList 的 roleKey 是 like 匹配，这里再精确比一次，避免匹配到别的角色
            if (STUDENT_ROLE_KEY.equals(role.getRoleKey()))
            {
                studentRole = role;
                break;
            }
        }
        if (studentRole == null)
        {
            throw new ServiceException("未找到角色 student，请先在「角色管理」里保留角色标识为 student 的学生角色");
        }

        SysUser user = new SysUser();
        user.setUserName(userName);
        user.setNickName(StringUtils.isEmpty(student.getStudentName()) ? userName : student.getStudentName());
        user.setDeptId(student.getDeptId());
        user.setPhonenumber(student.getPhone());
        // 若依用户表的性别约定：0 男 / 1 女 / 2 未知，与 ch_student.gender 完全一致，直接沿用
        user.setSex(student.getGender());
        user.setPassword(SecurityUtils.encryptPassword(DEFAULT_PASSWORD));
        user.setStatus("0");
        user.setCreateBy(SecurityUtils.getUsername());
        user.setRoleIds(new Long[] { studentRole.getRoleId() });

        sysUserService.insertUser(user);

        // 回给前端提示用：让管理员知道账号名是什么
        student.setAccountName(userName);
        return user.getUserId();
    }

    /**
     * 批量删除学生信息
     * 
     * @param ids 需要删除的学生信息主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteStudentByIds(Long[] ids)
    {
        // 先把要删的账号记下来，学生行删掉之后就查不到 user_id 了
        java.util.List<Long> accountIds = collectBoundAccounts(ids);
        int rows = studentMapper.deleteStudentByIds(ids);
        for (Long userId : accountIds)
        {
            deleteBoundAccount(userId);
        }
        return rows;
    }

    /**
     * 删除学生信息信息
     * 
     * @param id 学生信息主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteStudentById(Long id)
    {
        java.util.List<Long> accountIds = collectBoundAccounts(new Long[] { id });
        int rows = studentMapper.deleteStudentById(id);
        for (Long userId : accountIds)
        {
            deleteBoundAccount(userId);
        }
        return rows;
    }

    /** 收集这批学生各自绑定的 sys_user.user_id（没绑定的跳过） */
    private java.util.List<Long> collectBoundAccounts(Long[] ids)
    {
        java.util.List<Long> list = new java.util.ArrayList<>();
        for (Long id : ids)
        {
            Student s = studentMapper.selectStudentById(id);
            if (s != null && s.getUserId() != null)
            {
                list.add(s.getUserId());
            }
        }
        return list;
    }

    /**
     * 删除学生时，把当初为他开的登录账号一起删掉
     *
     * 不删会留下一个"能登录但没有任何学生档案"的僵尸账号，
     * 而且学号被永久占用，这个学生重新录入时再也开不了号。
     *
     * 两道保护：
     *   1. 绝不删 admin（user_id = 1）
     *   2. 该账号如果还绑着别的学生档案（理论上 1:1，防御性判断），就留着不删
     *
     * @param userId 账号主键
     */
    private void deleteBoundAccount(Long userId)
    {
        if (userId == null || userId == 1L)
        {
            return;
        }
        if (studentMapper.selectStudentByUserId(userId) != null)
        {
            return;
        }
        sysUserService.deleteUserById(userId);
    }

    /**
     * 导入学生数据
     * 
     * 逐行处理而不是整批插入，原因：
     * 1. 一行出错（学号重复、日期格式不对）不能让整批都失败，老师演示时更希望"导入 25 条成功、3 条失败并说明原因"；
     * 2. 每行都要查一次学号是否已存在，逐行处理逻辑最直观。
     * 
     * @param studentList     学生数据列表
     * @param isUpdateSupport 是否允许覆盖已存在的学号
     * @param operName        操作人
     * @return 导入结果提示
     */
    /**
     * 按班级名找到对应部门，写进 dept_id。
     * 找不到（比如导入的班级还没建部门）就保持原值，不硬塞一个错误的部门。
     */
    private void applyDeptByClassName(Student student)
    {
        if (student.getClassName() == null || student.getClassName().isEmpty())
        {
            return;
        }
        Long deptId = studentMapper.selectDeptIdByClassName(student.getClassName().trim());
        if (deptId != null)
        {
            student.setDeptId(deptId);
        }
    }

    @Override
    public String importStudent(List<Student> studentList, boolean isUpdateSupport, String operName)
    {
        if (studentList == null || studentList.isEmpty())
        {
            throw new ServiceException("导入学生数据不能为空！");
        }

        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (Student student : studentList)
        {
            // Excel 里可能有一整行空白，跳过而不是当成错误
            if (student.getStudentNo() == null || student.getStudentNo().trim().isEmpty())
            {
                failureNum++;
                failureMsg.append("<br/>第 " + (successNum + failureNum) + " 行：学号为空，已跳过");
                continue;
            }
            student.setStudentNo(student.getStudentNo().trim());

            try
            {
                // 用学号做业务主键查重（学号在库里是唯一索引）
                Student query = new Student();
                query.setStudentNo(student.getStudentNo());
                List<Student> exists = studentMapper.selectStudentList(query);

                if (exists.isEmpty())
                {
                    student.setCreateBy(operName);
                    student.setCreateTime(DateUtils.getNowDate());
                    // Excel 里没填的字段给个默认值，避免页面显示空白
                    if (student.getStatus() == null || student.getStatus().isEmpty())
                    {
                        student.setStatus("0");
                    }
                    if (student.getGender() == null || student.getGender().isEmpty())
                    {
                        student.setGender("2");
                    }
                    applyDeptByClassName(student);
                    studentMapper.insertStudent(student);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、学号 " + student.getStudentNo()
                            + "（" + student.getStudentName() + "）导入成功");
                }
                else if (isUpdateSupport)
                {
                    // 覆盖更新：主键必须用库里的，否则会插成新记录
                    student.setId(exists.get(0).getId());
                    applyDeptByClassName(student);
                    student.setUpdateBy(operName);
                    student.setUpdateTime(DateUtils.getNowDate());
                    studentMapper.updateStudent(student);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、学号 " + student.getStudentNo()
                            + "（" + student.getStudentName() + "）更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>学号 " + student.getStudentNo() + " 已存在，未导入");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                failureMsg.append("<br/>学号 " + student.getStudentNo() + " 导入失败：" + e.getMessage());
            }
        }

        if (failureNum > 0)
        {
            // 有失败就把失败明细一起抛给前端，用户才知道哪几行要改
            failureMsg.insert(0, "导入完成：成功 " + successNum + " 条，失败 " + failureNum + " 条。失败明细：");
            throw new ServiceException(failureMsg.toString());
        }

        successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条：");
        return successMsg.toString();
    }

    /**
     * 取当前登录账号绑定的学生档案
     *
     * 整个学生端的数据权限都建立在这个方法上：
     * 登录态 → userId → ch_student.user_id → 学生档案 → 该学生的预约/体检/档案。
     * 前端传的 studentId 一律不参与，所以改 URL 里的 id 也看不到别人的数据。
     */
    @Override
    public Student selectCurrentStudent()
    {
        Long userId = SecurityUtils.getUserId();
        Student student = studentMapper.selectStudentByUserId(userId);
        if (student == null)
        {
            // 管理员或未绑定的账号进到学生页面时给出可理解的提示，而不是空数据
            throw new ServiceException("当前账号未绑定学生档案，请使用学生账号登录（如 student01 / admin123）");
        }
        return student;
    }
}
