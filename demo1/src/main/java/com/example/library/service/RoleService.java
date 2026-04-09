package com.example.library.service;

import com.example.library.entity.Role;
import java.util.List;
import java.util.Set;

public interface RoleService {

    Role getById(Integer id);

    List<Role> getAll();

    boolean add(Role role);

    boolean update(Role role);

    boolean delete(Integer id);

    /**
     * 检查是否有某个权限
     */
    boolean hasPermission(Integer roleId, String permission);

    /**
     * 获取所有权限码
     */
    Set<String> getPermissions(Integer roleId);
}
