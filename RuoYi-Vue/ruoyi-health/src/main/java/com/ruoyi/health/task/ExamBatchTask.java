package com.ruoyi.health.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.health.mapper.ExamBatchMapper;

/**
 * 体检批次定时任务
 *
 * 用若依自带的 quartz 调用，不需要自己写 @Scheduled。
 * bean 名 examBatchTask 就是 sys_job.invoke_target 的前半段。
 *
 * @author shang
 */
@Component("examBatchTask")
public class ExamBatchTask
{
    private static final Logger log = LoggerFactory.getLogger(ExamBatchTask.class);

    @Autowired
    private ExamBatchMapper examBatchMapper;

    /**
     * 关闭过期批次：体检日期已过但状态还是「预约中」的，自动置为「已结束」
     */
    public void closeExpiredBatches()
    {
        int rows = examBatchMapper.closeExpiredBatches();
        log.info("关闭过期体检批次，本次处理 {} 条", rows);
    }
}
