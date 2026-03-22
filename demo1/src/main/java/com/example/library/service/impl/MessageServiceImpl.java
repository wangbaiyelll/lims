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
    public boolean markAsRead(Long id, Integer teacherId) {
        Message message = messageMapper.selectById(id);
        if (message == null || !message.getTeacherId().equals(teacherId)) {
            return false;
        }
        return messageMapper.updateStatus(id, 1) > 0;
    }

    @Override
    public boolean delete(Long id) {
        return messageMapper.deleteById(id) > 0;
    }
}