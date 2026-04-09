package com.example.library.mapper;

import com.example.library.entity.RenewApplication;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface RenewApplicationMapper {

    RenewApplication selectById(@Param("id") Long id);

    List<RenewApplication> selectByTeacherId(@Param("teacherId") Integer teacherId);

    List<RenewApplication> selectByStatus(@Param("status") Integer status);

    RenewApplication selectByBorrowIdAndStatus(@Param("borrowId") Long borrowId, @Param("status") Integer status);

    List<RenewApplication> selectByBorrowId(@Param("borrowId") Long borrowId);

    List<RenewApplication> selectByBorrowIds(@Param("borrowIds") List<Long> borrowIds);

    List<RenewApplication> selectAll(@Param("offset") int offset, @Param("size") Integer size);

    // 添加带查询条件的方法
    List<RenewApplication> selectAllWithCondition(@Param("offset") int offset,
                                                 @Param("limit") Integer limit,
                                                 @Param("teacherName") String teacherName,
                                                 @Param("bookTitle") String bookTitle,
                                                 @Param("status") Integer status);

    int countAll();

    int insert(RenewApplication application);

    int updateStatus(@Param("id") Long id,
                     @Param("status") Integer status,
                     @Param("auditAdminId") Integer auditAdminId,
                     @Param("auditRemark") String auditRemark);
}