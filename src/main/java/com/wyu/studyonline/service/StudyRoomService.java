package com.wyu.studyonline.service;


import com.wyu.studyonline.pojo.Category;
import com.wyu.studyonline.pojo.StudyRoom;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StudyRoomService {
    //根据用户id增加学习时间
    public int addStudyTimeByid(int addStudyTime, int userId);

    //根据用户id查找用户创建的自习室
    public StudyRoom selectStudyRoomByUserId(int userId);

    //查询所有自习室分类
    public List<Category> selectAllCategory();

    //创建自习室
    public int insertStudyRoom(StudyRoom studyRoom);

    //根据用户id更新自习室信息
    public int updateStudyRoomByUserId(StudyRoom studyRoom);

    //查找所有开启的自习室
    public List<StudyRoom> selectAllOpenStudyRoom();

    //根据用户id设置自习室状态为关闭
    public int closeStudyRoomByUserId(int userId);

    //根据自习室id查找自习室信息
    public StudyRoom selectStudyRoomByRoomId( int roomId);
}
