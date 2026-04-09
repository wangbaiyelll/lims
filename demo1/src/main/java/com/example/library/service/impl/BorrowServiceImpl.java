package com.example.library.service.impl;

import com.example.library.entity.*;
import com.example.library.mapper.*;
import com.example.library.service.BorrowService;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
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
        List<BorrowRecord> records = borrowRecordMapper.selectByTeacherId(teacherId, status, offset, size);
        
        // 实时更新逾期状态
        updateOverdueStatus(records);
        
        return records;
    }

    @Override
    public int getCountByTeacherId(Integer teacherId, Integer status) {
        return borrowRecordMapper.countByTeacherIdAndStatus(teacherId, status);
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
        // 应还日期 = 当前日期 + 30 天
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
        if (record == null || (record.getStatus() != 1 && record.getStatus() != 3)) {
            return false;
        }

        // 计算实际逾期天数
        Date now = new Date();
        int overdueDays = 0;
        if (now.after(record.getDueDate())) {
            long diff = now.getTime() - record.getDueDate().getTime();
            overdueDays = (int) (diff / (1000 * 60 * 60 * 24));
        }

        System.out.println("========== 办理还书手续 ==========");
        System.out.println("📖 借阅 ID: " + borrowId);
        System.out.println("📚 图书：《" + record.getBookTitle() + "》");
        System.out.println("📅 应还日期：" + record.getDueDate());
        System.out.println("⏱️ 逾期天数：" + overdueDays + "天");

        // 如果有逾期，处理罚款单
        if (overdueDays > 0) {
            // 获取书本价格
            BigDecimal bookPrice = BigDecimal.ZERO;
            if (record.getBookId() != null) {
                Book book = bookMapper.selectById(record.getBookId());
                if (book != null && book.getPrice() != null) {
                    bookPrice = book.getPrice();
                }
            }
            
            // 计算最终罚款金额（不超过书本价格）
            BigDecimal calculatedFine = FINE_RATE.multiply(new BigDecimal(overdueDays));
            BigDecimal fineAmount = calculatedFine.min(bookPrice);
            
            String remark = "图书逾期" + overdueDays + "天，滞纳金：0.5 元/天";
            if (calculatedFine.compareTo(bookPrice) > 0) {
                remark = "图书逾期" + overdueDays + "天，按原价赔偿（罚金已达书本价格上限）";
            }
            
            // 检查是否已有罚款记录
            List<Fine> existingFines = fineMapper.selectByBorrowId(borrowId);
            
            if (existingFines == null || existingFines.isEmpty()) {
                // 生成新的罚款单（这种情况较少，一般是直接来还书）
                Fine fine = new Fine();
                fine.setTeacherId(record.getTeacherId());
                fine.setBorrowId(borrowId);
                fine.setAmount(fineAmount);
                fine.setFineDate(now);
                fine.setDueDays(overdueDays);
                fine.setStatus(0); // 已还书，可以支付
                fine.setRemark(remark);
                fineMapper.insert(fine);

                // 发送罚款通知
                Message message = new Message();
                message.setTeacherId(record.getTeacherId());
                message.setType("fine");
                message.setTitle("罚款通知单");
                message.setContent("您归还的图书《" + record.getBookTitle() + "》已逾期" + overdueDays + 
                    "天，根据规定产生罚款" + fineAmount + "元" +
                    (bookPrice.compareTo(BigDecimal.ZERO) > 0 ? "（书本价格：" + bookPrice + "元，已按较低者收取）" : "") +
                    "。请及时在'我的罚款'页面缴纳。");
                messageMapper.insert(message);

                System.out.println("💰 生成罚款单 - 金额：" + fineAmount + "元，状态：可支付");
                System.out.println("📧 已发送罚款通知");
            } else {
                // 已存在罚款单，更新金额和状态（从"待归还"改为"可支付"）
                Fine existingFine = existingFines.get(0);
                boolean needUpdate = false;
                
                if (!existingFine.getAmount().equals(fineAmount) || existingFine.getDueDays() != overdueDays) {
                    fineMapper.updateOverdueDays(borrowId, overdueDays, fineAmount);
                    needUpdate = true;
                    System.out.println("🔄 更新罚款金额 - 新金额：" + fineAmount + "元");
                }
                
                // 关键：将状态从"待归还"(2) 更新为"可支付"(0)
                if (existingFine.getStatus() == 2) {
                    fineMapper.updateFineStatusToPayable(borrowId);
                    needUpdate = true;
                    System.out.println("✅ 罚款状态已更新为【可支付】");
                }
                
                if (!needUpdate) {
                    System.out.println("✓ 罚款单已存在，仅需更新状态");
                    fineMapper.updateFineStatusToPayable(borrowId);
                }
            }
        } else {
            System.out.println("✓ 未逾期，无需生成罚款");
        }

        // 更新借阅记录为已归还
        record.setReturnDate(now);
        record.setStatus(2);
        borrowRecordMapper.updateReturn(borrowId, now);
        System.out.println("✅ 借阅记录已更新为【已归还】");

        // 恢复库存
        stockMapper.updateAvailableQty(record.getStockId(), 1);
        System.out.println("📦 图书库存已恢复");
        
        System.out.println("========== 还书手续办理完成 ==========\n");

        return true;
    }

    @Override
    public boolean applyRenew(Long borrowId, Integer teacherId) {
        BorrowRecord record = borrowRecordMapper.selectById(borrowId);
        if (record == null || record.getTeacherId() != teacherId) {
            return false;
        }

        // 检查是否有逾期未还图书（包括其他书）
        List<BorrowRecord> overdueList = borrowRecordMapper.selectByTeacherId(teacherId, 3, 0, 100);
        if (overdueList != null && !overdueList.isEmpty()) {
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

        // 检查是否存在待审核的续借申请（防止重复提交）
        RenewApplication existingApplication = renewApplicationMapper.selectByBorrowIdAndStatus(borrowId, 0);
        if (existingApplication != null) {
            return false; // 已有待审核申请，不允许重复提交
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
    public RenewApplication getPendingRenewApplication(Long borrowId) {
        return renewApplicationMapper.selectByBorrowIdAndStatus(borrowId, 0);
    }

    @Override
    public RenewApplication getRecentRenewApplication(Long borrowId) {
        // 获取该借阅记录最近的审核申请（状态不为 0 的）
        List<RenewApplication> applications = renewApplicationMapper.selectByBorrowId(borrowId);
        if (applications != null && !applications.isEmpty()) {
            // 按审核时间倒序，返回第一个
            applications.sort((a1, a2) -> {
                if (a1.getAuditDate() == null) return 1;
                if (a2.getAuditDate() == null) return -1;
                return a2.getAuditDate().compareTo(a1.getAuditDate());
            });
            return applications.get(0);
        }
        return null;
    }

    @Override
    public List<RenewApplication> getRenewApplications(Integer page, Integer size) {
        int offset = (page - 1) * size;
        return renewApplicationMapper.selectAll(offset, size);
    }

    @Override
    public List<RenewApplication> getRenewApplicationsWithCondition(String teacherName, String bookTitle, Integer status) {
        // 使用大分页获取所有符合条件的数据
        return renewApplicationMapper.selectAllWithCondition(0, 10000, teacherName, bookTitle, status);
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
        List<BorrowRecord> records = borrowRecordMapper.selectAll(offset, size);
        
        // 实时更新逾期状态
        updateOverdueStatus(records);
        
        return records;
    }

    @Override
    public List<BorrowRecord> getOverdueList() {
        return borrowRecordMapper.selectOverdueList();
    }

    @Override
    public List<RenewApplication> getApplicationsByBorrowIds(List<Long> borrowIds) {
        if (borrowIds == null || borrowIds.isEmpty()) {
            return new ArrayList<>();
        }
        return renewApplicationMapper.selectByBorrowIds(borrowIds);
    }
    
    @Override
    public int countByTeacherIdAndStatus(Integer teacherId, Integer status) {
        return borrowRecordMapper.countByTeacherIdAndStatus(teacherId, status);
    }

    @Override
    public List<BorrowRecord> getBorrowsWithCondition(String teacherName, String bookTitle, Integer status, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return borrowRecordMapper.selectWithCondition(teacherName, bookTitle, status, offset, size);
    }
    
    private void updateOverdueStatus(List<BorrowRecord> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        
        Date now = new Date();
        for (BorrowRecord record : records) {
            // 只处理借阅中和逾期的记录
            if ((record.getStatus() == 1 || record.getStatus() == 3) 
                && record.getReturnDate() == null 
                && record.getDueDate() != null) {
                
                // 如果已过期，更新状态为逾期
                if (now.after(record.getDueDate()) && record.getStatus() != 3) {
                    borrowRecordMapper.updateStatus(record.getId(), 3);
                    record.setStatus(3);
                }
            }
        }
    }
}