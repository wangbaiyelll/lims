package com.example.library.mapper;

import com.example.library.entity.Book;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface BookMapper {

    Book selectById(@Param("id") Integer id);

    Book selectByIsbn(@Param("isbn") String isbn);

    List<Book> selectByCondition(@Param("title") String title,
                                 @Param("author") String author,
                                 @Param("isbn") String isbn,
                                 @Param("categoryId") Integer categoryId,
                                 @Param("status") Integer status,
                                 @Param("offset") Integer offset,
                                 @Param("limit") Integer limit);

    int countByCondition(@Param("title") String title,
                         @Param("author") String author,
                         @Param("isbn") String isbn,
                         @Param("categoryId") Integer categoryId,
                         @Param("status") Integer status);

    int insert(Book book);

    int update(Book book);

    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    int deleteById(@Param("id") Integer id);

    List<Book> selectPopular(@Param("limit") Integer limit);

    List<Book> selectRecommendByTeacher(@Param("teacherId") Integer teacherId,
                                        @Param("limit") Integer limit);
}