package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Comment {
    /**
     * id
     */
    private int id;
    /**
     * 用户id
     */
    private int userId;
    /**
     * 动态id
     */
    private int studyStatusId;
    /**
     * 评论内容
     */
    private String commentContent;
    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 用户名
     */
    private String userName;
    /**
     * 用户头像
     */
    private String userAvatar;
}
