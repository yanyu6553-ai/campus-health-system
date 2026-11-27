package com.ruoyi.health.service;

import java.util.Map;
import com.ruoyi.health.domain.Student;

/**
 * 健康档案Service接口
 *
 * @author shang
 * @date 2026-11-11
 */
public interface IArchiveService
{
    /**
     * 按学生聚合健康档案
     *
     * @param studentId 学生主键
     * @return student 学生信息 / latest 最新一次体检记录 / records 全部历史记录
     */
    public Map<String, Object> selectArchiveByStudentId(Long studentId);
}
