package com.example.library.vo;

import lombok.Data;

@Data
public class TrendVO {
    private String date;
    private Integer borrowCount;
    private Integer returnCount;
}