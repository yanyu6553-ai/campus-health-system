package com.ruoyi.health.mapper;

import com.ruoyi.health.domain.HealthArchive;

/**
 * 健康档案Mapper接口
 *
 * @author shang
 * @date 2026-11-11
 */
public interface HealthArchiveMapper
{
    /** 按学生查档案（student_id 上有唯一索引，最多一条） */
    HealthArchive selectByStudentId(Long studentId);

    /** 有则更新、无则新增：一次 SQL 完成，避免并发下"先查后插"出现两条 */
    int saveOrUpdate(HealthArchive healthArchive);
}
