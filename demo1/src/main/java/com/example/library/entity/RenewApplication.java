package com.example.library.entity;

import lombok.Data;
import java.util.Date;

@Data
public class RenewApplication {
    private Long id;
    private Integer teacherId;
    private Long borrowId;
    private Date applyDate;
    private Integer status;  // 0待审核 1已通过 2已拒绝
    
    // 添加一个方法来获取状态文本
    public String getStatusText() {
        switch(status) {
            case 0: return "待审核";
            case 1: return "已通过";
            case 2: return "已拒绝";
            default: return "待审核";
        }
    }
    
    // 添加一个方法来判断是否为预约状态
    public boolean isReserved() {
        // 根据业务需求，如果需要"已预约"状态，可能需要添加新的状态值
        return false;
    }
    
    private Date auditDate;
    private Integer auditAdminId;
    private String auditRemark;
    
    // 非数据库字段
    private String teacherName;
    private String bookTitle;
    private String auditAdminName;
}