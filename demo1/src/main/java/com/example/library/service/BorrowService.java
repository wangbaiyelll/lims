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

    List<RenewApplication> getRenewApplicationsWithCondition(String teacherName, String bookTitle, Integer status);

    RenewApplication getPendingRenewApplication(Long borrowId);

    RenewApplication getRecentRenewApplication(Long borrowId);

    int getRenewCount();

    boolean auditRenew(Long id, Integer status, Integer adminId, String remark);

    List<BorrowRecord> getAllBorrows(Integer page, Integer size);

    List<BorrowRecord> getOverdueList();

    List<BorrowRecord> getBorrowsWithCondition(String teacherName, String bookTitle, Integer status, Integer page, Integer size);

    List<RenewApplication> getApplicationsByBorrowIds(List<Long> borrowIds);
    
    int countByTeacherIdAndStatus(Integer teacherId, Integer status);

}