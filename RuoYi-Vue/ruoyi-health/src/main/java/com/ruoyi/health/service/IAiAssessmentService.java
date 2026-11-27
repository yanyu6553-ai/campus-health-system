package com.ruoyi.health.service;

import java.util.List;
import com.ruoyi.health.domain.AiAssessment;

/**
 * AI健康评估Service接口
 * 
 * @author ruoyi
 */
public interface IAiAssessmentService 
{
    /**
     * 查询AI健康评估
     * 
     * @param id AI健康评估主键
     * @return AI健康评估
     */
    public AiAssessment selectAiAssessmentById(Long id);

    /**
     * 按体检记录查询评估结果
     * 
     * @param examRecordId 体检记录主键
     * @return AI健康评估
     */
    public AiAssessment selectAiAssessmentByRecordId(Long examRecordId);

    /**
     * 查询AI健康评估列表
     * 
     * @param aiAssessment AI健康评估
     * @return AI健康评估集合
     */
    public List<AiAssessment> selectAiAssessmentList(AiAssessment aiAssessment);

    /**
     * 学生查看自己的评估记录（含待评估/评估中/已完成）
     *
     * 身份由后端从登录态解析，不接受前端传 studentId，避免学生翻别人的报告。
     * 对应设计文档 2.7「学生或授权校医查看评估报告」与 4.1 第 11 步。
     *
     * @return 本人评估记录集合
     */
    public List<AiAssessment> selectMyAssessmentList();

    /**
     * 体检登记完成后，给这条记录挂一条「待评估」任务。
     * 这样 AI 报告页能列出"已登记但还没评估"的记录，校医照着补评估，
     * 对应设计文档 4.2 的 AI 评估状态流转（待评估 → 评估中 → 评估完成）。
     *
     * @param studentId    学生主键
     * @param examRecordId 体检记录主键
     */
    public void createPendingTask(Long studentId, Long examRecordId);

    /**
     * 体检记录被编辑后，把已有「评估完成」的报告打回「待评估」。
     *
     * 为什么需要：报告是基于当时的体检数据生成的，数据改了报告就"过期"了，
     * 不打回的话用户看到的一直是旧数据的结论。
     * 只改状态、不删结果：重新评估会整体覆盖，旧报告在被覆盖前仍然可读。
     * 待评估/评估中的任务本来就会重跑，无需处理。
     *
     * @param examRecordId 体检记录主键
     */
    public void invalidateIfAssessed(Long examRecordId);

    /**
     * 对指定体检记录生成AI健康评估（调用大模型，结果入库）
     * 
     * @param examRecordId 体检记录主键
     * @return 评估结果
     */
    public AiAssessment assess(Long examRecordId);

    /**
     * 批量删除AI健康评估
     * 
     * @param ids 需要删除的AI健康评估主键集合
     * @return 结果
     */
    public int deleteAiAssessmentByIds(Long[] ids);

    /**
     * 删除AI健康评估信息
     * 
     * @param id AI健康评估主键
     * @return 结果
     */
    public int deleteAiAssessmentById(Long id);
}
