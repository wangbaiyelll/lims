package com.example.library.service.impl;

import com.example.library.entity.BorrowRecord;
import com.example.library.entity.Book;
import com.example.library.entity.Fine;
import com.example.library.entity.Message;
import com.example.library.mapper.BookMapper;
import com.example.library.mapper.BorrowRecordMapper;
import com.example.library.mapper.FineMapper;
import com.example.library.mapper.MessageMapper;
import com.example.library.service.FineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class FineServiceImpl implements FineService {

    @Autowired
    private FineMapper fineMapper;

    @Autowired
    private MessageMapper messageMapper;
    
    @Autowired
    private BorrowRecordMapper borrowRecordMapper;
    
    @Autowired
    private BookMapper bookMapper;

    @Override
    public Fine getById(Long id) {
        return fineMapper.selectById(id);
    }

    @Override
    public List<Fine> getByTeacherId(Integer teacherId, Integer status) {
        List<Fine> list = fineMapper.selectByTeacherId(teacherId, status);
        
        // 为每条罚款记录设置 canPay 标记和书本价格
        if (list != null && !list.isEmpty()) {
            for (Fine fine : list) {
                // status=0:可支付，status=1:已支付，status=2:待归还
                fine.setCanPay(fine.getStatus() == 0);
                
                // 获取书本价格
                if (fine.getBorrowId() != null) {
                    BorrowRecord record = borrowRecordMapper.selectById(fine.getBorrowId());
                    if (record != null && record.getBookId() != null) {
                        Book book = bookMapper.selectById(record.getBookId());
                        if (book != null) {
                            fine.setBookPrice(book.getPrice());
                        }
                    }
                }
            }
        }
        
        return list;
    }
    
    @Override
    public List<Fine> getByTeacherIdWithPagination(Integer teacherId, Integer status, Integer page, Integer size) {
        int offset = (page - 1) * size;
        List<Fine> list = fineMapper.selectByTeacherIdWithPagination(teacherId, status, offset, size);
        
        System.out.println("📖 [罚款服务] 教师 ID: " + teacherId + ", 查询到 " + list.size() + " 条罚款记录");
        
        // 为每条罚款记录设置 canPay 标记和书本价格
        if (list != null && !list.isEmpty()) {
            for (Fine fine : list) {
                fine.setCanPay(fine.getStatus() == 0);
                
                // 获取书本价格
                if (fine.getBorrowId() != null) {
                    try {
                        BorrowRecord record = borrowRecordMapper.selectById(fine.getBorrowId());
                        if (record != null && record.getBookId() != null) {
                            Book book = bookMapper.selectById(record.getBookId());
                            if (book != null && book.getPrice() != null) {
                                fine.setBookPrice(book.getPrice());
                                System.out.println("  📚 罚款 ID: " + fine.getId() + ", 图书：《" + fine.getBookTitle() + 
                                                 "》, 价格：" + book.getPrice());
                            }
                        }
                    } catch (Exception e) {
                        System.err.println("❌ 获取书本价格失败：" + e.getMessage());
                    }
                }
            }
        }
        
        return list;
    }
    
    @Override
    public int countByTeacherId(Integer teacherId, Integer status) {
        return fineMapper.countByTeacherId(teacherId, status);
    }

    @Override
    public List<Fine> getByCondition(String teacherName, Integer status, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return fineMapper.selectByCondition(teacherName, status, offset, size);
    }

    @Override
    public int getCount(String teacherName, Integer status) {
        return fineMapper.countByCondition(teacherName, status);
    }

    @Override
    public boolean payFine(Long id) {
        Fine fine = fineMapper.selectById(id);
        // 检查是否存在、是否未支付、是否已还书（status=0）
        if (fine == null || fine.getStatus() != 0) {
            return false;
        }

        int result = fineMapper.updateStatus(id, 1, new Date());

        if (result > 0) {
            // 发送消息通知
            Message message = new Message();
            message.setTeacherId(fine.getTeacherId());
            message.setType("fine_paid");
            message.setTitle("罚款缴纳成功");
            message.setContent("您已成功缴纳罚款" + fine.getAmount() + "元（图书《" + fine.getBookTitle() + "》逾期" + fine.getDueDays() + "天），感谢您的配合。");
            messageMapper.insert(message);
            return true;
        }
        return false;
    }
}