package com.example.library.service;

import com.example.library.entity.Stock;
import java.util.List;

public interface StockService {

    Stock getById(Integer id);

    List<Stock> getByBookId(Integer bookId);

    List<Stock> getByLocationId(Integer locationId);

    List<Stock> getAll(Integer page, Integer size);

    int getCount();

    boolean add(Stock stock);

    boolean update(Stock stock);

    boolean adjustQuantity(Integer id, Integer change);

    boolean delete(Integer id);
}