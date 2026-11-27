package com.ruoyi.health.service.impl;

import java.math.BigDecimal;
import java.util.List;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.health.mapper.ExamItemMapper;
import com.ruoyi.health.domain.ExamItem;
import com.ruoyi.health.service.IExamItemService;

/**
 * 体检项目Service业务层处理
 * 
 * 校验都放在 Service 而不是只在页面做，原因：
 * 页面校验只是"顺手帮用户挡一下"，接口是能被直接调用的（Postman / 小程序），
 * 真正的底线必须在后端。
 * 
 * @author shang
 * @date 2026-11-11
 */
@Service
public class ExamItemServiceImpl implements IExamItemService 
{
    /** 合法的异常判定方式 */
    private static final List<String> RULE_CODES = List.of("0", "1", "2", "3");

    @Autowired
    private ExamItemMapper examItemMapper;

    /**
     * 查询体检项目
     * 
     * @param id 体检项目主键
     * @return 体检项目
     */
    @Override
    public ExamItem selectExamItemById(Long id)
    {
        return examItemMapper.selectExamItemById(id);
    }

    /**
     * 查询体检项目列表
     * 
     * @param examItem 体检项目
     * @return 体检项目
     */
    @Override
    public List<ExamItem> selectExamItemList(ExamItem examItem)
    {
        return examItemMapper.selectExamItemList(examItem);
    }

    /**
     * 查询所有启用的体检项目（体检登记的异常判定要用）
     * 
     * @return 体检项目集合
     */
    @Override
    public List<ExamItem> selectEnabledExamItemList()
    {
        return examItemMapper.selectEnabledExamItemList();
    }

    /**
     * 新增体检项目
     * 
     * @param examItem 体检项目
     * @return 结果
     */
    @Override
    public int insertExamItem(ExamItem examItem)
    {
        checkRequired(examItem);
        checkCodeUnique(examItem.getItemCode(), null);
        checkReferenceRange(examItem);

        examItem.setCreateBy(SecurityUtils.getUsername());
        examItem.setCreateTime(DateUtils.getNowDate());
        return examItemMapper.insertExamItem(examItem);
    }

    /**
     * 修改体检项目
     * 
     * @param examItem 体检项目
     * @return 结果
     */
    @Override
    public int updateExamItem(ExamItem examItem)
    {
        if (examItem.getId() == null)
        {
            throw new ServiceException("体检项目ID不能为空");
        }
        checkRequired(examItem);
        // 查重时要排除自己，否则"没改编码只改了名字"也会被判定成重复
        checkCodeUnique(examItem.getItemCode(), examItem.getId());
        checkReferenceRange(examItem);

        examItem.setUpdateBy(SecurityUtils.getUsername());
        examItem.setUpdateTime(DateUtils.getNowDate());
        return examItemMapper.updateExamItem(examItem);
    }

    /**
     * 批量删除体检项目
     * 
     * @param ids 需要删除的体检项目主键
     * @return 结果
     */
    @Override
    public int deleteExamItemByIds(Long[] ids)
    {
        return examItemMapper.deleteExamItemByIds(ids);
    }

    /**
     * 删除体检项目信息
     * 
     * @param id 体检项目主键
     * @return 结果
     */
    @Override
    public int deleteExamItemById(Long id)
    {
        return examItemMapper.deleteExamItemById(id);
    }

    /**
     * 必填项检查
     */
    private void checkRequired(ExamItem examItem)
    {
        if (StringUtils.isEmpty(examItem.getItemCode()) || StringUtils.isEmpty(examItem.getItemName()))
        {
            throw new ServiceException("项目编码和项目名称不能为空");
        }
        if (StringUtils.isEmpty(examItem.getAbnormalRule()))
        {
            throw new ServiceException("请选择异常判定方式");
        }
        if (!RULE_CODES.contains(examItem.getAbnormalRule()))
        {
            throw new ServiceException("异常判定方式不正确");
        }
    }

    /**
     * 项目编码查重
     * 
     * @param itemCode 项目编码
     * @param selfId   修改时传自己的ID（排除自己），新增时传 null
     */
    private void checkCodeUnique(String itemCode, Long selfId)
    {
        ExamItem exist = examItemMapper.selectExamItemByCode(itemCode);
        if (exist != null && !exist.getId().equals(selfId))
        {
            throw new ServiceException("项目编码「" + itemCode + "」已存在，请换一个");
        }
    }

    /**
     * 参考范围合法性检查：
     * 1. 下限不能大于上限（填反了会导致所有数据都被判成异常）；
     * 2. 要判定异常（规则 0/1/2）就必须配对应的上下限，否则规则形同虚设。
     */
    private void checkReferenceRange(ExamItem examItem)
    {
        BigDecimal min = examItem.getReferenceMin();
        BigDecimal max = examItem.getReferenceMax();

        if (min != null && max != null && min.compareTo(max) > 0)
        {
            throw new ServiceException("参考下限不能大于参考上限");
        }

        String rule = examItem.getAbnormalRule();
        if ("0".equals(rule) && max == null)
        {
            throw new ServiceException("判定方式为「高于上限算异常」时必须填写参考上限");
        }
        if ("1".equals(rule) && min == null)
        {
            throw new ServiceException("判定方式为「低于下限算异常」时必须填写参考下限");
        }
        if ("2".equals(rule) && (min == null || max == null))
        {
            throw new ServiceException("判定方式为「超出上下限算异常」时上下限都要填");
        }
    }
}
