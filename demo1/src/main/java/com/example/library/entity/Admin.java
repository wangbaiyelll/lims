package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Admin {
    private Long id;
    private String name;
    private String username;
    private String password;
    private Integer roleId;
    private Date createTime;
    private Integer status;
    private Date lastLoginTime;
    
    // 关联角色信息（非数据库字段）
    private String roleName;
}