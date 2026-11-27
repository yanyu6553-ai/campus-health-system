package com.ruoyi.health.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.health.domain.Student;
import com.ruoyi.health.service.IArchiveService;
import com.ruoyi.health.service.IStudentService;

/**
 * 健康档案Controller
 *
 * @author shang
 * @date 2026-11-11
 */
@RestController
@RequestMapping("/health/archive")
public class ArchiveController extends BaseController
{
    @Autowired
    private IArchiveService archiveService;

    @Autowired
    private IStudentService studentService;

    /**
     * 获取学生健康档案（学生信息 + 最新指标 + 历史记录）
     */
    @PreAuthorize("@ss.hasPermi('health:archive:query')")
    @GetMapping(value = "/{studentId}")
    public AjaxResult getArchive(@PathVariable("studentId") Long studentId)
    {
        return success(archiveService.selectArchiveByStudentId(studentId));
    }

    /**
     * 我的健康档案
     *
     * 学生端唯一入口。没有 studentId 参数 —— 想看谁的档案，得先有谁的学生档案绑定，
     * 改 URL 是改不出别人数据的。这是"学生不能查看他人档案"（T13）的后端落点。
     */
    @PreAuthorize("@ss.hasPermi('health:my:archive')")
    @GetMapping(value = "/my")
    public AjaxResult myArchive()
    {
        Student me = studentService.selectCurrentStudent();
        return success(archiveService.selectArchiveByStudentId(me.getId()));
    }
}
