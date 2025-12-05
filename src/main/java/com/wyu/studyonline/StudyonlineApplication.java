package com.wyu.studyonline;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.wyu.studyonline.mapper")
@EnableScheduling//启用定时任务功能
public class StudyonlineApplication {

    public static void main(String[] args) {
        SpringApplication.run(StudyonlineApplication.class, args);

    }

}
