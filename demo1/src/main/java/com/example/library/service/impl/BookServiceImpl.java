package com.example.library.service.impl;

import com.example.library.entity.Book;
import com.example.library.mapper.BookMapper;
import com.example.library.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class BookServiceImpl implements BookService {

    @Autowired
    private BookMapper bookMapper;

    @Override
    public Book getById(Integer id) {
        return bookMapper.selectById(id);
    }

    @Override
    public Book getByIsbn(String isbn) {
        return bookMapper.selectByIsbn(isbn);
    }

    @Override
    public List<Book> getByCondition(String title, String author, String isbn,
                                     Integer categoryId, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return bookMapper.selectByCondition(title, author, isbn, categoryId, 1, offset, size);
    }

    @Override
    public int getCount(String title, String author, String isbn, Integer categoryId) {
        return bookMapper.countByCondition(title, author, isbn, categoryId, 1);
    }

    @Override
    public boolean add(Book book) {
        // 检查ISBN是否重复
        Book exist = bookMapper.selectByIsbn(book.getIsbn());
        if (exist != null) {
            return false;
        }
        book.setStatus(1);
        return bookMapper.insert(book) > 0;
    }

    @Override
    public boolean update(Book book) {
        return bookMapper.update(book) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return bookMapper.deleteById(id) > 0;
    }

    @Override
    public List<Book> getPopular(Integer limit) {
        return bookMapper.selectPopular(limit);
    }

    @Override
    public List<Book> getRecommendByTeacher(Integer teacherId, Integer limit) {
        return bookMapper.selectRecommendByTeacher(teacherId, limit);
    }
}