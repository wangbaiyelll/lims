package com.example.library.controller;

import com.example.library.entity.Message;
import com.example.library.entity.Teacher;
import com.example.library.service.MessageService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/teacher/message")
public class MessageController {

    @Autowired
    private MessageService messageService;

    /**
     * 获取我的消息列表
     */
    @GetMapping("/list")
    @ResponseBody
    public Result getList(HttpSession session,
                          @RequestParam(required = false) String type,
                          @RequestParam(required = false) Integer status,
                          @RequestParam(defaultValue = "1") Integer page,
                          @RequestParam(defaultValue = "10") Integer limit) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        List<Message> list = messageService.getByTeacherId(teacher.getId(), status, page, limit);
        
        // 如果指定了类型，过滤
        if (type != null && !type.isEmpty()) {
            list = list.stream()
                    .filter(m -> type.equals(m.getType()))
                    .collect(java.util.stream.Collectors.toList());
        }

        int total = messageService.getCountByTeacherId(teacher.getId(), status);

        return Result.success()
                .put("data", list)
                .put("count", total);
    }

    /**
     * 获取消息统计
     */
    @GetMapping("/count")
    @ResponseBody
    public Result getCount(HttpSession session) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher == null) {
            return Result.error("请先登录");
        }

        int total = messageService.getCountByTeacherId(teacher.getId(), null);
        int unread = messageService.getUnreadCount(teacher.getId());

        Map<String, Object> counts = new HashMap<>();
        counts.put("total", total);
        counts.put("unread", unread);

        return Result.success().put("data", counts);
    }

    /**
     * 标记为已读
     */
    @PostMapping("/read/{id}")
    @ResponseBody
    public Result markAsRead(@PathVariable Long id, HttpSession session) {
        try {
            Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
            if (teacher == null) {
                System.err.println("❌ [Controller] 用户未登录");
                return Result.error("请先登录");
            }

            System.out.println("🔵 [Controller] 收到标记请求 - 消息 ID: " + id + ", 教师 ID: " + teacher.getId());
            
            boolean success = messageService.markAsRead(id, teacher.getId());
            
            if (success) {
                System.out.println("✅ [Controller] 操作成功，返回前端");
                return Result.success();
            } else {
                System.err.println("❌ [Controller] 操作失败，返回错误信息");
                return Result.error("操作失败");
            }
        } catch (Exception e) {
            System.err.println("❌ [Controller] 发生异常：" + e.getMessage());
            e.printStackTrace();
            return Result.error("系统错误：" + e.getMessage());
        }
    }

    /**
     * 全部标为已读
     */
    @PostMapping("/read-all")
    @ResponseBody
    public Result markAllAsRead(HttpSession session) {
        try {
            Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
            if (teacher == null) {
                return Result.error("请先登录");
            }

            System.out.println("🔵 [Controller] 开始批量标记所有消息为已读 - 教师 ID: " + teacher.getId());
            
            // 直接通过 Mapper 批量更新，避免循环调用
            int updatedCount = messageService.markAllAsReadBatch(teacher.getId());
            
            System.out.println("✅ [Controller] 批量标记完成，共更新 " + updatedCount + " 条消息");
            
            return Result.success().put("message", "已成功标记 " + updatedCount + " 条消息为已读");
        } catch (Exception e) {
            System.err.println("❌ [Controller] 批量标记发生异常：" + e.getMessage());
            e.printStackTrace();
            return Result.error("系统错误：" + e.getMessage());
        }
    }
}
