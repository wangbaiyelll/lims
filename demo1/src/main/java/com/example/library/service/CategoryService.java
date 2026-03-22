package com.example.library.service;

import com.example.library.entity.Category;
import java.util.List;

public interface CategoryService {

    Category getById(Integer id);

    List<Category> getAll();

    List<Category> getByParentId(Integer parentId);

    List<Category> getLevel1();

    boolean add(Category category);

    boolean update(Category category);

    boolean delete(Integer id);

    boolean hasChildren(Integer id);

    boolean hasBooks(Integer id);
}