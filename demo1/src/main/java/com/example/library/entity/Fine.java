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
    private Integer status;  // 0:待支付 (已还书) 1:已支付 2:待归还 (未还书)
    private Date payDate;
    private String remark;
    private Date createTime;
    private Date updateTime;

    // 非数据库字段
    private String teacherName;
    private String bookTitle;
    private BigDecimal bookPrice;
    private Boolean canPay; // 是否可以支付
}