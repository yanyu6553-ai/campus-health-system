package com.ruoyi.health.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.health.domain.Appointment;

/**
 * 体检预约Mapper接口
 * 
 * @author shang
 * @date 2026-11-11
 */
public interface AppointmentMapper 
{
    /**
     * 查询体检预约
     * 
     * @param id 体检预约主键
     * @return 体检预约
     */
    public Appointment selectAppointmentById(Long id);

    /**
     * 查询体检预约列表
     * 
     * @param appointment 体检预约
     * @return 体检预约集合
     */
    public List<Appointment> selectAppointmentList(Appointment appointment);

    /**
     * 新增体检预约
     * 
     * @param appointment 体检预约
     * @return 结果
     */
    public int insertAppointment(Appointment appointment);

    /**
     * 修改体检预约
     * 
     * @param appointment 体检预约
     * @return 结果
     */
    public int updateAppointment(Appointment appointment);

    /**
     * 删除体检预约
     * 
     * @param id 体检预约主键
     * @return 结果
     */
    public int deleteAppointmentById(Long id);

    /**
     * 已取消的记录重新预约：状态复位为待审核，并清空上一轮审核痕迹
     * 
     * @param appointment 至少包含 id、appointmentTime
     * @return 结果
     */
    public int reappointAppointment(Appointment appointment);

    /**
     * 取消预约：仅「待审核」「已预约」可取消，状态条件写在 SQL 里保证并发安全
     *
     * @param appointment 至少包含 id、updateBy、updateTime
     * @return 受影响行数，0 表示状态已变、不允许取消
     */
    public int cancelAppointment(Appointment appointment);

    /**
     * 体检登记完成后把对应的「已预约」改成「已完成」
     *
     * @param studentId 学生ID
     * @param batchId   批次ID
     * @return 受影响行数
     */
    public int finishByStudentAndBatch(@Param("studentId") Long studentId, @Param("batchId") Long batchId);

    /**
     * 批量删除体检预约
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAppointmentByIds(Long[] ids);
}
