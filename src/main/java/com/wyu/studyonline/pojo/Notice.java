package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 公告表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Notice {
    /**
     * id
     */
    private int id;
    /**
     * 管理员id
     */
    private int adminId;
    /**
     * 公告标题
     */
    private String title;
    /**
     * 公告内容
     */
    private String content;
    /**
     * 创建时间
     */
    private String createTime;
}
