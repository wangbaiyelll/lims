package com.example.library.controller;

import com.example.library.entity.RenewApplication;
import com.example.library.entity.Teacher;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

import com.example.library.service.BorrowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.library.util.Result;
import com.github.pagehelper.PageInfo;
import com.example.library.entity.BorrowRecord;
import java.util.List;
import com.example.library.mapper.BookMapper;
import com.example.library.entity.Book;
import com.example.library.service.LocationService;
import com.example.library.entity.Location;

@Controller
@RequestMapping("/teacher")
public class TeacherCenterController {

    @Autowired
    private BorrowService borrowService;

    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private LocationService locationService;

    @GetMapping("/center")
    public String center(HttpSession session, Model model) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher != null) {
            model.addAttribute("teacher", teacher);
        }
        return "teacher/center";
    }

    @GetMapping("/my-borrow")
    public String myBorrow() {
        return "teacher/my-borrow";
    }

    @GetMapping("/myBorrow/data")
    @ResponseBody
    public Result getMyBorrowData(@RequestParam(defaultValue = "1") Integer page,
                                  @RequestParam(defaultValue = "10") Integer limit,
                                  @RequestParam(required = false) Integer status,
                                  HttpSession session) {
        // 从 session 获取教师 ID
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录").put("code", 401);
        }
        Integer teacherId = teacher.getId();
        
        List<BorrowRecord> list = borrowService.getByTeacherId(teacherId, status, page, limit);
        PageInfo<BorrowRecord> pageInfo = new PageInfo<>(list);
        
        // 为每条记录添加续借申请信息
        for (BorrowRecord record : list) {
            RenewApplication pendingApp = borrowService.getPendingRenewApplication(record.getId());
            record.setHasPendingRenewal(pendingApp != null);
            
            if (pendingApp != null) {
                record.setRenewalStatus(pendingApp.getStatus());
                record.setRenewalRemark(pendingApp.getAuditRemark());
            } else {
                RenewApplication recentApp = borrowService.getRecentRenewApplication(record.getId());
                if (recentApp != null && recentApp.getStatus() != 0) {
                    record.setRenewalStatus(recentApp.getStatus());
                    record.setRenewalRemark(recentApp.getAuditRemark());
                    record.setRenewalAuditDate(recentApp.getAuditDate());
                }
            }
        }
        
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }

    @GetMapping("/my-fine")
    public String myFine() {
        return "teacher/my-fine";
    }

    @GetMapping("/recommend")
    public String recommend() {
        return "teacher/recommend";
    }

    /**
     * 获取推荐图书数据
     */
    @GetMapping("/recommend/data")
    @ResponseBody
    public Result getRecommendData(HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录").put("code", 401);
        }

        System.out.println("📚 [推荐图书] 教师 ID: " + teacher.getId() + ", 姓名：" + teacher.getName());

        // 获取个性化推荐（基于借阅历史）
        List<Book> recommendBooks = bookMapper.selectRecommendByTeacher(teacher.getId(), 8);
        
        System.out.println("📊 [推荐图书] 找到 " + recommendBooks.size() + " 本推荐图书");
        
        // 如果没有推荐，返回一些热门图书
        if (recommendBooks == null || recommendBooks.isEmpty()) {
            System.out.println("⚠️ [推荐图书] 无个性化推荐，返回热门图书");
            recommendBooks = bookMapper.selectPopular(8);
            System.out.println("🔥 [推荐图书] 找到 " + recommendBooks.size() + " 本热门图书");
        }

        // 打印图书信息
        for (Book book : recommendBooks) {
            System.out.println("📖 图书：" + book.getTitle() + 
                             ", 作者：" + book.getAuthor() + 
                             ", 可借：" + book.getAvailableQty() + 
                             ", 价格：" + book.getPrice());
        }

        return Result.success().put("data", recommendBooks);
    }

    /**
     * 获取热门图书
     */
    @GetMapping("/book/popular")
    @ResponseBody
    public Result getPopularBooks(@RequestParam(defaultValue = "8") Integer limit, HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录").put("code", 401);
        }

        List<Book> list = bookMapper.selectPopular(limit);
        return Result.success().put("data", list);
    }

    @GetMapping("/location/getByCode")
    @ResponseBody
    public Result getLocationByCode(@RequestParam String code) {
        try {
            Location location = locationService.getByCode(code);
            if (location != null) {
                return Result.success().put("data", location);
            }
            return Result.error("位置编码不存在");
        } catch (Exception e) {
            return Result.error("查询失败：" + e.getMessage());
        }
    }

    @GetMapping("/message")
    public String message() {
        return "teacher/message";
    }
}