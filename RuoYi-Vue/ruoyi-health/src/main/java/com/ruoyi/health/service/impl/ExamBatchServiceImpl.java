package com.ruoyi.health.service.impl;

import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.health.mapper.ExamBatchMapper;
import com.ruoyi.health.mapper.AppointmentMapper;
import com.ruoyi.health.mapper.ExamRecordMapper;
import com.ruoyi.health.domain.Appointment;
import com.ruoyi.health.domain.ExamBatch;
import com.ruoyi.health.domain.ExamRecord;
import com.ruoyi.health.service.IExamBatchService;

/**
 * 体检批次Service业务层处理
 * 
 * @author shang
 * @date 2026-11-11
 */
@Service
public class ExamBatchServiceImpl implements IExamBatchService 
{
    @Autowired
    private ExamBatchMapper examBatchMapper;

    @Autowired
    private AppointmentMapper appointmentMapper;

    @Autowired
    private ExamRecordMapper examRecordMapper;

    /**
     * 查询体检批次
     * 
     * @param id 体检批次主键
     * @return 体检批次
     */
    @Override
    public ExamBatch selectExamBatchById(Long id)
    {
        return examBatchMapper.selectExamBatchById(id);
    }

    /**
     * 查询体检批次列表
     * 
     * @param examBatch 体检批次
     * @return 体检批次
     */
    @Override
    public List<ExamBatch> selectExamBatchList(ExamBatch examBatch)
    {
        return examBatchMapper.selectExamBatchList(examBatch);
    }

    /**
     * 新增体检批次
     * 
     * @param examBatch 体检批次
     * @return 结果
     */
    @Override
    public int insertExamBatch(ExamBatch examBatch)
    {
        // 名称唯一：库里 uk_batch_name 唯一索引只是兜底，直接撞索引用户看到的是
        // 一段英文 DuplicateKeyException 堆栈，业务层先拦住才能给"说得清"的提示
        checkBatchNameUnique(examBatch.getBatchName(), null);

        // 新建批次不可能是「已结束」：前端虽然隐藏了该选项，但接口可以绕过，后端要自己把关
        if ("2".equals(examBatch.getStatus()))
        {
            throw new ServiceException("新建批次不能是「已结束」状态");
        }

        // 容量是预约上限，必须是个正整数 —— 填 0 或负数的批次没法约人
        checkCapacity(examBatch.getCapacity(), 0L);

        // 时间段校验 + 由开始时间派生体检日期
        applyTimeRange(examBatch);

        examBatch.setCreateTime(DateUtils.getNowDate());
        return examBatchMapper.insertExamBatch(examBatch);
    }

    /**
     * 修改体检批次
     * 
     * @param examBatch 体检批次
     * @return 结果
     */
    @Override
    public int updateExamBatch(ExamBatch examBatch)
    {
        // 改名同样不能撞已有批次的名称（排除自己，否则把自己当成重名）
        if (examBatch.getBatchName() != null && !examBatch.getBatchName().isEmpty())
        {
            checkBatchNameUnique(examBatch.getBatchName(), examBatch.getId());
        }

        // 容量不能改到低于已预约人数：已约 5 人把容量改成 3，
        // 会出现"名额已超"的矛盾状态，进度条爆表、统计对不上。
        // 注意 mapper 的 update 不含 booked_count（名额只能由预约/审核流程增减），这里只需查库比对。
        if (examBatch.getCapacity() != null)
        {
            ExamBatch current = examBatchMapper.selectExamBatchById(examBatch.getId());
            if (current == null)
            {
                throw new ServiceException("体检批次不存在");
            }
            checkCapacity(examBatch.getCapacity(), current.getBookedCount());
        }

        applyTimeRange(examBatch);
        examBatch.setUpdateTime(DateUtils.getNowDate());
        return examBatchMapper.updateExamBatch(examBatch);
    }

    /**
     * 批次名称唯一性校验（学号查重同款做法）
     *
     * @param batchName 待校验的名称
     * @param excludeId 修改时排除的自身 id（新增传 null）
     */
    private void checkBatchNameUnique(String batchName, Long excludeId)
    {
        if (batchName == null || batchName.isEmpty())
        {
            throw new ServiceException("批次名称不能为空");
        }
        ExamBatch exists = examBatchMapper.checkBatchNameUnique(batchName.trim());
        if (exists != null && (excludeId == null || !exists.getId().equals(excludeId)))
        {
            throw new ServiceException("批次名称「" + batchName + "」已存在，请换一个名称");
        }
    }

    /**
     * 容量合法性检查
     *
     * @param capacity   新容量
     * @param bookedCount 该批次已预约人数（新增时传 0）
     */
    private void checkCapacity(Long capacity, Long bookedCount)
    {
        if (capacity == null || capacity < 1)
        {
            throw new ServiceException("预约人数上限必须大于 0");
        }
        long booked = bookedCount == null ? 0L : bookedCount;
        if (capacity < booked)
        {
            throw new ServiceException("预约人数上限不能小于已预约人数（当前已预约 " + booked + " 人）");
        }
    }

    /**
     * 校验时间段，并把「体检日期」从开始时间推出来
     *
     * 为什么不让前端直接填 exam_date：
     * 批次按时间段排（文档表3 是 start_time / end_time），日期是它的派生值。
     * 如果两个都由人填，就一定会出现"开始时间是 11-25、体检日期写 11-26"这种脏数据，
     * 到时候按日期统计和按时间排期会对不上。所以日期只认开始时间。
     *
     * @param examBatch 体检批次（原地修改）
     */
    private void applyTimeRange(ExamBatch examBatch)
    {
        if (examBatch.getStartTime() == null)
        {
            throw new ServiceException("批次开始时间不能为空");
        }
        if (examBatch.getEndTime() == null)
        {
            throw new ServiceException("批次结束时间不能为空");
        }
        if (!examBatch.getEndTime().after(examBatch.getStartTime()))
        {
            throw new ServiceException("结束时间必须晚于开始时间");
        }

        // exam_date = 开始时间的日期部分（时分秒截掉）
        examBatch.setExamDate(new java.sql.Date(examBatch.getStartTime().getTime()));
    }

    /**
     * 批量删除体检批次
     * 
     * @param ids 需要删除的体检批次主键
     * @return 结果
     */
    @Override
    public int deleteExamBatchByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            checkBatchDeletable(id);
        }
        return examBatchMapper.deleteExamBatchByIds(ids);
    }

    /**
     * 删除体检批次信息
     * 
     * @param id 体检批次主键
     * @return 结果
     */
    @Override
    public int deleteExamBatchById(Long id)
    {
        checkBatchDeletable(id);
        return examBatchMapper.deleteExamBatchById(id);
    }

    /**
     * 删批次前先确认没被业务数据引用
     *
     * 为什么不让直接删：
     * 预约表和体检记录表都存着 batch_id，批次一删，这些行就变成"指向不存在批次"的孤儿数据 ——
     * 列表里批次名列空白、按批次统计也对不上，而且没法通过界面找回来。
     * 想删就先把这个批次的预约/体检记录处理掉，属于"说得清"的操作顺序。
     *
     * @param id 批次主键
     */
    private void checkBatchDeletable(Long id)
    {
        Appointment aq = new Appointment();
        aq.setBatchId(id);
        if (!appointmentMapper.selectAppointmentList(aq).isEmpty())
        {
            throw new ServiceException("该批次下已有预约记录，不能删除；请先处理这些预约");
        }

        ExamRecord rq = new ExamRecord();
        rq.setBatchId(id);
        if (!examRecordMapper.selectExamRecordList(rq).isEmpty())
        {
            throw new ServiceException("该批次下已有体检记录，不能删除；体检数据需要留档");
        }
    }
}
