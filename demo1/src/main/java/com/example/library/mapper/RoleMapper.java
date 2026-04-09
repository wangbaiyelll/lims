package com.example.library.mapper;

import com.example.library.entity.Role;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface RoleMapper {

    Role selectById(@Param("id") Integer id);

    Role selectByName(@Param("roleName") String roleName);

    List<Role> selectAll();

    int insert(Role role);

    int update(Role role);

    int deleteById(@Param("id") Integer id);
}
