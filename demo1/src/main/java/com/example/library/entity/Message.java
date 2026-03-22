package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Message {
    private Long id;
    private Integer teacherId;
    private String type;  // overdue/renew/fine
    private String title;
    private String content;
    private Integer status;  // 0未读 1已读
    private Date createTime;
    private Date readTime;
}