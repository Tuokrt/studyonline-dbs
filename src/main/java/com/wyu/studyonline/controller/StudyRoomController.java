package com.wyu.studyonline.controller;

import com.qiniu.util.Auth;
import com.wyu.studyonline.config.QiNiuYunConfig;
import com.wyu.studyonline.pojo.Category;
import com.wyu.studyonline.pojo.StudyRoom;
import com.wyu.studyonline.pojo.User;
import com.wyu.studyonline.service.StudyRoomService;
import com.wyu.studyonline.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class StudyRoomController {
    @Autowired
    StudyRoomService studyRoomService;
    @Autowired
    UserService userService;
    @Autowired
    QiNiuYunConfig qiNiuYunConfig;

    @RequestMapping("/myStudyRoomPage")
    public String myStudyRoomPage(HttpSession session){
        //根据用户id查找用户创建的自习室
        User user = (User) session.getAttribute("user");
        System.out.println(user);
        StudyRoom studyRoom = studyRoomService.selectStudyRoomByUserId(user.getId());
        session.setAttribute("studyRoom",studyRoom);
        //把分类信息存到session层
        List<Category> categoryList = studyRoomService.selectAllCategory();
        session.setAttribute("categoryList",categoryList);
        return "user/myStudyRoomPage";
    }

    @RequestMapping("/joinStudyRoomPage")
    public String joinStudyRoomPage(HttpSession session){
        //查找所有开启的自习室
        List<StudyRoom> studyRoomList = studyRoomService.selectAllOpenStudyRoom();
        session.setAttribute("studyRoomList",studyRoomList);
        //把分类信息存到session层
        List<Category> categoryList = studyRoomService.selectAllCategory();
        session.setAttribute("categoryList",categoryList);
        return "user/joinStudyRoomPage";
    }

    @RequestMapping("/studyAlonePage")
    public String studyAlonePage(){
        return "user/studyAlonePage";
    }

    @RequestMapping("/addStudyTime")
    @ResponseBody
    public String addStudyTime(@RequestParam int userId, @RequestParam int hour, @RequestParam int min, @RequestParam int sec, HttpSession session){
        int studyTime = sec + min*60 + hour*3600;//学习时间以秒为单位
        int addExp = studyTime/60;//增加的经验值
        if(studyRoomService.addStudyTimeByid(studyTime,userId) != 0){
            if(userService.updateUserExpById(addExp,userId) != 0){
                //更新session层的用户信息
                User user = (User) session.getAttribute("user");
                user.setStudyTime(user.getStudyTime() + studyTime);
                user.setExp(user.getExp() + addExp);
                //如果用户经验达到临界值则等级加1
                if(user.getExp() >= user.getRank()*1000){
                    if(userService.updateUserRankById(userId) != 0){
                        user.setRank(user.getRank() + 1);
                    }
                }
                session.setAttribute("user", user);
                return "success";
            }
        }
        return "error";
    }

    @RequestMapping("/createStudyRoomPage")
    public String createStudyRoomPage(HttpSession session){
        //把分类信息存到session层
        List<Category> categoryList = studyRoomService.selectAllCategory();
        session.setAttribute("categoryList",categoryList);
        return "user/createStudyRoomPage";
    }

    //自习室图片上传处理（返回token与图片地址）
    @ResponseBody
    @RequestMapping("/uploadStudyRoomCover")
    public Map<String, Object> QiniuUpToken(@RequestParam MultipartFile file, HttpSession session) throws Exception{
        //String suffix = ".png";
        //System.out.println("文件后缀：" + suffix);

        Map<String, Object> result = new HashMap<String, Object>();
        try {

            if (file.isEmpty()) {
                result.put("message", "上传文件不能为空！，");
                result.put("success", 0);
                System.out.println("上传文件不能为空！");
                return result;
            }

            String originalFilename = file.getOriginalFilename();
            String suffix = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
            System.out.println("文件后缀：" + suffix);

            //验证七牛云身份是否通过
            Auth auth = Auth.create(qiNiuYunConfig.getQiniuAccessKey(), qiNiuYunConfig.getQiniuSecretKey());
            //生成凭证
            String upToken = auth.uploadToken(qiNiuYunConfig.getQiniuBucketName());
            result.put("token", upToken);
            //返回图片地址
            String imgName = UUID.randomUUID().toString() + suffix;
            result.put("imgName", imgName);
            String imgPath = "http://" + qiNiuYunConfig.getQiniuDomain() +"/" + imgName;
            result.put("imgPath", imgPath);
//            userService.updateUserAvatarById(imgPath,userId);
//            User user = (User) session.getAttribute("user");
//            user.setUserAvatar(imgPath);
//            session.setAttribute("user",user);
            result.put("success", 1);
        } catch (Exception e) {
            result.put("message", "获取凭证失败，"+e.getMessage());
            result.put("success", 0);
        } finally {
            return result;
        }
    }

    /**
     * @RequestParam int userId,
     * @RequestParam int categoryId,
     * @RequestParam String roomName,
     * @RequestParam String roomDescride,
     * @RequestParam String roomCover,
     * @RequestParam String userCard
     * @return
     */
    @ResponseBody
    @RequestMapping("/createStudyRoom")
    public String createStudyRoom(StudyRoom studyRoom, HttpSession session){
        System.out.println("要创建的自习室信息：" + studyRoom);
        if(studyRoomService.insertStudyRoom(studyRoom) != 0){
            StudyRoom studyRoom1 = studyRoomService.selectStudyRoomByUserId(studyRoom.getUserId());
            session.setAttribute("studyRoom",studyRoom1);
            return "success";
        }
        return "error";
    }

    @ResponseBody
    @RequestMapping("/updateStudyRoom")
    public String updateStudyRoom(StudyRoom studyRoom, HttpSession session){
        System.out.println("要创建的自习室信息：" + studyRoom);
        if(studyRoomService.updateStudyRoomByUserId(studyRoom) != 0){
            StudyRoom studyRoom1 = studyRoomService.selectStudyRoomByUserId(studyRoom.getUserId());
            session.setAttribute("studyRoom",studyRoom1);
            return "success";
        }
        return "error";
    }

    @RequestMapping("/startMyStudyRoom")
    public String startMyStudyRoom(){
        return "user/startMyStudyRoom";
    }

    @RequestMapping("/memberStudyRoom")
    public String memberStudyRoom(@RequestParam int roomId,HttpSession session){
        StudyRoom studyRoom = studyRoomService.selectStudyRoomByRoomId(roomId);
        session.setAttribute("studyRoom",studyRoom);
        return "user/memberStudyRoom";
    }

    @ResponseBody
    @RequestMapping("/closeStudyRoom")
    public String closeStudyRoom(@RequestParam("userId") String userId, HttpSession session){
        System.out.println("关闭自习室");
        int userIdInt = Integer.parseInt(userId);
        if(studyRoomService.closeStudyRoomByUserId(userIdInt) != 0){
            StudyRoom studyRoom = studyRoomService.selectStudyRoomByUserId(userIdInt);
            session.setAttribute("studyRoom",studyRoom);
            return "success";
        }
        return "error";
    }


}
