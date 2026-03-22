package com.example.library.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class BCryptUtil {

    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public static String encode(String password) {
        return encoder.encode(password);
    }

    public static boolean matches(String rawPassword, String encodedPassword) {
        if (encodedPassword == null || encodedPassword.isEmpty()) {
            System.err.println("密码为空");
            return false;
        }
        try {
            return encoder.matches(rawPassword, encodedPassword);
        } catch (Exception e) {
            System.err.println("密码验证异常: " + e.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        // 生成新的密码哈希值
        String adminPwd = encode("admin123");
        String teacherPwd = encode("teacher123");
        
        System.out.println("admin123加密后: " + adminPwd);
        System.out.println("teacher123加密后: " + teacherPwd);
        
        // 验证生成的哈希值是否有效
        System.out.println("admin123验证: " + matches("admin123", adminPwd));
        System.out.println("teacher123验证: " + matches("teacher123", teacherPwd));
    }
}
