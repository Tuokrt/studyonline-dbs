package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 学习待办表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudyPlan {
    /**
     * id
     */
    private int id;
    /**
     * 用户id
     */
    private int userId;
    /**
     * 待办内容
     */
    private String content;
    /**
     * 审核状态（0未完成 1已完成）
     */
    private int status = 0;
    /**
     * 创建时间
     */
    private Date createTime = new Date();
}
