package com.example.library.controller;

import com.example.library.entity.RenewApplication;
import com.example.library.entity.Teacher;
import com.example.library.service.BorrowService;
import com.example.library.service.BookService;
import com.example.library.service.LocationService;
import com.example.library.util.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/borrow")
public class BorrowController {

    @Autowired
    private BorrowService borrowService;

    @Autowired
    private BookService bookService;

    @Autowired
    private LocationService locationService;

    @PostMapping("/doBorrow")
    @ResponseBody
    public Result doBorrow(@RequestParam Integer bookId,
                           @RequestParam Integer locationId,
                           HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        try {
            if (borrowService.borrow(teacher.getId(), bookId, locationId)) {
                return Result.success("借书成功");
            }
            return Result.error("借书失败，请检查库存或是否有逾期未还图书");
        } catch (Exception e) {
            return Result.error("借书失败：" + e.getMessage());
        }
    }

    @PostMapping("/applyRenew/{borrowId}")
    @ResponseBody
    public Result applyRenew(@PathVariable Long borrowId, HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        try {
            if (borrowService.applyRenew(borrowId, teacher.getId())) {
                return Result.success("续借申请已提交，请等待审核");
            }
            return Result.error("申请失败，可能已逾期或已达到续借次数上限");
        } catch (Exception e) {
            return Result.error("申请失败：" + e.getMessage());
        }
    }

    @GetMapping("/renew/list")
    public String renewListPage() {
        return "admin/renew-list";
    }

    @GetMapping("/renew/data")
    @ResponseBody
    public Result getRenewList(@RequestParam(defaultValue = "1") Integer page,
                               @RequestParam(defaultValue = "10") Integer limit) {
        PageHelper.startPage(page, limit);
        List<RenewApplication> list = borrowService.getRenewApplications(page, limit);
        PageInfo<RenewApplication> pageInfo = new PageInfo<>(list);
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }

    @PostMapping("/renew/audit/{id}")
    @ResponseBody
    public Result auditRenew(@PathVariable Long id,
                             @RequestParam Integer status,
                             @RequestParam(required = false) String remark,
                             HttpSession session) {
        com.example.library.entity.Admin admin =
                (com.example.library.entity.Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return Result.error("请先登录");
        }

        try {
            if (borrowService.auditRenew(id, status, admin.getId(), remark)) {
                return Result.success(status == 1 ? "审核通过" : "已拒绝");
            }
            return Result.error("审核失败");
        } catch (Exception e) {
            return Result.error("审核失败：" + e.getMessage());
        }
    }
}