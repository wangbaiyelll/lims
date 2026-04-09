package com.example.library.task;

import com.example.library.entity.BorrowRecord;
import com.example.library.entity.Book;
import com.example.library.entity.Fine;
import com.example.library.entity.Message;
import com.example.library.entity.OverdueReminder;
import com.example.library.mapper.BookMapper;
import com.example.library.mapper.BorrowRecordMapper;
import com.example.library.mapper.FineMapper;
import com.example.library.mapper.MessageMapper;
import com.example.library.mapper.OverdueReminderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Component
public class OverdueReminderTask {

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private OverdueReminderMapper overdueReminderMapper;

    @Autowired
    private MessageMapper messageMapper;

    @Autowired
    private FineMapper fineMapper;
    
    @Autowired
    private BookMapper bookMapper;

    private static final BigDecimal FINE_RATE = new BigDecimal("0.5");

    /**
     * 应用启动完成后立即执行一次逾期检查
     */
    @EventListener(ApplicationReadyEvent.class)
    public void onApplicationReady() {
        System.out.println("\n\n🚀 [启动检查] 系统启动完成，开始检查逾期图书...\n");
        checkOverdue();
    }

    /**
     * 每 10 分钟执行一次逾期检查并生成/更新罚单
     * 生产环境如需改为每天执行，使用：cron = "0 0 1 * * ?"
     */
    @Scheduled(cron = "0 */10 * * * ?")
    public void checkOverdue() {
        System.out.println("========== 开始执行逾期检查任务（每 10 分钟一次） ==========");

        List<BorrowRecord> overdueList = borrowRecordMapper.selectOverdueList();
        
        System.out.println("📋 查询到 " + overdueList.size() + " 条逾期未还记录");
        if (!overdueList.isEmpty()) {
            for (BorrowRecord record : overdueList) {
                System.out.println("  📚 借阅 ID: " + record.getId() + 
                                 ", 图书：《" + record.getBookTitle() + 
                                 "》, 应还日期：" + record.getDueDate() + 
                                 ", 状态：" + record.getStatus() +
                                 ", 已归还：" + (record.getReturnDate() != null ? "是" : "否"));
            }
        }

        if (overdueList == null || overdueList.isEmpty()) {
            System.out.println("✅ 当前没有逾期未还的图书记录\n");
            return;
        }

        int newFineCount = 0;
        int updateFineCount = 0;

        for (BorrowRecord record : overdueList) {
            // 计算逾期天数
            long diff = System.currentTimeMillis() - record.getDueDate().getTime();
            int overdueDays = (int) (diff / (1000 * 60 * 60 * 24));
            
            // 获取书本价格
            BigDecimal bookPrice = BigDecimal.ZERO;
            if (record.getBookId() != null) {
                Book book = bookMapper.selectById(record.getBookId());
                if (book != null && book.getPrice() != null) {
                    bookPrice = book.getPrice();
                }
            }
            
            // 计算罚款金额（不超过书本价格）
            BigDecimal calculatedFine = FINE_RATE.multiply(new BigDecimal(overdueDays));
            BigDecimal fineAmount = calculatedFine.min(bookPrice);
            
            String remark = "图书逾期" + overdueDays + "天，滞纳金：0.5 元/天";
            if (calculatedFine.compareTo(bookPrice) > 0) {
                remark = "图书逾期" + overdueDays + "天，按原价赔偿（罚金已达书本价格上限）";
            }

            // 更新借阅状态为逾期
            if (record.getStatus() != 3) {
                borrowRecordMapper.updateStatus(record.getId(), 3);
                record.setStatus(3);
                System.out.println("📊 更新借阅 ID: " + record.getId() + " 为逾期状态");
            }

            // 检查是否已有罚单
            List<Fine> existingFines = fineMapper.selectByBorrowId(record.getId());
            
            if (existingFines == null || existingFines.isEmpty()) {
                // 生成新罚单 - 状态设为"待归还"(2)
                Fine fine = new Fine();
                fine.setTeacherId(record.getTeacherId());
                fine.setBorrowId(record.getId());
                fine.setAmount(fineAmount);
                fine.setFineDate(new Date());
                fine.setDueDays(overdueDays);
                fine.setStatus(2); // 待归还状态，不可支付
                fine.setRemark(remark);
                fineMapper.insert(fine);
                
                newFineCount++;
                System.out.println("💰 生成罚单 - 借阅 ID: " + record.getId() + 
                                 ", 金额：" + fineAmount + "元，逾期：" + overdueDays + 
                                 "天，状态：待归还");
            } else {
                // 更新已有罚单的金额和状态
                Fine existingFine = existingFines.get(0);
                boolean needUpdate = false;
                
                if (!existingFine.getAmount().equals(fineAmount) || existingFine.getDueDays() != overdueDays) {
                    needUpdate = true;
                }
                
                if (existingFine.getStatus() != 2) {
                    existingFine.setStatus(2);
                    needUpdate = true;
                }
                
                if (needUpdate) {
                    fineMapper.updateOverdueDaysWithStatus(record.getId(), overdueDays, fineAmount, 2);
                    updateFineCount++;
                    System.out.println("🔄 更新罚单 - 借阅 ID: " + record.getId() + 
                                     ", 新金额：" + fineAmount + "元，逾期：" + overdueDays + 
                                     "天，状态：待归还");
                }
            }

            // 发送提醒消息（每 3 天一次）
            OverdueReminder lastReminder = overdueReminderMapper.selectByBorrowId(record.getId());
            boolean shouldSendReminder = (lastReminder == null) || 
                ((System.currentTimeMillis() - lastReminder.getReminderDate().getTime()) 
                 / (1000 * 60 * 60 * 24) >= 3);

            if (shouldSendReminder) {
                Message message = new Message();
                message.setTeacherId(record.getTeacherId());
                message.setType("overdue");
                message.setTitle("图书逾期提醒");
                message.setContent("您借阅的图书《" + record.getBookTitle() + "》已逾期" +
                        overdueDays + "天，当前累计罚款" + fineAmount + "元" +
                        (bookPrice.compareTo(BigDecimal.ZERO) > 0 ? "（最高赔偿限额：" + bookPrice + "元）" : "") + 
                        "。请尽快归还，归还后方可缴纳罚款！");
                messageMapper.insert(message);
                
                if (lastReminder == null) {
                    OverdueReminder reminder = new OverdueReminder();
                    reminder.setTeacherId(record.getTeacherId());
                    reminder.setBorrowId(record.getId());
                    reminder.setOverdueDays(overdueDays);
                    reminder.setReminderDate(new Date());
                    reminder.setSendStatus(1);
                    overdueReminderMapper.insert(reminder);
                }
                
                System.out.println("📧 发送逾期提醒 - 教师：" + record.getTeacherId());
            }
        }

        System.out.println("========== 任务完成：新增罚单 " + newFineCount + 
                         " 张，更新罚单 " + updateFineCount + " 张 ==========\n");
    }

    /**
     * 每天上午 10 点发送临期提醒
     */
    @Scheduled(cron = "0 0 10 * * ?")
    public void checkDueSoon() {
        System.out.println("========== 开始执行临期检查任务 ==========");

        List<BorrowRecord> dueSoonList = borrowRecordMapper.selectDueSoon(3);

        for (BorrowRecord record : dueSoonList) {
            long diff = record.getDueDate().getTime() - System.currentTimeMillis();
            int daysLeft = (int) (diff / (1000 * 60 * 60 * 24)) + 1;

            Message message = new Message();
            message.setTeacherId(record.getTeacherId());
            message.setType("due_soon");
            message.setTitle("图书即将到期提醒");
            message.setContent("温馨提示：您借阅的图书《" + record.getBookTitle() + "》将于" +
                    record.getDueDate() + "到期（还剩" + daysLeft + "天），请按时归还。");
            messageMapper.insert(message);

            System.out.println("⏰ 临期提醒 - 图书：《" + record.getBookTitle() + 
                             "》, 剩余：" + daysLeft + "天");
        }

        System.out.println("========== 临期检查任务完成 ==========\n");
    }
}