package com.wyu.studyonline.service.impl;

import com.wyu.studyonline.mapper.StudyRoomMapper;
import com.wyu.studyonline.pojo.Category;
import com.wyu.studyonline.pojo.StudyRoom;
import com.wyu.studyonline.service.StudyRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@CacheConfig(cacheNames = "studyRoom")
public class StudyRoomServiceImpl implements StudyRoomService {
    @Autowired
    StudyRoomMapper studyRoomMapper;

    @Override
    public int addStudyTimeByid(int addStudyTime, int userId) {
        return studyRoomMapper.addStudyTimeByid(addStudyTime, userId);
    }

    @Override
    @Cacheable(key = "'selectStudyRoomByUserId:' + #userId")
    public StudyRoom selectStudyRoomByUserId(int userId) {
        return studyRoomMapper.selectStudyRoomByUserId(userId);
    }

    @Override
    @Cacheable(cacheNames = "category", key = "'selectAllCategory'")
    public List<Category> selectAllCategory() {
        return studyRoomMapper.selectAllCategory();
    }

    @Override
    public int insertStudyRoom(StudyRoom studyRoom) {
        return studyRoomMapper.insertStudyRoom(studyRoom);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int updateStudyRoomByUserId(StudyRoom studyRoom) {
        return studyRoomMapper.updateStudyRoomByUserId(studyRoom);
    }

    @Override
    @Cacheable(key = "'selectAllOpenStudyRoom'")
    public List<StudyRoom> selectAllOpenStudyRoom() {
        return studyRoomMapper.selectAllOpenStudyRoom();
    }

    @Override
    @CacheEvict(key = "'selectAllOpenStudyRoom'")
    public int closeStudyRoomByUserId(int userId) {
        return studyRoomMapper.closeStudyRoomByUserId(userId);
    }

    @Override
    @Cacheable(key = "'selectStudyRoomByRoomId:' + #roomId")
    public StudyRoom selectStudyRoomByRoomId(int roomId) {
        return studyRoomMapper.selectStudyRoomByRoomId(roomId);
    }
}
