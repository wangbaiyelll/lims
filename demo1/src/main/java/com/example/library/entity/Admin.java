package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Admin {
    private Integer id;
    private String username;
    private String password;
    private String realName;
    private String role;
    private Integer status;
    private Date lastLoginTime;
    private Date createTime;
}