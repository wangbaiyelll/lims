package com.example.library.interceptor;

import com.example.library.entity.Admin;
import com.example.library.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
public class PermissionInterceptor implements HandlerInterceptor {

    @Autowired
    private RoleService roleService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取请求 URI
        String uri = request.getRequestURI();

        // 放行登录、登出、静态资源
        if (uri.contains("/login") || uri.contains("/logout") ||
                uri.contains("/css") || uri.contains("/js") || uri.contains("/images")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // 系统管理员拥有所有权限
        if ("admin".equals(admin.getUsername())) {
            return true;
        }

        // 检查权限
        String permission = convertUriToPermission(uri);
        if (permission != null && !roleService.hasPermission(admin.getRoleId(), permission)) {
            // 无权限，返回 403 或跳转错误页面
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return false;
        }

        return true;
    }

    /**
     * 将 URI 转换为权限码
     */
    private String convertUriToPermission(String uri) {
        // 示例：/admin/book/list → book:list
        // /admin/borrow/audit → borrow:audit
        if (uri.startsWith("/admin/")) {
            String path = uri.substring("/admin/".length());
            String[] parts = path.split("/");
            if (parts.length >= 2) {
                return parts[0] + ":" + parts[1];
            } else if (parts.length == 1) {
                return parts[0] + ":index";
            }
        }
        return null;
    }
}
