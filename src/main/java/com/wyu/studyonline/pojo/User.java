package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 用户表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    /**
     * id
     */
    private int id;
    /**
     * 用户昵称
     */
    private String userName;
    /**
     * 手机号
     */
    private String cellPhone;
    /**
     * 密码
     */
    private String userPassword;
    /**
     * 用户头像
     */
    private String userAvatar;
    /**
     * 性别（0保密 1男 2女）
     */
    private int gender;
    /**
     * 用户经验
     */
    private Long exp;
    /**
     * 用户等级
     */
    private int rank;
    /**
     * 学习时间（秒）
     */
    private Long studyTime;
    /**
     * 用户状态（0正常 1封禁中）
     */
    private int status;
    /**
     * 封禁天数
     */
    private int banDay;
    /**
     * 创建时间
     */
    private Date createTime;
}
