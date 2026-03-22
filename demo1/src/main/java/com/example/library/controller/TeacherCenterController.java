package com.example.library.controller;

import com.example.library.entity.Teacher;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/teacher")
public class TeacherCenterController {

    @GetMapping("/center")
    public String center(HttpSession session, Model model) {
        Teacher teacher = (Teacher) session.getAttribute("loginTeacher");
        if (teacher != null) {
            model.addAttribute("teacher", teacher);
        }
        return "teacher/center";  // 改成简单页面
    }
}