package com.example.library.service.impl;

import com.alibaba.fastjson2.JSON;
import com.example.library.entity.Role;
import com.example.library.mapper.RoleMapper;
import com.example.library.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Override
    public Role getById(Integer id) {
        return roleMapper.selectById(id);
    }

    @Override
    public List<Role> getAll() {
        return roleMapper.selectAll();
    }

    @Override
    public boolean add(Role role) {
        return roleMapper.insert(role) > 0;
    }

    @Override
    public boolean update(Role role) {
        return roleMapper.update(role) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return roleMapper.deleteById(id) > 0;
    }

    @Override
    public boolean hasPermission(Integer roleId, String permission) {
        Role role = roleMapper.selectById(roleId);
        if (role == null) {
            return false;
        }

        // 超级管理员拥有所有权限
        if ("超级管理员".equals(role.getRoleName())) {
            return true;
        }

        // 解析权限 JSON
        Set<String> permissions = getPermissions(roleId);
        return permissions.contains(permission);
    }

    @Override
    public Set<String> getPermissions(Integer roleId) {
        Role role = roleMapper.selectById(roleId);
        if (role == null) {
            return new HashSet<>();
        }

        // 超级管理员拥有所有权限
        if ("超级管理员".equals(role.getRoleName())) {
            Set<String> allPerms = new HashSet<>();
            allPerms.add("*");
            return allPerms;
        }

        // 解析 permission_json
        try {
            if (role.getPermissionJson() != null && !role.getPermissionJson().isEmpty()) {
                List<String> perms = JSON.parseArray(role.getPermissionJson(), String.class);
                return new HashSet<>(perms);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new HashSet<>();
    }
}
