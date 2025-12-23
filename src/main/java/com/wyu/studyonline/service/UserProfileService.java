package com.wyu.studyonline.service;

import com.wyu.studyonline.pojo.UserProfile;

public interface UserProfileService {
    
    // 根据用户ID获取用户扩展信息
    UserProfile getUserProfileByUserId(int userId);
    
    // 保存或更新用户扩展信息
    int saveOrUpdateUserProfile(UserProfile userProfile);
    
    // 删除用户扩展信息
    int deleteUserProfile(int userId);
}