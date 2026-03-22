package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class Location {
    private Integer id;
    private String libraryName;
    private String shelfNo;
    private String positionCode;
    private String description;
    private Integer status;
    private Date createTime;
    private Date updateTime;
}