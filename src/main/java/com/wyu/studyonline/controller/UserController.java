package com.wyu.studyonline.controller;

import com.alibaba.fastjson.JSON;
import com.qiniu.util.Auth;
import com.wyu.studyonline.config.QiNiuYunConfig;
import com.wyu.studyonline.pojo.*;
import com.wyu.studyonline.service.UserService;
import com.wyu.studyonline.service.impl.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.server.Session;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
//import sun.text.resources.cldr.ff.FormatData_ff;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    UserServiceImpl userService;

    @Autowired
    QiNiuYunConfig qiNiuYunConfig;

    @Autowired
    RedisTemplate redisTemplate;

//    @RequestMapping("/")
//    public String index(){
//        return "index";
//    }

    @RequestMapping("/indexPage")
    public String indexPage(Model model,HttpSession session){
        User user = (User) session.getAttribute("user");
        List<StudyPlan> studyPlanList = null;
        List<ExamTime> examTimeList = null;
        if(user != null){
            studyPlanList = userService.selectUnfinishedStudyPlan(user.getId());
            examTimeList = userService.selectLateExamTime(user.getId());
        } else {

        }

        Notice notice = userService.selectNewNotice();
        List<User> userList = userService.selectStudyTimeList();
        model.addAttribute("studyPlanList",studyPlanList);
        model.addAttribute("examTimeList",examTimeList);
        model.addAttribute("notice",notice);
        model.addAttribute("userList",userList);
        return "user/indexPage";
    }


    @RequestMapping("/finishStudyPlanById")
    @ResponseBody
    public Result finishStudyPlanById(@RequestParam int id){
        if(userService.updateStudyPlanStatus(id) != 0){
            return Result.success();
        }
        return Result.failure("更改失败！");

    }

    @RequestMapping("/loginPage")
    public String loginPage(){
        return "user/loginPage";
    }

    @RequestMapping("/registerPage")
    public String registerPage(){
        System.out.println("注册页面");
        return "user/registerPage";
    }

    @RequestMapping("/authCode")
    public void authCode(String cellPhone, HttpSession session){
        //生成4位的验证码
        String random = Math.random()+"";
        String substring = random.substring(random.length()-4);
        System.out.println(cellPhone + "的验证码:" + substring);
        //session.setAttribute("authCode",substring);
        //向redis中添加该手机的验证码（5分钟内有效）
        redisTemplate.opsForValue().set(cellPhone+"authCode",substring,1, TimeUnit.MINUTES);
    }

    @RequestMapping("/register")
    @ResponseBody
    public Result register(@RequestParam String cellPhone, @RequestParam String authCode,HttpSession session){

        System.out.println("注册表单处理");
//        if(authCode.equals(session.getAttribute("authCode"))){
        if(authCode.equals(redisTemplate.opsForValue().get(cellPhone + "authCode"))){
            //登录成功后，将验证码删除
            redisTemplate.delete(cellPhone + "authCode");
            User user = new User();
            user.setUserName(cellPhone);
            user.setCellPhone(cellPhone);
            //user.setUserPassword(userPassword);
            user.setUserAvatar("user.webp");
            System.out.println(user);
            User user1 = userService.selectUserByCellPhone(cellPhone);
            System.out.println(user1);
            if(user1 == null){
                int flag = userService.insertUser(user);
                User user2 = userService.selectUserByCellPhone(user.getCellPhone());
                System.out.println("注册的用户信息："+user2);
                System.out.println("注册的用户id：" + user2.getId());
                if(flag != 0){
                    //user.setId(userId);
                    session.setAttribute("user",user2);
                    System.out.println("注册登录成功");
                    //插入打卡表
                    userService.insertEverydayStatusById(user2.getId());
                    //查找用户对应的每日打卡
                    EverydayStatus everydayStatus = userService.selectEverydayStatusById(user2.getId());
                    //用户对应的每日打卡放入session层
                    session.setAttribute("everydayStatus",everydayStatus);

                }
            }else {
                if(user1.getStatus() == 1){
                    return new Result(3,user1.getBanDay()+"");
                }
                session.setAttribute("user",user1);
                //查找用户对应的每日打卡
                EverydayStatus everydayStatus = userService.selectEverydayStatusById(user1.getId());
                //用户对应的每日打卡放入session层
                session.setAttribute("everydayStatus",everydayStatus);

                System.out.println("登录成功");

            }
            return Result.success();

        }else if(redisTemplate.getExpire(cellPhone+"authCode")  < 0) {
            return Result.failure("验证码已过期，请重新获取");
        }else {
            System.out.println("验证码错误");
            return Result.failure("验证码错误");
        }

    }

    @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.removeAttribute("user");
        return "redirect:/";
    }

    @RequestMapping("/login")
    @ResponseBody
    public Result login(@RequestParam String cellPhone, @RequestParam String userPassword, HttpSession session){
        //查找用户信息
        User user = userService.selectUserByCellPhone(cellPhone);
        System.out.println(user);
        if(user == null){
            return new Result(1,"nullUser");
        }else {
            if(user.getUserPassword() == null){
                return new Result(2,"nullPassword");
            }
        }

        if(user.getUserPassword().equals(userPassword)){
            if(user.getStatus() == 1){
                return new Result(3,user.getBanDay()+"");
            }
            session.setAttribute("user",user);
            //查找用户对应的每日打卡
            EverydayStatus everydayStatus = userService.selectEverydayStatusById(user.getId());
            //用户对应的每日打卡放入session层
            session.setAttribute("everydayStatus",everydayStatus);
            
            return Result.success();
        }
        return new Result(4,"密码错误");
    }

    @RequestMapping("/addStudyPlanPage")
    public String addStudyPlanPage(){
        return "user/addStudyPlanPage";
    }

    @RequestMapping("/addStudyPlan")
    public String addStudyPlan(@RequestParam int userId, @RequestParam String content, Model model){
        System.out.println("添加待办处理");
//        int userIdInt = Integer.parseInt(userId);
        if(userService.insertStudyPlan(userId,content) == 1){
            model.addAttribute("addSuccess", "添加成功");
        }
        return "user/addStudyPlanPage";
    }

    @RequestMapping("/updateStudyPlanPage")
    public String updateStudyPlanPage(){
        return "user/updateStudyPlanPage";
    }

    @RequestMapping("/selectAllStudyPlanByUserId")
    @ResponseBody
    public String selectAllStudyPlanByUserId(@RequestParam String page, @RequestParam String limit, @RequestParam int userId){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<StudyPlan> studyPlanList = userService.selectAllStudyPlanByUserId(page,limit,userId);
        int count = userService.selectAllStudyPlanByUserIdCount(userId);
        String listjson = JSON.toJSONString(studyPlanList);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @ResponseBody
    @RequestMapping("/updateStudyPlanContent")
    public String updateStudyPlanContent(@RequestParam int id, @RequestParam String updateContent){
        if(userService.updateStudyPlanContent(id,updateContent) != 0){
            return "success";
        }else {
            return "error";
        }
    }

    @ResponseBody
    @RequestMapping("/deleteStudyPlanContent")
    public String deleteStudyPlanContent(@RequestParam int id){
        if(userService.deleteStudyPlanContent(id) != 0){
            return "success";
        }else {
            return "error";
        }
    }

    @RequestMapping("/addExamTimePage")
    public String addExamTimePage(){
        return "user/addExamTimePage";
    }

    @RequestMapping("/addExamTime")
    public String addExamTime(@RequestParam String examName, @RequestParam String examTime, @RequestParam int userId, Model model){
        System.out.println(examName + "  " + examTime);
        if(userService.insertExamTime(examName,examTime,userId) != 0){
            model.addAttribute("addSuccess", "添加成功");
        }
        return "user/addExamTimePage";
    }

    @RequestMapping("/updateExamTimePage")
    public String updateExamTimePage(){
        return "user/updateExamTimePage";
    }

    @ResponseBody
    @RequestMapping("/selectAllExamTimeByUserId")
    public String selectAllExamTimeByUserId(@RequestParam String page, @RequestParam String limit, @RequestParam int userId){
        //layui Table 数据表自动封装了两个参数：page(当前页) limit(一页显示的条数)
        System.out.println("page" + page + ";" + "limit" + limit);
        List<ExamTime> examTimeList = userService.selectAllExamTimeByUserId(page,limit,userId);
        int count = userService.selectAllExamTimeByUserIdCount(userId);
        String listjson = JSON.toJSONString(examTimeList);
        System.out.println(listjson);
        String json = "{\"code\": 0,\"msg\": \"\",\"count\": "+count+",\"data\": "+listjson+"}";
        return json;
    }

    @ResponseBody
    @RequestMapping("/updateExamTime")
    public String updateExamTime(@RequestParam int id, @RequestParam String examName, @RequestParam String examTime){
        if(userService.updateExamTimeById(id,examName,examTime) != 0){
            return "success";
        }else {
            return "error";
        }
    }

    @ResponseBody
    @RequestMapping("/deleteExamTime")
    public String deleteExamTime(@RequestParam int id){
        if(userService.deleteExamTimeById(id) != 0){
            return "success";
        }else {
            return "error";
        }

    }

    @RequestMapping("/personalCenterPage")
    public String personalCenterPage(){
        return "user/personalCenterPage";
    }

    @ResponseBody
    @RequestMapping("/updateEverydayStatus")
    public EverydayStatus updateEverydayStatus(@RequestParam int userId, HttpSession session){
        try {
            // 先检查用户是否有打卡记录
            EverydayStatus existingStatus = userService.selectEverydayStatusById(userId);
            
            // 如果用户没有打卡记录，先插入新记录
            if(existingStatus == null){
                userService.insertEverydayStatusById(userId);
            }
            
            // 更新打卡状态
            if(userService.updateEverydayStatus(userId) != 0){
                //查找用户对应的每日打卡
                EverydayStatus everydayStatus = userService.selectEverydayStatusById(userId);
                System.out.println("打卡后：" + everydayStatus);
                //用户对应的每日打卡放入session层
                session.setAttribute("everydayStatus",everydayStatus);
                //根据用户id增加打卡对应的经验值（打卡得30经验值）
                userService.updateUserExpById(30,userId);
                //更新session层的用户信息
                User user = (User) session.getAttribute("user");
                user.setExp(user.getExp() + 30);
                //如果用户经验达到临界值则等级加1
                while(user.getExp() >= user.getRank()*1000){
                if(user.getExp() >= user.getRank()*1000){
                    if(userService.updateUserRankById(userId) != 0){
                        user.setRank(user.getRank() + 1);
                    }
                }}
                session.setAttribute("user",user);
                return everydayStatus;
            }
            
            // 如果执行到这里，说明打卡失败
            System.out.println("打卡失败，用户ID：" + userId);
            return null;
        } catch (Exception e) {
            // 捕获异常，避免返回500错误
            System.out.println("打卡异常：" + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping("/updateInformationPage")
    public String updateInformationPage(){
        return "user/updateInformationPage";
    }

    @RequestMapping("/updatePasswordPage")
    public String updatePasswordPage(){
        return "user/updatePasswordPage";
    }

    @RequestMapping("/updatePhonePage")
    public String updatePhonePage(){
        return "user/updatePhonePage";
    }


    //用户头像上传处理（返回token与图片地址）
    @ResponseBody
    @RequestMapping("/qiniuUpToken")
    public Map<String, Object> QiniuUpToken(@RequestParam MultipartFile file, @RequestParam int userId, HttpSession session) throws Exception{
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
            userService.updateUserAvatarById(imgPath,userId);
            User user = (User) session.getAttribute("user");
            user.setUserAvatar(imgPath);
            session.setAttribute("user",user);
            result.put("success", 1);
        } catch (Exception e) {
            result.put("message", "获取凭证失败，"+e.getMessage());
            result.put("success", 0);
        } finally {
            return result;
        }
    }

    @RequestMapping("/updateInformation")
    @ResponseBody
    public String updateInformation(@RequestParam int userId, @RequestParam String userName, @RequestParam int gender, HttpSession session){
        //更新用户信息
        if(userService.updateUserById(userId,userName,gender) != 0){
            User user = (User) session.getAttribute("user");
            user.setUserName(userName);
            user.setGender(gender);
            session.setAttribute("user",user);
            return "success";
        }
        return "error";
    }

    @RequestMapping("/updatePasswordNextPage")
    public String updatePasswordNextPage(){
        return "user/updatePasswordNextPage";
    }

    //身份验证
    @ResponseBody
    @RequestMapping("/authentication")
    public String authentication(@RequestParam String authCode, @RequestParam String cellPhone, HttpSession session){
//        if(session.getAttribute("authCode").equals(authCode)){
//            return "success";
//        }
        if(redisTemplate.opsForValue().get(cellPhone + "authCode").equals(authCode)){
            //验证成功后，将验证码删除
            redisTemplate.delete(cellPhone + "authCode");
            return "success";
        }
        return "error";
    }

    //修改密码
    @ResponseBody
    @RequestMapping("/authenticationNext")
    public String authenticationNext(@RequestParam String userPassword, @RequestParam int userId, HttpSession session){
        if(userService.updateUserPasswordById(userPassword, userId) != 0){
            //将session层的用户信息清空
            session.setAttribute("user",null);
            return "success";
        }
        return "error";
    }

    @RequestMapping("/updatePhoneNextPage")
    public String updatePhoneNextPage(){
        return "user/updatePhoneNextPage";
    }

    @ResponseBody
    @RequestMapping("/updatePhone")
    public String updatePhone(@RequestParam String authCode, @RequestParam int userId, @RequestParam String cellPhone, HttpSession session){
//        if(authCode.equals(session.getAttribute("authCode"))){
        if(authCode.equals(redisTemplate.opsForValue().get(cellPhone + "authCode"))){
            if(userService.selectUserByCellPhone(cellPhone) == null){
                if(userService.updateCellPhoneById(cellPhone, userId) != 0){
                    //更新session层的用户信息
                    User user = (User) session.getAttribute("user");
                    user.setCellPhone(cellPhone);
                    session.setAttribute("user",user);
                    return "success";
                }
                return "error";
            }
            //手机号已被占用
            return "cellPhoneUsed";
        }
        return "authCodeError";
    }



}
