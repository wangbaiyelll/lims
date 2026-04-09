package com.example.library.controller;

import com.example.library.entity.Admin;
import com.example.library.entity.Role;
import com.example.library.service.RoleService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/admin/role")
public class RoleController {

    @Autowired
    private RoleService roleService;

    /**
     * 角色列表页面
     */
    @GetMapping("/list")
    public String roleListPage() {
        return "admin/role-list";
    }

    /**
     * 获取所有角色
     */
    @GetMapping("/data")
    @ResponseBody
    public Result getRoleList(HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        // 只有超级管理员可以查看所有角色
        if (!"admin".equals(admin.getUsername())) {
            return Result.error("无权访问");
        }

        List<Role> roles = roleService.getAll();
        return Result.success().put("data", roles).put("count", roles.size());
    }

    /**
     * 添加角色
     */
    @PostMapping("/add")
    @ResponseBody
    public Result addRole(@RequestBody Role role, HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        if (!"admin".equals(admin.getUsername())) {
            return Result.error("无权操作");
        }

        if (roleService.add(role)) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    /**
     * 更新角色
     */
    @PostMapping("/update")
    @ResponseBody
    public Result updateRole(@RequestBody Role role, HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        if (!"admin".equals(admin.getUsername())) {
            return Result.error("无权操作");
        }

        if (roleService.update(role)) {
            return Result.success("修改成功");
        }
        return Result.error("修改失败");
    }

    /**
     * 删除角色
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Result deleteRole(@PathVariable Integer id, HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        if (!"admin".equals(admin.getUsername())) {
            return Result.error("无权操作");
        }

        if (roleService.delete(id)) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    /**
     * 权限配置页面
     */
    @GetMapping("/config/{id}")
    public String configPage(@PathVariable Integer id, Model model) {
        Role role = roleService.getById(id);
        model.addAttribute("role", role);
        return "admin/role-config";
    }

    /**
     * 保存权限配置
     */
    @PostMapping("/config/save")
    @ResponseBody
    public Result saveConfig(@RequestParam Integer id,
                             @RequestParam String permissions,
                             HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        if (!"admin".equals(admin.getUsername())) {
            return Result.error("无权操作");
        }

        Role role = roleService.getById(id);
        if (role == null) {
            return Result.error("角色不存在");
        }

        // 将权限字符串转换为 JSON 数组
        role.setPermissionJson(permissions);
        if (roleService.update(role)) {
            return Result.success("权限配置已保存");
        }
        return Result.error("保存失败");
    }
}
