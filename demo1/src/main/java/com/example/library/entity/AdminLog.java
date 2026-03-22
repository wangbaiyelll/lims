package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class AdminLog {
    private Long id;
    private Integer adminId;
    private String adminName;
    private String operation;
    private String targetType;
    private Integer targetId;
    private String targetName;
    private Date createTime;
}