package com.example.library.mapper;

import com.example.library.entity.Message;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface MessageMapper {

    Message selectById(@Param("id") Long id);

    List<Message> selectByTeacherId(@Param("teacherId") Integer teacherId,
                                    @Param("status") Integer status,
                                    @Param("offset") Integer offset,
                                    @Param("limit") Integer limit);

    int countByTeacherId(@Param("teacherId") Integer teacherId,
                         @Param("status") Integer status);

    int insert(Message message);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int deleteById(@Param("id") Long id);
}