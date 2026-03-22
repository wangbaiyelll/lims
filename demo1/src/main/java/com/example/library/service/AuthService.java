package com.example.library.service;

import com.example.library.entity.Admin;
import com.example.library.entity.Teacher;
import javax.servlet.http.HttpSession;

public interface AuthService {

    Admin adminLogin(String username, String password, HttpSession session);

    Teacher teacherLogin(String username, String password, HttpSession session);

    void logout(HttpSession session);
}