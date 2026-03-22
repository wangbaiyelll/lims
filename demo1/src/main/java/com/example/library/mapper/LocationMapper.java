package com.example.library.mapper;

import com.example.library.entity.Location;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface LocationMapper {

    Location selectById(@Param("id") Integer id);

    Location selectByCode(@Param("positionCode") String positionCode);

    List<Location> selectAll();

    List<Location> selectByLibrary(@Param("libraryName") String libraryName);

    // 添加这个方法
    List<String> selectAllLibraries();

    int insert(Location location);

    int update(Location location);

    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    int deleteById(@Param("id") Integer id);
}