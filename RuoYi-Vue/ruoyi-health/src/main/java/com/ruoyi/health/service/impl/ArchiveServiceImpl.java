package com.ruoyi.health.service.impl;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.health.mapper.ExamRecordMapper;
import com.ruoyi.health.mapper.StudentMapper;
import com.ruoyi.health.domain.ExamRecord;
import com.ruoyi.health.domain.HealthArchive;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.service.IArchiveService;
import com.ruoyi.health.service.IHealthArchiveService;

/**
 * 健康档案Service业务层处理
 *
 * 档案 = 学生信息 + 档案快照（ch_health_archive）+ 体检明细（ch_exam_record）
 * 明细单独查而不是存进档案，避免出现"档案里的记录"和"体检记录表"两份数据打架。
 *
 * @author shang
 * @date 2026-11-11
 */
@Service
public class ArchiveServiceImpl implements IArchiveService
{
    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private IHealthArchiveService healthArchiveService;

    /**
     * 按学生聚合健康档案
     *
     * @param studentId 学生主键
     * @return student 学生信息 / archive 档案快照 / latest 最新一次体检记录 / records 全部历史记录（按体检日期升序）
     */
    @Override
    public Map<String, Object> selectArchiveByStudentId(Long studentId)
    {
        Student student = studentMapper.selectStudentById(studentId);
        if (student == null)
        {
            throw new ServiceException("学生不存在");
        }

        // 辅导员只能看本班学生：越权时直接拒绝，而不是返回空数据
        // （返回空数据会让人误以为"这个学生没有体检记录"）
        checkCounselorScope(student);

        ExamRecord query = new ExamRecord();
        query.setStudentId(studentId);
        List<ExamRecord> records = examRecordMapper.selectExamRecordList(query);

        // 按体检日期升序排列（趋势图从早到晚），同一日期按记录 ID 升序
        records.sort(Comparator
                .comparing(ExamRecord::getExamDate, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(ExamRecord::getId));

        // 最新一次体检 = 日期最大的那条
        ExamRecord latest = records.isEmpty() ? null : records.get(records.size() - 1);

        // 档案快照可能还没生成（比如历史数据），这里顺手补一次，保证页面一定有摘要
        HealthArchive archive = healthArchiveService.selectByStudentId(studentId);
        if (archive == null)
        {
            healthArchiveService.refresh(studentId);
            archive = healthArchiveService.selectByStudentId(studentId);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("student", student);
        result.put("archive", archive);
        result.put("latest", latest);
        result.put("records", records);
        return result;
    }

    /**
     * 辅导员的数据范围校验：自己所在班级（部门）之外的学生，不允许查看档案。
     * 管理员和校医不受限制（data_scope = 1 全部数据）。
     */
    private void checkCounselorScope(Student student)
    {
        List<SysRole> roles = SecurityUtils.getLoginUser().getUser().getRoles();
        if (roles == null || roles.isEmpty())
        {
            return;
        }
        boolean counselor = false;
        for (SysRole role : roles)
        {
            if ("counselor".equals(role.getRoleKey()))
            {
                counselor = true;
                break;
            }
        }
        if (!counselor)
        {
            return;
        }

        Long myDeptId = SecurityUtils.getLoginUser().getDeptId();
        if (student.getDeptId() == null || !Objects.equals(student.getDeptId(), myDeptId))
        {
            throw new ServiceException("只能查看本班学生的健康档案");
        }
    }
}
