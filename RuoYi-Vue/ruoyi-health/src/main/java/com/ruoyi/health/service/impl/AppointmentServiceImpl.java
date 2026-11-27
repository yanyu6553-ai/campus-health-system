package com.ruoyi.health.service.impl;

import java.util.List;

import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.health.mapper.AppointmentMapper;
import com.ruoyi.health.mapper.ExamBatchMapper;
import com.ruoyi.health.domain.Appointment;
import com.ruoyi.health.domain.ExamBatch;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.service.IAppointmentService;
import com.ruoyi.health.service.IStudentService;

/**
 * 体检预约Service业务层处理
 * 
 * @author shang
 * @date 2026-11-11
 */
@Service
public class AppointmentServiceImpl implements IAppointmentService 
{
    @Autowired
    private AppointmentMapper appointmentMapper;

    @Autowired
    private ExamBatchMapper examBatchMapper;

    @Autowired
    private IStudentService studentService;

    /**
     * 查询体检预约
     * 
     * @param id 体检预约主键
     * @return 体检预约
     */
    @Override
    public Appointment selectAppointmentById(Long id)
    {
        return appointmentMapper.selectAppointmentById(id);
    }

    /**
     * 查询体检预约列表
     * 
     * @param appointment 体检预约
     * @return 体检预约
     */
    @Override
    @DataScope(deptAlias = "s")
    public List<Appointment> selectAppointmentList(Appointment appointment)
    {
        return appointmentMapper.selectAppointmentList(appointment);
    }

    /**
     * 新增体检预约
     * 
     * @param appointment 体检预约
     * @return 结果
     */
    @Override
    public int insertAppointment(Appointment appointment)
    {
        // ⓪ 参数校验：查重依赖 studentId + batchId，任一为空都会让动态 SQL 条件失效，
        //    查重范围被放大导致误判，所以必须先拦住
        if (appointment.getStudentId() == null)
        {
            throw new ServiceException("请选择学生");
        }
        if (appointment.getBatchId() == null)
        {
            throw new ServiceException("请选择体检批次");
        }

        // ⓪-2 批次必须处于「预约中」，否则不允许提交。
        //      状态是人工开关，未开放和已结束的批次都不该收预约。
        ExamBatch batch = examBatchMapper.selectExamBatchById(appointment.getBatchId());
        if (batch == null)
        {
            throw new ServiceException("体检批次不存在");
        }
        if (!"1".equals(batch.getStatus()))
        {
            throw new ServiceException("2".equals(batch.getStatus()) ? "该批次已结束，无法预约" : "该批次尚未开放预约");
        }

        // ⓪-3 名额已满就别让学生白提交 —— 提交了审核也过不了。
        //      这里只是「快速失败」，真正的防超卖靠审核时那条原子 update。
        long capacity = batch.getCapacity() == null ? 0L : batch.getCapacity();
        long booked = batch.getBookedCount() == null ? 0L : batch.getBookedCount();
        if (booked >= capacity)
        {
            throw new ServiceException("该批次名额已满，请选择其他批次");
        }

        // ① 状态强制为「待审核」：不管前端传什么，一律按待审核入库
        appointment.setStatus("0");

        // ② 预约提交时间由系统填，不允许前端指定
        appointment.setAppointmentTime(DateUtils.getNowDate());

        // ③ 审核相关字段一律由后端控制：前端传了也要抹掉，否则会出现
        //    「状态=待审核、审核人=某某」这种伪造痕迹
        appointment.setAuditUser(null);
        appointment.setAuditTime(null);
        appointment.setAuditRemark(null);

        // ④ 查重：同一学生 + 同一批次只留一条记录（不新增，复用旧的）
        Appointment query = new Appointment();
        query.setStudentId(appointment.getStudentId());
        query.setBatchId(appointment.getBatchId());
        List<Appointment> exists = appointmentMapper.selectAppointmentList(query);
        if (!exists.isEmpty())
        {
            // 「已取消(3)」和「已拒绝(2)」都允许重新预约：复用这条记录、改回待审核。
            // 只放行「已取消」的话，学生被校医拒一次就再也约不上这个批次了，
            // 只能找管理员直接改库，等于把业务堵死。
            boolean finished = false;
            for (Appointment old : exists)
            {
                if ("3".equals(old.getStatus()) || "2".equals(old.getStatus()))
                {
                    old.setAppointmentTime(DateUtils.getNowDate());
                    return appointmentMapper.reappointAppointment(old);
                }
                if ("4".equals(old.getStatus()))
                {
                    finished = true;
                }
            }
            // 已经体检完的批次再约就没意义了，这里单独给一句话，
            // 别让学生看到"请勿重复提交"却不知道自己到底哪里重复了
            throw new ServiceException(finished
                    ? "该批次的体检已完成，无需重复预约"
                    : "该学生已预约此批次，请勿重复提交");
        }

        appointment.setCreateTime(DateUtils.getNowDate());
        return appointmentMapper.insertAppointment(appointment);
    }


    /**
     * 修改体检预约
     * 
     * @param appointment 体检预约
     * @return 结果
     */
    @Override
    public int updateAppointment(Appointment appointment)
    {
        // 状态和审核痕迹只能由 auditAppointment 流转。
        // 否则前端在「修改」弹窗里把状态改成「已通过」，就绕过了审核和名额校验。
        appointment.setStatus(null);
        appointment.setAuditUser(null);
        appointment.setAuditTime(null);
        appointment.setAuditRemark(null);

        appointment.setUpdateTime(DateUtils.getNowDate());
        return appointmentMapper.updateAppointment(appointment);
    }

    /**
     * 审核体检预约
     * 
     * 加 @Transactional 的原因：审核通过要同时做两件事 —— 写预约状态、占批次名额。
     * 必须同生共死，否则可能出现「名额扣了但状态没改」或「状态通过了但名额没扣」。
     * 注意：@Transactional 基于 AOP 代理，只对 public 方法、且从外部调用时生效。
     * 
     * @param appointment 至少包含 id、status；拒绝时还需 auditRemark
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int auditAppointment(Appointment appointment)
    {
        if (appointment.getId() == null)
        {
            throw new ServiceException("请选择要审核的预约记录");
        }

        // 审核结果只允许「通过」或「拒绝」，不允许借此接口把状态改成别的值
        String target = appointment.getStatus();
        if (!"1".equals(target) && !"2".equals(target))
        {
            throw new ServiceException("审核结果不合法");
        }

        // 拒绝必须说明原因，否则学生不知道该改什么
        if ("2".equals(target) && StringUtils.isEmpty(appointment.getAuditRemark()))
        {
            throw new ServiceException("拒绝预约必须填写审核备注（说明原因）");
        }

        // 先查旧状态：只有「待审核」才能被审核，防止重复点击或并发重复审核
        Appointment old = appointmentMapper.selectAppointmentById(appointment.getId());
        if (old == null)
        {
            throw new ServiceException("预约记录不存在");
        }
        if (!"0".equals(old.getStatus()))
        {
            throw new ServiceException("该预约已审核或已取消，请勿重复操作");
        }

        // 审核通过才占名额：这条 update 自带 booked_count < capacity 条件，
        // 返回 0 行就说明名额已满，直接抛异常让事务回滚
        if ("1".equals(target))
        {
            if (examBatchMapper.incrementBookedCount(old.getBatchId()) == 0)
            {
                throw new ServiceException("该体检批次名额已满，无法通过，请改为拒绝并提示学生改约其他批次");
            }
        }

        // 只构造需要改的字段，交给动态 update 精确更新
        Appointment update = new Appointment();
        update.setId(old.getId());
        update.setStatus(target);
        update.setAuditUser(SecurityUtils.getUserId());
        update.setAuditTime(DateUtils.getNowDate());
        update.setUpdateTime(DateUtils.getNowDate());
        if ("2".equals(target))
        {
            update.setAuditRemark(appointment.getAuditRemark());
        }

        return appointmentMapper.updateAppointment(update);
    }

    /**
     * 批量删除体检预约
     * 
     * @param ids 需要删除的体检预约主键
     * @return 结果
     */
    @Override
    public int deleteAppointmentByIds(Long[] ids)
    {
        return appointmentMapper.deleteAppointmentByIds(ids);
    }

    /**
     * 删除体检预约信息
     * 
     * @param id 体检预约主键
     * @return 结果
     */
    @Override
    public int deleteAppointmentById(Long id)
    {
        return appointmentMapper.deleteAppointmentById(id);
    }

    // =====================================================================
    // 学生自助入口
    // 这三个方法的共同点：学生ID 一律从登录态反查，前端传什么都不看。
    // 答辩时可以现场改 URL 里的 id 试，越权是拿不到数据的。
    // =====================================================================

    /**
     * 查自己的预约
     */
    @Override
    public List<Appointment> selectMyAppointmentList()
    {
        Student me = studentService.selectCurrentStudent();
        Appointment query = new Appointment();
        query.setStudentId(me.getId());
        return appointmentMapper.selectAppointmentList(query);
    }

    /**
     * 学生提交预约
     *
     * 不复用前端传的 appointment 对象直接入库，而是新建一个只带必要字段的实体：
     * 这样即使有人往请求体里塞 status=1（已预约）或 auditUser=1，也进不了库。
     */
    @Override
    public int applyAppointment(Appointment appointment)
    {
        Student me = studentService.selectCurrentStudent();
        if (appointment == null || appointment.getBatchId() == null)
        {
            throw new ServiceException("请选择体检批次");
        }

        Appointment submit = new Appointment();
        submit.setStudentId(me.getId());
        submit.setBatchId(appointment.getBatchId());
        submit.setRemark(appointment.getRemark());

        // 后续校验（批次是否开放、名额、重复预约）全在 insertAppointment 里，无需重复实现
        return insertAppointment(submit);
    }

    /**
     * 学生取消自己的预约
     *
     * 加事务的原因：状态要从「已预约」改成「已取消」，同时要把批次名额还回去。
     * 两件事必须同生共死，否则名额会凭空少一个。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int cancelMyAppointment(Long id)
    {
        Student me = studentService.selectCurrentStudent();

        Appointment old = appointmentMapper.selectAppointmentById(id);
        if (old == null)
        {
            throw new ServiceException("预约记录不存在");
        }
        // 归属校验放在最前面：别人的预约直接当作"不存在"，不泄露记录是否存在
        if (!me.getId().equals(old.getStudentId()))
        {
            throw new ServiceException("只能取消自己的预约");
        }
        if ("4".equals(old.getStatus()))
        {
            throw new ServiceException("体检已完成，不能取消预约");
        }
        if ("3".equals(old.getStatus()))
        {
            throw new ServiceException("该预约已取消，无需重复操作");
        }
        if ("2".equals(old.getStatus()))
        {
            throw new ServiceException("该预约已被拒绝，无需取消");
        }

        Appointment update = new Appointment();
        update.setId(id);
        update.setUpdateBy(SecurityUtils.getUsername());
        update.setUpdateTime(DateUtils.getNowDate());

        // SQL 里带 status in ('0','1') 条件，返回 0 说明状态已被别人改过
        int rows = appointmentMapper.cancelAppointment(update);
        if (rows == 0)
        {
            throw new ServiceException("预约状态已变化，请刷新后重试");
        }

        // 只有「已预约」才占过名额，待审核的没占，不能白减
        if ("1".equals(old.getStatus()))
        {
            examBatchMapper.decrementBookedCount(old.getBatchId());
        }
        return rows;
    }

    /**
     * 体检登记完成后回写预约状态
     * 允许 batchId 为空（线下零散体检没走预约流程），此时直接跳过。
     */
    @Override
    public int finishByExamRecord(Long studentId, Long batchId)
    {
        if (studentId == null || batchId == null)
        {
            return 0;
        }
        return appointmentMapper.finishByStudentAndBatch(studentId, batchId);
    }
}
