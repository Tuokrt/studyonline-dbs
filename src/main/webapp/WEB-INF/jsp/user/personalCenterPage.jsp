<%@ page import="com.wyu.studyonline.pojo.User" %>
<%@ page import="com.wyu.studyonline.pojo.EverydayStatus" %>
<%@ page import="java.text.SimpleDateFormat" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/27
  Time: 15:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>personalCenter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <base href="<%=request.getContextPath()%>">
</head>
<body>
<style>
    .layui-progress {
        height: 20px;
    }

    .layui-progress-bar {
        border-radius: 10px;
        height: 100%;
        width: 200px;
    }
    .user-info {
        display: flex;
        align-items: center;
        margin: 13px 130px;
    }

    .user-avatar {
        flex-shrink: 0;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 13px;
    }
    .user-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .user-content {
        flex-shrink: 1;
    }

    .user-name {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 8px;
        position: relative;
    }

    .user-progress {
        width: 300px;
        display: inline-block;
    }

    .user-exp{
        position: absolute;
        display: inline-block;
        height: 20px;
        line-height: 20px;
        margin-left: 20px;
    }

    .update-information{
        position: absolute;
        height: 23px;
        margin-left: 200px;
        border-radius: 5px;
        line-height: 23px;
    }

    .update-password{
        position: absolute;
        height: 23px;
        margin-left: 280px !important;
        border-radius: 5px;
        line-height: 23px;
    }

    .update-phone{
        position: absolute;
        height: 23px;
        margin-left: 360px !important;
        border-radius: 5px;
        line-height: 23px;
    }

    .every-day{
        margin-left: 140px;
        margin-top: -25px;
        position: relative;
    }

    .total-day{
        font-size: 15px;
        color: #222;
        margin-left: 200px;
        margin-top: 15px;
    }

    .last-day{
        font-size: 15px;
        color: #222;
        margin-left: 200px;
        margin-top: 15px;
    }

    .everyday-icon{
        position: absolute;
        height: 80px;
        width: 80px;
        background-color: #1E9FFF;
        border-color: #1E9FFF;
        border-radius: 50%;
        font-size: 15px;
        line-height: 80px;
        text-align: center;
        margin-left: 470px;
    }

    .circle-button {
        display: inline-block;
        width: 80px;
        height: 80px;
        background-color: #1E9FFF;
        color: #fff;
        border: none;
        border-radius: 50%;
        text-align: center;
        line-height: 50px;
        cursor: pointer;
    }

    .study-time{
        margin-left: 140px;
        margin-top: 90px;
    }

    .study-time-titile{
        position: relative;
    }

    .points-header-warp {
        margin-top: 15px;
        padding: 0 22px;
        height: 145px;
        width: 789px;
        background: url(<%=request.getContextPath()%>score.png) no-repeat;
        position: relative;
        text-align: center;
    }

    .points-header-box {
        padding-top: 30px;
    }

    #studyTime{
        position: absolute;
        margin-top: 5px;
        margin-left: -58px;
    }


    .box {
        width: 80px;
        height: 80px;
        background-color: #1E9FFF;
    }
    .layui-anim-scale {
        animation-duration: 2s;
        animation-iteration-count: infinite;
    }
    .layui-anim-scale.layui-anim-loop {
        animation-direction: alternate;
    }
    @keyframes layui-anim-scale {
        0% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.2);
        }
        100% {
            transform: scale(1);
        }
    }

    .success {
        background-color: #5FB878;
        pointer-events: none;
    }

</style>
<%
    User user = (User)session.getAttribute("user");
    if(user != null){
        EverydayStatus everydayStatus = (EverydayStatus)session.getAttribute("everydayStatus");
        Long totalSeconds = user.getStudyTime();
        Long hours = totalSeconds / 3600;
        Long minutes = (totalSeconds % 3600) / 60;
        String formattedTime = String.format("%02d时%02d分", hours, minutes); // 格式化为时:分的形式
%>

<div class="user-info">
    <div class="user-avatar">
        <img src="<%=user.getUserAvatar()%>" alt="用户头像">
    </div>
    <div class="user-content">
        <div class="user-name"><%=user.getUserName()%>
            <span class="layui-badge layui-bg-orange" style="margin-left: 10px">LV<%=user.getRank()%></span>
        </div>
        <div>
            <div class="user-progress">
                <div class="layui-progress" style="border-radius: 5px;">
                    <div class="layui-progress-bar layui-bg-red" lay-percent="<%=(int)((user.getExp()/(user.getRank()*1000.0))*100)%>%"></div>
                </div>
            </div>
            <span class="user-exp"><%=user.getExp()%>/<%=user.getRank()*1000%></span>
            <button class="layui-btn layui-btn-radius layui-btn-primary layui-btn-sm update-information" id="updateInformation">修改信息</button>
            <button class="layui-btn layui-btn-radius layui-btn-primary layui-btn-sm update-password" id="updatePassword">修改密码</button>
            <button class="layui-btn layui-btn-radius layui-btn-primary layui-btn-sm update-phone" id="updatePhone">更换手机</button>
        </div>
    </div>
</div>
<hr width="950px" style="margin: 50px 50px">
<%--每日打卡--%>
<div class="every-day">
    <div class="study-time-titile">
        <i class="layui-icon layui-icon-ok-circle" style="font-size: 35px; color: #1E9FFF;"></i>
        <span style="font-size: 19px;position: absolute;margin-top: 5px;margin-left: 5px">每日打卡</span>
    </div>
    <div style="display: inline-block; position: absolute">
        <p class="total-day">
            累计打卡：<i style="color: #1E9FFF;font-size: 15px" id="totalDay"><%=everydayStatus != null ? everydayStatus.getTotalDay() : 0%>天</i>
        </p>
        <p class="last-day">
            上次打卡：<i style="color: #1E9FFF;font-size: 15px" id="lastDay"><!-- 判断日期是否有效 -->
            <c:choose>
            <c:when test="${everydayStatus == null || everydayStatus.totalDay == 0}">
            你没有打卡记录
            </c:when>
            <c:otherwise>
                <!-- 输出日期时间 -->
                <fmt:formatDate value="${everydayStatus.updateTime}" pattern="yyyy-MM-dd HH:mm:ss" />
            </c:otherwise>
            </c:choose></i>
        </p>
    </div>
    <div id="daily-check-in" style="display: inline-block">
        <div class="check-in-button everyday-icon box layui-anim layui-anim-scale">
            <button class="circle-button">点击打卡</button>
        </div>
    </div>
</div>
<%--累计学习时间--%>
<div class="study-time">
    <div class="study-time-titile">
        <i class="layui-icon layui-icon-time" style="font-size: 35px; color: #1E9FFF;"></i>
        <span style="font-size: 19px;position: absolute;margin-top: 5px;margin-left: 5px">累计学习时间</span>
    </div>
    <div class="points-header-warp">
        <div class="points-header-box">
            <span style="font-size: 30px;color: #1E9FFF;" id="studyTime"><%= formattedTime %></span>
        </div>
    </div>
</div>

<%
    if(everydayStatus != null && everydayStatus.getTodayStatus() ==1){


%>
<script>
    const $box = $('.box');
    const $btn = $('.circle-button');
    $box.removeClass('layui-anim-scale layui-anim-loop');
    $btn.addClass('success');
    $btn.text("已打卡");
</script>
<%
    }
%>

<script>
//格式化时间数据
    function formatDate(dateStr) {
        var date = new Date(dateStr);
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);
        var hour = ("0" + date.getHours()).slice(-2);
        var minute = ("0" + date.getMinutes()).slice(-2);
        var second = ("0" + date.getSeconds()).slice(-2);
        return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
    }

    $('.circle-button').click(function() {

        $.ajax({
            type: 'post',
            url: '/user/updateEverydayStatus',
            data: {
                userId: <%=user.getId()%>,
            },
            success: function (data) {
                if (data != null) {
                    console.log(data);
                    $('.box').removeClass('layui-anim-scale layui-anim-loop');
                    $('.circle-button').addClass('success');
                    $('.circle-button').text("已打卡");
                    
                    // 确保数据是对象格式
                    var everydayStatus = typeof data === 'string' ? JSON.parse(data) : data;
                    
                    // 安全地设置累计打卡天数
                    var totalDay = everydayStatus.totalDay || everydayStatus.totalday || 0;
                    $("#totalDay").text(totalDay + "天");
                    
                    // 安全地设置上次打卡时间
                    var updateTime = everydayStatus.updateTime || everydayStatus.updatetime;
                    if (updateTime) {
                        var formattedTime = formatDate(updateTime);
                        $("#lastDay").text(formattedTime);
                    } else {
                        $("#lastDay").text("你没有打卡记录");
                    }
                } else {
                    layer.msg('打卡失败，请重试！');
                }
            },
            error: function () {
                layer.msg('网络错误,请重试！');
            }
        });
    });

$(function () {
    $('#updateInformation').click(function () {
        //console.log("点击了");
        //iframe 层
        layer.open({
            type: 2,
            title: '修改信息',
            shadeClose: true,
            shade: false,
            move:false,
            scrollbar: false,
            //maxmin: true, //开启最大化最小化按钮
            area: ['700px', '450px'],
            offset: '0px',
            content: 'updateInformationPage'
        });
    })

    $("#updatePassword").click(function () {
        //iframe 层
        layer.open({
            type: 2,
            title: '验证身份',
            shadeClose: true,
            shade: false,
            move:false,
            scrollbar: false,
            //maxmin: true, //开启最大化最小化按钮
            area: ['700px', '450px'],
            offset: '0px',
            content: 'updatePasswordPage'
        });
    })

    $("#updatePhone").click(function () {
        //iframe 层
        layer.open({
            type: 2,
            title: '更换手机号',
            shadeClose: true,
            shade: false,
            move:false,
            scrollbar: false,
            //maxmin: true, //开启最大化最小化按钮
            area: ['700px', '450px'],
            offset: '0px',
            content: 'updatePhonePage'
        });
    })

});
</script>
<%
    }else {
%>
<p>你还没登录</p>
<%
    }
%>

</body>
</html>
