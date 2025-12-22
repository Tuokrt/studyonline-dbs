package com.wyu.studyonline.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.wyu.studyonline.pojo.*;
import com.wyu.studyonline.service.StudyStatusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/user")
public class StudyStatusController {
    @Autowired
    StudyStatusService studyStatusService;

    @Autowired
    ZSetOperations zSetOperations;

    @RequestMapping("/myStudyStatusPage")
    public String myStudyStatusPage(){
        return "user/myStudyStatusPage";
    }

    @RequestMapping("/addStudyStatusPage")
    public String addStudyStatusPage(){
        return "user/addStudyStatusPage";
    }

    @RequestMapping("/addStudyStatus")
    @ResponseBody
    public String addStudyStatus(StudyStatus studyStatus){
        System.out.println("发布的动态" + studyStatus);
        if(studyStatusService.addStudyStatus(studyStatus) != 0){
            //动态发布成功，热度+100
            zSetOperations.add("studyStatusRank",studyStatus.getId(),100);
            return "success";
        }
        return "error";
    }

    @RequestMapping("/allStudyStatusPage")
    public String allStudyStatusPage(Model model){
        List<Map<Integer,String>> studyStatusRankList = new ArrayList<>();
        String key = "studyStatusRank";
        //查询热度前10名
        Set<ZSetOperations.TypedTuple<String>> set = zSetOperations.reverseRangeWithScores(key, 0, 9);
        JSONArray jsonArray = JSONObject.parseArray(JSONObject.toJSONString(set));
        for(int i = 0, size = jsonArray.size(); i < size; i++) {
            JSONObject o = JSONObject.parseObject(jsonArray.get(i).toString());
            System.out.println("动态id：" + o.getString("value") + ", 热度值：" + o.getLongValue("score"));
            StudyStatus studyStatus = studyStatusService.selectStudyStatusById(Integer.parseInt(o.getString("value")));
            // 检查动态是否存在，如果已被删除则跳过
            if (studyStatus != null) {
                Map<Integer,String> resMap = new HashMap<>();
                resMap.put(studyStatus.getId(),studyStatus.getContent());
                studyStatusRankList.add(resMap);
            }
        }
        model.addAttribute("studyStatusRankList", studyStatusRankList);
        return "user/allStudyStatusPage";
    }

    @ResponseBody
    @RequestMapping("/selectAllStudyStatus")
    public Result<List<StudyStatus>> selectAllStudyStatus(@RequestParam String page, @RequestParam String limit, @RequestParam int userId){
        //layui 流加载发来的两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<StudyStatus> studyStatusList = studyStatusService.selectAllStudyStatus(page,limit);
        int count = studyStatusService.studyStatusPages(limit);
        System.out.println("pages = " + count);

        //String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        List<Integer> likeRecordList = studyStatusService.selectAllLikeRecordByUserId(userId);
        System.out.println("likeRecordList  =" + likeRecordList);
        //将该用户所有点赞过的动态设置isLike属性为true
        studyStatusList.forEach(status -> {
            if (likeRecordList.contains(status.getId())) {
                status.setLike(true);
            }
        });

        String listjson = JSON.toJSONString(studyStatusList);
        System.out.println(listjson);

        //点赞过的动态列表
//        List<StudyStatus> result = studyStatusList.stream()
//                .filter(status -> likeRecordList.contains(status.getId()))
//                .collect(Collectors.toList());
//        System.out.println("点赞过的动态列表 = " + result);

        return Result.success(count,studyStatusList);
    }

    @ResponseBody
    @RequestMapping("/addStudyStatusLike")
    public Result addStudyStatusLike(@RequestParam int studyStatusId, @RequestParam int userId){
        if(studyStatusService.addStudyStatusLike(studyStatusId) != 0 && studyStatusService.addLikeRecord(userId,studyStatusId) != 0){
            //点赞成功，热度+50
            zSetOperations.incrementScore("studyStatusRank",studyStatusId,50);
            return Result.success();
        }
        return Result.failure("点赞失败！");
    }

    @ResponseBody
    @RequestMapping("/subStudyStatusLike")
    public Result subStudyStatusLike(@RequestParam int studyStatusId, @RequestParam int userId){
        if(studyStatusService.subStudyStatusLike(studyStatusId) != 0 && studyStatusService.deleteLikeRecord(userId,studyStatusId) != 0){
            //点赞取消，热度-50
            zSetOperations.incrementScore("studyStatusRank",studyStatusId,-50);
            return Result.success();
        }
        return Result.failure("取消点赞失败！");
    }

    @RequestMapping("/commentPage/{studyStatusId}")
    public String commentPage(@PathVariable int studyStatusId,@RequestParam int userId, Model model){
        StudyStatus studyStatus = studyStatusService.selectStudyStatusById(studyStatusId);
        List<Integer> likeRecordList = studyStatusService.selectAllLikeRecordByUserId(userId);
        if (likeRecordList.contains(studyStatus.getId())) {
            studyStatus.setLike(true);
        }
        model.addAttribute("studyStatus",studyStatus);
        //用户点击进入详情页，热度+20
        zSetOperations.incrementScore("studyStatusRank",studyStatusId,20);
        return "user/commentPage";
    }

    @ResponseBody
    @RequestMapping("/selectAllCommentByStatusId")
    public Result<List<Comment>> selectAllCommentByStatusId(@RequestParam String page, @RequestParam String limit, @RequestParam int studyStatusId){
        //layui 流加载发来的两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<Comment> CommentList = studyStatusService.selectAllCommentByStatusId(page,limit,studyStatusId);
        int pages = studyStatusService.commentPagesByStatusId(limit,studyStatusId);
        System.out.println("pages = " + pages);

        String listjson = JSON.toJSONString(CommentList);
        System.out.println(listjson);
        return Result.success(pages,CommentList);
    }

//    @ResponseBody
//    @RequestMapping("/addComment")
//    public Result addComment(@RequestParam int studyStatusId, @RequestParam int userId, @RequestParam String content){
//        if(studyStatusService.addComment(userId, studyStatusId, content) != 0 && studyStatusService.addCommentCount(studyStatusId) != 0){
//            return Result.success();
//        }
//        return Result.failure("点赞失败！");
//    }

    @ResponseBody
    @RequestMapping("/addComment")
    public Result addComment(Comment comment){
        if(studyStatusService.addComment(comment) != 0 && studyStatusService.addCommentCount(comment.getStudyStatusId()) != 0){
            int id = comment.getId();
            System.out.println("commentId  =  " + id);
            //评论成功，热度+100
            zSetOperations.incrementScore("studyStatusRank",comment.getStudyStatusId(),100);
            return Result.success(id,null);
        }
        return Result.failure("评论失败！");
    }

    @ResponseBody
    @RequestMapping("/deleteCommentById")
    public Result deleteCommentById(@RequestParam int commentId, @RequestParam int studyStatusId){
        if(studyStatusService.deleteCommentById(commentId) != 0 && studyStatusService.subCommentCount(studyStatusId) != 0){
            return Result.success();
        }
        return Result.failure("删除评论失败！");
    }

    @ResponseBody
    @RequestMapping("/selectMyStudyStatus")
    public Result<List<StudyStatus>> selectMyStudyStatus(@RequestParam String page, @RequestParam String limit, @RequestParam int userId){
        //layui 流加载发来的两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<StudyStatus> myStudyStatusList = studyStatusService.selectMyStudyStatus(page,limit,userId);
        int count = studyStatusService.selectMyStudyStatusPages(limit,userId);
        System.out.println("pages = " + count);

        //String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        List<Integer> likeRecordList = studyStatusService.selectAllLikeRecordByUserId(userId);
        System.out.println("likeRecordList  =" + likeRecordList);
        //将该用户所有点赞过的动态设置isLike属性为true
        myStudyStatusList.forEach(status -> {
            if (likeRecordList.contains(status.getId())) {
                status.setLike(true);
            }
        });

        //点赞过的动态列表
//        List<StudyStatus> result = studyStatusList.stream()
//                .filter(status -> likeRecordList.contains(status.getId()))
//                .collect(Collectors.toList());
//        System.out.println("点赞过的动态列表 = " + result);

        String listjson = JSON.toJSONString(myStudyStatusList);
        System.out.println(listjson);

        return Result.success(count,myStudyStatusList);
    }

    @ResponseBody
    @RequestMapping("/transmitStudyStatus")
    public Result transmitStudyStatus(@RequestParam int studyStatusId, @RequestParam int userId){
        StudyStatus studyStatus = studyStatusService.selectStudyStatusById(studyStatusId);
        studyStatus.setContent("#转发动态\n" + "@" + studyStatus.getUserName() + "\n" + studyStatus.getContent());
        studyStatus.setUserId(userId);
        System.out.println("#转发动态" + studyStatus);
        if(studyStatusService.addStudyStatus(studyStatus) != 0 && studyStatusService.addTransmitCount(studyStatusId) != 0){
            //转发成功，热度+200
            zSetOperations.incrementScore("studyStatusRank",studyStatusId,200);
            return Result.success();
        }
        return Result.failure("转发失败！");
    }

    @ResponseBody
    @RequestMapping("/deleteStudyStatus")
    public Result deleteStudyStatus(@RequestParam int studyStatusId){
        studyStatusService.deleteStudyStatus(studyStatusId);
        //删除动态，则把热度key删除
        zSetOperations.remove("studyStatusRank",studyStatusId);
        return Result.success();
    }

    @RequestMapping("/reportPage")
    public String reportPage(@RequestParam int reportType,@RequestParam int beReportedId, Model model){
        //StudyStatus studyStatus = studyStatusService.selectStudyStatusById(studyStatusId);
        //List<Integer> likeRecordList = studyStatusService.selectAllLikeRecordByUserId(userId);
//        if (likeRecordList.contains(studyStatus.getId())) {
//            studyStatus.setLike(true);
//        }
        model.addAttribute("reportType",reportType);
        model.addAttribute("beReportedId",beReportedId);
        return "user/reportPage";
    }

    /**
     * @RequestParam int userId, @RequestParam int reportType, @RequestParam int beReportedId, @RequestParam String reportContent, String photo
     * @return
     */
    @ResponseBody
    @RequestMapping("/addReport")
    public Result addReport(Report report){
        if(studyStatusService.addReport(report) != 0){
            return Result.success();
        }
        return Result.failure("提交举报失败！");
    }

//    @ResponseBody
//    @RequestMapping("/studyStatusRank")
//    public List<String> studyStatusRank(){
//        List<String> studyStatusRankList = new ArrayList<>();
//        String key = "studyStatusRank";
//        Set<ZSetOperations.TypedTuple<String>> set = zSetOperations.reverseRangeWithScores(key, 0, 9);
//        JSONArray jsonArray = JSONObject.parseArray(JSONObject.toJSONString(set));
//        for(int i = 0, size = jsonArray.size(); i < size; i++) {
//            JSONObject o = JSONObject.parseObject(jsonArray.get(i).toString());
//            System.out.println("动态id：" + o.getString("value") + ", 热度值：" + o.getLongValue("score"));
//            studyStatusRankList.add(studyStatusService.selectStudyStatusById(Integer.parseInt(o.getString("value"))).getContent());
//        }
//        return studyStatusRankList;
//    }


}
