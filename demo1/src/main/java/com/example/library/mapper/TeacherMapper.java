package com.example.library.mapper;

import com.example.library.entity.Teacher;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface TeacherMapper {

    Teacher selectById(@Param("id") Integer id);

    Teacher selectByUsername(@Param("username") String username);

    Teacher selectByEmpNo(@Param("empNo") String empNo);

    List<Teacher> selectByCondition(@Param("keyword") String keyword,
                                    @Param("college") String college,
                                    @Param("status") Integer status,
                                    @Param("offset") Integer offset,
                                    @Param("limit") Integer limit);

    int countByCondition(@Param("keyword") String keyword,
                         @Param("college") String college,
                         @Param("status") Integer status);

    int insert(Teacher teacher);

    int update(Teacher teacher);

    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    int updatePassword(@Param("id") Integer id, @Param("password") String password);

    int deleteById(@Param("id") Integer id);
}