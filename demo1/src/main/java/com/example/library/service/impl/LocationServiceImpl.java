package com.example.library.service.impl;

import com.example.library.entity.Location;
import com.example.library.mapper.LocationMapper;
import com.example.library.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class LocationServiceImpl implements LocationService {

    @Autowired
    private LocationMapper locationMapper;

    @Override
    public Location getById(Integer id) {
        return locationMapper.selectById(id);
    }

    @Override
    public Location getByCode(String positionCode) {
        return locationMapper.selectByCode(positionCode);
    }

    @Override
    public List<Location> getAll() {
        return locationMapper.selectAll();
    }

    @Override
    public List<Location> getByLibrary(String libraryName) {
        return locationMapper.selectByLibrary(libraryName);
    }

    // ← 添加这个方法
    @Override
    public List<String> getAllLibraries() {
        return locationMapper.selectAllLibraries();
    }

    @Override
    public boolean add(Location location) {
        // 检查位置编码是否重复
        Location exist = locationMapper.selectByCode(location.getPositionCode());
        if (exist != null) {
            return false;
        }
        location.setStatus(1);
        return locationMapper.insert(location) > 0;
    }

    @Override
    public boolean update(Location location) {
        return locationMapper.update(location) > 0;
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        return locationMapper.updateStatus(id, status) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return locationMapper.deleteById(id) > 0;
    }
}