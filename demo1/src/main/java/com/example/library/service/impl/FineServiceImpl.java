package com.example.library.service.impl;

import com.example.library.entity.Fine;
import com.example.library.entity.Message;
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

    @Override
    public Fine getById(Long id) {
        return fineMapper.selectById(id);
    }

    @Override
    public List<Fine> getByTeacherId(Integer teacherId, Integer status) {
        return fineMapper.selectByTeacherId(teacherId, status);
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
        if (fine == null || fine.getStatus() == 1) {
            return false;
        }

        int result = fineMapper.updateStatus(id, 1, new Date());

        if (result > 0) {
            // 发送消息通知
            Message message = new Message();
            message.setTeacherId(fine.getTeacherId());
            message.setType("fine");
            message.setTitle("罚款缴纳成功");
            message.setContent("您已成功缴纳罚款" + fine.getAmount() + "元，感谢您的配合。");
            messageMapper.insert(message);
            return true;
        }
        return false;
    }
}