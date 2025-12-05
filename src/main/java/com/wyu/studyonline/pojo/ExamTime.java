package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 备考日历表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamTime {
    /**
     * id
     */
    private int id;
    /**
     * 用户id
     */
    private int userId;
    /**
     * 考试内容
     */
    private String examName;
    /**
     * 考试时间
     */
    private Date examTime;
    /**
     * 创建时间
     */
    private Date createTime;
}
