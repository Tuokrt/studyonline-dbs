<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/4
  Time: 1:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>index</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/pintuer.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<style>
    .buttonBg:hover{
        background-color: #5FB878;
    }
</style>
<body style="background-color:#ABCDEF;">
<div class="header bg-main">
    <div class="logo margin-big-left fadein-top">
        <h1 style="font-family:楷体; font-size: 20px">线上自习室系统后台</h1>
    </div>
    <div class="head-l" style="float: right; margin-right: 20px">
        <a class="button button-little buttonBg" href="${pageContext.request.contextPath}/admin/index" style="border-color: #97EBFD"><span class="icon-home"></span> 首页</a>
        &nbsp;&nbsp;<a class="button button-little buttonBg" href="${pageContext.request.contextPath}/admin/logout" style="border-color: #97EBFD"><span class="icon-power-off"></span> 退出</a>
    </div>
</div>
<div class="leftnav">
    <div>
        <div style="height: 60px; width: 60px; overflow: hidden; margin-left: 15px; margin-right:13px; margin-top: 13px;display: inline-block">
            <c:if test="${admin != null}">
                <img src="${admin.userAvatar}" style="height: 60px; width: 60px;border-radius: 50%;">
            </c:if>
            <c:if test="${admin == null}">
                <img src="user.webp" style="height: 60px; width: 60px;border-radius: 50%;">
            </c:if>
        </div>
        <div style="display: inline; position: relative">

            <div style="margin-top: 25px; display: inline-block; position: absolute; width: 90px">
                <c:if test="${admin == null}">
                    欢迎你！！
                </c:if>
                欢迎你！！
                <br>
                ${admin.userName}

            </div>
        </div>
        <hr>
    </div>
    <ul style="display:block">
        <li><a href="${pageContext.request.contextPath}/admin/noticePage" target="right"><span
                class="icon-caret-right"></span> 发布公告</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/checkStudyRoomPage" target="right"><span
                class="icon-caret-right"></span> 自习室审核</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/checkReportPage" target="right"><span
                class="icon-caret-right"></span> 举报审核</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/manageUserPage" target="right"><span
                class="icon-caret-right"></span> 用户管理</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/manageStudyRoomPage" target="right"><span
                class="icon-caret-right"></span> 自习室管理</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/manageStudyStatusPage" target="right"><span
                class="icon-caret-right"></span> 动态管理</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/manageCommentPage" target="right"><span
                class="icon-caret-right"></span> 评论管理</a></li>
    </ul>
</div>
<script type="text/javascript">
    $(function(){
        $(".leftnav h2").click(function(){
            $(this).next().slideToggle(200);
            $(this).toggleClass("on");
        })
        $(".leftnav ul li a").click(function(){
            $("#a_leader_txt").text($(this).text());
            $(".leftnav ul li a").removeClass("on");
            $(this).addClass("on");
        })
    });
</script>
<ul class="bread" style="background-color: #FFF">
    <li><a href="${pageContext.request.contextPath}/admin/index"><span target="right" class="icon-home" style="color: #333"> 首页</span></a></li>
    <li><span id="a_leader_txt" style="color: #333"></span></li>
</ul>
<div class="admin" style="padding: 0px">
    <iframe scrolling="auto" rameborder="0" src="${pageContext.request.contextPath}/admin/userDatePage" name="right" width="100%" height="100%"></iframe>
</div>
</body>
</html>
