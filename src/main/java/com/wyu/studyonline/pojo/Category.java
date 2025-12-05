package com.wyu.studyonline.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 分类表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Category {
    /**
     * id
     */
    private int id;
    /**
     * 分类名称
     */
    private String name;
}
