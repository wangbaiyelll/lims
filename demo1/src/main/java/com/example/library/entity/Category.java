package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Category {
    private Integer id;
    private Integer parentId;
    private String name;
    private Integer level;
    private Integer sortOrder;
    private Date createTime;

    // 非数据库字段
    private String parentName;
}