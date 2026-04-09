package com.example.library.service;

import com.example.library.entity.Message;
import java.util.List;

public interface MessageService {

    Message getById(Long id);

    List<Message> getByTeacherId(Integer teacherId, Integer status, Integer page, Integer size);

    int getCountByTeacherId(Integer teacherId, Integer status);

    int getUnreadCount(Integer teacherId);

    boolean send(Message message);

    boolean markAsRead(Long id, Integer teacherId);

    int markAllAsReadBatch(Integer teacherId);

    boolean delete(Long id);
}