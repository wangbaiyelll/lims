package com.example.library.service.impl;

import com.example.library.entity.AdminLog;
import com.example.library.mapper.AdminLogMapper;
import com.example.library.service.AdminLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminLogServiceImpl implements AdminLogService {

    @Autowired
    private AdminLogMapper adminLogMapper;

    @Override
    public void logOperation(Integer adminId, String adminName, String operation,
                             String targetType, Integer targetId, String targetName) {
        try {
            AdminLog log = new AdminLog();
            log.setAdminId(adminId);
            log.setAdminName(adminName);
            log.setOperation(operation);
            log.setTargetType(targetType);
            log.setTargetId(targetId);
            log.setTargetName(targetName);

            adminLogMapper.insert(log);

            System.out.println("📝 [操作日志] 记录成功 - 管理员：" + adminName +
                    ", 操作：" + operation +
                    ", 目标：" + targetType + "-" + targetId);
        } catch (Exception e) {
            System.err.println("❌ [操作日志] 记录失败：" + e.getMessage());
            // 日志记录失败不影响主业务流程
        }
    }

    @Override
    public List<AdminLog> getByAdminId(Integer adminId, Integer page, Integer limit) {
        return adminLogMapper.selectByAdminId(adminId);
    }

    @Override
    public List<AdminLog> getByTarget(String targetType, Integer targetId) {
        return adminLogMapper.selectByTarget(targetType, targetId);
    }

    @Override
    public List<AdminLog> getAllLogs(Integer page, Integer limit) {
        // 查询所有日志
        return adminLogMapper.selectAll();
    }

    @Override
    public int getTotalCount() {
        // TODO: 需要在 Mapper 中添加 count 方法
        return 0;
    }
}
