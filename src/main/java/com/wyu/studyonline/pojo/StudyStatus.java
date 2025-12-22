package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 学习动态表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudyStatus {
    /**
     * id
     */
    private int id;
    /**
     * 用户id
     */
    private int userId;
    /**
     * 用户名
     */
    private String userName;
    /**
     * 用户头像地址
     */
    private String userAvatar;
    /**
     * 动态内容
     */
    private String content;
    /**
     * 第一张图片
     */
    private String firstPhoto;
    /**
     * 第二张图片
     */
    private String secondPhoto;
    /**
     * 第三张图片
     */
    private String thirdPhoto;
    /**
     *转发次数
     */
    private int transmitCount = 0;
    /**
     *评论条数
     */
    private int commentCount = 0;
    /**
     *点赞次数
     */
    private int likeCount = 0;
    /**
     * 是否点赞
     */
    private boolean isLike = false;
    /**
     * 创建时间
     */
    private Date createTime = new Date();

}
