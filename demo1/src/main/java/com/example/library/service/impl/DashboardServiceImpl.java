package com.example.library.service.impl;

import com.example.library.entity.BorrowRecord;
import com.example.library.mapper.BookMapper;
import com.example.library.mapper.BorrowRecordMapper;
import com.example.library.mapper.TeacherMapper;
import com.example.library.vo.BookRankVO;
import com.example.library.vo.DashboardVO;
import com.example.library.vo.TrendVO;
import com.example.library.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private TeacherMapper teacherMapper;

    @Autowired
    private BookMapper bookMapper;

    @Override
    public DashboardVO getDashboardData() {
        DashboardVO vo = new DashboardVO();

        // 今日借书量
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        List<BorrowRecord> todayBorrows = borrowRecordMapper.selectByCondition(null, null, null,
                java.sql.Date.valueOf(today), java.sql.Date.valueOf(today), 0, 1000);
        vo.setTodayBorrowCount(todayBorrows != null ? todayBorrows.size() : 0);

        // 今日还书量（实际归还日期为今天）
        List<BorrowRecord> todayReturns = borrowRecordMapper.selectByCondition(null, null, 2,
                java.sql.Date.valueOf(today), java.sql.Date.valueOf(today), 0, 1000);
        vo.setTodayReturnCount(todayReturns != null ? todayReturns.size() : 0);

        // 当前借阅总数
        List<BorrowRecord> borrowing = borrowRecordMapper.selectByCondition(null, null, 1, null, null, 0, 10000);
        vo.setTotalBorrowing(borrowing != null ? borrowing.size() : 0);

        // 逾期未还总数
        List<BorrowRecord> overdue = borrowRecordMapper.selectByCondition(null, null, 3, null, null, 0, 10000);
        vo.setTotalOverdue(overdue != null ? overdue.size() : 0);

        // 教师总数
        int teacherCount = teacherMapper.countByCondition(null, null, 1);
        vo.setTotalTeachers(teacherCount);

        // 图书总数
        int bookCount = bookMapper.countByCondition(null, null, null, null, 1);
        vo.setTotalBooks(bookCount);

        return vo;
    }

    @Override
    public List<TrendVO> getBorrowTrend(int days) {
        List<TrendVO> trendList = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();

        for (int i = days - 1; i >= 0; i--) {
            calendar.setTime(new Date());
            calendar.add(Calendar.DAY_OF_MONTH, -i);
            String date = sdf.format(calendar.getTime());

            TrendVO trend = new TrendVO();
            trend.setDate(date);

            // 当日借书量
            List<BorrowRecord> borrows = borrowRecordMapper.selectByCondition(null, null, null,
                    java.sql.Date.valueOf(date), java.sql.Date.valueOf(date), 0, 1000);
            trend.setBorrowCount(borrows != null ? borrows.size() : 0);

            // 当日还书量
            List<BorrowRecord> returns = borrowRecordMapper.selectByCondition(null, null, 2,
                    java.sql.Date.valueOf(date), java.sql.Date.valueOf(date), 0, 1000);
            trend.setReturnCount(returns != null ? returns.size() : 0);

            trendList.add(trend);
        }

        return trendList;
    }

    @Override
    public List<BookRankVO> getHotBooks(int limit) {
        List<BookRankVO> rankList = new ArrayList<>();

        // 查询所有借阅记录，按图书分组统计
        List<BorrowRecord> allRecords = borrowRecordMapper.selectByCondition(null, null, null, null, null, 0, 10000);

        if (allRecords != null && !allRecords.isEmpty()) {
            Map<Integer, Integer> borrowCountMap = new HashMap<>();
            for (BorrowRecord record : allRecords) {
                borrowCountMap.put(record.getBookId(),
                        borrowCountMap.getOrDefault(record.getBookId(), 0) + 1);
            }

            // 转换为列表并排序
            List<Map.Entry<Integer, Integer>> sorted = borrowCountMap.entrySet().stream()
                    .sorted(Map.Entry.<Integer, Integer>comparingByValue().reversed())
                    .limit(limit)
                    .collect(Collectors.toList());

            int rank = 1;
            for (Map.Entry<Integer, Integer> entry : sorted) {
                BookRankVO vo = new BookRankVO();
                vo.setBookId(entry.getKey());
                vo.setBorrowCount(entry.getValue());
                vo.setRank(rank++);

                // 获取图书信息
                com.example.library.entity.Book book = bookMapper.selectById(entry.getKey());
                if (book != null) {
                    vo.setTitle(book.getTitle());
                    vo.setAuthor(book.getAuthor());
                }
                rankList.add(vo);
            }
        }

        return rankList;
    }

    @Override
    public List<BookRankVO> getCategoryHotBooks(Integer categoryId, int limit) {
        List<BookRankVO> rankList = new ArrayList<>();

        // 查询指定分类的借阅记录
        List<BorrowRecord> allRecords = borrowRecordMapper.selectByCondition(null, null, null, null, null, 0, 10000);

        if (allRecords != null && !allRecords.isEmpty()) {
            Map<Integer, Integer> borrowCountMap = new HashMap<>();
            for (BorrowRecord record : allRecords) {
                com.example.library.entity.Book book = bookMapper.selectById(record.getBookId());
                if (book != null && book.getCategoryId() != null && book.getCategoryId().equals(categoryId)) {
                    borrowCountMap.put(record.getBookId(),
                            borrowCountMap.getOrDefault(record.getBookId(), 0) + 1);
                }
            }

            // 转换为列表并排序
            List<Map.Entry<Integer, Integer>> sorted = borrowCountMap.entrySet().stream()
                    .sorted(Map.Entry.<Integer, Integer>comparingByValue().reversed())
                    .limit(limit)
                    .collect(Collectors.toList());

            int rank = 1;
            for (Map.Entry<Integer, Integer> entry : sorted) {
                BookRankVO vo = new BookRankVO();
                vo.setBookId(entry.getKey());
                vo.setBorrowCount(entry.getValue());
                vo.setRank(rank++);

                com.example.library.entity.Book book = bookMapper.selectById(entry.getKey());
                if (book != null) {
                    vo.setTitle(book.getTitle());
                    vo.setAuthor(book.getAuthor());
                }
                rankList.add(vo);
            }
        }

        return rankList;
    }
}