package com.ruoyi.health.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.health.domain.Appointment;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.mapper.DashboardMapper;
import com.ruoyi.health.service.IAppointmentService;
import com.ruoyi.health.service.IArchiveService;
import com.ruoyi.health.service.IStudentService;

/**
 * 首页数据看板
 *
 * 这个接口不加 @PreAuthorize：它是登录后所有人都能看的概览数据，
 * 但也不该给出明细（健康档案的逐人数据另有接口和权限控制）。
 *
 * 注意区分两种视角：
 *   管理端（管理员/校医/辅导员）→ 全校数据；
 *   学生端 → 只看自己的数据，否则"学生看不到全校体检数据统计"这条要求就落空了。
 *
 * @author shang
 */
@RestController
@RequestMapping("/health/dashboard")
public class DashboardController extends BaseController
{
    @Autowired
    private DashboardMapper dashboardMapper;

    @Autowired
    private IStudentService studentService;

    @Autowired
    private IArchiveService archiveService;

    @Autowired
    private IAppointmentService appointmentService;

    /**
     * 首页汇总数据：一次请求把卡片、图表、最近记录都带回去，
     * 避免前端串行发四五个请求。
     */
    @GetMapping("/summary")
    public AjaxResult summary()
    {
        // 学生视角：只给自己的数据，不返回任何全校汇总
        if (isStudent())
        {
            return success(selfSummary());
        }

        int studentTotal = dashboardMapper.countStudents();
        int examined = dashboardMapper.countExaminedStudents();
        int pending = dashboardMapper.countAppointmentsByStatus("0");
        int approved = dashboardMapper.countAppointmentsByStatus("1");
        int abnormal = dashboardMapper.countAbnormalStudents();
        int todayAppointment = dashboardMapper.countTodayAppointments();

        // 完成率保留一位小数，分母为 0 时直接给 0，避免出现 NaN
        double rate = studentTotal == 0 ? 0.0 : Math.round(examined * 1000.0 / studentTotal) / 10.0;

        List<Map<String, Object>> bmi = dashboardMapper.selectBmiDistribution();
        List<Map<String, Object>> itemAbnormal = dashboardMapper.selectItemAbnormalDistribution();
        List<Map<String, Object>> batches = dashboardMapper.selectBatchProgress();
        List<Map<String, Object>> recent = dashboardMapper.selectRecentAppointments();

        Map<String, Object> data = new HashMap<>();
        data.put("studentTotal", studentTotal);
        data.put("examinedCount", examined);
        data.put("notExaminedCount", Math.max(studentTotal - examined, 0));
        data.put("pendingAuditCount", pending);
        data.put("approvedCount", approved);
        data.put("abnormalCount", abnormal);
        data.put("todayAppointmentCount", todayAppointment);
        data.put("completeRate", rate);
        data.put("bmiDistribution", bmi);
        data.put("itemAbnormal", itemAbnormal);
        data.put("batchProgress", batches);
        data.put("recentAppointments", recent);
        return success(data);
    }

    /**
     * 当前账号是否学生角色
     * 用角色 key 而不是角色名判断，改名不怕；管理员即便也有 roleKey 也不该走这条路
     */
    private boolean isStudent()
    {
        try
        {
            if (SecurityUtils.getLoginUser().getUser().isAdmin())
            {
                return false;
            }
            List<SysRole> roles = SecurityUtils.getLoginUser().getUser().getRoles();
            if (roles == null)
            {
                return false;
            }
            for (SysRole role : roles)
            {
                if ("student".equals(role.getRoleKey()))
                {
                    return true;
                }
            }
            return false;
        }
        catch (Exception e)
        {
            // 没有登录态根本进不到这个方法（接口需要认证），这里只是防御性兜底
            return false;
        }
    }

    /**
     * 学生个人视角的首页数据
     * scope=self 让前端知道该渲染"我的"那套卡片，而不是全校看板
     */
    private Map<String, Object> selfSummary()
    {
        Student me = studentService.selectCurrentStudent();
        Map<String, Object> archive = archiveService.selectArchiveByStudentId(me.getId());
        List<Appointment> myAppointments = appointmentService.selectMyAppointmentList();

        // 未完成的预约算"待办"，已完成的历史记录不算
        int todo = 0;
        for (Appointment a : myAppointments)
        {
            if ("0".equals(a.getStatus()) || "1".equals(a.getStatus()))
            {
                todo++;
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("scope", "self");
        data.put("student", archive.get("student"));
        data.put("latest", archive.get("latest"));
        data.put("records", archive.get("records"));
        data.put("appointments", myAppointments);
        data.put("examCount", myAppointments.size());
        data.put("todoCount", todo);
        return data;
    }
}
