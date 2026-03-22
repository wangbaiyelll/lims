package com.example.library.service.impl;

import com.example.library.entity.*;
import com.example.library.mapper.*;
import com.example.library.service.BorrowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class BorrowServiceImpl implements BorrowService {

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private StockMapper stockMapper;

    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private TeacherMapper teacherMapper;

    @Autowired
    private RenewApplicationMapper renewApplicationMapper;

    @Autowired
    private FineMapper fineMapper;

    @Autowired
    private MessageMapper messageMapper;

    private static final int BORROW_DAYS = 30;
    private static final BigDecimal FINE_RATE = new BigDecimal("0.5");

    @Override
    public BorrowRecord getById(Long id) {
        return borrowRecordMapper.selectById(id);
    }

    @Override
    public List<BorrowRecord> getByTeacherId(Integer teacherId, Integer status, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return borrowRecordMapper.selectByTeacherId(teacherId, status, offset, size);
    }

    @Override
    public int getCountByTeacherId(Integer teacherId, Integer status) {
        return borrowRecordMapper.countByTeacherId(teacherId, status);
    }

    @Override
    public boolean borrow(Integer teacherId, Integer bookId, Integer locationId) {
        // 1. 检查教师状态
        Teacher teacher = teacherMapper.selectById(teacherId);
        if (teacher == null || teacher.getStatus() != 1) {
            return false;
        }

        // 2. 检查是否有逾期未还图书
        List<BorrowRecord> overdueList = borrowRecordMapper.selectByTeacherId(teacherId, 3, 0, 100);
        if (overdueList != null && !overdueList.isEmpty()) {
            return false;
        }

        // 3. 检查库存
        Stock stock = stockMapper.selectByBookAndLocation(bookId, locationId);
        if (stock == null || stock.getAvailableQty() <= 0) {
            return false;
        }

        // 4. 创建借阅记录
        BorrowRecord record = new BorrowRecord();
        record.setTeacherId(teacherId);
        record.setBookId(bookId);
        record.setStockId(stock.getId());
        record.setBorrowDate(new Date());
        // 应还日期 = 当前日期 + 30天
        record.setDueDate(new Date(System.currentTimeMillis() + BORROW_DAYS * 24 * 60 * 60 * 1000L));
        record.setStatus(1);
        record.setRenewCount(0);

        int result = borrowRecordMapper.insert(record);
        if (result > 0) {
            // 5. 更新库存
            stockMapper.updateAvailableQty(stock.getId(), -1);
            return true;
        }
        return false;
    }

    @Override
    public boolean returnBook(Long borrowId) {
        BorrowRecord record = borrowRecordMapper.selectById(borrowId);
        if (record == null || record.getStatus() != 1) {
            return false;
        }

        // 计算逾期天数
        Date now = new Date();
        int overdueDays = 0;
        if (now.after(record.getDueDate())) {
            long diff = now.getTime() - record.getDueDate().getTime();
            overdueDays = (int) (diff / (1000 * 60 * 60 * 24));
        }

        // 如果有逾期，生成罚款
        if (overdueDays > 0) {
            Fine fine = new Fine();
            fine.setTeacherId(record.getTeacherId());
            fine.setBorrowId(borrowId);
            fine.setAmount(FINE_RATE.multiply(new BigDecimal(overdueDays)));
            fine.setFineDate(new Date());
            fine.setDueDays(overdueDays);
            fine.setRemark("逾期" + overdueDays + "天");
            fineMapper.insert(fine);

            // 发送消息通知
            Message message = new Message();
            message.setTeacherId(record.getTeacherId());
            message.setType("fine");
            message.setTitle("罚款通知");
            message.setContent("您借阅的图书已逾期" + overdueDays + "天，产生罚款" +
                    FINE_RATE.multiply(new BigDecimal(overdueDays)) + "元，请及时缴纳。");
            messageMapper.insert(message);
        }

        // 更新借阅记录
        record.setReturnDate(now);
        record.setStatus(2);
        borrowRecordMapper.updateReturn(borrowId, now);

        // 更新库存
        stockMapper.updateAvailableQty(record.getStockId(), 1);

        return true;
    }

    @Override
    public boolean applyRenew(Long borrowId, Integer teacherId) {
        BorrowRecord record = borrowRecordMapper.selectById(borrowId);
        if (record == null || record.getTeacherId() != teacherId) {
            return false;
        }

        // 检查是否已逾期
        if (new Date().after(record.getDueDate())) {
            return false;
        }

        // 检查续借次数
        if (record.getRenewCount() >= 1) {
            return false;
        }

        // 创建续借申请
        RenewApplication application = new RenewApplication();
        application.setTeacherId(teacherId);
        application.setBorrowId(borrowId);
        application.setApplyDate(new Date());
        application.setStatus(0);

        return renewApplicationMapper.insert(application) > 0;
    }

    @Override
    public List<RenewApplication> getRenewApplications(Integer page, Integer size) {
        int offset = (page - 1) * size;
        return renewApplicationMapper.selectAll(offset, size);
    }

    @Override
    public int getRenewCount() {
        return renewApplicationMapper.countAll();
    }

    @Override
    public boolean auditRenew(Long id, Integer status, Integer adminId, String remark) {
        RenewApplication application = renewApplicationMapper.selectById(id);
        if (application == null || application.getStatus() != 0) {
            return false;
        }

        // 更新申请状态
        renewApplicationMapper.updateStatus(id, status, adminId, remark);

        if (status == 1) { // 审核通过
            // 更新借阅记录的应还日期
            BorrowRecord record = borrowRecordMapper.selectById(application.getBorrowId());
            Date newDueDate = new Date(record.getDueDate().getTime() + BORROW_DAYS * 24 * 60 * 60 * 1000L);
            borrowRecordMapper.updateRenew(application.getBorrowId(), newDueDate);

            // 发送消息通知教师
            Message message = new Message();
            message.setTeacherId(application.getTeacherId());
            message.setType("renew");
            message.setTitle("续借申请通过");
            message.setContent("您的续借申请已通过，新应还日期为：" + newDueDate);
            messageMapper.insert(message);
        } else if (status == 2) { // 审核拒绝
            Message message = new Message();
            message.setTeacherId(application.getTeacherId());
            message.setType("renew");
            message.setTitle("续借申请被拒绝");
            message.setContent("您的续借申请被拒绝，原因：" + remark);
            messageMapper.insert(message);
        }

        return true;
    }

    @Override
    public List<BorrowRecord> getAllBorrows(Integer page, Integer size) {
        int offset = (page - 1) * size;
        return borrowRecordMapper.selectAll(offset, size);
    }

    @Override
    public List<BorrowRecord> getOverdueList() {
        return borrowRecordMapper.selectOverdueList();
    }
}