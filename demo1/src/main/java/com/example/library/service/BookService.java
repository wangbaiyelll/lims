package com.example.library.service;

import com.example.library.entity.Book;
import java.util.List;

public interface BookService {

    Book getById(Integer id);

    Book getByIsbn(String isbn);

    List<Book> getByCondition(String title, String author, String isbn,
                              Integer categoryId, Integer page, Integer size);

    int getCount(String title, String author, String isbn, Integer categoryId);

    boolean add(Book book);

    boolean update(Book book);

    boolean delete(Integer id);

    List<Book> getPopular(Integer limit);

    List<Book> getRecommendByTeacher(Integer teacherId, Integer limit);
}