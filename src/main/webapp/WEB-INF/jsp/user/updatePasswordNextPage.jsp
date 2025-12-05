<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/3
  Time: 22:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>updatePasswordPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<i class="layui-icon layui-icon-vercode" style="font-size: 18px; margin-left: 200px; margin-top: 20px;" ></i>
<div class="layui-btn layui-btn-primary" style="margin-left: -16px; margin-top: -3px; border: #FFFFFF; border-right-color: #a9a9a9; font-size: 19px" >验证身份</div>
<div style="width: 60px;height: 2px;background: #e3e5e7;border-radius: 8px;margin: 60px -10px 5px 0px; display: inline-block" ></div>
<i class="layui-icon layui-icon-password" style="color: #5FB878;font-size: 18px; margin-left: 27px; margin-top: -40px;" ></i>
<div class="layui-btn layui-btn-primary" style="color: #5FB878;margin-left: -16px; margin-top: -3px; border: #FFFFFF; font-size: 19px">修改密码</div>
<form class="layui-form layui-form-pane" id="authenticationNextForm" style="margin-left: 180px; margin-top:45px">
    <div class="layui-form-item">
        <label class="layui-form-label">新的密码</label>
        <div class="layui-input-inline">
            <input type="password" name="userPassword" id="userPassword" required lay-verify="required" autocomplete="off" placeholder="请输入内容" class="layui-input" >
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">确认密码</label>
        <div class="layui-input-inline">
            <input type="password" name="ensurePassword" id="ensurePassword" required lay-verify="required|ensurePassword" placeholder="请输入内容" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo" type="submit">提交</button>
        </div>
    </div>
</form>

<script>
    layui.use(['form'], function () {
        var form = layui.form;
        form.verify({
            ensurePassword: function (value, item) { //value：表单的值、item：表单的DOM对象
                if (value != $("#userPassword").val()) {
                    alert("两次密码不一致");
                    return true;
                }
            }
        });
    });

    $('#authenticationNextForm').submit(function(e) {
        e.preventDefault();
        var userPassword = $('input[name="userPassword"]').val();
        $.ajax({
            url: '<%=request.getContextPath()%>/user/authenticationNext',
            type: 'POST',
            data: {userPassword: userPassword,userId : ${user.id}},
            success: function(data) {
                if (data == 'success') {
                    layer.msg("修改成功");
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    parent.parent.location.reload();
                } else {
                    alert('修改失败！请重试');
                }
            }
        });
    });
</script>
</body>
</html>
