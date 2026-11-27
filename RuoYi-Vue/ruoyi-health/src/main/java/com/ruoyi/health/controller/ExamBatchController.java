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
import com.ruoyi.health.domain.ExamBatch;
import com.ruoyi.health.service.IExamBatchService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 体检批次Controller
 * 
 * @author shang
 * @date 2026-11-11
 */
@RestController
@RequestMapping("/health/examBatch")
public class ExamBatchController extends BaseController
{
    @Autowired
    private IExamBatchService examBatchService;

    /**
     * 查询体检批次列表
     */
    @PreAuthorize("@ss.hasPermi('health:examBatch:list')")
    @GetMapping("/list")
    public TableDataInfo list(ExamBatch examBatch)
    {
        startPage();
        List<ExamBatch> list = examBatchService.selectExamBatchList(examBatch);
        return getDataTable(list);
    }

    /**
     * 导出体检批次列表
     */
    @PreAuthorize("@ss.hasPermi('health:examBatch:export')")
    @Log(title = "体检批次", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ExamBatch examBatch)
    {
        List<ExamBatch> list = examBatchService.selectExamBatchList(examBatch);
        ExcelUtil<ExamBatch> util = new ExcelUtil<ExamBatch>(ExamBatch.class);
        util.exportExcel(response, list, "体检批次数据");
    }

    /**
     * 获取体检批次详细信息
     */
    @PreAuthorize("@ss.hasPermi('health:examBatch:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(examBatchService.selectExamBatchById(id));
    }

    /**
     * 新增体检批次
     */
    @PreAuthorize("@ss.hasPermi('health:examBatch:add')")
    @Log(title = "体检批次", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ExamBatch examBatch)
    {
        return toAjax(examBatchService.insertExamBatch(examBatch));
    }

    /**
     * 修改体检批次
     */
    @PreAuthorize("@ss.hasPermi('health:examBatch:edit')")
    @Log(title = "体检批次", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ExamBatch examBatch)
    {
        return toAjax(examBatchService.updateExamBatch(examBatch));
    }

    /**
     * 删除体检批次
     */
    @PreAuthorize("@ss.hasPermi('health:examBatch:remove')")
    @Log(title = "体检批次", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(examBatchService.deleteExamBatchByIds(ids));
    }

    /**
     * 可预约的批次（学生端下拉框用）
     *
     * 只返回「预约中」的批次，且只给必要字段。
     * 没有单独开一个公共接口：仍然要求登录 + 具备学生预约权限或批次查看权限。
     */
    @PreAuthorize("@ss.hasPermi('health:my:appointment') or @ss.hasPermi('health:examBatch:list')")
    @GetMapping("/open")
    public AjaxResult open()
    {
        ExamBatch query = new ExamBatch();
        query.setStatus("1");
        return success(examBatchService.selectExamBatchList(query));
    }
}
