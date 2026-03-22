package com.example.library.mapper;

import com.example.library.entity.Admin;
import org.apache.ibatis.annotations.Param;

public interface AdminMapper {

    Admin selectByUsername(@Param("username") String username);

    Admin selectById(@Param("id") Integer id);

    int updateLoginTime(@Param("id") Integer id, @Param("loginTime") java.util.Date loginTime);
}