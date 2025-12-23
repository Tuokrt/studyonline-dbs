package com.wyu.studyonline.service.impl;

import com.wyu.studyonline.mapper.UserProfileMapper;
import com.wyu.studyonline.pojo.UserProfile;
import com.wyu.studyonline.service.UserProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class UserProfileServiceImpl implements UserProfileService {

    @Autowired
    private UserProfileMapper userProfileMapper;

    @Override
    public UserProfile getUserProfileByUserId(int userId) {
        UserProfile userProfile = userProfileMapper.selectUserProfileByUserId(userId);
        // 如果用户扩展信息不存在，返回一个默认对象
        if (userProfile == null) {
            userProfile = new UserProfile();
            userProfile.setUserId(userId);
        }
        return userProfile;
    }

    @Override
    public int saveOrUpdateUserProfile(UserProfile userProfile) {
        // 设置更新时间
        userProfile.setUpdateTime(new Date());
        
        // 检查是否已存在
        UserProfile existingProfile = userProfileMapper.selectUserProfileByUserId(userProfile.getUserId());
        
        if (existingProfile == null) {
            // 不存在，执行插入
            return userProfileMapper.addUserProfile(userProfile);
        } else {
            // 已存在，执行更新
            userProfile.setId(existingProfile.getId());
            return userProfileMapper.updateUserProfile(userProfile);
        }
    }

    @Override
    public int deleteUserProfile(int userId) {
        return userProfileMapper.deleteUserProfile(userId);
    }
}