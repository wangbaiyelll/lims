package com.example.library.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.library.entity.BorrowRecord;
import com.example.library.service.BorrowService;
import com.example.library.util.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private BorrowService borrowService;

    @GetMapping("/index")
    public String index() {
        return "admin/index";
    }

    @GetMapping("/stock-list")
    public String stockList() {
        return "admin/stock-list";
    }

    @GetMapping("/borrow/list")
    public String borrowList() {
        return "admin/borrow-list";
    }

    @GetMapping("/fine/list")
    public String fineList() {
        return "admin/fine-list";
    }

    @GetMapping("/borrow/data")
    @ResponseBody
    public Result getBorrowData(@RequestParam(defaultValue = "1") Integer page,
                                @RequestParam(defaultValue = "10") Integer limit,
                                @RequestParam(required = false) String teacherName,
                                @RequestParam(required = false) String bookTitle,
                                @RequestParam(required = false) Integer status) {
        PageHelper.startPage(page, limit);
        List<BorrowRecord> list = borrowService.getBorrowsWithCondition(teacherName, bookTitle, status, page, limit);
        PageInfo<BorrowRecord> pageInfo = new PageInfo<>(list);
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }

    @GetMapping("/borrow/overdue")
    @ResponseBody
    public Result getOverdueData(@RequestParam(defaultValue = "1") Integer page,
                                @RequestParam(defaultValue = "10") Integer limit) {
        PageHelper.startPage(page, limit);
        List<BorrowRecord> list = borrowService.getOverdueList();
        PageInfo<BorrowRecord> pageInfo = new PageInfo<>(list);
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }
}