package com.wyu.studyonline.config;

import com.wyu.studyonline.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;

@Component
public class ResetEverydayStatusTask implements Runnable{

    @Autowired
    UserService userService;
    @Autowired
    RedisTemplate redisTemplate;

    public static final DefaultRedisScript luaScript;
    static {
        luaScript = new DefaultRedisScript();
        luaScript.setLocation(new ClassPathResource("config/studyStatusHeatAttenuation.lua")); // 指定脚本文件路径
        luaScript.setResultType(Long.class); // 指定脚本返回值类型
    }

    @Override
    @Scheduled(cron = "0 0 0 * * ?") // 每天0点触发
    public void run() {
        System.out.println("Resetting everyday status...");
        //重置每天打卡
        userService.resetEverydayStatus();
        //封禁天数减1
        userService.subBanDay();
        //学习动态的热度衰减，若热度低于20则删除该key
        String key = "studyStatusRank";
        List<String> keys = Collections.singletonList(key);
        List<String> args = Collections.emptyList();
        String scriptSha = redisTemplate.execute(luaScript, keys, args).toString();

        System.out.println("Resetting everyday status completed.");
    }
}
