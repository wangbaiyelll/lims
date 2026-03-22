package com.example.library.controller;

import com.example.library.service.BorrowService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/return")
public class ReturnController {

    @Autowired
    private BorrowService borrowService;

    @PostMapping("/doReturn/{borrowId}")
    @ResponseBody
    public Result doReturn(@PathVariable Long borrowId, HttpSession session) {
        try {
            if (borrowService.returnBook(borrowId)) {
                return Result.success("还书成功");
            }
            return Result.error("还书失败");
        } catch (Exception e) {
            return Result.error("还书失败：" + e.getMessage());
        }
    }
}