package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 自习室表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudyRoom {
    /**
     * id
     */
    private int id;
    /**
     * 分类id
     */
    private int categoryId;
    /**
     * 用户id
     */
    private int userId;
    /**
     * 自习室名称
     */
    private String roomName;
    /**
     * 自习室描述
     */
    private String roomDescride;
    /**
     * 自习室封面图片
     */
    private String roomCover;
    /**
     * 身份证号码
     */
    private String userCard;
    /**
     * 审核状态（0未审核 1审核通过 2审核不通过）
     */
    private int auditStatus;
    /**
     * 开启状态（0关闭 1开启）
     */
    private int openStatus;
    /**
     * 创建时间
     */
    private Date createTime;
}
