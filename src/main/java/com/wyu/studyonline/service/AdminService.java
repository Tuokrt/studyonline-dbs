package com.wyu.studyonline.service;

import com.wyu.studyonline.pojo.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AdminService {

    //根据手机号查找管理员
    public Admin selectAdminByCellPhone(String cellPhone);

    //根据性别查找用户的个数
    public int selectUserCountByGender(int gender);

    //根据自习室状态查找自习室的个数
    public int selectStudyRoomByStatus(int status);

    //增加一条公告
    public int addNotice(Notice notice);

    //根据状态查找的自习室
    public List<StudyRoom> selectAuditStudyRoom(String page, String limit, int status);

    //根据状态查找自习室个数
    public int selectStudyRoomCount(int status);

    //根据id设置自习室审核状态
    public int setStudyRoomById(int id, int auditStatus);

    //查找所有举报
    public List<Report> selectAllReport(String page, String limit);

    //查找举报条数
    public int selectAllReportCount();

    //成功处理举报
    public int ideaReportById(int id);

    //查找最近用户
    public List<User> selectLatelyUser(String page, String limit, int latelyDay);

    //查找最近用户条数
    public int selectLatelyUserCount(int latelyDay);

    //根据id查找用户信息
    public List<User> selectUserById(String page, String limit, int id);

    //根据天数与id封禁用户
    public int banUserByDay(int id, int banDay);

    //根据id解除封禁
    public int notBanUserById(int id);

    //根据id查找自习室
    public List<StudyRoom> selectStudyRoomById(String page, String limit, int id);

    //根据id封禁自习室
    public int banStudyRoomById(int id);

    //根据id解封自习室
    public int notBanStudyRoomById(int id);

    //根据id查找动态
    public List<StudyStatus> selectStudyStatusById(String page, String limit, int id);

    //根据id查找评论
    public List<Comment> selectCommentById(String page, String limit, int id);
}
