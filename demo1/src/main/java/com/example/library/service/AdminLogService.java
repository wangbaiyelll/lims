package com.example.library.service;

import com.example.library.entity.AdminLog;
import java.util.List;

public interface AdminLogService {

    /**
     * 记录操作日志
     */
    void logOperation(Integer adminId, String adminName, String operation,
                      String targetType, Integer targetId, String targetName);

    /**
     * 查询管理员的操作日志
     */
    List<AdminLog> getByAdminId(Integer adminId, Integer page, Integer limit);

    /**
     * 查询目标对象的操作日志
     */
    List<AdminLog> getByTarget(String targetType, Integer targetId);

    /**
     * 查询所有日志（分页）
     */
    List<AdminLog> getAllLogs(Integer page, Integer limit);

    /**
     * 查询总数
     */
    int getTotalCount();
}
