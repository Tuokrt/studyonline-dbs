package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 管理员表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Admin {
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
     * 创建时间
     */
    private Date createTime;
}
