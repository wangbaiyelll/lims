package com.example.library.controller;

import com.example.library.service.DashboardService;
import com.example.library.util.Result;
import com.example.library.vo.BookRankVO;
import com.example.library.vo.DashboardVO;
import com.example.library.vo.TrendVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/admin/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping
    public String dashboardPage(Model model) {
        DashboardVO dashboard = dashboardService.getDashboardData();
        List<TrendVO> trend = dashboardService.getBorrowTrend(7);
        List<BookRankVO> hotBooks = dashboardService.getHotBooks(10);

        model.addAttribute("dashboard", dashboard);
        model.addAttribute("trend", trend);
        model.addAttribute("hotBooks", hotBooks);

        return "admin/dashboard";
    }

    @GetMapping("/data")
    @ResponseBody
    public Result getDashboardData() {
        DashboardVO vo = dashboardService.getDashboardData();
        return Result.success().put("data", vo);
    }

    @GetMapping("/trend")
    @ResponseBody
    public Result getTrend(@RequestParam(defaultValue = "7") Integer days) {
        List<TrendVO> list = dashboardService.getBorrowTrend(days);
        return Result.success().put("data", list);
    }

    @GetMapping("/hotBooks")
    @ResponseBody
    public Result getHotBooks(@RequestParam(defaultValue = "10") Integer limit) {
        List<BookRankVO> list = dashboardService.getHotBooks(limit);
        return Result.success().put("data", list);
    }
}