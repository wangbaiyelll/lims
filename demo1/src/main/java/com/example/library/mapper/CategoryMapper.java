package com.example.library.mapper;

import com.example.library.entity.Category;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CategoryMapper {

    Category selectById(@Param("id") Integer id);

    List<Category> selectAll();

    List<Category> selectByParentId(@Param("parentId") Integer parentId);

    List<Category> selectLevel1();

    int insert(Category category);

    int update(Category category);

    int deleteById(@Param("id") Integer id);

    int countChildren(@Param("parentId") Integer parentId);

    int countBooks(@Param("categoryId") Integer categoryId);
}