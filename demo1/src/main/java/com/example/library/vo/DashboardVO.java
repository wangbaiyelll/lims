package com.example.library.vo;

import lombok.Data;

@Data
public class DashboardVO {
    private Integer todayBorrowCount;
    private Integer todayReturnCount;
    private Integer totalBorrowing;
    private Integer totalOverdue;
    private Integer totalTeachers;
    private Integer totalBooks;
}