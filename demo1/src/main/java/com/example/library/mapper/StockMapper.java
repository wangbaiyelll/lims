package com.example.library.mapper;

import com.example.library.entity.Stock;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface StockMapper {

    Stock selectById(@Param("id") Integer id);

    Stock selectByBookAndLocation(@Param("bookId") Integer bookId,
                                  @Param("locationId") Integer locationId);

    List<Stock> selectByBookId(@Param("bookId") Integer bookId);

    List<Stock> selectByLocationId(@Param("locationId") Integer locationId);

    List<Stock> selectAll(@Param("offset") Integer offset, @Param("limit") Integer limit, @Param("bookTitle") String bookTitle);

    int countAll(@Param("bookTitle") String bookTitle);

    int insert(Stock stock);

    int update(Stock stock);

    int updateAvailableQty(@Param("id") Integer id, @Param("change") Integer change);

    int deleteById(@Param("id") Integer id);
}