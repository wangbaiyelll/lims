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

/**
 * 教师管理控制器
 * 处理管理员对教师信息的管理操作，包括查询、添加、更新、删除等
 */
@Controller
@RequestMapping("/admin/teacher")
public class AdminTeacherController {

    @Autowired
    private TeacherService teacherService;  // 教师服务层，用于处理教师相关的业务逻辑

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

    @GetMapping("/edit/{id}")
    @ResponseBody
    public Result editTeacher(@PathVariable Integer id) {
        try {
            Teacher teacher = teacherService.getById(id);
            if (teacher != null) {
                return Result.success().put("data", teacher);
            }
            return Result.error("教师不存在");
        } catch (Exception e) {
            return Result.error("获取失败：" + e.getMessage());
        }
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

    @DeleteMapping("/batchDelete")
    @ResponseBody
    public Result batchDelete(@RequestParam String ids) {
        try {
            String[] idArray = ids.split(",");
            int successCount = 0;
            for (String idStr : idArray) {
                try {
                    Integer id = Integer.parseInt(idStr.trim());
                    if (teacherService.delete(id)) {
                        successCount++;
                    }
                } catch (NumberFormatException e) {
                    // 跳过无效的 ID
                }
            }
            return Result.success("成功删除 " + successCount + " 条记录");
        } catch (Exception e) {
            return Result.error("批量删除失败：" + e.getMessage());
        }
    }
}