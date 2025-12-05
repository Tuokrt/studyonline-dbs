package com.wyu.studyonline.controller;

import com.alibaba.fastjson.JSON;
import com.wyu.studyonline.pojo.*;
import com.wyu.studyonline.service.AdminService;
import com.wyu.studyonline.service.StudyRoomService;
import com.wyu.studyonline.service.StudyStatusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {
    //为了解耦，controller层不能直接依赖于service层的实现类，只能依赖于其接口，
    //所以这个地方注入的应该是接口，而不是实现类
    @Autowired
    AdminService adminService;

    @Autowired
    StudyRoomService studyRoomService;

    @Autowired
    StudyStatusService studyStatusService;

    @Autowired
    RedisTemplate redisTemplate;

    @RequestMapping("/passwordLogin")
    @ResponseBody
    public Result passwordLogin(@RequestParam String cellPhone, @RequestParam String userPassword, HttpSession session){
        //查找用户信息
        Admin admin = adminService.selectAdminByCellPhone(cellPhone);
        System.out.println(admin);
        if(admin == null){
            return Result.failure("nullUser");
        }else {
            if(admin.getUserPassword() == null){
                return Result.failure("nullPassword");
            }
        }

        if(admin.getUserPassword().equals(userPassword)){
            session.setAttribute("admin",admin);
            return Result.success();
        }
        return Result.failure("密码错误");
    }

    @RequestMapping("/cellPhoneLogin")
    @ResponseBody
    public Result cellPhoneLogin(@RequestParam String cellPhone, @RequestParam String authCode,HttpSession session){

        //System.out.println("注册表单处理");
//        if(authCode.equals(session.getAttribute("authCode"))){
        if(authCode.equals(redisTemplate.opsForValue().get(cellPhone + "authCode"))){
            //登录成功后，将验证码删除
            redisTemplate.delete(cellPhone + "authCode");
            Admin admin = adminService.selectAdminByCellPhone(cellPhone);
            System.out.println(admin);
            if(admin == null){
                return Result.failure("nullUser");
            }else {
                session.setAttribute("admin",admin);
                return Result.success();
            }


        }else {
            System.out.println("验证码错误");
            return Result.failure("验证码错误");
        }

    }

    @RequestMapping("/userDatePage")
    public String userDatePage(Model model){
        int man = adminService.selectUserCountByGender(1);
        int woman = adminService.selectUserCountByGender(2);
        int secrecy = adminService.selectUserCountByGender(0);
        int userCount = man + woman + secrecy;
        model.addAttribute("man",man);
        model.addAttribute("woman",woman);
        model.addAttribute("secrecy",secrecy);
        model.addAttribute("userCount",userCount);
        int openRoom = adminService.selectStudyRoomByStatus(1);
        int closeRoom = adminService.selectStudyRoomByStatus(0);
        int studyRoomCount = openRoom + closeRoom;
        model.addAttribute("openRoom",openRoom);
        model.addAttribute("closeRoom",closeRoom);
        model.addAttribute("studyRoomCount",studyRoomCount);
        return "admin/userDatePage";
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.removeAttribute("admin");
        return "redirect:/admin";
    }

    @RequestMapping("/index")
    public String index(){
        return "admin/index";
    }

    @RequestMapping("/noticePage")
    public String noticePage(){
        return "admin/noticePage";
    }

    @RequestMapping("/checkStudyRoomPage")
    public String checkStudyRoomPage(){
        return "admin/checkStudyRoomPage";
    }

    @RequestMapping("/checkReportPage")
    public String checkReportPage(){
        return "admin/checkReportPage";
    }

    @RequestMapping("/manageUserPage")
    public String manageUserPage(){
        return "admin/manageUserPage";
    }

    @RequestMapping("/manageStudyRoomPage")
    public String manageStudyRoomPage(){
        return "admin/manageStudyRoomPage";
    }

    @RequestMapping("/manageStudyStatusPage")
    public String manageStudyStatusPage(){
        return "admin/manageStudyStatusPage";
    }

    @RequestMapping("/manageCommentPage")
    public String manageCommentPage(){
        return "admin/manageCommentPage";
    }


    @RequestMapping("/addNotice")
    @ResponseBody
    public String addNotice(Notice notice){
        System.out.println("发布的动态" + notice);
        if(adminService.addNotice(notice) != 0){
            return "success";
        }
        return "error";
    }

    @RequestMapping("/selectAuditStudyRoom")
    @ResponseBody
    public String selectAuditStudyRoom(@RequestParam String page, @RequestParam String limit){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        int status = 0;//(0代表待审核)
        List<StudyRoom> studyRoomList = adminService.selectAuditStudyRoom(page,limit,status);
        int count = adminService.selectStudyRoomCount(status);
        String listjson = JSON.toJSONString(studyRoomList);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @ResponseBody
    @RequestMapping("/passStudyRoomById")
    public String passStudyRoomById(@RequestParam int id){
        int auditStatus = 1;//（1代表审核通过）
        if(adminService.setStudyRoomById(id,auditStatus) != 0){
            return "success";
        }else {
            return "error";
        }
    }

    @ResponseBody
    @RequestMapping("/notPassStudyRoomById")
    public String notPassStudyRoomById(@RequestParam int id){
        int auditStatus = 2;//（2代表审核不通过）
        if(adminService.setStudyRoomById(id,auditStatus) != 0){
            return "success";
        }else {
            return "error";
        }
    }


    @RequestMapping("/selectAllReport")
    @ResponseBody
    public String selectAllReport(@RequestParam String page, @RequestParam String limit){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<Report> reportList = adminService.selectAllReport(page, limit);
        int count = adminService.selectAllReportCount();
        String listjson = JSON.toJSONString(reportList);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @ResponseBody
    @RequestMapping("/ideaReportById")
    public String ideaReportById(@RequestParam int id){
        if(adminService.ideaReportById(id) != 0){
            return "success";
        }else {
            return "error";
        }
    }


    @RequestMapping("/selectLatelyUser")
    @ResponseBody
    public String selectLatelyUser(@RequestParam String page, @RequestParam String limit){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        int latelyDay = 5;
        List<User> latelyUser = adminService.selectLatelyUser(page, limit, latelyDay);
        int count = adminService.selectLatelyUserCount(latelyDay);
        String listjson = JSON.toJSONString(latelyUser);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @RequestMapping("/selectUserById")
    @ResponseBody
    public String selectUserById(@RequestParam String page, @RequestParam String limit, @RequestParam int id){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<User> latelyUser = adminService.selectUserById(page, limit, id);
        int count = 1;
        String listjson = JSON.toJSONString(latelyUser);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @ResponseBody
    @RequestMapping("/banUserByDay")
    public String banUserByDay(@RequestParam int id, @RequestParam int banDay){
        if(adminService.banUserByDay(id,banDay) != 0){
            return "success";
        }else {
            return "error";
        }
    }

    @ResponseBody
    @RequestMapping("/notBanUserById")
    public String notBanUserById(@RequestParam int id){
        if(adminService.notBanUserById(id) != 0){
            return "success";
        }else {
            return "error";
        }
    }


    @RequestMapping("/adminJoinStudyRoom")
    public String adminJoinStudyRoom(@RequestParam String roomId,HttpSession session){

        StudyRoom studyRoom = studyRoomService.selectStudyRoomByRoomId(Integer.parseInt(roomId));
        System.out.println(studyRoom);
        session.setAttribute("studyRoom",studyRoom);
        return "admin/adminJoinStudyRoom";
    }


    @RequestMapping("/selectAllStudyRoom")
    @ResponseBody
    public String selectAllStudyRoom(@RequestParam String page, @RequestParam String limit){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        int status = 1;//(1代表审核通过，未封禁)
        List<StudyRoom> studyRoomList = adminService.selectAuditStudyRoom(page,limit,status);
        int count = adminService.selectStudyRoomCount(status);
        String listjson = JSON.toJSONString(studyRoomList);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @RequestMapping("/selectAllBanStudyRoom")
    @ResponseBody
    public String selectAllBanStudyRoom(@RequestParam String page, @RequestParam String limit){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        int status = 3;//(1代表审核通过，未封禁)
        List<StudyRoom> studyRoomList = adminService.selectAuditStudyRoom(page,limit,status);
        int count = adminService.selectStudyRoomCount(status);
        String listjson = JSON.toJSONString(studyRoomList);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }


    @RequestMapping("/selectStudyRoomById")
    @ResponseBody
    public String selectStudyRoomById(@RequestParam String page, @RequestParam String limit, @RequestParam int id){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<StudyRoom> studyRoomById = adminService.selectStudyRoomById(page, limit, id);
        int count = 1;
        String listjson = JSON.toJSONString(studyRoomById);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }


    @ResponseBody
    @RequestMapping("/banStudyRoomById")
    public String banStudyRoomById(@RequestParam int id){
        if(adminService.banStudyRoomById(id) != 0){
            return "success";
        }else {
            return "error";
        }
    }


    @ResponseBody
    @RequestMapping("/notBanStudyRoomById")
    public String notBanStudyRoomById(@RequestParam int id){
        if(adminService.notBanStudyRoomById(id) != 0){
            return "success";
        }else {
            return "error";
        }
    }


    @RequestMapping("/selectStudyStatusById")
    @ResponseBody
    public String selectStudyStatusById(@RequestParam String page, @RequestParam String limit, @RequestParam int id){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<StudyStatus> studyStatusById = adminService.selectStudyStatusById(page, limit, id);
        int count = 1;
        String listjson = JSON.toJSONString(studyStatusById);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }


    @RequestMapping("/selectCommentById")
    @ResponseBody
    public String selectCommentById(@RequestParam String page, @RequestParam String limit, @RequestParam int id){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<Comment> commentById = adminService.selectCommentById(page, limit, id);
        int count = 1;
        String listjson = JSON.toJSONString(commentById);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
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
    @RequestMapping("/deleteStudyStatus")
    public Result deleteStudyStatus(@RequestParam int studyStatusId){
        studyStatusService.deleteStudyStatus(studyStatusId);
        return Result.success();
    }
}
