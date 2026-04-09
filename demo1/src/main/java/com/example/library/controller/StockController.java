package com.example.library.controller;

import com.example.library.entity.Stock;
import com.example.library.service.StockService;
import com.example.library.util.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/stock")
public class StockController {

    @Autowired
    private StockService stockService;

    @GetMapping("/list")
    @ResponseBody
    public Result getStockList(@RequestParam(defaultValue = "1") Integer page,
                      @RequestParam(defaultValue = "10") Integer limit,
                      @RequestParam(required = false) String bookTitle) {
        // 移除PageHelper.startPage调用，因为Service层已经处理了分页
        List<Stock> list = stockService.getAll(page, limit, bookTitle);
        // 使用Service层返回的数据直接构建响应
        return Result.success().put("data", list).put("count", stockService.getCount(bookTitle));
    }

    @GetMapping("/book/{bookId}")
    @ResponseBody
    public Result getStockByBook(@PathVariable Integer bookId) {
        List<Stock> list = stockService.getByBookId(bookId);
        return Result.success().put("data", list);
    }

    @PostMapping("/add")
    @ResponseBody
    public Result addStock(Stock stock) {
        try {
            if (stockService.add(stock)) {
                return Result.success("添加成功");
            }
            return Result.error("添加失败");
        } catch (Exception e) {
            return Result.error("添加失败：" + e.getMessage());
        }
    }

    @PutMapping("/update")
    @ResponseBody
    public Result updateStock(Stock stock) {
        try {
            if (stockService.update(stock)) {
                return Result.success("更新成功");
            }
            return Result.error("更新失败");
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }

    @PutMapping("/adjust/{id}/{change}")
    @ResponseBody
    public Result adjustStock(@PathVariable Integer id, @PathVariable Integer change) {
        try {
            if (stockService.adjustQuantity(id, change)) {
                return Result.success(change > 0 ? "入库成功" : "出库成功");
            }
            return Result.error("操作失败");
        } catch (Exception e) {
            return Result.error("操作失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result deleteStock(@PathVariable Integer id) {
        try {
            if (stockService.delete(id)) {
                return Result.success("删除成功");
            }
            return Result.error("删除失败");
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}