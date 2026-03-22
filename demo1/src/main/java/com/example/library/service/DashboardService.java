package com.example.library.service;

import com.example.library.vo.BookRankVO;
import com.example.library.vo.DashboardVO;
import com.example.library.vo.TrendVO;
import java.util.List;

public interface DashboardService {

    DashboardVO getDashboardData();

    List<TrendVO> getBorrowTrend(int days);

    List<BookRankVO> getHotBooks(int limit);

    List<BookRankVO> getCategoryHotBooks(Integer categoryId, int limit);
}