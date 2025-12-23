package com.wyu.studyonline.mapper;

import com.wyu.studyonline.pojo.UserProfile;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserProfileMapper {
    
    // 根据用户ID查找用户扩展信息
    UserProfile selectUserProfileByUserId(@Param("userId") int userId);
    
    // 添加用户扩展信息
    int addUserProfile(UserProfile userProfile);
    
    // 更新用户扩展信息
    int updateUserProfile(UserProfile userProfile);
    
    // 删除用户扩展信息
    int deleteUserProfile(@Param("userId") int userId);
}