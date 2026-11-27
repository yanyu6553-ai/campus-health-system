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
import com.ruoyi.health.domain.ExamItem;
import com.ruoyi.health.service.IExamItemService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 体检项目Controller
 * 
 * @author shang
 * @date 2026-11-11
 */
@RestController
@RequestMapping("/health/examItem")
public class ExamItemController extends BaseController
{
    @Autowired
    private IExamItemService examItemService;

    /**
     * 查询体检项目列表
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:list')")
    @GetMapping("/list")
    public TableDataInfo list(ExamItem examItem)
    {
        startPage();
        List<ExamItem> list = examItemService.selectExamItemList(examItem);
        return getDataTable(list);
    }

    /**
     * 查询全部启用的体检项目
     * 体检登记页面拉取"该录入哪些指标、各自参考范围是多少"时用
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:list')")
    @GetMapping("/enabled")
    public AjaxResult enabledList()
    {
        return success(examItemService.selectEnabledExamItemList());
    }

    /**
     * 导出体检项目列表
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:export')")
    @Log(title = "体检项目", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ExamItem examItem)
    {
        List<ExamItem> list = examItemService.selectExamItemList(examItem);
        ExcelUtil<ExamItem> util = new ExcelUtil<ExamItem>(ExamItem.class);
        util.exportExcel(response, list, "体检项目数据");
    }

    /**
     * 获取体检项目详细信息
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(examItemService.selectExamItemById(id));
    }

    /**
     * 新增体检项目
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:add')")
    @Log(title = "体检项目", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ExamItem examItem)
    {
        return toAjax(examItemService.insertExamItem(examItem));
    }

    /**
     * 修改体检项目
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:edit')")
    @Log(title = "体检项目", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ExamItem examItem)
    {
        return toAjax(examItemService.updateExamItem(examItem));
    }

    /**
     * 删除体检项目
     */
    @PreAuthorize("@ss.hasPermi('health:examItem:remove')")
    @Log(title = "体检项目", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(examItemService.deleteExamItemByIds(ids));
    }
}
