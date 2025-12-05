package com.wyu.studyonline.mapper;

import com.wyu.studyonline.pojo.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdminMapper {

    //根据手机号查找管理员
    public Admin selectAdminByCellPhone(@Param("cellPhone") String cellPhone);

    //根据性别查找用户的个数
    public int selectUserCountByGender(@Param("gender") int gender);

    //根据自习室状态查找自习室的个数
    public int selectStudyRoomByStatus(@Param("status") int status);

    //增加一条公告
    public int addNotice(Notice notice);

    //根据状态查找自习室
    public List<StudyRoom> selectAuditStudyRoom(@Param("begin") String begin, @Param("limit") String limit, @Param("status") int status);

    //根据状态查找自习室个数
    public int selectStudyRoomCount(@Param("status") int status);

    //根据id设置自习室审核状态
    public int setStudyRoomById(@Param("id") int id, @Param("auditStatus") int auditStatus);

    //查找所有举报
    public List<Report> selectAllReport(@Param("begin") String begin, @Param("limit") String limit);

    //查找举报条数
    public int selectAllReportCount();

    //成功处理举报
    public int ideaReportById(@Param("id") int id);

    //查找最近用户
    public List<User> selectLatelyUser(@Param("begin") String begin, @Param("limit") String limit, @Param("latelyDay") int latelyDay);

    //查找最近用户条数
    public int selectLatelyUserCount(@Param("latelyDay") int latelyDay);

    //根据id查找用户信息
    public List<User> selectUserById(@Param("begin") String begin, @Param("limit") String limit,@Param("id") int id);

    //根据天数与id封禁用户
    public int banUserByDay(@Param("id") int id, @Param("banDay") int banDay);

    //根据id解除封禁
    public int notBanUserById(@Param("id") int id);

    //根据id查找自习室
    public List<StudyRoom> selectStudyRoomById(@Param("begin") String begin, @Param("limit") String limit,@Param("id") int id);

    //根据id封禁自习室
    public int banStudyRoomById(@Param("id") int id);

    //根据id解封自习室
    public int notBanStudyRoomById(@Param("id") int id);

    //根据id查找动态
    public List<StudyStatus> selectStudyStatusById(@Param("begin") String begin, @Param("limit") String limit,@Param("id") int id);

    //根据id查找评论
    public List<Comment> selectCommentById(@Param("begin") String begin, @Param("limit") String limit,@Param("id") int id);

}
