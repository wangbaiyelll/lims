package com.example.library.controller;

import com.example.library.entity.Category;
import com.example.library.service.CategoryService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    // ... existing code ...
    @GetMapping("/list")
    @ResponseBody
    public Result getCategoryList() {
        List<Category> list = categoryService.getAll();
        return Result.success().put("data", list);
    }

    @GetMapping("/data")  // 添加这个兼容的API端点
    @ResponseBody
    public Result getCategoryData() {
        List<Category> list = categoryService.getAll();
        return Result.success().put("data", list);
    }
// ... existing code ...


    @GetMapping("/level1")
    @ResponseBody
    public Result getLevel1() {
        List<Category> list = categoryService.getLevel1();
        return Result.success().put("data", list);
    }

    @GetMapping("/children/{parentId}")
    @ResponseBody
    public Result getChildren(@PathVariable Integer parentId) {
        List<Category> list = categoryService.getByParentId(parentId);
        return Result.success().put("data", list);
    }

    @PostMapping("/add")
    @ResponseBody
    public Result addCategory(Category category) {
        try {
            if (categoryService.add(category)) {
                return Result.success("添加成功");
            }
            return Result.error("添加失败");
        } catch (Exception e) {
            return Result.error("添加失败：" + e.getMessage());
        }
    }

    @PutMapping("/update")
    @ResponseBody
    public Result updateCategory(Category category) {
        try {
            if (categoryService.update(category)) {
                return Result.success("更新成功");
            }
            return Result.error("更新失败");
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result deleteCategory(@PathVariable Integer id) {
        try {
            if (categoryService.delete(id)) {
                return Result.success("删除成功");
            }
            return Result.error("删除失败，该分类下存在子分类或图书");
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}