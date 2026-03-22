package com.example.library.mapper;

import com.example.library.entity.BorrowRecord;
import org.apache.ibatis.annotations.Param;
import java.util.Date;
import java.util.List;

public interface BorrowRecordMapper {

    BorrowRecord selectById(@Param("id") Long id);

    List<BorrowRecord> selectByTeacherId(@Param("teacherId") Integer teacherId,
                                         @Param("status") Integer status,
                                         @Param("offset") Integer offset,
                                         @Param("limit") Integer limit);

    int countByTeacherId(@Param("teacherId") Integer teacherId,
                         @Param("status") Integer status);

    List<BorrowRecord> selectByBookId(@Param("bookId") Integer bookId);

    BorrowRecord selectByTeacherAndBook(@Param("teacherId") Integer teacherId,
                                        @Param("bookId") Integer bookId,
                                        @Param("status") Integer status);

    /**
     * 查询所有借阅记录（分页）
     */
    List<BorrowRecord> selectAll(@Param("offset") Integer offset,
                                @Param("limit") Integer limit);

    /**
     * 查询逾期借阅记录
     */
    List<BorrowRecord> selectOverdueList();

    List<BorrowRecord> selectDueSoon(@Param("days") int days);

    List<BorrowRecord> selectByCondition(@Param("teacherName") String teacherName,
                                         @Param("bookTitle") String bookTitle,
                                         @Param("status") Integer status,
                                         @Param("startDate") Date startDate,
                                         @Param("endDate") Date endDate,
                                         @Param("offset") Integer offset,
                                         @Param("limit") Integer limit);

    int countByCondition(@Param("teacherName") String teacherName,
                         @Param("bookTitle") String bookTitle,
                         @Param("status") Integer status,
                         @Param("startDate") Date startDate,
                         @Param("endDate") Date endDate);

    int insert(BorrowRecord record);

    int update(BorrowRecord record);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int updateReturn(@Param("id") Long id, @Param("returnDate") Date returnDate);

    int updateRenew(@Param("id") Long id, @Param("newDueDate") Date newDueDate);
}