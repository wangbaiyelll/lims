package com.example.library.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {

    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");

    public static String formatDateTime(Date date) {
        if (date == null) return "";
        return sdf.format(date);
    }

    public static String formatDate(Date date) {
        if (date == null) return "";
        return sdfDate.format(date);
    }

    public static Date getCurrentDate() {
        return new Date();
    }

    public static int daysBetween(Date start, Date end) {
        long diff = end.getTime() - start.getTime();
        return (int) (diff / (1000 * 60 * 60 * 24));
    }
}