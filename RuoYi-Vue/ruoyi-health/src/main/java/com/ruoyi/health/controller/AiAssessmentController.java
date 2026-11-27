package com.ruoyi.health.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.health.domain.AiAssessment;
import com.ruoyi.health.service.IAiAssessmentService;

/**
 * AI健康评估Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/health/ai")
public class AiAssessmentController extends BaseController
{
    @Autowired
    private IAiAssessmentService aiAssessmentService;

    /**
     * 查询AI健康评估列表
     */
    @PreAuthorize("@ss.hasPermi('health:ai:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiAssessment aiAssessment)
    {
        startPage();
        List<AiAssessment> list = aiAssessmentService.selectAiAssessmentList(aiAssessment);
        return getDataTable(list);
    }

    /**
     * 导出AI健康评估列表
     */
    @PreAuthorize("@ss.hasPermi('health:ai:export')")
    @Log(title = "AI健康评估", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiAssessment aiAssessment)
    {
        List<AiAssessment> list = aiAssessmentService.selectAiAssessmentList(aiAssessment);
        ExcelUtil<AiAssessment> util = new ExcelUtil<AiAssessment>(AiAssessment.class);
        util.exportExcel(response, list, "AI健康评估数据");
    }

    /**
     * 学生查看自己的 AI 评估记录（含待评估/评估中/已完成）
     *
     * 权限单独用一个 student 角色的按钮权限，不走 health:ai:list —— 后者是全校报告的管理权限，
     * 授给学生就等于放开全校健康数据，违反设计文档 1.4「不能默认开放全校健康档案」。
     */
    @PreAuthorize("@ss.hasPermi('health:my:ai')")
    @GetMapping("/my")
    public AjaxResult my()
    {
        return success(aiAssessmentService.selectMyAssessmentList());
    }

    /**
     * 按体检记录查询已有的评估结果（没有则返回 null）
     */
    @PreAuthorize("@ss.hasPermi('health:ai:query')")
    @GetMapping("/byRecord/{examRecordId}")
    public AjaxResult getByRecord(@PathVariable Long examRecordId)
    {
        return success(aiAssessmentService.selectAiAssessmentByRecordId(examRecordId));
    }

    /**
     * 获取AI健康评估详细信息
     */
    @PreAuthorize("@ss.hasPermi('health:ai:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(aiAssessmentService.selectAiAssessmentById(id));
    }

    /**
     * 对指定体检记录生成AI健康评估（调用大模型并入库）
     */
    @PreAuthorize("@ss.hasPermi('health:ai:assess')")
    @Log(title = "AI健康评估", businessType = BusinessType.INSERT)
    @PostMapping("/assess/{examRecordId}")
    public AjaxResult assess(@PathVariable("examRecordId") Long examRecordId)
    {
        return success(aiAssessmentService.assess(examRecordId));
    }

    /**
     * 删除AI健康评估
     */
    @PreAuthorize("@ss.hasPermi('health:ai:remove')")
    @Log(title = "AI健康评估", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(aiAssessmentService.deleteAiAssessmentByIds(ids));
    }
}
