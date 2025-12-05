package com.wyu.studyonline.service.impl;

import com.wyu.studyonline.mapper.AdminMapper;
import com.wyu.studyonline.pojo.*;
import com.wyu.studyonline.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@CacheConfig(cacheNames = "admin")
public class AdminServiceImpl implements AdminService {
    @Autowired
    AdminMapper adminMapper;

    @Override
    @Cacheable(key = "#cellPhone", condition = "#result != null")
    public Admin selectAdminByCellPhone(String cellPhone) {
        return adminMapper.selectAdminByCellPhone(cellPhone);
    }

    @Override
    @Cacheable(key = "'selectUserCountByGender:' + #gender")
    public int selectUserCountByGender(int gender) {
        return adminMapper.selectUserCountByGender(gender);
    }

    @Override
    @Cacheable(key = "'selectStudyRoomByStatus:' + #status")
    public int selectStudyRoomByStatus(int status) {
        return adminMapper.selectStudyRoomByStatus(status);
    }

    @Override
    public int addNotice(Notice notice) {
        return adminMapper.addNotice(notice);
    }

    @Override
    @Cacheable(cacheNames = "studyRoom", key = "'selectAuditStudyRoom:' + #status + 'page:' + #page")
    public List<StudyRoom> selectAuditStudyRoom(String page, String limit, int status) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectAuditStudyRoom(begin,limit,status);
    }

    @Override
    @Cacheable(cacheNames = "studyRoom", key = "'selectStudyRoomCount:' + #status")
    public int selectStudyRoomCount(int status) {
        return adminMapper.selectStudyRoomCount(status);
    }

    @Override
    @CacheEvict(cacheNames = "studyRoom", allEntries = true)
    public int setStudyRoomById(int id, int auditStatus) {
        return adminMapper.setStudyRoomById(id,auditStatus);
    }

    @Override
    @Cacheable(cacheNames = "report", key = "'selectAllReport:' + #page")
    public List<Report> selectAllReport(String page, String limit) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectAllReport(begin,limit);
    }

    @Override
    @Cacheable(cacheNames = "report", key = "'selectAllReportCount'")
    public int selectAllReportCount() {
        return adminMapper.selectAllReportCount();
    }

    @Override
    @CacheEvict(cacheNames = "report", allEntries = true)
    public int ideaReportById(int id) {
        return adminMapper.ideaReportById(id);
    }

    @Override
    @Cacheable(key = "'selectLatelyUser:' + #page + 'latelyDay:' + #latelyDay")
    public List<User> selectLatelyUser(String page, String limit, int latelyDay) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectLatelyUser(begin, limit, latelyDay);
    }

    @Override
    @Cacheable(key = "'selectLatelyUserCount:' + 'latelyDay:' + #latelyDay")
    public int selectLatelyUserCount(int latelyDay) {
        return adminMapper.selectLatelyUserCount(latelyDay);
    }

    @Override
    @Cacheable(cacheNames = "user", key = "'selectUserById:' + #id")
    public List<User> selectUserById(String page, String limit, int id) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectUserById(begin,limit,id);
    }

    @Override
    @CacheEvict(cacheNames = "user", allEntries = true)
    public int banUserByDay(int id, int banDay) {
        return adminMapper.banUserByDay(id, banDay);
    }

    @Override
    @CacheEvict(cacheNames = "user", allEntries = true)
    public int notBanUserById(int id) {
        return adminMapper.notBanUserById(id);
    }

    @Override
    @Cacheable(cacheNames = "studyRoom", key = "'selectStudyRoomById:' + #id")
    public List<StudyRoom> selectStudyRoomById(String page, String limit, int id) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectStudyRoomById(begin,limit,id);
    }

    @Override
    @CacheEvict(cacheNames = "studyRoom", allEntries = true)
    public int banStudyRoomById(int id) {
        return adminMapper.banStudyRoomById(id);
    }

    @Override
    @CacheEvict(cacheNames = "studyRoom", allEntries = true)
    public int notBanStudyRoomById(int id) {
        return adminMapper.notBanStudyRoomById(id);
    }

    @Override
    @Cacheable(cacheNames = "studyStatus", key = "'selectStudyStatusById:' + #id")
    public List<StudyStatus> selectStudyStatusById(String page, String limit, int id) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectStudyStatusById(begin,limit,id);
    }

    @Override
    @Cacheable(cacheNames = "comment", key = "'selectCommentById:' + #id")
    public List<Comment> selectCommentById(String page, String limit, int id) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return adminMapper.selectCommentById(begin,limit,id);
    }


}
