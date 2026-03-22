package com.example.library.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

@Data
public class Fine {
    private Long id;
    private Integer teacherId;
    private Long borrowId;
    private BigDecimal amount;
    private Date fineDate;
    private Integer dueDays;
    private Integer status;  // 0未支付 1已支付
    private Date payDate;
    private String remark;
    private Date createTime;
    private Date updateTime;

    // 非数据库字段
    private String teacherName;
    private String bookTitle;
}