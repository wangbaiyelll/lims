package com.example.library.controller;

import com.example.library.entity.BorrowRecord;
import com.example.library.entity.Fine;
import com.example.library.entity.Teacher;
import com.example.library.mapper.BorrowRecordMapper;
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
    
    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @GetMapping("/list")
    public String listPage() {
        return "admin/fine-list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Result getFineList(@RequestParam(defaultValue = "1") Integer page,
                              @RequestParam(defaultValue = "10") Integer limit,
                              @RequestParam(required = false) String teacherName,
                              @RequestParam(required = false) Integer status) {
        // 处理空字符串，转换为 null
        if (teacherName != null && teacherName.trim().isEmpty()) {
            teacherName = null;
        }
        
        List<Fine> list = fineService.getByCondition(teacherName, status, page, limit);
        
        // 获取总数（用于分页）
        int count = fineService.getCount(teacherName, status);
        
        return Result.success().put("data", list).put("count", count);
    }

    @GetMapping("/my")
    @ResponseBody
    public Result getMyFines(HttpSession session,
                             @RequestParam(defaultValue = "1") Integer page,
                             @RequestParam(defaultValue = "10") Integer limit,
                             @RequestParam(required = false) Integer status) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        System.out.println("🔍 [罚款查询] 教师 ID: " + teacher.getId() + ", 姓名：" + teacher.getName() + 
                         ", 状态过滤：" + (status == null ? "全部" : status));

        // 使用分页查询 - 如果 status 为 null，则查询所有状态
        List<Fine> list = fineService.getByTeacherIdWithPagination(teacher.getId(), status, page, limit);
        
        // 获取总数
        int totalCount = fineService.countByTeacherId(teacher.getId(), null); // 查询所有状态的总数
        
        System.out.println("📊 [罚款查询] 找到 " + list.size() + " 条记录，总计：" + totalCount + " 条");
        
        // 打印每条记录的信息
        if (list != null && !list.isEmpty()) {
            for (Fine fine : list) {
                System.out.println("  💰 罚款 ID: " + fine.getId() + 
                                 ", 借阅 ID: " + fine.getBorrowId() + 
                                 ", 金额：" + fine.getAmount() + 
                                 ", 状态：" + fine.getStatus() + 
                                 ", 图书：《" + fine.getBookTitle() + "》");
            }
        } else {
            System.out.println("⚠️ [罚款查询] 没有找到任何罚款记录");
            
            // 检查该教师是否有逾期未还的图书
            List<BorrowRecord> overdueRecords = borrowRecordMapper.selectByTeacherId(teacher.getId(), 3, 0, 100);
            if (overdueRecords != null && !overdueRecords.isEmpty()) {
                System.out.println("❗ [罚款查询] 发现 " + overdueRecords.size() + " 条逾期图书记录，但未生成罚款");
            }
        }
        
        return Result.success()
                .put("data", list)
                .put("count", totalCount);
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