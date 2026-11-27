package com.ruoyi.health.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

/**
 * 首页数据看板 Mapper
 *
 * 只做只读统计，没有增删改，所以不需要事务。
 *
 * @author shang
 */
public interface DashboardMapper
{
    /** 在校学生总数（status=0 正常） */
    int countStudents();

    /** 已有体检记录的学生数（去重，一个学生多次体检只算一次） */
    int countExaminedStudents();

    /** 按状态统计预约数 */
    int countAppointmentsByStatus(@Param("status") String status);

    /** 今日预约人数：预约时间落在今天、且没有取消/拒绝的预约 */
    int countTodayAppointments();

    /** 异常学生数：BMI 超重/肥胖，或血压超标 */
    int countAbnormalStudents();

    /** BMI 等级分布 */
    List<Map<String, Object>> selectBmiDistribution();

    /**
     * 各体检项目的异常人数（去重学生）
     *
     * 对应设计文档 2.1 首页的「体检项目分布图」：让人一眼看出哪些指标最容易出问题。
     * 口径与体检项目的默认参考范围保持一致（血压 140/90、BMI 超重及以上、视力 4.8、心率 60~100）。
     */
    List<Map<String, Object>> selectItemAbnormalDistribution();

    /** 各批次预约进度 */
    List<Map<String, Object>> selectBatchProgress();

    /** 最近预约记录 */
    List<Map<String, Object>> selectRecentAppointments();
}
