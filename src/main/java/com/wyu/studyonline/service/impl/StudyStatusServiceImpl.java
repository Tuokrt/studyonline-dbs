package com.wyu.studyonline.service.impl;

import com.wyu.studyonline.mapper.StudyStatusMapper;
import com.wyu.studyonline.pojo.Comment;
import com.wyu.studyonline.pojo.Report;
import com.wyu.studyonline.pojo.StudyStatus;
import com.wyu.studyonline.service.StudyStatusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@CacheConfig(cacheNames = "studyStatus")
public class StudyStatusServiceImpl implements StudyStatusService {
    @Autowired
    StudyStatusMapper studyStatusMapper;

    @Override
    @CacheEvict(cacheNames = "studyStatus", allEntries = true)
    public int addStudyStatus(StudyStatus studyStatus) {
        return studyStatusMapper.addStudyStatus(studyStatus);
    }

    @Override
    @Cacheable(key = "'allStudyStatus' + #page")
    public List<StudyStatus> selectAllStudyStatus(String page, String limit) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return studyStatusMapper.selectAllStudyStatus(begin,limit);
    }

    @Override
    @Cacheable(key = "'studyStatusPages' + #limit")
    public int studyStatusPages(String limit) {
        return studyStatusMapper.studyStatusPages(limit);
    }

    @Override
    @CacheEvict(cacheNames = "studyStatus", allEntries = true)
    public int addStudyStatusLike(int studyStatusId) {
        return studyStatusMapper.addStudyStatusLike(studyStatusId);
    }

    @Override
    @CacheEvict(cacheNames = "studyStatus", allEntries = true)
    public int subStudyStatusLike(int studyStatusId) {
        return studyStatusMapper.subStudyStatusLike(studyStatusId);
    }

    @Override
    public int addLikeRecord(int userId, int studyStatusId) {
        return studyStatusMapper.addLikeRecord(userId, studyStatusId);
    }

    @Override
    public int deleteLikeRecord(int userId, int studyStatusId) {
        return studyStatusMapper.deleteLikeRecord(userId, studyStatusId);
    }

    @Override
    @Cacheable(key = "'allLikeRecord:' + #userId")
    public List<Integer> selectAllLikeRecordByUserId(int userId) {
        return studyStatusMapper.selectAllLikeRecordByUserId(userId);
    }

    @Override
    @Cacheable(key = "'studyStatusById:' + #studyStatusId")
    public StudyStatus selectStudyStatusById(int studyStatusId) {
        return studyStatusMapper.selectStudyStatusById(studyStatusId);
    }

    @Override
    @Cacheable(cacheNames = "comment", key = "'allCommentByStatusId:' + #studyStatusId + 'page:' + #page")
    public List<Comment> selectAllCommentByStatusId(String page, String limit, int studyStatusId) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return studyStatusMapper.selectAllCommentByStatusId(begin,limit,studyStatusId);
    }

    @Override
    @Cacheable(cacheNames = "comment", key = "'commentPagesByStatusId:' + #studyStatusId + 'limit:' + #limit")
    public int commentPagesByStatusId(String limit, int studyStatusId) {
        return studyStatusMapper.commentPagesByStatusId(limit,studyStatusId);
    }

//    @Override
//    public int addComment(int userId, int studyStatusId, String content) {
//        return studyStatusMapper.addComment(userId, studyStatusId, content);
//    }

    @Override
    @CacheEvict(cacheNames = "comment", allEntries = true)
    public int addComment(Comment comment) {
        return studyStatusMapper.addComment(comment);
    }

    @Override
    @CacheEvict(cacheNames = "studyStatus", allEntries = true)
    public int addCommentCount(int studyStatusId) {
        return studyStatusMapper.addCommentCount(studyStatusId);
    }

    @Override
    @CacheEvict(cacheNames = "comment", allEntries = true)
    public int deleteCommentById(int id) {
        return studyStatusMapper.deleteCommentById(id);
    }

    @Override
    @CacheEvict(cacheNames = "studyStatus", allEntries = true)
    public int subCommentCount(int studyStatusId) {
        return studyStatusMapper.subCommentCount(studyStatusId);
    }

    @Override
    @Cacheable(key = "'myStudyStatus:' + #userId + 'page:' + #page")
    public List<StudyStatus> selectMyStudyStatus(String page, String limit, int userId) {
        int pageInt = Integer.parseInt(page);
        int limitInt = Integer.parseInt(limit);
        int beginInt = (pageInt-1)*limitInt;
        String begin = beginInt + "";
        return studyStatusMapper.selectMyStudyStatus(begin,limit,userId);
    }

    @Override
    @Cacheable(key = "'myStudyStatusPages:' + #userId + 'limit:' + #limit")
    public int selectMyStudyStatusPages(String limit, int userId) {
        return studyStatusMapper.selectMyStudyStatusPages(limit, userId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int addTransmitCount(int studyStatusId) {
        return studyStatusMapper.addTransmitCount(studyStatusId);
    }

    @Override
    @CacheEvict(allEntries = true)
    public int deleteStudyStatus(int studyStatusId) {
        return studyStatusMapper.deleteStudyStatus(studyStatusId);
    }

    @Override
    public int addReport(Report report) {
        return studyStatusMapper.addReport(report);
    }
}
