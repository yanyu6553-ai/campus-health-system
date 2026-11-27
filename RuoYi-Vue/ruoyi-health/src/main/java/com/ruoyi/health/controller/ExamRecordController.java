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
import com.ruoyi.health.domain.ExamRecord;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.service.IExamRecordService;
import com.ruoyi.health.service.IStudentService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 体检记录Controller
 * 
 * @author shang
 * @date 2026-11-11
 */
@RestController
@RequestMapping("/health/examRecord")
public class ExamRecordController extends BaseController
{
    @Autowired
    private IExamRecordService examRecordService;

    @Autowired
    private IStudentService studentService;

    /**
     * 查询体检记录列表
     */
    @PreAuthorize("@ss.hasPermi('health:examRecord:list')")
    @GetMapping("/list")
    public TableDataInfo list(ExamRecord examRecord)
    {
        startPage();
        List<ExamRecord> list = examRecordService.selectExamRecordList(examRecord);
        return getDataTable(list);
    }

    /**
     * 导出体检记录列表
     */
    @PreAuthorize("@ss.hasPermi('health:examRecord:export')")
    @Log(title = "体检记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ExamRecord examRecord)
    {
        List<ExamRecord> list = examRecordService.selectExamRecordList(examRecord);
        ExcelUtil<ExamRecord> util = new ExcelUtil<ExamRecord>(ExamRecord.class);
        util.exportExcel(response, list, "体检记录数据");
    }

    /**
     * 获取体检记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('health:examRecord:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(examRecordService.selectExamRecordById(id));
    }

    /**
     * 新增体检记录
     */
    @PreAuthorize("@ss.hasPermi('health:examRecord:add')")
    @Log(title = "体检记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ExamRecord examRecord)
    {
        return toAjax(examRecordService.insertExamRecord(examRecord));
    }

    /**
     * 修改体检记录
     */
    @PreAuthorize("@ss.hasPermi('health:examRecord:edit')")
    @Log(title = "体检记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ExamRecord examRecord)
    {
        return toAjax(examRecordService.updateExamRecord(examRecord));
    }

    /**
     * 删除体检记录
     */
    @PreAuthorize("@ss.hasPermi('health:examRecord:remove')")
    @Log(title = "体检记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(examRecordService.deleteExamRecordByIds(ids));
    }

    /**
     * 我的体检记录（学生端）
     *
     * 不接收 studentId，学生身份由登录态反查，避免越权查看他人记录。
     */
    @PreAuthorize("@ss.hasPermi('health:my:records')")
    @GetMapping("/my")
    public AjaxResult my()
    {
        Student me = studentService.selectCurrentStudent();
        ExamRecord query = new ExamRecord();
        query.setStudentId(me.getId());
        return success(examRecordService.selectExamRecordList(query));
    }
}
