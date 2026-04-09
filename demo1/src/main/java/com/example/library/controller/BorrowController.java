package com.example.library.controller;

import com.example.library.entity.BorrowRecord;
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
import java.util.ArrayList;
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
            return Result.error("申请失败，可能已逾期、已达到续借次数上限或已有待审核申请");
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
                               @RequestParam(defaultValue = "10") Integer limit,
                               @RequestParam(required = false) String teacherName,
                               @RequestParam(required = false) String bookTitle,
                               @RequestParam(required = false) Integer status) {
        // 使用条件查询服务
        List<RenewApplication> list = borrowService.getRenewApplicationsWithCondition(teacherName, bookTitle, status);
        
        // 手动分页
        int start = (page - 1) * limit;
        int end = Math.min(start + limit, list.size());
        List<RenewApplication> pageList;
        if (start >= list.size()) {
            pageList = java.util.Collections.emptyList();
        } else {
            pageList = list.subList(start, end);
        }
        
        return Result.success().put("data", pageList).put("count", list.size());
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
            if (borrowService.auditRenew(id, status, admin.getId().intValue(), remark)) {
                return Result.success(status == 1 ? "审核通过" : "已拒绝");
            }
            return Result.error("审核失败");
        } catch (Exception e) {
            return Result.error("审核失败：" + e.getMessage());
        }
    }

    @GetMapping("/my-borrows")
    @ResponseBody
    public Result getMyBorrows(@RequestParam(defaultValue = "1") Integer page,
                               @RequestParam(defaultValue = "10") Integer limit,
                               @RequestParam(required = false) Integer teacherId,
                               @RequestParam(required = false) Integer status,
                               @RequestParam(required = false) String field,
                               @RequestParam(required = false) String order) {
        // 设置排序
        if (field != null && !field.isEmpty()) {
            String orderBy = field + " " + (order != null ? order : "asc");
            PageHelper.orderBy(orderBy);
        }
        
        PageHelper.startPage(page, limit);
        List<BorrowRecord> list = borrowService.getByTeacherId(teacherId, status, page, limit);
        PageInfo<BorrowRecord> pageInfo = new PageInfo<>(list);
        
        // 优化：批量查询所有续借申请，避免 N+1 查询问题
        if (list != null && !list.isEmpty()) {
            List<Long> borrowIds = new ArrayList<>();
            for (BorrowRecord record : list) {
                borrowIds.add(record.getId());
            }
            
            // 一次性查询所有借阅记录的续借申请
            List<RenewApplication> allApplications = borrowService.getApplicationsByBorrowIds(borrowIds);
            
            // 为每条记录分配续借申请信息
            for (BorrowRecord record : list) {
                // 查找待审核的申请
                RenewApplication pendingApp = null;
                RenewApplication recentApp = null;
                
                for (RenewApplication app : allApplications) {
                    if (app.getBorrowId().equals(record.getId())) {
                        if (app.getStatus() == 0 && pendingApp == null) {
                            pendingApp = app;
                        }
                        // 找最近的已审核申请
                        if (app.getStatus() != 0 && (recentApp == null || app.getAuditDate().after(recentApp.getAuditDate()))) {
                            recentApp = app;
                        }
                    }
                }
                
                record.setHasPendingRenewal(pendingApp != null);
                
                if (pendingApp != null) {
                    record.setRenewalStatus(pendingApp.getStatus());
                    record.setRenewalRemark(pendingApp.getAuditRemark());
                } else if (recentApp != null) {
                    record.setRenewalStatus(recentApp.getStatus());
                    record.setRenewalRemark(recentApp.getAuditRemark());
                    record.setRenewalAuditDate(recentApp.getAuditDate());
                }
            }
        }
        
        // 检查该教师是否有逾期未还的图书记录（使用实时更新后的数据）
        boolean hasAnyOverdue = false;
        int overdueCount = 0;
        
        // 遍历当前页的记录检查是否有逾期
        if (list != null && !list.isEmpty()) {
            for (BorrowRecord record : list) {
                if (record.getStatus() == 3) {
                    hasAnyOverdue = true;
                    overdueCount++;
                    break;
                }
            }
        }
        
        // 如果没有，再查询总数（优化性能）
        if (!hasAnyOverdue) {
            overdueCount = borrowService.countByTeacherIdAndStatus(teacherId, 3);
            hasAnyOverdue = overdueCount > 0;
        }
        
        return Result.success()
                .put("data", pageInfo.getList())
                .put("count", pageInfo.getTotal())
                .put("hasAnyOverdue", hasAnyOverdue);
    }
}