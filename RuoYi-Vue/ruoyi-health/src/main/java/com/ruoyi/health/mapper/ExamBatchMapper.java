package com.ruoyi.health.mapper;

import java.util.List;
import com.ruoyi.health.domain.ExamBatch;

/**
 * 体检批次Mapper接口
 * 
 * @author shang
 * @date 2026-11-11
 */
public interface ExamBatchMapper 
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
     * 按批次名称精确查询（新增/改名前查重用）
     *
     * batch_name 在库里有唯一索引 uk_batch_name 兜底，
     * 但直接撞索引抛给用户的是 DuplicateKeyException 英文堆栈，
     * 所以业务层先用这条 SQL 精确查重，给出人话提示。
     *
     * @param batchName 批次名称（全等匹配，不是模糊）
     * @return 同名批次，不存在返回 null
     */
    public ExamBatch checkBatchNameUnique(@org.apache.ibatis.annotations.Param("batchName") String batchName);

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
     * 删除体检批次
     * 
     * @param id 体检批次主键
     * @return 结果
     */
    public int deleteExamBatchById(Long id);

    /**
     * 批量删除体检批次
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteExamBatchByIds(Long[] ids);

    /**
     * 原子占用一个名额：只有 booked_count < capacity 时才会更新成功
     * 
     * @param batchId 批次主键
     * @return 影响行数，0 表示名额已满
     */
    public int incrementBookedCount(Long batchId);

    /**
     * 原子释放一个名额（取消预约时用）
     *
     * @param batchId 批次主键
     * @return 影响行数
     */
    public int decrementBookedCount(Long batchId);

    /**
     * 把体检日期已过、但仍处于「预约中」的批次置为「已结束」
     * 
     * @return 影响行数
     */
    public int closeExpiredBatches();
}
