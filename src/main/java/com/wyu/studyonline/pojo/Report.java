package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 举报表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Report {
    /**
     * id
     */
    private int id;
    /**
     * 用户id
     */
    private int userId;
    /**
     * 举报类型（1举报自习室，2举报动态，3举报评论）
     */
    private int reportType;
    /**
     * 被举报的自习室/动态/评论的id
     */
    private int beReportedId;
    /**
     * 举报内容
     */
    private String reportContent;
    /**
     * 图片
     */
    private String photo;
    /**
     * 处理状态（0未处理 1已处理）
     */
    private int status;
    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 更新时间
     */
    private Date updateTime;
}
