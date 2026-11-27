package com.ruoyi.health.service;

import java.util.List;
import com.ruoyi.health.domain.Appointment;

/**
 * 体检预约Service接口
 * 
 * @author shang
 * @date 2026-11-11
 */
public interface IAppointmentService 
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
     * 审核体检预约：通过（status=1）或拒绝（status=2）
     * 
     * @param appointment 至少包含 id、status；拒绝时还需 auditRemark
     * @return 结果
     */
    public int auditAppointment(Appointment appointment);

    /**
     * 修改体检预约
     * 
     * @param appointment 体检预约
     * @return 结果
     */
    public int updateAppointment(Appointment appointment);

    /**
     * 批量删除体检预约
     * 
     * @param ids 需要删除的体检预约主键集合
     * @return 结果
     */
    public int deleteAppointmentByIds(Long[] ids);

    /**
     * 删除体检预约信息
     * 
     * @param id 体检预约主键
     * @return 结果
     */
    public int deleteAppointmentById(Long id);

    /**
     * 查询当前登录学生自己的预约记录
     *
     * @return 自己的预约列表；账号未绑定学生档案时抛业务异常
     */
    public List<Appointment> selectMyAppointmentList();

    /**
     * 学生自助预约：学生ID由登录态推导，忽略前端传入值
     *
     * @param appointment 只取 batchId、remark
     * @return 结果
     */
    public int applyAppointment(Appointment appointment);

    /**
     * 学生自助取消预约：只能取消自己的记录；已通过的会同步释放批次名额
     *
     * @param id 预约主键
     * @return 结果
     */
    public int cancelMyAppointment(Long id);

    /**
     * 体检登记完成后回写预约状态（同学生 + 同批次：已预约 → 已完成）
     *
     * @param studentId 学生ID
     * @param batchId   批次ID
     * @return 影响行数
     */
    public int finishByExamRecord(Long studentId, Long batchId);
}
