package com.example.library.mapper;

import com.example.library.entity.OverdueReminder;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface OverdueReminderMapper {

    OverdueReminder selectByBorrowId(@Param("borrowId") Long borrowId);

    List<OverdueReminder> selectUnsent();

    int insert(OverdueReminder reminder);

    int updateSendStatus(@Param("id") Long id, @Param("sendStatus") Integer sendStatus);
}