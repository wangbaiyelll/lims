package com.example.library.controller;

import com.example.library.entity.Location;
import com.example.library.service.LocationService;
import com.example.library.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/location")
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/list")
    @ResponseBody
    public Result getLocationList() {
        List<Location> list = locationService.getAll();
        return Result.success().put("data", list);
    }

    @GetMapping("/libraries")
    @ResponseBody
    public Result getLibraries() {
        List<String> libraries = locationService.getAllLibraries();
        return Result.success().put("data", libraries);
    }

    @PostMapping("/add")
    @ResponseBody
    public Result addLocation(Location location) {
        try {
            if (locationService.add(location)) {
                return Result.success("添加成功");
            }
            return Result.error("添加失败");
        } catch (Exception e) {
            return Result.error("添加失败：" + e.getMessage());
        }
    }

    @PutMapping("/update")
    @ResponseBody
    public Result updateLocation(Location location) {
        try {
            if (locationService.update(location)) {
                return Result.success("更新成功");
            }
            return Result.error("更新失败");
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }

    @PutMapping("/status/{id}/{status}")
    @ResponseBody
    public Result updateStatus(@PathVariable Integer id, @PathVariable Integer status) {
        try {
            if (locationService.updateStatus(id, status)) {
                return Result.success(status == 1 ? "启用成功" : "禁用成功");
            }
            return Result.error("操作失败");
        } catch (Exception e) {
            return Result.error("操作失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result deleteLocation(@PathVariable Integer id) {
        try {
            if (locationService.delete(id)) {
                return Result.success("删除成功");
            }
            return Result.error("删除失败");
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}