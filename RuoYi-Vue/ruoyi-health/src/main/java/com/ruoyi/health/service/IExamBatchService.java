package com.ruoyi.health.service;

import java.util.List;
import com.ruoyi.health.domain.ExamBatch;

/**
 * 体检批次Service接口
 * 
 * @author shang
 * @date 2026-11-11
 */
public interface IExamBatchService 
{
    /**
     * 查询体检批次
     * 
     * @param id 体检批次主键
     * @return 体检批次
     */
    public ExamBatch selectExamBatchById(Long id);

    /**
     * 查询体检批次列表
     * 
     * @param examBatch 体检批次
     * @return 体检批次集合
     */
    public List<ExamBatch> selectExamBatchList(ExamBatch examBatch);

    /**
     * 新增体检批次
     * 
     * @param examBatch 体检批次
     * @return 结果
     */
    public int insertExamBatch(ExamBatch examBatch);

    /**
     * 修改体检批次
     * 
     * @param examBatch 体检批次
     * @return 结果
     */
    public int updateExamBatch(ExamBatch examBatch);

    /**
     * 批量删除体检批次
     * 
     * @param ids 需要删除的体检批次主键集合
     * @return 结果
     */
    public int deleteExamBatchByIds(Long[] ids);

    /**
     * 删除体检批次信息
     * 
     * @param id 体检批次主键
     * @return 结果
     */
    public int deleteExamBatchById(Long id);
}
