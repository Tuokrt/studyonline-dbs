<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/25
  Time: 0:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>addStudyPlan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<%
    if (request.getAttribute("addSuccess") != null) {
        out.println("<script language='JavaScript'>alert('添加成功');window.location.href='/user/addStudyPlanPage'</script>");
        return;
    }
%>

<form class="layui-form" style="margin: 100px 100px" action="${pageContext.request.contextPath}/user/addStudyPlan">
    <input style="display: none" value="${user.id}" name="userId">
    <div class="layui-form-item">
        <label class="layui-form-label">待办内容</label>
        <div class="layui-input-block">
            <input type="text" name="content" required  lay-verify="required" style="width: 500px" placeholder="请输入待办内容" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>
</body>
</html>
