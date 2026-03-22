package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class OverdueReminder {
    private Long id;
    private Integer teacherId;
    private Long borrowId;
    private Integer overdueDays;
    private Date reminderDate;
    private Integer sendStatus;  // 0待发送 1已发送
}