<%@ page import="com.wyu.studyonline.pojo.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wyu.studyonline.pojo.StudyRoom" %>
<%@ page import="com.wyu.studyonline.pojo.User" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/4
  Time: 1:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>joinStudyRoomPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.15.3/css/all.min.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
</head>
<style>
    .subscribe-live-item {
        float: left;
        overflow: hidden;
        box-sizing: border-box;
        width: 210px;
        margin: 0 20px 30px 0;
        padding-bottom: 11px;
        font-size: 12px;
        background: #f4f5f8;
        border-radius: 6px;
        box-shadow: 0 1px 2px rgba(0,0,0,.05);
        list-style: none;
        backface-visibility: hidden;
    }
    .subscribe-live-item .pic {
        overflow: hidden;
        position: relative;
        max-width: none;
        width: 100%;
        border-top-left-radius: 6px;
        border-top-right-radius: 6px;
    }

    .report{
        position: relative;
    }
    .report:hover::after {
        content: attr(title);
        background-color: #333;
        color: #fff;
        padding: 0px 8px;
        position: absolute;
        bottom: calc(100% + 5px);
        left: 50%;
        transform: translateX(-50%);
        border-radius: 5px;
    }
</style>
<body>
<%
    User user = (User) session.getAttribute("user");
%>
<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief" style="margin-top: -10px">
    <ul class="layui-tab-title">
        <li class="layui-this">全部</li>
        <%
            List<Category> categoryList = (List<Category>)session.getAttribute("categoryList");
            for(Category category : categoryList){

        %>

        <li><%=category.getName()%></li>

        <%
            }
        %>

    </ul>
    <div class="layui-tab-content" style="height: 100px;">
        <div class="layui-tab-item layui-show" style="padding-left: 75px">
            <%
                List<StudyRoom> studyRoomList = (List<StudyRoom>)session.getAttribute("studyRoomList");
                for(StudyRoom studyRoom : studyRoomList){

            %>

            <li class="subscribe-live-item">
                <a href="/user/memberStudyRoom?roomId=<%=studyRoom.getId()%>">
                    <img src="<%=studyRoom.getRoomCover()%>" style="width: 210px;height: 110px; " class="pic">
                </a>
                <div style="display: inline-block;">
                    <p><a href="/user/memberStudyRoom?roomId=<%=studyRoom.getId()%>"  cursor="pointer" style="display: block"><%=studyRoom.getRoomName()%></a></p>
                    <p><a href="/user/memberStudyRoom?roomId=<%=studyRoom.getId()%>"  cursor="pointer" style="display: block"><%=studyRoom.getRoomDescride()%></a></p>
                </div>
                <div style="display: inline-block;float: right">
                    <button title="举报" class="layui-btn layui-btn-primary layui-btn-sm report" style="border-color: #F4F5F8"  onclick="report(<%=studyRoom.getId()%>)"><i class="fa fa-exclamation-triangle" aria-hidden="true" style="color: #99a2aa"></i></button>
                </div>
            </li>

            <%
                    session.setAttribute("joinStudyRoomId",studyRoom.getId());
                }
            %>
        </div>
        <%
            for(int i = 0;i < categoryList.size();i++){
        %>
        <div class="layui-tab-item" style="padding-left: 75px">
        <%
                for(int j = 0;j < studyRoomList.size();j++){
                    StudyRoom studyRoom = studyRoomList.get(j);
                    if(studyRoom.getCategoryId() == categoryList.get(i).getId()){

        %>

            <li class="subscribe-live-item">
                <a href="/user/memberStudyRoom?roomId=<%=studyRoom.getId()%>">
                    <img src="<%=studyRoom.getRoomCover()%>" style="width: 210px;height: 110px; " class="pic">
                </a>
                <div style="display: inline-block;">
                    <p><a href="/user/memberStudyRoom?roomId=<%=studyRoom.getId()%>" cursor="pointer" style="display: block"><%=studyRoom.getRoomName()%></a></p>
                    <p><a href="/user/memberStudyRoom?roomId=<%=studyRoom.getId()%>" cursor="pointer" style="display: block"><%=studyRoom.getRoomDescride()%></a></p>
                </div>
                <div style="display: inline-block;float: right">
                    <button title="举报" class="layui-btn layui-btn-primary layui-btn-sm report" style="border-color: #F4F5F8"  onclick="report(<%=studyRoom.getId()%>)"><i class="fa fa-exclamation-triangle" aria-hidden="true" style="color: #99a2aa"></i></button>
                </div>
            </li>

        <%
                    }
                }
        %>
        </div>
        <%
            }
        %>

    </div>
</div>

<script>
    layui.use('util', function(){
        var util = layui.util;
        //固定块
        util.fixbar({
            bar1: false
            ,bar2: false
            ,showHeight: 30
            ,css: {right: 20, bottom: 20}
            ,bgcolor: '#9F9F9F'
            ,click: function(type){
                if(type === 'bar1'){
                    layer.msg('icon 是可以随便换的')
                } else if(type === 'bar2') {
                    layer.msg('两个 bar 都可以设定是否开启')
                }
            }
        });

    });

    //举报弹窗
    function report(studyRoomId){
        var reportType = 1;
        //iframe 层
        layer.open({
            type: 2,
            title: '我要举报！',
            shadeClose: true,
            shade: 0.8,
            area: ['390px', '90%'],
            offset: ['20px', '330px'],
            content: 'reportPage?reportType=' + reportType + '&beReportedId=' + studyRoomId//iframe的url
        });
    }

</script>
</body>
</html>
