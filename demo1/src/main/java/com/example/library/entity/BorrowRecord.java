package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class BorrowRecord {
    private Long id;
    private Integer teacherId;
    private Integer bookId;
    private Integer stockId;
    private Date borrowDate;
    private Date dueDate;
    private Date returnDate;
    private Integer status;  // 1借阅中 2已归还 3逾期
    private Integer renewCount;
    private Date createTime;
    private Date updateTime;

    // 非数据库字段
    private String teacherName;
    private String bookTitle;
    private String author;
    private String isbn;
    private String locationCode;
    private Integer overdueDays;
    private Boolean hasPendingRenewal;
    private Integer renewalStatus;
    private String renewalRemark;
    private Date renewalAuditDate;
}