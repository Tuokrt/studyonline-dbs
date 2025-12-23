package com.wyu.studyonline.mapper;

import com.wyu.studyonline.pojo.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface UserMapper {
    //添加用户
    public int insertUser(User user);

    //查询用户是否存在
    public User selectUserByCellPhone(@Param("cellPhone") String cellPhone);

    //添加学习待办
    public int insertStudyPlan(@Param("userId") int userId, @Param("content") String content);

    //根据用户id查找所有学习待办
    public List<StudyPlan> selectAllStudyPlanByUserId(@Param("begin") String begin, @Param("limit") String limit, @Param("userId") int userId);

    //根据用户id查找所有学习待办总记录数
    public int selectAllStudyPlanByUserIdCount(@Param("userId") int userId);

    //根据学习待办id修改content
    public int updateStudyPlanContent(@Param("id") int id, @Param("updateContent") String updateContent);

    //根据学习待办id删除对应记录
    public int deleteStudyPlanContent(@Param("id") int id);

    //添加备考日历
    public int insertExamTime(@Param("examName") String examName, @Param("examTime") String examTime, @Param("userId") int userId);

    //根据用户id查找所有考试时间
    public List<ExamTime> selectAllExamTimeByUserId(@Param("begin") String begin, @Param("limit") String limit, @Param("userId") int userId);

    //根据用户id查找所有考试时间总记录数
    public int selectAllExamTimeByUserIdCount(@Param("userId") int userId);

    //根据考试计划的id更新考试信息
    public int updateExamTimeById(@Param("id") int id, @Param("examName") String examName, @Param("examTime") String examTime);

    //根据考试考试计划的id删除考试信息
    public int deleteExamTimeById(@Param("id") int id);

    //根据用户id查找对应的打卡信息
    public EverydayStatus selectEverydayStatusById(@Param("userId") int userId);

    //根据用户id插入打卡信息
    public int insertEverydayStatusById(@Param("userId") int userId);

    //根据用户id更新打卡信息
    public int updateEverydayStatus(@Param("userId") int userId);

    //每天0点将已打卡用户的打卡状态置0
    public int resetEverydayStatus();

    //根据用户id更新图片地址
    public int updateUserAvatarById(@Param("imgPath") String imgPath,@Param("userId") int userId);

    //根据用户id更新用户信息
    public int updateUserById(@Param("userId") int userId, @Param("userName") String userName, @Param("gender") int gender);

    //根据用户id修改密码
    public int updateUserPasswordById(@Param("userPassword") String userPassword, @Param("userId") int userId);

    //根据用户id修改手机号
    public int updateCellPhoneById(@Param("cellPhone") String cellPhone,@Param("userId") int userId);

    //根据用户id增加经验值
    public int updateUserExpById(@Param("addExp") int addExp,@Param("userId") int userId);

    //根据用户id提高用户一个等级
    public int updateUserRankById(@Param("userId") int userId);

    //根据用户id查找其等级
    public int selectRankByUserId(@Param("userId") int userId);

    //每天0点将封禁天数减1
    public int subBanDay();

    //查找没完成的待办
    public List<StudyPlan> selectUnfinishedStudyPlan(@Param("userId") int userId);

    //查找当前时间之后的考试
    public List<ExamTime> selectLateExamTime(@Param("userId") int userId);

    //查找最新公告
    public Notice selectNewNotice();

    //查找学习排行榜
    public List<User> selectStudyTimeList();

    //根据id更改待办状态
    public int updateStudyPlanStatus(@Param("id") int id);

    // ========== 学习行为分析功能 ==========

    // 集合操作：获取用户学习活动数据（UNION）
    public List<java.util.Map<String, Object>> selectUserLearningActivities(@Param("userId") int userId);

    // 除法查询：查找参与了所有三种学习活动的用户
    public List<User> selectUsersParticipateAllActivities();

    // 统计用户参与的学习活动类型数量
    public java.util.Map<String, Object> selectUserActivityStats(@Param("userId") int userId);
}
