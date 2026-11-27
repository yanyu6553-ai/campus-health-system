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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.service.IStudentService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 学生信息Controller
 * 
 * @author ruoyi
 * @date 2026-11-10
 */
@RestController
@RequestMapping("/health/student")
public class StudentController extends BaseController
{
    @Autowired
    private IStudentService studentService;

    /**
     * 查询学生信息列表
     */
    @PreAuthorize("@ss.hasPermi('health:student:list')")
    @GetMapping("/list")
    public TableDataInfo list(Student student)
    {
        startPage();
        List<Student> list = studentService.selectStudentList(student);
        return getDataTable(list);
    }

    /**
     * 导出学生信息列表
     */
    @PreAuthorize("@ss.hasPermi('health:student:export')")
    @Log(title = "学生信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Student student)
    {
        List<Student> list = studentService.selectStudentList(student);
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        util.exportExcel(response, list, "学生信息数据");
    }

    /**
     * 获取学生信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('health:student:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(studentService.selectStudentById(id));
    }

    /**
     * 新增学生信息
     */
    @PreAuthorize("@ss.hasPermi('health:student:add')")
    @Log(title = "学生信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Student student)
    {
        return toAjax(studentService.insertStudent(student));
    }

    /**
     * 修改学生信息
     */
    @PreAuthorize("@ss.hasPermi('health:student:edit')")
    @Log(title = "学生信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Student student)
    {
        return toAjax(studentService.updateStudent(student));
    }

    /**
     * 删除学生信息
     */
    @PreAuthorize("@ss.hasPermi('health:student:remove')")
    @Log(title = "学生信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(studentService.deleteStudentByIds(ids));
    }

    /**
     * 下载学生导入模板
     * 模板就是 Student 实体按 @Excel 注解生成的那张表头，字段改了模板自动跟着变
     */
    @PreAuthorize("@ss.hasPermi('health:student:import')")
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response)
    {
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        util.importTemplateExcel(response, "学生信息数据");
    }

    /**
     * 导入学生数据
     * 
     * @param file           上传的 Excel 文件
     * @param updateSupport  true=学号已存在时覆盖更新，false=跳过并报错
     */
    @PreAuthorize("@ss.hasPermi('health:student:import')")
    @Log(title = "学生信息", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(@RequestParam("file") MultipartFile file,
                                 @RequestParam(value = "updateSupport", defaultValue = "false") boolean updateSupport)
            throws Exception
    {
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        List<Student> studentList = util.importExcel(file.getInputStream());
        String message = studentService.importStudent(studentList, updateSupport, getUsername());
        return success(message);
    }
}
