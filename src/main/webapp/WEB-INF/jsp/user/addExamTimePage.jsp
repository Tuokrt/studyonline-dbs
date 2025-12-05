<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/25
  Time: 22:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>addExamTimePage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<%
    if (request.getAttribute("addSuccess") != null) {
        out.println("<script language='JavaScript'>alert('添加成功');window.location.href='/user/addExamTimePage'</script>");
        return;
    }
%>

<form class="layui-form" style="margin: 10px 250px" action="${pageContext.request.contextPath}/user/addExamTime">
    <input style="display: none" value="${user.id}" name="userId">
    <div class="layui-form-item">
        <label class="layui-form-label">考试名称</label>
        <div class="layui-input-block">
            <input type="text" name="examName" required  lay-verify="required" style="width: 273px" placeholder="请输入考试名称" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div style="display: inline-block" class="layui-form-item">
        <label class="layui-form-label " style="margin-bottom: 150px">考试时间</label>
        <input type="text" class="layui-input" name="examTime" style="display: none" id="examTime" required lay-verify="notnull">
    </div>
    <div class="layui-inline" style="margin-top: -46px; margin-left: -5px" id="test-n1"></div>
    <div class="layui-form-item" style="margin-top: 20px;margin-left: 50px">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo" id="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>
<script>
    layui.use('laydate', function() {
        var laydate = layui.laydate;
        laydate.render({
            elem: '#test-n1'
            ,position: 'static'
            ,done: function(value, date, endDate){
                console.log(value); //得到日期生成的值，如：2017-08-18
                //console.log(date); //得到日期时间对象：{year: 2017, month: 8, date: 18, hours: 0, minutes: 0, seconds: 0}
                //console.log(endDate); //得结束的日期时间对象，开启范围选择（range: true）才会返回。对象成员同上。
                $("#examTime").val(value);
            }
        });
    });

    $(function () {
//表单自定义验证
        var form =layui.form
        form.verify({
            notnull: function(value, item) { //value：表单的值、item：表单的DOM对象
                if (value == null || value == '') {
                    return '考试时间不能为空';
                }
                return false;
            }
        });
    })
//
//     $("#submit").click(function () {
//         if($("#examTime").value != null){
//             alert("111");
//             layer.msg("考试时间不能为空");
//         }
//     });

</script>
</body>
</html>
