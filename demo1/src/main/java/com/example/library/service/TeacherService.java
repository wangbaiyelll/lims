package com.example.library.service;

import com.example.library.entity.Teacher;
import java.util.List;

public interface TeacherService {

    Teacher getById(Integer id);

    Teacher getByUsername(String username);

    List<Teacher> getByCondition(String keyword, String college, Integer status, Integer page, Integer size);

    int getCount(String keyword, String college, Integer status);

    boolean add(Teacher teacher);

    boolean update(Teacher teacher);

    boolean updateStatus(Integer id, Integer status);

    boolean resetPassword(Integer id);

    boolean delete(Integer id);
}