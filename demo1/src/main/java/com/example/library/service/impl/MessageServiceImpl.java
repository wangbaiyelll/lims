package com.example.library.service.impl;

import com.example.library.entity.Message;
import com.example.library.mapper.MessageMapper;
import com.example.library.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class MessageServiceImpl implements MessageService {

    @Autowired
    private MessageMapper messageMapper;

    @Override
    public Message getById(Long id) {
        return messageMapper.selectById(id);
    }

    @Override
    public List<Message> getByTeacherId(Integer teacherId, Integer status, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return messageMapper.selectByTeacherId(teacherId, status, offset, size);
    }

    @Override
    public int getCountByTeacherId(Integer teacherId, Integer status) {
        return messageMapper.countByTeacherId(teacherId, status);
    }

    @Override
    public int getUnreadCount(Integer teacherId) {
        return messageMapper.countByTeacherId(teacherId, 0);
    }

    @Override
    public boolean send(Message message) {
        return messageMapper.insert(message) > 0;
    }

    @Override
    @Transactional(readOnly = false, rollbackFor = Exception.class)
    public boolean markAsRead(Long id, Integer teacherId) {
        try {
            System.out.println("🔵 [MessageService] 开始标记消息 " + id + " 为已读");
            
            Message message = messageMapper.selectById(id);
            if (message == null || !message.getTeacherId().equals(teacherId)) {
                System.err.println("❌ [MessageService] 消息不存在或权限不足");
                return false;
            }
            
            int result = messageMapper.updateStatus(id, 1);
            System.out.println("✅ [MessageService] SQL 执行结果：" + result + " 行已更新");
            
            if (result > 0) {
                System.out.println("✅ [MessageService] 标记成功");
            } else {
                System.err.println("❌ [MessageService] 标记失败，SQL 未影响任何行");
            }
            
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ [MessageService] 发生异常：" + e.getMessage());
            e.printStackTrace();
            throw e; // 重新抛出异常，让事务回滚
        }
    }

    @Override
    @Transactional(readOnly = false, rollbackFor = Exception.class)
    public int markAllAsReadBatch(Integer teacherId) {
        try {
            System.out.println("🔵 [MessageService] 开始批量标记教师 " + teacherId + " 的所有消息为已读");
            
            // 直接查询所有未读消息，不使用分页
            List<Message> unreadMessages = messageMapper.selectByTeacherId(teacherId, 0, 0, 1000);
            System.out.println("📊 [MessageService] 找到 " + unreadMessages.size() + " 条未读消息");
            
            int count = 0;
            for (Message message : unreadMessages) {
                // 验证权限
                if (message.getTeacherId().equals(teacherId)) {
                    int result = messageMapper.updateStatus(message.getId(), 1);
                    if (result > 0) {
                        count++;
                    }
                }
            }
            
            System.out.println("✅ [MessageService] 批量标记完成，成功 " + count + " 条");
            return count;
        } catch (Exception e) {
            System.err.println("❌ [MessageService] 批量标记异常：" + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public boolean delete(Long id) {
        return messageMapper.deleteById(id) > 0;
    }
}
