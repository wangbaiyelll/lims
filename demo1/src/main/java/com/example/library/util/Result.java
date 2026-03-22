package com.example.library.util;

import java.util.HashMap;

public class Result extends HashMap<String, Object> {

    private static final long serialVersionUID = 1L;

    public Result() {
        put("code", 0);
        put("msg", "success");
    }

    public static Result success() {
        return new Result();
    }

    public static Result success(String msg) {
        Result result = new Result();
        result.put("msg", msg);
        return result;
    }

    public static Result error(String msg) {
        Result result = new Result();
        result.put("code", 500);
        result.put("msg", msg);
        return result;
    }

    public Result put(String key, Object value) {
        super.put(key, value);
        return this;
    }

    public int getCode() {
        return (int) get("code");
    }
}