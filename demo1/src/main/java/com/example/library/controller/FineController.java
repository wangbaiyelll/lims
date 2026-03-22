package com.example.library.controller;

import com.example.library.entity.Fine;
import com.example.library.entity.Teacher;
import com.example.library.service.FineService;
import com.example.library.util.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/fine")
public class FineController {

    @Autowired
    private FineService fineService;

    @GetMapping("/list")
    public String listPage() {
        return "admin/fine-list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Result getFineList(@RequestParam(defaultValue = "1") Integer page,
                              @RequestParam(defaultValue = "10") Integer limit,
                              String teacherName, Integer status) {
        PageHelper.startPage(page, limit);
        List<Fine> list = fineService.getByCondition(teacherName, status, page, limit);
        PageInfo<Fine> pageInfo = new PageInfo<>(list);
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }

    @GetMapping("/my")
    @ResponseBody
    public Result getMyFines(HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        List<Fine> list = fineService.getByTeacherId(teacher.getId(), null);
        return Result.success().put("data", list);
    }

    @PostMapping("/pay/{id}")
    @ResponseBody
    public Result payFine(@PathVariable Long id, HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        Fine fine = fineService.getById(id);
        if (fine == null || !fine.getTeacherId().equals(teacher.getId())) {
            return Result.error("罚款记录不存在");
        }

        try {
            if (fineService.payFine(id)) {
                return Result.success("支付成功");
            }
            return Result.error("支付失败");
        } catch (Exception e) {
            return Result.error("支付失败：" + e.getMessage());
        }
    }
}