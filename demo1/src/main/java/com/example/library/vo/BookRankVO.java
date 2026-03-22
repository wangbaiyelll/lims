package com.example.library.vo;

import lombok.Data;

@Data
public class BookRankVO {
    private Integer bookId;
    private String title;
    private String author;
    private Integer borrowCount;
    private Integer rank;
}