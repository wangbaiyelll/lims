package com.example.library.controller;

import com.example.library.entity.Admin;
import com.example.library.entity.Teacher;
import com.example.library.service.AuthService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/")
    public String index() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/doLogin")
    @ResponseBody
    public Result doLogin(@RequestParam String username,
                          @RequestParam String password,
                          @RequestParam String userType,
                          HttpSession session) {
        if ("admin".equals(userType)) {
            Admin admin = authService.adminLogin(username, password, session);
            if (admin != null) {
                return Result.success("登录成功").put("redirect", "/admin/index");
            }
        } else if ("teacher".equals(userType)) {
            Teacher teacher = authService.teacherLogin(username, password, session);
            if (teacher != null) {
                return Result.success("登录成功").put("redirect", "/teacher/center");
            }
        }
        return Result.error("用户名或密码错误");
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
