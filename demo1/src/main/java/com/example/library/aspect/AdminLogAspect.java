package com.example.library.aspect;

import com.example.library.entity.Admin;
import com.example.library.service.AdminLogService;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Aspect
@Component
public class AdminLogAspect {

    @Autowired
    private AdminLogService adminLogService;

    /**
     * 定义切点：所有 Service 层的方法
     */
    @Pointcut("execution(* com.example.library.service..*.*(..))")
    public void adminLogPointcut() {
    }

    /**
     * 环绕通知：记录操作日志
     */
    @Around("adminLogPointcut()")
    public Object aroundLog(ProceedingJoinPoint joinPoint) throws Throwable {
        // 获取方法签名
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getSignature().getDeclaringTypeName();

        // 判断是否是写操作（add/update/delete）
        boolean isWriteOperation = methodName.startsWith("add") ||
                methodName.startsWith("update") ||
                methodName.startsWith("delete") ||
                methodName.startsWith("create") ||
                methodName.startsWith("remove");

        if (!isWriteOperation) {
            // 非写操作，直接执行
            return joinPoint.proceed();
        }

        // 获取管理员信息
        Admin admin = getCurrentAdmin();

        if (admin != null) {
            // 提取操作信息
            String operation = extractOperationName(methodName, joinPoint.getArgs());
            String targetType = extractTargetType(className);
            Integer targetId = extractTargetId(joinPoint.getArgs());
            String targetName = extractTargetName(joinPoint.getArgs());

            // 异步记录日志（不阻塞主流程）
            new Thread(() -> {
                adminLogService.logOperation(
                        admin.getId().intValue(),
                        admin.getName(),
                        operation,
                        targetType,
                        targetId,
                        targetName
                );
            }).start();
        }

        // 执行原方法
        return joinPoint.proceed();
    }

    /**
     * 获取当前登录的管理员
     */
    private Admin getCurrentAdmin() {
        try {
            ServletRequestAttributes attributes =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) {
                return null;
            }
            HttpServletRequest request = attributes.getRequest();
            HttpSession session = request.getSession(false);
            if (session == null) {
                return null;
            }
            return (Admin) session.getAttribute("loginAdmin");
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 提取操作名称
     */
    private String extractOperationName(String methodName, Object[] args) {
        if (methodName.startsWith("add") || methodName.startsWith("create")) {
            return "新增";
        } else if (methodName.startsWith("update") || methodName.startsWith("modify")) {
            return "修改";
        } else if (methodName.startsWith("delete") || methodName.startsWith("remove")) {
            return "删除";
        } else if (methodName.contains("audit")) {
            return "审核";
        } else if (methodName.contains("reset")) {
            return "重置";
        } else if (methodName.contains("status")) {
            return "状态变更";
        }
        return "操作：" + methodName;
    }

    /**
     * 提取目标类型
     */
    private String extractTargetType(String className) {
        if (className.contains("Book")) return "BOOK";
        if (className.contains("Teacher")) return "TEACHER";
        if (className.contains("Borrow")) return "BORROW";
        if (className.contains("Fine")) return "FINE";
        if (className.contains("Category")) return "CATEGORY";
        if (className.contains("Stock")) return "STOCK";
        if (className.contains("Location")) return "LOCATION";
        return "OTHER";
    }

    /**
     * 提取目标 ID（从参数中）
     */
    private Integer extractTargetId(Object[] args) {
        for (Object arg : args) {
            if (arg instanceof Integer) {
                return (Integer) arg;
            }
            // 从实体类中获取 ID
            try {
                if (arg != null && arg.getClass().getMethod("getId") != null) {
                    Object id = arg.getClass().getMethod("getId").invoke(arg);
                    if (id instanceof Integer) {
                        return (Integer) id;
                    }
                }
            } catch (Exception e) {
                // 忽略
            }
        }
        return null;
    }

    /**
     * 提取目标名称（从参数中）
     */
    private String extractTargetName(Object[] args) {
        for (Object arg : args) {
            try {
                if (arg != null) {
                    // 尝试获取 title 或 name 属性
                    try {
                        Object title = arg.getClass().getMethod("getTitle").invoke(arg);
                        if (title != null) return title.toString();
                    } catch (Exception e) {}

                    try {
                        Object name = arg.getClass().getMethod("getName").invoke(arg);
                        if (name != null) return name.toString();
                    } catch (Exception e) {}
                }
            } catch (Exception e) {
                // 忽略
            }
        }
        return null;
    }
}
