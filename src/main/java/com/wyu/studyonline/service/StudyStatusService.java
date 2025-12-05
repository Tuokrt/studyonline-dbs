package com.wyu.studyonline.service;

import com.wyu.studyonline.pojo.Comment;
import com.wyu.studyonline.pojo.Report;
import com.wyu.studyonline.pojo.StudyStatus;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StudyStatusService {

    //新增动态
    public int addStudyStatus(StudyStatus studyStatus);

    //查找所有动态
    public List<StudyStatus> selectAllStudyStatus(String page, String limit);

    //查所有动态的页数
    public int studyStatusPages(String limit);

    //根据动态id增加一个点赞
    public int addStudyStatusLike(int studyStatusId);

    //根据动态id减少一个点赞
    public int subStudyStatusLike(int studyStatusId);

    //添加一条点赞记录
    public int addLikeRecord(int userId, int studyStatusId);

    //根据userId与studyStatusId删除一条点赞记录
    public int deleteLikeRecord(int userId, int studyStatusId);

    //根据userId查找该用户所有点赞的动态
    public List<Integer> selectAllLikeRecordByUserId(int userId);

    //根据studyStatusId查找一条动态
    public StudyStatus selectStudyStatusById(int studyStatusId);

    //根据id查找该动态的所有评论
    public List<Comment> selectAllCommentByStatusId(String page, String limit, int studyStatusId);

    //根据id查找所有评论的页数
    public int commentPagesByStatusId(String limit, int studyStatusId);

//    //添加一条评论
//    public int addComment(int userId, int studyStatusId, String content);

    //添加一条评论
    public int addComment(Comment comment);

    //根据动态id增加一个评论
    public int addCommentCount(int studyStatusId);

    //根据评论id删除一个评论
    public int deleteCommentById(int id);

    //根据动态id减少一个评论
    public int subCommentCount(int studyStatusId);

    //根据用户id查找该用户的所有动态
    public List<StudyStatus> selectMyStudyStatus(String page, String limit, int userId);

    //根据用户id查找该用户的所有动态的页数
    public int selectMyStudyStatusPages(String limit, int userId);

    //根据动态id增加一个转发
    public int addTransmitCount(int studyStatusId);

    //根据动态id删除一条动态
    public int deleteStudyStatus(int studyStatusId);

    //添加一条举报
    public int addReport(Report report);
}
