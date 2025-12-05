<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/4
  Time: 16:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>userDatePage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
<%--    <script src="${pageContext.request.contextPath}/webjars/requirejs/2.3.6/require.min.js"></script>--%>
    <script src="${pageContext.request.contextPath}/webjars/chart.js/4.2.1/dist/chart.umd.js" charset="utf-8"></script>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>--%>
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body style="background-color: #F6F6F6">
<div class="layui-panel" style="margin-left: 50px; width: 40%; top: 75px ;float: left; line-height: 40px">
    <div style="padding: 20px 20px;">
        <p style="font-family: 'Adobe 宋体 Std L'; font-size: 16px; font-weight: bold;text-align: center">后台操作手册</p>
        管理员！您好！你可以在后台管理进行以下操作：<br>
        (1)发布公告：可编辑并发布公告到网站首页。<br>
        (2)自习室审核：可查看用户的自习室创建申请并是否同意创建。<br>
        (3)审核举报：可查看审核用户发起的举报并进行相应的处理。<br>
        (4)用户管理：可对用户进行经验清零、封号处理。<br>
        (5)自习室管理：可对自习室进行封禁处理。<br>
        (6)动态管理：可对违规动态进行删除。<br>
        (7)评论管理：可对违规评论进行删除。<br>
    </div>
</div>
<div style="float: left">
    <div style="margin: 38px 50px 50px 100px;color: #5FB878;font-weight: bold;font-family: 'Adobe 宋体 Std L';">
        <div style="top: 20px">
            注册用户数：<br><br>
            <span style="font-size: 25px;font-weight: bold; color: #000;margin-left: 30px;">${userCount}</span>
        </div>
    </div>
    <div style="margin: 180px 50px 50px 100px;color: #5FB878;font-weight: bold;font-family: 'Adobe 宋体 Std L';">
        <div style="top: 20px">
            自习室数量：<br><br>
            <span style="font-size: 25px;font-weight: bold; color: #000;margin-left: 30px;">${studyRoomCount}</span>
        </div>
    </div>
</div>
<div style="display: inline-block;margin-top: 30px">
    <div style="width: 250px; height: 250px; ">
        <canvas id="userCount" ></canvas>
    </div>
    <div style="width: 250px; height: 250px; ">
        <canvas id="studyRoomCount" ></canvas>
    </div>
</div>



<script>
    <%--import Chart from '${pageContext.request.contextPath}/webjars/chart.js/4.2.1/dist/chart.js';--%>
    <%--require.config({--%>
    <%--    paths: {--%>
    <%--        'chart': '${pageContext.request.contextPath}/webjars/chart.js/4.2.1/dist/chart'--%>
    <%--    }--%>
    <%--});--%>
    // require(['chart'], function(Chart) {

    // 配置选项
    // options: {}

    //图表数据
    userData = {
        datasets: [
            {
                data: [${man}, ${woman}, ${secrecy}]
            }
        ],

        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: ["男", "女", "保密"]
    };
    //用户人数表
    var userCount = document.getElementById("userCount");
    // 饼形图
    var myPieChart = new Chart(userCount, {
        type: "pie",
        data: userData,
        options: {}
    });


    //图表数据
    studyRoomData = {
        datasets: [
            {
                data: [${openRoom}, ${closeRoom}]
            }
        ],

        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: ["已开启", "未开启"]
    };
    //自习室个数表
    var studyRoomCount = document.getElementById("studyRoomCount");
    // 饼形图
    var myPieChart = new Chart(studyRoomCount, {
        type: "pie",
        data: studyRoomData,
        options: {}
    });

    // });

</script>
</body>
</html>
