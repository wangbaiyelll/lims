package com.example.library.service.impl;

import com.example.library.entity.Admin;
import com.example.library.entity.Teacher;
import com.example.library.mapper.AdminMapper;
import com.example.library.mapper.TeacherMapper;
import com.example.library.service.AdminLogService;
import com.example.library.service.AuthService;
import com.example.library.util.BCryptUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private TeacherMapper teacherMapper;

    @Autowired
    private AdminLogService adminLogService;

    @Override
    public Admin adminLogin(String username, String password, HttpSession session) {
        Admin admin = adminMapper.selectByUsername(username);
        if (admin != null && admin.getStatus() == 1) {
            // 使用 BCrypt 验证密码
            if (BCryptUtil.matches(password, admin.getPassword())) {
                admin.setLastLoginTime(new Date());
                adminMapper.updateLoginTime(admin.getId().intValue(), new Date());
                session.setAttribute("loginAdmin", admin);
                session.setAttribute("userType", "admin");
                
                // 记录登录日志
                adminLogService.logOperation(
                    admin.getId().intValue(),
                    admin.getName(),
                    "登录系统",
                    "SYSTEM",
                    null,
                    "管理员登录"
                );
                
                return admin;
            }
        }
        return null;
    }

    @Override
    public Teacher teacherLogin(String username, String password, HttpSession session) {
        Teacher teacher = teacherMapper.selectByUsername(username);
        if (teacher != null && teacher.getStatus() == 1) {
            if (BCryptUtil.matches(password, teacher.getPassword())) {
                session.setAttribute("loginTeacher", teacher);
                session.setAttribute("userType", "teacher");
                return teacher;
            }
        }
        return null;
    }

    @Override
    public void logout(HttpSession session) {
        session.removeAttribute("loginAdmin");
        session.removeAttribute("loginTeacher");
        session.removeAttribute("userType");
        session.invalidate();
    }
}