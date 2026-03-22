package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class RenewApplication {
    private Long id;
    private Integer teacherId;
    private Long borrowId;
    private Date applyDate;
    private Integer status;  // 0待审核 1已通过 2已拒绝
    private Date auditDate;
    private Integer auditAdminId;
    private String auditRemark;

    // 非数据库字段
    private String teacherName;
    private String bookTitle;
    private String auditAdminName;
}