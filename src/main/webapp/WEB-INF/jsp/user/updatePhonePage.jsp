<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/1
  Time: 22:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>updatePhonePage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<i class="layui-icon layui-icon-vercode" style="color: #5FB878; font-size: 18px; margin-left: 200px; margin-top: 20px;" ></i>
<div class="layui-btn layui-btn-primary" style="color: #5FB878;margin-left: -16px; margin-top: -3px; border: #FFFFFF; border-right-color: #a9a9a9; font-size: 19px" >验证身份</div>
<div style="width: 60px;height: 2px;background: #e3e5e7;border-radius: 8px;margin: 60px -10px 5px 0px; display: inline-block" ></div>
<i class="layui-icon layui-icon-cellphone" style="font-size: 18px; margin-left: 27px; margin-top: -40px;" ></i>
<div class="layui-btn layui-btn-primary" style="margin-left: -16px; margin-top: -3px; border: #FFFFFF; font-size: 19px">绑定手机</div>
<form class="layui-form layui-form-pane" id="authenticationForm" style="margin-left: 180px; margin-top:45px">
    <div class="layui-form-item">
        <label class="layui-form-label">手机号</label>
        <div class="layui-input-inline">
            <input type="text" name="cellPhone" id="cellPhone" disabled autocomplete="off" class="layui-input" value="${user.cellPhone}">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">验证码</label>
        <div class="layui-input-inline">
            <input type="text" name="authCode" required lay-verify="required" placeholder="请输入验证码" autocomplete="off" class="layui-input">
        </div>
        <div>
            <input type="button" class="layui-btn layui-btn-primary layui-border-green" id="authCode" value="获取验证码"></input>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo" id="nextStep">下一步</button>
        </div>
    </div>
</form>

<%--//验证码--%>
<script>

    function test(o) {
        const tel = document.getElementById("cellPhone").value;
        if (!(/^1[3|5|7|8][0-9]\d{4,8}$/.test(tel))) {
            alert("手机号格式不正确");
            document.mobileform.tel.focus();
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
            o.value = "重新发送(" + wait + ")s";
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

        $.post("authCode?cellPhone=" + cellPhone);
        // var request = new XMLHttpRequest();
        // request.open("POST","authCode?cellPhone=" + cellPhone);
    }

    document.getElementById("authCode").onclick = function () {
        test(this);
    }
</script>

<%--//ajax发送注册表单数据--%>
<script>

    $('#authenticationForm').submit(function(e) {
        e.preventDefault();
        var cellPhone = $('input[name="cellPhone"]').val();
        var authCode = $('input[name="authCode"]').val();
        $.ajax({
            url: '<%=request.getContextPath()%>/user/authentication',
            type: 'POST',
            data: {authCode: authCode,cellPhone: cellPhone},
            success: function(data) {
                if (data == 'success') {
                    layer.msg("验证成功");
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    parent.layer.open({
                        type: 2,
                        title: '绑定手机',
                        shadeClose: true,
                        shade: false,
                        move:false,
                        scrollbar: false,
                        //maxmin: true, //开启最大化最小化按钮
                        area: ['700px', '450px'],
                        offset: '0px',
                        content: 'updatePhoneNextPage'
                    });
                } else {
                    alert('验证码错误！');
                }
            }
        });
    });
</script>

</body>
</html>
