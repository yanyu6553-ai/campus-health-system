package com.ruoyi.health.mapper;

import java.util.List;
import com.ruoyi.health.domain.ExamRecord;

/**
 * 体检记录Mapper接口
 * 
 * @author shang
 * @date 2026-11-11
 */
public interface ExamRecordMapper 
{
    /**
     * 查询体检记录
     * 
     * @param id 体检记录主键
     * @return 体检记录
     */
    public ExamRecord selectExamRecordById(Long id);

    /**
     * 查询体检记录列表
     * 
     * @param examRecord 体检记录
     * @return 体检记录集合
     */
    public List<ExamRecord> selectExamRecordList(ExamRecord examRecord);

    /**
     * 新增体检记录
     * 
     * @param examRecord 体检记录
     * @return 结果
     */
    public int insertExamRecord(ExamRecord examRecord);

    /**
     * 修改体检记录
     * 
     * @param examRecord 体检记录
     * @return 结果
     */
    public int updateExamRecord(ExamRecord examRecord);

    /**
     * 删除体检记录
     * 
     * @param id 体检记录主键
     * @return 结果
     */
    public int deleteExamRecordById(Long id);

    /**
     * 批量删除体检记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteExamRecordByIds(Long[] ids);
}
