package com.example.library.service;

import com.example.library.entity.BorrowRecord;
import com.example.library.entity.RenewApplication;

import java.util.List;

public interface BorrowService {

    BorrowRecord getById(Long id);

    List<BorrowRecord> getByTeacherId(Integer teacherId, Integer status, Integer page, Integer size);

    int getCountByTeacherId(Integer teacherId, Integer status);

    boolean borrow(Integer teacherId, Integer bookId, Integer locationId);

    boolean returnBook(Long borrowId);

    boolean applyRenew(Long borrowId, Integer teacherId);

    List<RenewApplication> getRenewApplications(Integer page, Integer size);

    int getRenewCount();

    boolean auditRenew(Long id, Integer status, Integer adminId, String remark);

    /**
     * 获取所有借阅记录（分页）
     */
    List<BorrowRecord> getAllBorrows(Integer page, Integer size);

    /**
     * 获取逾期借阅记录
     */
    List<BorrowRecord> getOverdueList();
}