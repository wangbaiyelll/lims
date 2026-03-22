package com.example.library.service;

import com.example.library.entity.Fine;
import java.util.List;

public interface FineService {

    Fine getById(Long id);

    List<Fine> getByTeacherId(Integer teacherId, Integer status);

    List<Fine> getByCondition(String teacherName, Integer status, Integer page, Integer size);

    int getCount(String teacherName, Integer status);

    boolean payFine(Long id);
}