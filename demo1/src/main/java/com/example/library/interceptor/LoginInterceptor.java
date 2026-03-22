package com.example.library.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {

        String uri = request.getRequestURI();

        // 打印日志
        System.out.println("拦截器检查: " + uri);

        // 放行所有不需要登录的路径
        if (uri.equals("/") ||
                uri.equals("/login") ||
                uri.equals("/doLogin") ||
                uri.equals("/logout") ||
                uri.equals("/error") ||                           // ← 添加这一行
                uri.startsWith("/static/") ||
                uri.startsWith("/css/") ||
                uri.startsWith("/js/") ||
                uri.startsWith("/images/") ||
                uri.startsWith("/druid/")) {
            System.out.println("放行: " + uri);
            return true;
        }

        HttpSession session = request.getSession();
        Object admin = session.getAttribute("loginAdmin");
        Object teacher = session.getAttribute("loginTeacher");

        if (admin == null && teacher == null) {
            System.out.println("未登录，重定向到登录页: " + uri);
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        System.out.println("已登录: " + uri);
        return true;
    }
}