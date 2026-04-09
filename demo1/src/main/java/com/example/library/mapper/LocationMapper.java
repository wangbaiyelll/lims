package com.example.library.mapper;

import com.example.library.entity.Location;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface LocationMapper {

    Location selectById(Integer id);

    Location selectByCode(String code);

    List<Location> selectAll();

    List<String> selectAllLibraries();

    List<Location> selectByLibrary(String libraryName);

    int insert(Location location);

    int update(Location location);

    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    int deleteById(Integer id);
}