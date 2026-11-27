package com.ruoyi.health.service;

import com.ruoyi.health.domain.HealthArchive;

/**
 * 健康档案Service接口
 *
 * @author shang
 * @date 2026-11-11
 */
public interface IHealthArchiveService
{
    /** 按学生查档案快照 */
    HealthArchive selectByStudentId(Long studentId);

    /**
     * 重新计算并保存某学生的档案快照。
     * 体检记录新增/修改/删除后调用，保证档案的"次数、最近日期、摘要、状态"始终跟明细一致。
     *
     * @param studentId 学生主键
     */
    void refresh(Long studentId);
}
