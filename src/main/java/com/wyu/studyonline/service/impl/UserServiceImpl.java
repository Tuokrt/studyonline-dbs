package com.wyu.studyonline.service.impl;

import com.wyu.studyonline.mapper.UserMapper;
import com.wyu.studyonline.pojo.*;
import com.wyu.studyonline.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import com.wyu.studyonline.config.RedisConfig;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.util.List;

@CacheConfig(cacheNames = "user")
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserMapper userMapper;

    @Autowired
    ValueOperations valueOperations;


    @Override
    public int insertUser(User user) {
        return userMapper.insertUser(user);
    }

    @Override
    @Cacheable(key = "#cellPhone", condition = "#result != null")
    public User selectUserByCellPhone(String cellPhone) {
        return userMapper.selectUserByCellPhone(cellPhone);
    }

    @Override
    public int insertStudyPlan(int userId, String content) {
        return userMapper.insertStudyPlan(userId,content);
    }

    @Override
    public List<StudyPlan> selectAllStudyPlanByUserId(String page, String limit, int userId) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return userMapper.selectAllStudyPlanByUserId(begin,limit,userId);
    }

    @Override
    public int selectAllStudyPlanByUserIdCount(int userId) {
        return userMapper.selectAllStudyPlanByUserIdCount(userId);
    }

    @Override
    public int updateStudyPlanContent(int id, String updateContent) {
        return userMapper.updateStudyPlanContent(id,updateContent);
    }

    @Override
    public int deleteStudyPlanContent(int id) {
        return userMapper.deleteStudyPlanContent(id);
    }

    @Override
    public int insertExamTime(String examName, String examTime, int userId) {
        return userMapper.insertExamTime(examName,examTime,userId);
    }

    @Override
    public List<ExamTime> selectAllExamTimeByUserId(String page, String limit, int userId) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return userMapper.selectAllExamTimeByUserId(begin,limit,userId);
    }

    @Override
    public int selectAllExamTimeByUserIdCount(int userId) {
        return userMapper.selectAllExamTimeByUserIdCount(userId);
    }

    @Override
    public int updateExamTimeById(int id, String examName, String examTime) {
        return userMapper.updateExamTimeById(id,examName,examTime);
    }

    @Override
    public int deleteExamTimeById(int id) {
        return userMapper.deleteExamTimeById(id);
    }

    @Override
    @Cacheable(key = "'EverydayStatus:' + #userId", unless = "#result == null")
    public EverydayStatus selectEverydayStatusById(int userId) {
        return userMapper.selectEverydayStatusById(userId);
    }

    @Override
    public int insertEverydayStatusById(int userId) {
        return userMapper.insertEverydayStatusById(userId);
    }

    @Override
    @CacheEvict(key = "'EverydayStatus:' + #userId")
    public int updateEverydayStatus(int userId) {
        return userMapper.updateEverydayStatus(userId);
    }

    @Override
    @CacheEvict(key = "'EverydayStatus:' + #userId")
    public int resetEverydayStatus() {
        return userMapper.resetEverydayStatus();
    }

    @Override
    public int updateUserAvatarById(String imgPath, int userId) {
        return userMapper.updateUserAvatarById(imgPath,userId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int updateUserById(int userId, String userName, int gender) {
        return userMapper.updateUserById(userId,userName,gender);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int updateUserPasswordById(String userPassword, int userId) {
        return userMapper.updateUserPasswordById(userPassword, userId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int updateCellPhoneById(String cellPhone, int userId) {
        return userMapper.updateCellPhoneById(cellPhone, userId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int updateUserExpById(int addExp, int userId) {
        return userMapper.updateUserExpById(addExp, userId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int updateUserRankById(int userId) {
        return userMapper.updateUserRankById(userId);
    }

    @Override
    @Cacheable(key = "'userRank:' + #userId")
    public int selectRankByUserId(int userId) {
        return userMapper.selectRankByUserId(userId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int subBanDay() {
        return userMapper.subBanDay();
    }

    @Override
    public List<StudyPlan> selectUnfinishedStudyPlan(int userId) {
        return userMapper.selectUnfinishedStudyPlan(userId);
    }

    @Override
    public List<ExamTime> selectLateExamTime(int userId) {
        return userMapper.selectLateExamTime(userId);
    }

    @Override
    @Cacheable(cacheNames = "adminNotice", key = "'newNotice'")
    public Notice selectNewNotice() {
        return userMapper.selectNewNotice();
    }

    @Override
    @Cacheable(key = "'StudyTimeList'")
    public List<User> selectStudyTimeList() {
        return userMapper.selectStudyTimeList();
    }

    @Override
    public int updateStudyPlanStatus(int id) {
        return userMapper.updateStudyPlanStatus(id);
    }

    // ========== 学习行为分析功能实现 ==========

    @Override
    public List<java.util.Map<String, Object>> selectUserLearningActivities(int userId) {
        return userMapper.selectUserLearningActivities(userId);
    }

    @Override
    public List<User> selectUsersParticipateAllActivities() {
        return userMapper.selectUsersParticipateAllActivities();
    }

    @Override
    public java.util.Map<String, Object> selectUserActivityStats(int userId) {
        return userMapper.selectUserActivityStats(userId);
    }
}
