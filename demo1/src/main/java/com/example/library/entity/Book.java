package com.example.library.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

@Data
public class Book {
    private Integer id;
    private String isbn;
    private String title;
    private String author;
    private String publisher;
    private Date publishDate;
    private BigDecimal price;
    private String summary;
    private Integer categoryId;
    private Integer status;
    private Date createTime;
    private Date updateTime;

    // 非数据库字段
    private String categoryName;
    private Integer availableQty;
    private Integer totalQty;
    private String borrowStatus;
    private Integer borrowCount;
}