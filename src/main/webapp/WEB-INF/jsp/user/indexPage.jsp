<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/22
  Time: 22:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>indexPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.15.3/css/all.min.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<style>
    .todo-list {
        /*list-style: none; !* 去掉默认的列表样式 *!*/
        margin: 0;
        padding: 0;
        font-size: 16px;
    }

    .todo-list li {
        padding: 8px 16px; /* 添加内边距 */
        border-bottom: 1px solid #ddd; /* 添加底部边框 */
        min-height: 25px;
    }

    .icon-do{
        float: right;
        font-size: 25px;
        color: #5FB878;
    }

    .icon-noDo{
        float: right;
        font-size: 25px;
        color: #FF5722;
    }

    /* 设置排行榜样式 */
    .user-list {
        list-style: none;
        padding: 0;
        margin: 0;
        width: 300px;
    }
    .user-list li {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px;
        background-color: #f5f5f5;
        border-radius: 10px;
        margin-bottom: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        font-size: 18px;
        font-weight: bold;
    }
    .user-list li:nth-child(odd) {
        background-color: #e5e5e5;
    }
    .user-list li span {
        margin-left: 10px;
        font-size: 16px;
        font-weight: normal;
        color: #666;
    }

    /* 设置前三名的样式 */
    .user-list li:nth-child(1) {
        background-color: #ffd700;
    }
    .user-list li:nth-child(1) span:first-child::before {
        content: "🥇";
        margin-right: 10px;
    }
    .user-list li:nth-child(2) {
        background-color: #c0c0c0;
    }
    .user-list li:nth-child(2) span:first-child::before {
        content: "🥈";
        margin-right: 10px;
    }
    .user-list li:nth-child(3) {
        background-color: #cd7f32;
    }
    .user-list li:nth-child(3) span:first-child::before {
        content: "🥉";
        margin-right: 10px;
    }


</style>
<body>
<div style="display: inline-block; width: 60%" >
    <div class="layui-panel" style="margin-left: 50px; width: 85%; top: 50px ; line-height: 24px">
        <div style="padding: 10px 20px;">
            <p style="font-family: 'Adobe 宋体 Std L'; font-size: 16px; font-weight: bold;text-align: center; margin-bottom: 10px">系统公告</p>
            <p style="font-family: 'Adobe 宋体 Std L'; font-size: 15px;">${notice.title}</p>
            <pre>${notice.content}</pre>
        </div>
    </div>
    <div>
        <div style="width: 35%; margin-top: 60px;margin-left: 45px; display: inline-block;vertical-align: top;">
            <p style="font-family: 'Adobe 宋体 Std L'; font-size: 16px; font-weight: bold;text-align: center; margin-bottom: 10px">学习待办</p>
            <ul class="todo-list">
                <c:if test="${empty studyPlanList}">
                    <li> </li>
                    <li> </li>
                    <li> </li>
                    <li> </li>
                </c:if>
                <c:if test="${not empty studyPlanList}">
                    <c:forEach var="studyPlan" items="${studyPlanList}">
                        <li>${studyPlan.content}<i class="far fa-square icon-noDo" data-index="${studyPlan.id}" onclick="finish(${studyPlan.id})"></i></li>
                    </c:forEach>
                </c:if>
                <%--            <li>${studyPlan.content}<i class="far fa-check-square icon-do" onclick=""></i></li>--%>
                <%--            <li>${studyPlan.content}<i class="far fa-square icon-noDo"></i></li>--%>
            </ul>
        </div>
        <div style="width: 50%; margin-top: 60px;margin-left: 10px; display: inline-block;vertical-align: top;">
            <p style="font-family: 'Adobe 宋体 Std L'; font-size: 16px; font-weight: bold;text-align: center; margin-bottom: 10px">考试待办</p>
            <ul class="todo-list">
                <c:if test="${empty examTimeList}">
                    <li> </li>
                    <li> </li>
                    <li> </li>
                    <li> </li>
                </c:if>
                <c:if test="${not empty examTimeList}">
                    <c:forEach var="examTime" items="${examTimeList}">
                        <li>${examTime.examName}<span data-index="${examTime.id}" class="countdown icon-do" style="font-size: 16px" data-time="${examTime.examTime}"></span></li>
                    </c:forEach>
                </c:if>
            </ul>
        </div>
    </div>
</div>

<%--排行榜--%>
<div style=" margin-top: 30px;margin-left: 50px;vertical-align: top;display: inline-block">
    <p style="font-family: 'Adobe 宋体 Std L'; font-size: 16px; font-weight: bold;text-align: center; margin-bottom: 10px">学习排行榜</p>
    <ul class="user-list">
        <c:if test="${empty userList}">
            <li> </li>
            <li> </li>
            <li> </li>
            <li> </li>
        </c:if>
        <c:if test="${not empty userList}">
            <c:forEach var="user" items="${userList}">
<%--                <c:set var="hours" value="${int(user.studyTime div 3600)}" />--%>
                <fmt:formatNumber value="${(user.studyTime div 3600)}" pattern="#0" var="hours"></fmt:formatNumber>
                <c:set var="minutes" value="${(user.studyTime mod 3600) div 60}" />
                <li>${user.userName}<span>${hours}小时${minutes}分钟</span></li>
            </c:forEach>
        </c:if>
    </ul>
</div>
<script>



    function finish(studyPlanId) {
        $.ajax({
            url: '/user/finishStudyPlanById',
            method: 'POST',
            data:{
                id: studyPlanId
            },
            success: function (result) {
                if(result.code == 200){
                    var comment = $('[data-index="' + studyPlanId + '"]');
                    comment.removeClass('fa-square');
                    comment.removeClass('icon-noDo');
                    comment.addClass('fa-check-square');
                    comment.addClass('icon-do');
                }else {
                    layer.msg(result.message);
                }
            }
        });
    }

    layui.use('util', function(){
        var util = layui.util;
        //倒计时
        var thisTimer, setCountdown = function(id,time){
            console.log("time==" + time);
            var endTime = time //结束日期
                ,serverTime = new Date(); //假设为当前服务器时间，这里采用的是本地时间，实际使用一般是取服务端的

            clearTimeout(thisTimer);
            util.countdown(endTime, serverTime, function(date, serverTime, timer){
                var str = date[0] + '天' + date[1] + '时' +  date[2] + '分' + date[3] + '秒';
                $('[data-index="' + id + '"]').html(str);
                thisTimer = timer;
            });
        };

        <%--// 选择所有需要绑定load事件的元素--%>
        <%--const elements = document.querySelectorAll('[data-index="' + ${studyStatus.id} + '"]');--%>

        <%--// 遍历所有元素，将countdown(time)函数绑定到它们的load事件上--%>
        <%--elements.forEach((element) => {--%>
        <%--    element.addEventListener('load', function() {--%>
        <%--        setCountdown(element.dataset.time,element.dataset.index); // 在每个元素加载完成后自动执行countdown(time)函数--%>
        <%--    });--%>
        <%--});--%>
        window.onload = function() {
            // 选择所有具有class为"countdown"的元素
            const elements = document.querySelectorAll('.countdown');

            // 遍历所有元素，调用setCountdown(id, time)函数
            elements.forEach((element) => {
                const id = element.dataset.index;
                const time = element.dataset.time;
                setCountdown(id, time);
            });
        }


    });
</script>
</body>
</html>
