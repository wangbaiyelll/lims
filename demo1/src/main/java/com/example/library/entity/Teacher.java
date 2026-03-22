package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Teacher {
    private Integer id;
    private String username;
    private String password;
    private String empNo;
    private String name;
    private String college;
    private String phone;
    private String email;
    private Date hireDate;
    private Integer status;
    private Date createTime;
}