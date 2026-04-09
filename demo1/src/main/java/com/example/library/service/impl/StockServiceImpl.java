package com.example.library.service.impl;

import com.example.library.entity.Stock;
import com.example.library.mapper.StockMapper;
import com.example.library.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class StockServiceImpl implements StockService {

    @Autowired
    private StockMapper stockMapper;

    @Override
    public Stock getById(Integer id) {
        return stockMapper.selectById(id);
    }

    @Override
    public List<Stock> getByBookId(Integer bookId) {
        return stockMapper.selectByBookId(bookId);
    }

    @Override
    public List<Stock> getByLocationId(Integer locationId) {
        return stockMapper.selectByLocationId(locationId);
    }

    @Override
    public List<Stock> getAll(Integer page, Integer size) {
        return getAll(page, size, null);
    }

    @Override
    public List<Stock> getAll(Integer page, Integer size, String bookTitle) {
        int offset = (page - 1) * size;
        return stockMapper.selectAll(offset, size, bookTitle);
    }

    @Override
    public int getCount() {
        return getCount(null);
    }

    @Override
    public int getCount(String bookTitle) {
        return stockMapper.countAll(bookTitle);
    }

    @Override
    public boolean add(Stock stock) {
        // 检查是否已存在相同图书和位置的库存记录
        Stock exist = stockMapper.selectByBookAndLocation(stock.getBookId(), stock.getLocationId());
        if (exist != null) {
            return false;
        }
        stock.setAvailableQty(stock.getTotalQty());
        stock.setStatus(1);
        return stockMapper.insert(stock) > 0;
    }

    @Override
    public boolean update(Stock stock) {
        return stockMapper.update(stock) > 0;
    }

    @Override
    public boolean adjustQuantity(Integer id, Integer change) {
        return stockMapper.updateAvailableQty(id, change) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return stockMapper.deleteById(id) > 0;
    }
}