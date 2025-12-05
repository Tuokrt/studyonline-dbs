<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/3
  Time: 23:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>loginPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<style>
    body {
        background-image: linear-gradient(to bottom, #97EBFD 50%, #FFF 50%);
    }

    .none{
        display: none;
    }
</style>
<body>
<div style="width: 270px;margin: 90px auto;color: #FFF;font-size: 30px">
<p>线上自习室系统后台</p>
</div>
<div style="width: 400px;height: 250px;margin: auto auto;background-color: #FFF;box-shadow: 0 0 5px rgba(0, 0, 0, 0.5);">
    <button class="layui-btn layui-btn-primary" style="color: #5FB878; margin-left: 82px; margin-top: -40px; border: #FFFFFF; border-right-color: darkgray; font-size: 19px" id="passwordLogin">密码登录</button>
    <div style="width: 1px;height: 20px;background: #e3e5e7;border-radius: 8px;margin: 40px -10px 15px 0px; display: inline-block" ></div>
    <button class="layui-btn layui-btn-primary register" style="margin-left: 10px; margin-top: -40px; border: #FFFFFF; font-size: 19px" id="cellPhoneLogin">短信登录</button>
    <form class="layui-form layui-form-pane" id="passwordForm" style="margin-left: 84px; margin-top: 10px">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 80px">账号</label>
            <div class="layui-input-inline">
                <input type="text" name="cellPhone" required  lay-verify="required" style="width: 150px" placeholder="请输入账号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 80px">密码</label>
            <div class="layui-input-inline">
                <input type="password" name="userPassword" required lay-verify="required" style="width: 150px" placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-left: 75px">
                <button class="layui-btn" lay-submit lay-filter="formDemo" style="width: 100px">登录</button>
            </div>
        </div>
    </form>

    <form class="layui-form layui-form-pane none" id="cellPhoneForm" name="cellPhoneForm" style="margin-left: 84px; margin-top: 10px;">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 80px">手机号</label>
            <div class="layui-input-inline">
                <input type="text" name="cellPhoneCode" id="cellPhone" required  lay-verify="required" style="width: 150px" placeholder="请输入手机号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 80px">验证码</label>
            <div class="layui-input-inline" style="width: 150px">
                <input type="text" name="authCode" required lay-verify="required" style="width: 150px" placeholder="请输入验证码" autocomplete="off" class="layui-input">
            </div>
            <div>
                <input type="button" class="layui-btn layui-btn-primary layui-border-green " id="authCode" style="padding: 0px 2px;margin-left: -5px;width: 75px" value="获取验证码">
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-left: 75px">
                <button class="layui-btn" lay-submit lay-filter="formDemo" style="width: 100px">登录</button>
            </div>
        </div>
    </form>
</div>
<script>
    $("#cellPhoneLogin").click(function () {
        $("#passwordForm").addClass("none");
        $("#cellPhoneForm").removeClass("none");
    });

    $("#passwordLogin").click(function () {
        $("#cellPhoneForm").addClass("none");
        $("#passwordForm").removeClass("none");
    });

    //密码登录
    $('#passwordForm').submit(function(e) {
        e.preventDefault();
        var cellPhone = $('input[name="cellPhone"]').val();
        var userPassword = $('input[name="userPassword"]').val();
        $.ajax({
            url: '<%=request.getContextPath()%>/admin/passwordLogin',
            type: 'POST',
            data: {cellPhone: cellPhone, userPassword: userPassword},
            success: function(result) {
                if (result.code == 200) {
                    layer.msg("登录成功");
                    // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    // parent.layer.close(index); //再执行关闭
                    // parent.parent.location.reload();
                    location.href = "/admin/index";
                } else if(result.message == 'nullPassword'){
                    alert('你还没设置密码，请使用短信登录！')
                } else if(result.message == 'nullUser'){
                    alert("该管理员不存在！");
                } else {
                    alert('密码错误！');
                }
            }
        });
    });
</script>
<%--//ajax发送验证码表单数据--%>
<script>

    //验证码登录
    $('#cellPhoneForm').submit(function(e) {
        e.preventDefault();
        var cellPhone = $('input[name="cellPhoneCode"]').val();
        var authCode = $('input[name="authCode"]').val();
        console.log("cellPhone" + cellPhone);
        $.ajax({
            url: '<%=request.getContextPath()%>/admin/cellPhoneLogin',
            type: 'POST',
            data: {cellPhone: cellPhone, authCode: authCode},
            success: function(result) {
                if (result.code == 200) {
                    layer.msg("登录成功");
                    location.href = "/admin/index";
                } else if(result.message == 'nullUser'){
                    alert("该管理员不存在！");
                } else {
                    alert('验证码错误！');
                }
            }
        });
    });
</script>
<%--//验证码--%>
<script>

    function test(o) {
        const tel = document.getElementById("cellPhone").value;
        if (!(/^1[3|5|7|8][0-9]\d{4,8}$/.test(tel))) {
            alert("手机号格式不正确");
            document.cellPhoneForm.cellPhone.focus();
            return false;
        }
        sendSMS();
        time(o)
    }

    let wait = 60;
    function time(o) {

        if (wait === 0) {
            o.removeAttribute("disabled");
            o.value = "获取验证码";
            wait = 60;
        } else {
            o.setAttribute("disabled", true);
            o.value = "重发(" + wait + ")s";
            wait--;
            setTimeout(function () {
                    time(o)
                },
                1000)
        }
    }

    function sendSMS() {
        // const tmp = document.createElement("form");
        // tmp.target = "sendSMS"
        const cellPhone = document.getElementById("cellPhone").value;
        // console.log(cellPhone)
        // tmp.action = "authCode?cellPhone=" + cellPhone;
        // tmp.method = "post";
        // document.body.appendChild(tmp);
        // tmp.submit();
        // return tmp;

        $.post("user/authCode?cellPhone=" + cellPhone);
        // var request = new XMLHttpRequest();
        // request.open("POST","authCode?cellPhone=" + cellPhone);
    }

    document.getElementById("authCode").onclick = function () {
        test(this);
    }
</script>


</body>
</html>
