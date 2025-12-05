package com.wyu.studyonline.pojo;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * websocket用的json数据格式
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WebSocketMsg {
    private String type;
    private int userId;
    private String name;
    private String content;

}
