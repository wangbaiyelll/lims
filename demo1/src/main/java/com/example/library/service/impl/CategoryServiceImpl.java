package com.example.library.service.impl;

import com.example.library.entity.Category;
import com.example.library.mapper.CategoryMapper;
import com.example.library.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public Category getById(Integer id) {
        return categoryMapper.selectById(id);
    }

    @Override
    public List<Category> getAll() {
        return categoryMapper.selectAll();
    }

    @Override
    public List<Category> getByParentId(Integer parentId) {
        return categoryMapper.selectByParentId(parentId);
    }

    @Override
    public List<Category> getLevel1() {
        return categoryMapper.selectLevel1();
    }

    @Override
    public boolean add(Category category) {
        if (category.getParentId() == 0) {
            category.setLevel(1);
        } else {
            category.setLevel(2);
        }
        return categoryMapper.insert(category) > 0;
    }

    @Override
    public boolean update(Category category) {
        return categoryMapper.update(category) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        // 检查是否有子分类
        if (hasChildren(id)) {
            return false;
        }
        // 检查是否有图书
        if (hasBooks(id)) {
            return false;
        }
        return categoryMapper.deleteById(id) > 0;
    }

    @Override
    public boolean hasChildren(Integer id) {
        return categoryMapper.countChildren(id) > 0;
    }

    @Override
    public boolean hasBooks(Integer id) {
        return categoryMapper.countBooks(id) > 0;
    }
}