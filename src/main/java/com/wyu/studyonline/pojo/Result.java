package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 自定义的统一返回结果类
 * @param <T>
 */
@Data
public class Result<T> {
    private int code;       // 状态码
    private String message; // 提示信息
    private int count;//数据的条数
    private T data;         // 返回数据

    public Result() {}

    public Result(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public Result(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public Result(int code, String message, int count, T data) {
        this.code = code;
        this.message = message;
        this.count = count;
        this.data = data;
    }

    // getter and setter methods

    // toString method

    public static <T> Result<T> success() {
        return new Result<>(200, "OK");
    }

    public static <T> Result<T> success(T data) {
        return new Result<>(200, "OK", data);
    }

    public static <T> Result<T> success(int count, T data) {
        return new Result<>(200, "OK", count, data);
    }

    public static <T> Result<T> failure(int code, String message) {
        return new Result<>(code, message);
    }

    public static <T> Result<T> failure(String message) {
        return new Result<>(500, message);
    }
}