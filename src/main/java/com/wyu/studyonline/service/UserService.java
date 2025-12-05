package com.wyu.studyonline.service;

import com.wyu.studyonline.pojo.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserService {
    //用户注册
    public int insertUser(User user);

    //根据手机号查找用户
    public User selectUserByCellPhone(String cellPhone);

    //添加待办事件
    public int insertStudyPlan(int userId, String content);

    //查找所有待办事件
    public List<StudyPlan> selectAllStudyPlanByUserId(String page, String limit, int userId);

    //根据用户id查找所有学习待办总记录数
    public int selectAllStudyPlanByUserIdCount(int userId);

    //根据学习待办id修改content
    public int updateStudyPlanContent(int id,String updateContent);

    //根据学习待办id删除对应记录
    public int deleteStudyPlanContent(int id);

    //添加备考日历
    public int insertExamTime(String examName, String examTime, int userId);

    //查找所有学习时间
    public List<ExamTime> selectAllExamTimeByUserId(String page, String limit, int userId);

    //根据用户id查找所有学习时间总记录数
    public int selectAllExamTimeByUserIdCount(int userId);

    //根据考试计划的id更新考试信息
    public int updateExamTimeById(int id, String examName, String examTime);

    //根据考试考试计划的id删除考试信息
    public int deleteExamTimeById(int id);

    //根据用户id查找对应的打卡信息
    public EverydayStatus selectEverydayStatusById(int userId);

    //插入用户id插入打卡信息
    public int insertEverydayStatusById(int userId);

    //根据用户id更新打卡信息
    public int updateEverydayStatus(int userId);

    //每天0点将已打卡用户的打卡状态置0
    public int resetEverydayStatus();

    //根据用户id更新图片地址
    public int updateUserAvatarById(String imgPath,int userId);

    //根据用户id更新用户信息
    public int updateUserById(int userId, String userName, int gender);

    //根据用户id修改密码
    public int updateUserPasswordById(String userPassword, int userId);

    //根据用户id修改手机号
    public int updateCellPhoneById(String cellPhone, int userId);

    //根据用户id增加经验值
    public int updateUserExpById(int addExp,int userId);

    //根据用户id提高用户一个等级
    public int updateUserRankById(int userId);

    //根据用户id查找其等级
    public int selectRankByUserId(int userId);

    //每天0点将封禁天数减1
    public int subBanDay();

    //查找没完成的待办
    public List<StudyPlan> selectUnfinishedStudyPlan(int userId);

    //查找当前时间之后的考试
    public List<ExamTime> selectLateExamTime(int userId);

    //查找最新公告
    public Notice selectNewNotice();

    //查找学习排行榜
    public List<User> selectStudyTimeList();

    //根据id更改待办状态
    public int updateStudyPlanStatus(int id);
}
