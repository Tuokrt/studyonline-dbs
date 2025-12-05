<%@ page import="com.wyu.studyonline.pojo.StudyRoom" %>
<%@ page import="com.wyu.studyonline.pojo.User" %>
<%@ page import="java.util.Vector" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/6
  Time: 0:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>startMyStudyRoom</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            position: relative;
        }

        .subscribe-live-item {
            float: left;
            overflow: hidden;
            box-sizing: border-box;
            margin: 0 20px 30px 20px;
            padding-bottom: 11px;
            font-size: 12px;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
            list-style: none;
            backface-visibility: hidden;

        }
        /*.subscribe-live-item .pic {*/
        /*    overflow: hidden;*/
        /*    position: relative;*/
        /*    max-width: none;*/
        /*    width: 100%;*/
        /*    border-top-left-radius: 6px;*/
        /*    border-top-right-radius: 6px;*/
        /*}*/

        #message {
            background-color: #fff;
            border-radius: 5px;
            border: darkgrey 1px solid;
            padding: 10px;
            margin-top: -35px;
            overflow-y: scroll;
            max-height: 350px;
        }

        input[type=text] {
            width: 200px;
            padding: 5px;
            font-size: 16px;
            border-radius: 5px;
            margin-right: 10px;
        }

        .none{
            display: none!important;
        }

        .right{
            position: absolute;
            width: 35%;
            left: 60%;
            height: 380px;
        }
        .left{
            position: absolute;
            display: inline-block;
            width: 60%;
            height: 380px;

        }

        /* 我的消息样式 */
        .my-message {
            background-color: #5FB878;
            padding: 5px 10px;
            border-radius: 5px;
            margin: 2px 0;
            float: right;
            clear: both;
            white-space: pre-wrap; /* 使用pre-wrap属性控制文本换行 */
        }

        /* 成员消息样式 */
        .member-message {
            background-color: #E0E0E0;
            padding: 5px 10px;
            border-radius: 5px;
            margin: 2px 0;
            float: left;
            clear: both;
            white-space: pre-wrap; /* 使用pre-wrap属性控制文本换行 */
        }

        /* 系统消息样式 */
        .system-message {
            font-style: italic;
            color: #999;
            margin: 5px 0;
            text-align: center;
            clear: both; /* 添加clear:both属性 */
        }

        .timeSelect{
            display: inline-block;
            position: absolute;
            margin-left: 120px;
        }
        span{
            font-size: 14px;
        }
    </style>
</head>
<body>
<%
    StudyRoom studyRoom = (StudyRoom)session.getAttribute("studyRoom");
    Vector<User> userVector = (Vector<User>) session.getAttribute("userVector");
    User user = (User) session.getAttribute("user");
//    Object joinStudyRoomId = ;
//    int joinStudyRoomIdInt = (Integer) joinStudyRoomId;
%>

<div style="margin-left: 10px">
<%--    <button onclick="create(${user.getId()})" class="layui-btn layui-btn-primary layui-border-blue" id="open">开启自习室</button>--%>
    <button onclick="closeWebSocket()" style="margin-left: 0px" class="layui-btn layui-btn-primary layui-border-orange" id="close">关闭自习室</button>
    <div class="timeSelect">
        <div id="timeSelect">
<%--            <div class="layui-input-inline">--%>
                <input type="text" readonly class="layui-input" id="studyTime" placeholder="选择学习时间" style="width: 150px;">
                <input type="text" style="display: none" id="hours">
                <input type="text" style="display: none" id="minutes">
                <input type="text" style="display: none" id="seconds" class="layui-input" required lay-verify="notnull">
                <button onclick="startStudy()" class="layui-btn layui-btn-radius layui-btn-normal" style="display: inline-block;position: absolute;margin-left: 180px;margin-top: -40px;border-radius: 10px">开始学习</button>
<%--            </div>--%>
        </div>
        <div class="none layui-input-block" id="studyCount" style="margin-left: 10px">
            <label class="layui-form-label">学习倒计时</label>
            <div style="display: inline-block; font-size: 14px; font-weight: bold; color: #333; padding: 10px 20px; border: 2px solid #ccc; border-radius: 6px;width: 80px;height: 18px;line-height: 18px" id="timer"></div>
        </div>
    </div>


</div>

<div id="left" class="left"></div>
<div class="right">
    <div id="message" style="height: 350px"></div>

    <div style="margin-top: 20px;">
        <label for="text">发送消息：</label>
        <input id="text" type="text"/>
        <button onclick="send()" id="sendMsg" class="layui-btn layui-btn-primary layui-border-blue" style="border-radius: 5px;height: 30px;line-height: 30px">发送</button>
    </div>
</div>
</body>
<script type="text/javascript">
//时间选择器
    layui.use('laydate', function() {
        var laydate = layui.laydate;
        laydate.render({
            elem: '#studyTime'
            ,type: 'time'
            ,done: function(value, date, endDate){
                console.log(value); //得到日期生成的值，如：2017-08-18
                //console.log(date); //得到日期时间对象：{year: 2017, month: 8, date: 18, hours: 0, minutes: 0, seconds: 0}
                //console.log(endDate); //得结束的日期时间对象，开启范围选择（range: true）才会返回。对象成员同上。
                //$("#examTime").val(value);
                console.log(date.hours);
                console.log(date.minutes);
                console.log(date.seconds);
                $("#hours").val(date.hours);
                $("#minutes").val(date.minutes);
                $("#seconds").val(date.seconds);

                //给成员发送学习时间
                var time = JSON.stringify({
                    type: "time",
                    userId: <%=user.getId()%>,
                    name: "<%=user.getUserName()%>",
                    content: date
                });
                websocket.send(time);
            }
        });
    });

    function startStudy() {
        if($("#seconds").val() == null || $("#seconds").val() == ''){
            alert("学习时间不能为空");
        }else {
            //给成员发送开始学习信号
            var start = JSON.stringify({
                type: "start",
                userId: <%=user.getId()%>,
                name: "<%=user.getUserName()%>",
                content: "系统消息：学习中，全员禁言！"
            });
            websocket.send(start);
            $("#timeSelect").addClass("none");
            $("#studyCount").removeClass("none");
            var messageInput = $("#text");
            // 设置输入框为只读
            messageInput.prop('readonly', true);
            // 设置输入框的提示信息
            messageInput.attr('placeholder', '正在学习中，不能发言');
            $("#sendMsg").prop('disabled',true);
            // 目标时间（以毫秒为单位）
            var studyTime = 60 * 60 * 1000 * $("#hours").val() + 60 * 1000 * $("#minutes").val() + 1000 * $("#seconds").val();
            var targetTime = new Date().getTime() + studyTime;
            // 更新并显示剩余时间
            var timer = setInterval(function() {
                var now = new Date().getTime();
                var remainingTime = targetTime - now; // 剩余毫秒数

                var minutes = Math.floor((remainingTime % (1000 * 60 * 60)) / (1000 * 60)); // 分钟
                var seconds = Math.floor((remainingTime % (1000 * 60)) / 1000); // 秒数

                // 输出倒计时
                document.getElementById("timer").innerHTML = minutes + " 分钟 " + seconds + " 秒";

                // 如果计时结束，清除定时器并输出提示
                if (remainingTime < 0) {
                    clearInterval(timer);
                    document.getElementById("timer").innerHTML = "";
                    $("#timeSelect").removeClass("none");
                    $("#studyCount").addClass("none");
                    var messageInput = $("#text");
                    messageInput.prop('readonly', false);
                    // 设置输入框的提示信息
                    messageInput.attr('placeholder', '');
                    $("#sendMsg").prop('disabled',false);
                    setSystemMessageInnerHTML("系统消息：学习结束！禁言结束！");
                    $("#studyTime").val("");
                    var endStudy = JSON.stringify({
                        type: "endStudy",
                        userId: <%=user.getId()%>,
                        name: "<%=user.getUserName()%>",
                        content: "系统消息：学习结束！禁言结束！"
                    });
                    websocket.send(endStudy);
                    $.ajax({
                        url: '<%=request.getContextPath()%>/user/addStudyTime',
                        type: 'POST',
                        data: {userId: <%=user.getId()%>, hour: $("#hours").val(), min: $("#minutes").val(), sec: $("#seconds").val()},
                        success: function(data) {
                            if (data == 'success') {
                                console.log("学习时间存储成功");
                            } else {
                                console.log("学习时间存储失败");
                            }
                        }
                    });
                }
            }, 1000);
        }

    }

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

    var html = "";

    function create(userId) {
        //判断当前浏览器是否支持WebSocket
        if ('WebSocket' in window) {
            //改成你的地址
            socketPath = "ws://" + location.host + "${pageContext.request.contextPath}" + "/studyRoom/" + "<%=studyRoom.getId()%>/" + userId;
            websocket = new WebSocket(socketPath);
            init(websocket);
            // setSystemMessageInnerHTML(userId + "连接成功");
            setSystemMessageInnerHTML("系统消息：成功开启自习室！");
            html = "";
            $("#left").html(html);
            return websocket;
        } else {
            alert('当前浏览器 Not support websocket')
        }
    }



    function init(websocket){
        //连接发生错误的回调方法
        websocket.onerror = function () {
            setSystemMessageInnerHTML("连接自习室发生错误");
        };

        //连接成功建立的回调方法
        websocket.onopen = function () {
            //websocket.send("连接成功");
            var msg = JSON.stringify({
                type: "user",
                userId: <%=user.getId()%>,
                name: "<%=user.getUserName()%>",
                content: "<%=user.getUserAvatar()%>"
            });
            websocket.send(msg);
            //setSystemMessageInnerHTML("WebSocket连接成功");
        }
        //接收到消息的回调方法
        websocket.onmessage = function (event) {
            console.log(event);
            var res = JSON.parse(event.data);
            switch(res.type){
                case "user":
                    html += '<li class="subscribe-live-item">\n' +
                        ' <a>\n' +
                        ' <img src="' + res.content + '" style="width: 60px;height: 60px;border-radius: 50%;overflow: hidden;margin-top: 5px;" class="pic" alt="用户头像" title="双击踢出房间" ondblclick="kickOut('+ res.userId +')">\n' +
                        ' </a>\n' +
                        ' <div>\n' +
                        ' <p><a cursor="pointer" style="display: block;text-align: center">' + res.name + '</a></p>\n' +
                        ' </div>\n' +
                        '</li>';
                    $("#left").html(html);

                    break;
                case "msg":
                    if(res.userId == <%=user.getId()%>){
                        setMyMessageInnerHTML(res.content)
                    }else {
                        setMemberMessageInnerHTML(res.name + "：" + res.content);
                    }

                    break;
                case "sysMsg":
                    setSystemMessageInnerHTML(res.content);
                    break;
                case "quit":
                    html = "";
                    $("#left").html(html);
                    break;
                case "start":
                    setSystemMessageInnerHTML(res.content);
                    break;
                case "ban":
                    parent.layer.msg("自习室已被封禁！");
                    closeWebSocket();
                    break;

            }



        }

        //连接关闭的回调方法
        websocket.onclose = function () {

            setSystemMessageInnerHTML("室长关闭了自习室！");

        }

        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
        // window.onbeforeunload = function () {
        //     console.log("你关闭了此子页面");
        //     closeWebSocket();
        // }

        window.addEventListener("unload", function(event) {
            //parent.alert()
            //更新自习室状态
            parent.$.ajax({
                url: '/user/closeStudyRoom',
                type: 'POST',
                data: {userId: <%=user.getId()%>},
                success: function(data) {
                    console.log(data);
                    if (data == 'success') {
                        console.log("success");
                    } else {
                        alert('closeStudyRoom请求失败');
                    }
                },
                error: function(xhr, status, error) {
                    // 请求失败的回调函数
                    console.log("closeStudyRoom请求失败");
                }
            });
            var close = JSON.stringify({
                type: "close",
                userId: <%=user.getId()%>,
                name: "<%=user.getUserName()%>",
                content: "close"
            });
            websocket.send(close);
            console.log("closeWebSocket执行中");
            setSystemMessageInnerHTML("室长关闭了自习室！");
            websocket.onclose = function() {
                console.log("WebSocket已关闭");
            };
            websocket.close();
        });
    }

    //将成员消息显示在网页上
    function setMemberMessageInnerHTML(innerHTML) {
        //document.getElementById('message').innerHTML += innerHTML + '<br/>';
        var innerHTMLFilter = filterString(innerHTML);
        var chatbox = document.getElementById("message");
        var messageDiv = document.createElement("div");
        messageDiv.className = "member-message";
        messageDiv.innerHTML = innerHTMLFilter;
        chatbox.appendChild(messageDiv);
        chatbox.appendChild(document.createElement("div")); // 添加一个清除浮动的元素
    }

    //将我的消息显示在网页上
    function setMyMessageInnerHTML(innerHTML) {
        //document.getElementById('message').innerHTML += innerHTML + '<br/>';
        var innerHTMLFilter = filterString(innerHTML);
        var chatbox = document.getElementById("message");
        var messageDiv = document.createElement("div");
        messageDiv.className = "my-message";
        messageDiv.innerHTML = innerHTMLFilter;
        chatbox.appendChild(messageDiv);
        chatbox.appendChild(document.createElement("div")); // 添加一个清除浮动的元素
    }

    //将系统消息显示在网页上
    function setSystemMessageInnerHTML(innerHTML) {
        //document.getElementById('message').innerHTML += innerHTML + '<br/>';
        var chatbox = document.getElementById("message");
        var messageDiv = document.createElement("div");
        messageDiv.className = "system-message";
        messageDiv.innerHTML = innerHTML;
        chatbox.appendChild(messageDiv);
        chatbox.appendChild(document.createElement("div")); // 添加一个清除浮动的元素
    }

    // 过滤输入字符串中的特殊字符
    function filterString(str) {
        str = str.replace(/&/g, "&amp;");
        str = str.replace(/</g, "&lt;");
        str = str.replace(/>/g, "&gt;");
        str = str.replace(/"/g, "&quot;");
        str = str.replace(/'/g, "&#39;");
        return str;
    }

    //关闭WebSocket连接
    function closeWebSocket() {
//更新自习室状态
        $.ajax({
            url: '/user/closeStudyRoom',
            type: 'POST',
            data: {userId: <%=user.getId()%>},
            success: function(data) {
                console.log(data);
                if (data == 'success') {
                    console.log("success");
                } else {
                    alert('创建失败！请重试');
                }
            }
        });
        var close = JSON.stringify({
            type: "close",
            userId: <%=user.getId()%>,
            name: "<%=user.getUserName()%>",
            content: "close"
        });
        websocket.send(close);
        console.log("closeWebSocket执行中");
        setSystemMessageInnerHTML("室长关闭了自习室！");
        location.href='/user/myStudyRoomPage';
        websocket.close();


    }

    //发送消息
    function send() {
        var message = document.getElementById('text').value;
        document.getElementById('text').value="";
        var msg = JSON.stringify({
            type: "msg",
            userId: <%=user.getId()%>,
            name: "<%=user.getUserName()%>",
            content: message
        });
        websocket.send(msg);

    }

    // 给输入框添加事件监听器（回车发送消息）
    $('#text').keypress(function(event) {
        // 检测用户是否按下了回车键
        if (event.keyCode == 13) {
            // 阻止默认的回车键行为，避免换行
            event.preventDefault();
            // 触发发送消息的函数
            send();
        }
    });

    //踢出用户
    function kickOut(userId){
        var kickOut = JSON.stringify({
            type: "kickOut",
            userId: userId,
            name: "kickOut",
            content: "kickOut"
        });
        websocket.send(kickOut);
    }



    $(function () {
        create(<%=user.getId()%>)
    })


</script>
</html>
