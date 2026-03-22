package com.example.library.mapper;

import com.example.library.entity.RenewApplication;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface RenewApplicationMapper {

    RenewApplication selectById(@Param("id") Long id);

    List<RenewApplication> selectByTeacherId(@Param("teacherId") Integer teacherId);

    List<RenewApplication> selectByStatus(@Param("status") Integer status);

    List<RenewApplication> selectAll(@Param("offset") Integer offset, @Param("limit") Integer limit);

    int countAll();

    int insert(RenewApplication application);

    int updateStatus(@Param("id") Long id,
                     @Param("status") Integer status,
                     @Param("auditAdminId") Integer auditAdminId,
                     @Param("auditRemark") String auditRemark);
}