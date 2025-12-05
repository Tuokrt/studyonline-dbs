<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/23
  Time: 13:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<button class="layui-btn layui-btn-primary" style="color: #5FB878; margin-left: 230px; margin-top: -40px; border: #FFFFFF; border-right-color: darkgray; font-size: 19px">密码登录</button>
<div style="width: 1px;height: 20px;background: #e3e5e7;border-radius: 8px;margin: 40px -10px 15px 0px; display: inline-block" ></div>
<button class="layui-btn layui-btn-primary register" style="margin-left: 10px; margin-top: -40px; border: #FFFFFF; font-size: 19px" >短信登录</button>
<form class="layui-form layui-form-pane" id="loginForm" style="margin-left: 200px; margin-top: 25px">
    <div class="layui-form-item">
        <label class="layui-form-label">账号</label>
        <div class="layui-input-inline">
            <input type="text" name="cellPhone" required  lay-verify="required" placeholder="请输入账号" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">密码</label>
        <div class="layui-input-inline">
            <input type="password" name="userPassword" required lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block" style="margin-left: 70px">
            <button class="layui-btn" lay-submit lay-filter="formDemo">登录</button>
            <button type="button" class="layui-btn layui-btn-primary register">注册</button>
        </div>
    </div>
</form>
<script>
    $(".register").click(function () {
        var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
        parent.layer.close(index); //再执行关闭
        var index = parent;
        parent.layer.open({
            type: 2,
            title: '线上自习室欢迎你！请注册...',
            shadeClose: true,
            shade: false,
            move:false,
            //maxmin: true, //开启最大化最小化按钮
            area: ['700px', '400px'],
            content: 'user/registerPage',
            cancel: function () {
                // location.href = '/';
                // $(".layui-nav-item").removeClass("layui-nav-itemed");
                // window.location.reload();
                // window.opener.location.reload();
                index.location.reload();
            }
        });
    })

    $('#loginForm').submit(function(e) {
        e.preventDefault();
        var cellPhone = $('input[name="cellPhone"]').val();
        var userPassword = $('input[name="userPassword"]').val();
        $.ajax({
            url: '<%=request.getContextPath()%>/user/login',
            type: 'POST',
            data: {cellPhone: cellPhone, userPassword: userPassword},
            success: function(result) {
                if (result.code == 200) {
                    layer.msg("登录成功");
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    parent.parent.location.reload();
                } else if(result.code == 2){
                    alert('你还没设置密码，请使用短信登录！')
                } else if(result.code == 1){
                    alert("用户不存在，请先注册");
                } else if(result.code == 3){
                    alert("你已被封禁，封禁剩余" + result.message + "天");}
                else {
                    alert('密码错误！请重试');
                }
            }
        });
    });
</script>
</body>
</html>
