package com.example.library.controller;

import com.example.library.entity.Admin;
import com.example.library.entity.AdminLog;
import com.example.library.service.AdminLogService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/log")
public class AdminLogController {

    @Autowired
    private AdminLogService adminLogService;

    /**
     * 日志列表页面
     */
    @GetMapping("/list")
    public String logListPage() {
        return "admin/log-list";
    }

    /**
     * 获取操作日志列表
     * - 系统管理员（用户名=admin）：查看所有日志
     * - 普通管理员：只能查看自己的日志
     */
    @GetMapping("/data")
    @ResponseBody
    public Result getLogList(@RequestParam(defaultValue = "1") Integer page,
                            @RequestParam(defaultValue = "20") Integer limit,
                            @RequestParam(required = false) String targetType,
                            @RequestParam(required = false) Integer targetId,
                            HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        try {
            List<AdminLog> logs;
            
            // 判断是否为系统管理员（通过用户名判断，admin 为系统管理员）
            boolean isSystemAdmin = "admin".equals(admin.getUsername());
            
            if (isSystemAdmin) {
                // 系统管理员可以查询所有日志
                if (targetType != null && targetId != null) {
                    logs = adminLogService.getByTarget(targetType, targetId);
                } else {
                    logs = adminLogService.getAllLogs(page, limit);
                }
            } else {
                // 普通管理员只能查看自己的日志
                logs = adminLogService.getByAdminId(admin.getId().intValue(), page, limit);
            }
            
            return Result.success().put("data", logs).put("count", logs.size());
        } catch (Exception e) {
            return Result.error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 获取我的操作日志（所有管理员都可以）
     */
    @GetMapping("/my")
    @ResponseBody
    public Result getMyLogs(HttpSession session,
                           @RequestParam(defaultValue = "1") Integer page,
                           @RequestParam(defaultValue = "20") Integer limit) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        List<AdminLog> logs = adminLogService.getByAdminId(admin.getId().intValue(), page, limit);
        return Result.success().put("data", logs).put("count", logs.size());
    }
}
