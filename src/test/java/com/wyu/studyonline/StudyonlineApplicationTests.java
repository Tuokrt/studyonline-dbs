package com.wyu.studyonline;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.wyu.studyonline.config.ResetEverydayStatusTask;
import com.wyu.studyonline.controller.StudyStatusController;
import com.wyu.studyonline.service.StudyStatusService;
import com.wyu.studyonline.service.impl.StudyStatusServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = StudyonlineApplication.class,webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class StudyonlineApplicationTests {

    @Test
    void contextLoads() {
        studyStatusService.addTransmitCount(1);
    }

    @Autowired
    StudyStatusService studyStatusService;
    @Test
    public void testMyMethod(){

        studyStatusService.addTransmitCount(1);
    }

    @Autowired
    StudyStatusController studyStatusController;

    @Autowired
    ZSetOperations zSetOperations;

    @Autowired
    RedisTemplate redisTemplate;

    @Test
    public void testStudyStatusRank(){
//        studyStatusController.studyStatusRank();
        String key = "studyStatusRank";
        Set<ZSetOperations.TypedTuple<String>> set = zSetOperations.reverseRangeWithScores(key, 0, -1);
        JSONArray jsonArray = JSONObject.parseArray(JSONObject.toJSONString(set));
        for(int i = 0, size = jsonArray.size(); i < size; i++) {
            JSONObject o = JSONObject.parseObject(jsonArray.get(i).toString());
            System.out.println("动态id：" + o.getString("value") + ", 热度值：" + o.getLongValue("score"));
        }
    }

    @Autowired
    ResetEverydayStatusTask resetEverydayStatusTask;

    @Test
    public void testResetEverydayStatusTask(){
        resetEverydayStatusTask.run();
    }



}
