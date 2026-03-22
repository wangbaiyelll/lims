package com.example.library.task;

import com.example.library.entity.BorrowRecord;
import com.example.library.entity.Message;
import com.example.library.entity.OverdueReminder;
import com.example.library.mapper.BorrowRecordMapper;
import com.example.library.mapper.MessageMapper;
import com.example.library.mapper.OverdueReminderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

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

    /**
     * 每天凌晨1点执行逾期检查
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void checkOverdue() {
        System.out.println("开始执行逾期检查任务...");

        // 获取所有逾期未还的借阅记录
        List<BorrowRecord> overdueList = borrowRecordMapper.selectOverdueList();

        for (BorrowRecord record : overdueList) {
            // 计算逾期天数
            long diff = System.currentTimeMillis() - record.getDueDate().getTime();
            int overdueDays = (int) (diff / (1000 * 60 * 60 * 24));

            // 检查是否已发送过提醒（避免重复发送）
            OverdueReminder existing = overdueReminderMapper.selectByBorrowId(record.getId());

            if (existing == null || existing.getOverdueDays() != overdueDays) {
                // 创建逾期提醒记录
                OverdueReminder reminder = new OverdueReminder();
                reminder.setTeacherId(record.getTeacherId());
                reminder.setBorrowId(record.getId());
                reminder.setOverdueDays(overdueDays);
                reminder.setReminderDate(new Date());
                reminder.setSendStatus(1);
                overdueReminderMapper.insert(reminder);

                // 发送站内消息
                Message message = new Message();
                message.setTeacherId(record.getTeacherId());
                message.setType("overdue");
                message.setTitle("图书逾期提醒");
                message.setContent("您借阅的图书《" + record.getBookTitle() + "》已逾期" +
                        overdueDays + "天，请尽快归还，以免产生更多罚款。");
                messageMapper.insert(message);

                System.out.println("发送逾期提醒给教师ID: " + record.getTeacherId() +
                        "，逾期天数: " + overdueDays);
            }
        }

        System.out.println("逾期检查任务执行完毕，共处理 " + overdueList.size() + " 条逾期记录");
    }

    /**
     * 每天上午10点发送即将到期提醒（可选）
     */
    @Scheduled(cron = "0 0 10 * * ?")
    public void checkDueSoon() {
        System.out.println("开始执行即将到期检查任务...");

        // 获取3天内到期的借阅记录
        List<BorrowRecord> dueSoonList = borrowRecordMapper.selectDueSoon(3);

        for (BorrowRecord record : dueSoonList) {
            // 发送即将到期提醒
            Message message = new Message();
            message.setTeacherId(record.getTeacherId());
            message.setType("overdue");
            message.setTitle("图书即将到期提醒");
            message.setContent("您借阅的图书《" + record.getBookTitle() + "》将于" +
                    record.getDueDate() + "到期，请及时归还。");
            messageMapper.insert(message);
        }

        System.out.println("即将到期检查任务执行完毕，共处理 " + dueSoonList.size() + " 条记录");
    }
}