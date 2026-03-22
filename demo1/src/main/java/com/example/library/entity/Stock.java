package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Stock {
    private Integer id;
    private Integer bookId;
    private Integer locationId;
    private Integer totalQty;
    private Integer availableQty;
    private Integer status;
    private Date lastInDate;
    private Date createTime;
    private Date updateTime;

    // 非数据库字段
    private String bookTitle;
    private String locationCode;
}