package com.wyu.studyonline.mapper;

import com.wyu.studyonline.pojo.Category;
import com.wyu.studyonline.pojo.StudyRoom;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudyRoomMapper {
    //根据用户id增加学习时间
    public int addStudyTimeByid(@Param("addStudyTime") int addStudyTime, @Param("userId") int userId);

    //根据用户id查找用户创建的自习室
    public StudyRoom selectStudyRoomByUserId(@Param("userId") int userId);

    //查询所有自习室分类
    public List<Category> selectAllCategory();

    //创建自习室
    public int insertStudyRoom(StudyRoom studyRoom);

    //根据用户id更新自习室信息
    public int updateStudyRoomByUserId(StudyRoom studyRoom);

    //查找所有开启的自习室
    public List<StudyRoom> selectAllOpenStudyRoom();

    //根据用户id设置自习室状态为关闭
    public int closeStudyRoomByUserId(@Param("userId") int userId);

    //根据自习室id查找自习室信息
    public StudyRoom selectStudyRoomByRoomId(@Param("roomId") int roomId);


}
