package com.example.library.controller;

import com.example.library.entity.Teacher;
import com.example.library.service.TeacherService;
import com.example.library.util.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/teacher")
public class AdminTeacherController {

    @Autowired
    private TeacherService teacherService;

    @GetMapping("/list")
    public String listPage() {
        return "admin/teacher-list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Result getTeacherList(@RequestParam(defaultValue = "1") Integer page,
                                 @RequestParam(defaultValue = "10") Integer limit,
                                 String keyword, String college, Integer status) {
        PageHelper.startPage(page, limit);
        List<Teacher> list = teacherService.getByCondition(keyword, college, status, page, limit);
        PageInfo<Teacher> pageInfo = new PageInfo<>(list);
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }

    @PostMapping("/add")
    @ResponseBody
    public Result addTeacher(Teacher teacher) {
        try {
            if (teacherService.add(teacher)) {
                return Result.success("添加成功");
            }
            return Result.error("工号或用户名已存在");
        } catch (Exception e) {
            return Result.error("添加失败：" + e.getMessage());
        }
    }

    @PutMapping("/update")
    @ResponseBody
    public Result updateTeacher(Teacher teacher) {
        try {
            if (teacherService.update(teacher)) {
                return Result.success("更新成功");
            }
            return Result.error("更新失败");
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }

    @PutMapping("/status/{id}/{status}")
    @ResponseBody
    public Result updateStatus(@PathVariable Integer id, @PathVariable Integer status) {
        try {
            if (teacherService.updateStatus(id, status)) {
                return Result.success(status == 1 ? "启用成功" : "禁用成功");
            }
            return Result.error("操作失败");
        } catch (Exception e) {
            return Result.error("操作失败：" + e.getMessage());
        }
    }

    @PostMapping("/resetPwd/{id}")
    @ResponseBody
    public Result resetPassword(@PathVariable Integer id) {
        try {
            if (teacherService.resetPassword(id)) {
                return Result.success("密码重置成功，新密码已发送至邮箱");
            }
            return Result.error("重置失败");
        } catch (Exception e) {
            return Result.error("重置失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result deleteTeacher(@PathVariable Integer id) {
        try {
            if (teacherService.delete(id)) {
                return Result.success("删除成功");
            }
            return Result.error("删除失败");
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}