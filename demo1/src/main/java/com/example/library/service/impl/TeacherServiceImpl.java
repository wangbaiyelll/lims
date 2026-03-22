package com.example.library.service.impl;

import com.example.library.entity.Teacher;
import com.example.library.mapper.TeacherMapper;
import com.example.library.mapper.AdminLogMapper;
import com.example.library.service.TeacherService;
import com.example.library.util.BCryptUtil;
import com.example.library.util.RandomPasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class TeacherServiceImpl implements TeacherService {

    @Autowired
    private TeacherMapper teacherMapper;

    @Autowired
    private AdminLogMapper adminLogMapper;

    @Override
    public Teacher getById(Integer id) {
        return teacherMapper.selectById(id);
    }

    @Override
    public Teacher getByUsername(String username) {
        return teacherMapper.selectByUsername(username);
    }

    @Override
    public List<Teacher> getByCondition(String keyword, String college, Integer status,
                                        Integer page, Integer size) {
        int offset = (page - 1) * size;
        return teacherMapper.selectByCondition(keyword, college, status, offset, size);
    }

    @Override
    public int getCount(String keyword, String college, Integer status) {
        return teacherMapper.countByCondition(keyword, college, status);
    }

    @Override
    public boolean add(Teacher teacher) {
        // 检查工号是否重复
        Teacher exist = teacherMapper.selectByEmpNo(teacher.getEmpNo());
        if (exist != null) {
            return false;
        }
        // 检查用户名是否重复
        exist = teacherMapper.selectByUsername(teacher.getUsername());
        if (exist != null) {
            return false;
        }
        // 密码加密
        teacher.setPassword(BCryptUtil.encode(teacher.getPassword()));
        teacher.setStatus(1);
        return teacherMapper.insert(teacher) > 0;
    }

    @Override
    public boolean update(Teacher teacher) {
        return teacherMapper.update(teacher) > 0;
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        return teacherMapper.updateStatus(id, status) > 0;
    }

    @Override
    public boolean resetPassword(Integer id) {
        String newPassword = RandomPasswordUtil.generateRandomPassword();
        String encodedPassword = BCryptUtil.encode(newPassword);
        int result = teacherMapper.updatePassword(id, encodedPassword);
        if (result > 0) {
            // 返回新密码，实际应该通过邮件发送
            System.out.println("教师ID:" + id + " 新密码:" + newPassword);
            return true;
        }
        return false;
    }

    @Override
    public boolean delete(Integer id) {
        return teacherMapper.deleteById(id) > 0;
    }
}