package com.example.library.controller;

import com.example.library.entity.Book;
import com.example.library.service.BookService;
import com.example.library.service.CategoryService;
import com.example.library.util.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/book")
public class BookController {

    @Autowired
    private BookService bookService;

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/list")
    public String listPage(Model model) {
        model.addAttribute("categories", categoryService.getAll());
        return "admin/book-list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Result getBookList(@RequestParam(defaultValue = "1") Integer page,
                              @RequestParam(defaultValue = "10") Integer limit,
                              String title, String author, String isbn, Integer categoryId) {
        PageHelper.startPage(page, limit);
        List<Book> list = bookService.getByCondition(title, author, isbn, categoryId, page, limit);
        PageInfo<Book> pageInfo = new PageInfo<>(list);
        return Result.success().put("data", pageInfo.getList()).put("count", pageInfo.getTotal());
    }

    @PostMapping("/add")
    @ResponseBody
    public Result addBook(Book book) {
        try {
            if (bookService.add(book)) {
                return Result.success("添加成功");
            }
            return Result.error("ISBN已存在");
        } catch (Exception e) {
            return Result.error("添加失败：" + e.getMessage());
        }
    }

    @GetMapping("/edit/{id}")
    @ResponseBody
    public Result getBook(@PathVariable Integer id) {
        Book book = bookService.getById(id);
        return Result.success().put("data", book);
    }

    @PutMapping("/update")
    @ResponseBody
    public Result updateBook(Book book) {
        try {
            if (bookService.update(book)) {
                return Result.success("更新成功");
            }
            return Result.error("更新失败");
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result deleteBook(@PathVariable Integer id) {
        try {
            if (bookService.delete(id)) {
                return Result.success("删除成功");
            }
            return Result.error("删除失败");
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }

    @GetMapping("/popular")
    @ResponseBody
    public Result getPopularBooks(@RequestParam(defaultValue = "10") Integer limit) {
        List<Book> list = bookService.getPopular(limit);
        return Result.success().put("data", list);
    }
}