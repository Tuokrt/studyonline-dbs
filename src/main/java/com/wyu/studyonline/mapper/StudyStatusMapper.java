package com.wyu.studyonline.mapper;

import com.wyu.studyonline.pojo.Comment;
import com.wyu.studyonline.pojo.Report;
import com.wyu.studyonline.pojo.StudyStatus;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudyStatusMapper {

    //新增动态
    public int addStudyStatus(StudyStatus studyStatus);

    //查找所有动态
    public List<StudyStatus> selectAllStudyStatus(@Param("begin") String begin,@Param("limit") String limit);

    //查所有动态的页数
    public int studyStatusPages(@Param("limit") String limit);

    //根据动态id增加一个点赞
    public int addStudyStatusLike(@Param("studyStatusId") int studyStatusId);

    //根据动态id减少一个点赞
    public int subStudyStatusLike(@Param("studyStatusId") int studyStatusId);

    //添加一条点赞记录
    public int addLikeRecord(@Param("userId") int userId, @Param("studyStatusId") int studyStatusId);

    //根据userId与studyStatusId删除一条点赞记录
    public int deleteLikeRecord(@Param("userId") int userId, @Param("studyStatusId") int studyStatusId);

    //根据userId查找该用户所有点赞的动态
    public List<Integer> selectAllLikeRecordByUserId(@Param("userId") int userId);

    //根据studyStatusId查找一条动态
    public StudyStatus selectStudyStatusById(@Param("studyStatusId") int studyStatusId);

    //根据id查找该动态的所有评论
    public List<Comment> selectAllCommentByStatusId(@Param("begin") String begin, @Param("limit") String limit, @Param("studyStatusId") int studyStatusId);

    //根据id查找所有评论的页数
    public int commentPagesByStatusId(@Param("limit") String limit, @Param("studyStatusId") int studyStatusId);

//    //添加一条评论
//    public int addComment(@Param("userId") int userId, @Param("studyStatusId") int studyStatusId, @Param("content") String content);

    //添加一条评论
    public int addComment(Comment comment);

    //根据动态id增加一个评论
    public int addCommentCount(@Param("studyStatusId") int studyStatusId);

    //根据评论id删除一个评论
    public int deleteCommentById(@Param("id") int id);

    //根据动态id减少一个评论
    public int subCommentCount(@Param("studyStatusId") int studyStatusId);

    //根据用户id查找该用户的所有动态
    public List<StudyStatus> selectMyStudyStatus(@Param("begin") String begin,@Param("limit") String limit,@Param("userId") int userId);

    //根据用户id查找该用户的所有动态的页数
    public int selectMyStudyStatusPages(@Param("limit") String limit, @Param("userId") int userId);

    //根据动态id增加一个转发
    public int addTransmitCount(@Param("studyStatusId") int studyStatusId);

    //根据动态id删除一条动态
    public int deleteStudyStatus(@Param("studyStatusId") int studyStatusId);

    //添加一条举报
    public int addReport(Report report);
}
