package com.example.library.mapper;

import com.example.library.entity.Fine;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public interface FineMapper {

    Fine selectById(@Param("id") Long id);

    List<Fine> selectByTeacherId(@Param("teacherId") Integer teacherId, @Param("status") Integer status);
    
    List<Fine> selectByTeacherIdWithPagination(@Param("teacherId") Integer teacherId, 
                                               @Param("status") Integer status,
                                               @Param("offset") Integer offset,
                                               @Param("limit") Integer limit);
    
    int countByTeacherId(@Param("teacherId") Integer teacherId, @Param("status") Integer status);

    List<Fine> selectByCondition(@Param("teacherName") String teacherName,
                                 @Param("status") Integer status,
                                 @Param("offset") Integer offset,
                                 @Param("limit") Integer limit);

    int countByCondition(@Param("teacherName") String teacherName, @Param("status") Integer status);

    List<Fine> selectByBorrowId(@Param("borrowId") Long borrowId);

    int insert(Fine fine);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status, @Param("payDate") Date payDate);

    int updateOverdueDays(@Param("borrowId") Long borrowId, 
                         @Param("overdueDays") Integer overdueDays, 
                         @Param("amount") BigDecimal amount);
    
    int updateOverdueDaysWithStatus(@Param("borrowId") Long borrowId, 
                                   @Param("overdueDays") Integer overdueDays, 
                                   @Param("amount") BigDecimal amount,
                                   @Param("status") Integer status);
    
    int updateFineStatusToPayable(@Param("borrowId") Long borrowId);
}