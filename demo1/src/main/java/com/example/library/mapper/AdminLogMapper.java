package com.example.library.mapper;

import com.example.library.entity.AdminLog;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface AdminLogMapper {

    List<AdminLog> selectByAdminId(@Param("adminId") Integer adminId);

    List<AdminLog> selectByTarget(@Param("targetType") String targetType,
                                  @Param("targetId") Integer targetId);

    List<AdminLog> selectAll();

    int insert(AdminLog log);
}