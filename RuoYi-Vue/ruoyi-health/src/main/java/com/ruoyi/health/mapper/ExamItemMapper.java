package com.ruoyi.health.mapper;

import java.util.List;
import com.ruoyi.health.domain.ExamItem;

/**
 * 体检项目Mapper接口
 * 
 * @author shang
 * @date 2026-11-11
 */
public interface ExamItemMapper 
{
    /**
     * 查询体检项目
     * 
     * @param id 体检项目主键
     * @return 体检项目
     */
    public ExamItem selectExamItemById(Long id);

    /**
     * 查询体检项目列表
     * 
     * @param examItem 体检项目
     * @return 体检项目集合
     */
    public List<ExamItem> selectExamItemList(ExamItem examItem);

    /**
     * 按项目编码查询（新增/修改前查重）
     * 
     * @param itemCode 项目编码
     * @return 体检项目
     */
    public ExamItem selectExamItemByCode(String itemCode);

    /**
     * 查询所有启用的体检项目（异常判定时用）
     * 
     * @return 体检项目集合
     */
    public List<ExamItem> selectEnabledExamItemList();

    /**
     * 新增体检项目
     * 
     * @param examItem 体检项目
     * @return 结果
     */
    public int insertExamItem(ExamItem examItem);

    /**
     * 修改体检项目
     * 
     * @param examItem 体检项目
     * @return 结果
     */
    public int updateExamItem(ExamItem examItem);

    /**
     * 删除体检项目
     * 
     * @param id 体检项目主键
     * @return 结果
     */
    public int deleteExamItemById(Long id);

    /**
     * 批量删除体检项目
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteExamItemByIds(Long[] ids);
}
