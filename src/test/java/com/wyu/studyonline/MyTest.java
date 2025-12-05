package com.wyu.studyonline;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.wyu.studyonline.service.impl.StudyStatusServiceImpl;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Set;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = StudyonlineApplication.class,webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class MyTest {
    @Autowired
    StudyStatusServiceImpl studyStatusService;

    @Autowired
    RedisTemplate redisTemplate;
    @Test
    public void testMyMethod(){

        studyStatusService.addTransmitCount(1);
    }

    @Test
    public void testStudyStatusRank(){
        String key = "studyStatusRank";
        Set<ZSetOperations.TypedTuple<String>> set = redisTemplate.opsForZSet().reverseRangeWithScores(key, 0, -1);
        JSONArray jsonArray = JSONObject.parseArray(JSONObject.toJSONString(set));
        for(int i = 0, size = jsonArray.size(); i < size; i++) {
            JSONObject o = JSONObject.parseObject(jsonArray.get(i).toString());
            System.out.println("动态id：" + o.getString("value") + ", 热度值：" + o.getLongValue("score"));
        }
    }
}
