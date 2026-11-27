package com.ruoyi.health.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.health.domain.AiAssessment;

/**
 * AI健康评估Mapper接口
 * 
 * @author ruoyi
 */
public interface AiAssessmentMapper 
{
    /**
     * 查询AI健康评估
     * 
     * @param id AI健康评估主键
     * @return AI健康评估
     */
    public AiAssessment selectAiAssessmentById(Long id);

    /**
     * 按体检记录查询评估结果（一条记录只保留一份）
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
     * 新增AI健康评估
     * 
     * @param aiAssessment AI健康评估
     * @return 结果
     */
    public int insertAiAssessment(AiAssessment aiAssessment);

    /**
     * 修改AI健康评估
     * 
     * @param aiAssessment AI健康评估
     * @return 结果
     */
    public int updateAiAssessment(AiAssessment aiAssessment);

    /** 只更新评估状态（1 评估中 / 2 评估完成 / 0 待评估），不动评估内容 */
    public int updateAssessStatus(@Param("examRecordId") Long examRecordId,
                                  @Param("status") String status,
                                  @Param("updateBy") String updateBy);

    /**
     * 删除AI健康评估
     * 
     * @param id AI健康评估主键
     * @return 结果
     */
    public int deleteAiAssessmentById(Long id);

    /**
     * 批量删除AI健康评估
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAiAssessmentByIds(Long[] ids);

    /**
     * 按体检记录删除（重新生成前清理旧结果）
     * 
     * @param examRecordId 体检记录主键
     * @return 结果
     */
    public int deleteAiAssessmentByRecordId(Long examRecordId);
}
