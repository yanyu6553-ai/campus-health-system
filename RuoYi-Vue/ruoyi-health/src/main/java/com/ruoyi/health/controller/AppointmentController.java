package com.ruoyi.health.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.health.domain.Appointment;
import com.ruoyi.health.service.IAppointmentService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 体检预约Controller
 * 
 * @author shang
 * @date 2026-11-11
 */
@RestController
@RequestMapping("/health/appointment")
public class AppointmentController extends BaseController
{
    @Autowired
    private IAppointmentService appointmentService;

    /**
     * 查询体检预约列表
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:list')")
    @GetMapping("/list")
    public TableDataInfo list(Appointment appointment)
    {
        startPage();
        List<Appointment> list = appointmentService.selectAppointmentList(appointment);
        return getDataTable(list);
    }

    /**
     * 导出体检预约列表
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:export')")
    @Log(title = "体检预约", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Appointment appointment)
    {
        List<Appointment> list = appointmentService.selectAppointmentList(appointment);
        ExcelUtil<Appointment> util = new ExcelUtil<Appointment>(Appointment.class);
        util.exportExcel(response, list, "体检预约数据");
    }

    /**
     * 获取体检预约详细信息
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(appointmentService.selectAppointmentById(id));
    }

    /**
     * 新增体检预约
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:add')")
    @Log(title = "体检预约", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Appointment appointment)
    {
        return toAjax(appointmentService.insertAppointment(appointment));
    }

    /**
     * 修改体检预约
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:edit')")
    @Log(title = "体检预约", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Appointment appointment)
    {
        return toAjax(appointmentService.updateAppointment(appointment));
    }

    /**
     * 审核体检预约：status=1 通过，status=2 拒绝（需带 auditRemark）
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:edit')")
    @Log(title = "体检预约审核", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@RequestBody Appointment appointment)
    {
        return toAjax(appointmentService.auditAppointment(appointment));
    }

    /**
     * 删除体检预约
     */
    @PreAuthorize("@ss.hasPermi('health:appointment:remove')")
    @Log(title = "体检预约", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(appointmentService.deleteAppointmentByIds(ids));
    }

    // =====================================================================
    // 学生端：我的预约
    // 注意这几个接口都不接收 studentId —— 一律由登录态反查，避免改个 id 就查别人
    // =====================================================================

    /**
     * 我的预约记录
     */
    @PreAuthorize("@ss.hasPermi('health:my:appointment')")
    @GetMapping("/my")
    public AjaxResult my()
    {
        List<Appointment> list = appointmentService.selectMyAppointmentList();
        return success(list);
    }

    /**
     * 学生提交预约（批次由前端选择，学生身份由后端确定）
     */
    @PreAuthorize("@ss.hasPermi('health:my:appointment')")
    @Log(title = "体检预约", businessType = BusinessType.INSERT)
    @PostMapping("/apply")
    public AjaxResult apply(@RequestBody Appointment appointment)
    {
        return toAjax(appointmentService.applyAppointment(appointment));
    }

    /**
     * 学生取消自己的预约
     */
    @PreAuthorize("@ss.hasPermi('health:my:appointment')")
    @Log(title = "体检预约", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{id}")
    public AjaxResult cancel(@PathVariable Long id)
    {
        return toAjax(appointmentService.cancelMyAppointment(id));
    }
}
