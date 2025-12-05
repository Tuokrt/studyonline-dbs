<%@ page import="com.wyu.studyonline.pojo.StudyRoom" %>
<%@ page import="com.wyu.studyonline.pojo.User" %>
<%@ page import="java.util.Vector" %>
<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/14
  Time: 15:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>memberStudyRoom</title>
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
            display: none;
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
<%--    <button onclick="create(${user.getId()})" class="layui-btn layui-btn-primary layui-border-blue" id="join">加入自习室</button>--%>
    <button onclick="closeWebSocket()" style="margin-left: 0px" class="layui-btn layui-btn-primary layui-border-orange" id="out">退出自习室</button>
    <div class="timeSelect">
        <div id="timeSelect" style="display: none">
            <%--            <div class="layui-input-inline">--%>
<%--            <input type="text" readonly class="layui-input" id="studyTime" placeholder="选择学习时间" style="width: 150px;">--%>
            <input type="text" style="display: none" id="hours">
            <input type="text" style="display: none" id="minutes">
            <input type="text" style="display: none" id="seconds" class="layui-input" required lay-verify="notnull">
<%--            <button onclick="startStudy()" class="layui-btn layui-btn-radius layui-btn-normal" style="display: inline-block;position: absolute;margin-left: 180px;margin-top: -40px;border-radius: 10px">开始学习</button>--%>
            <%--            </div>--%>
        </div>
        <div class="layui-input-block" id="studyCount" style="margin-left: 10px">
            <label class="layui-form-label">学习倒计时</label>
            <div style="display: inline-block; font-size: 14px; font-weight: bold; color: #333; padding: 10px 20px; border: 2px solid #ccc; border-radius: 6px;width: 80px;height: 18px;line-height: 18px" id="timer"></div>
        </div>
    </div>
</div>


<%--<%--%>
<%--    if(userVector != null){--%>
<%--        for(User user : userVector){--%>

<%--%>--%>



<%--<%--%>
<%--        }--%>
<%--    }--%>
<%--%>--%>
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
    //实现用户等级到2级才能在自习室发言
    <%
    if(user.getRank() < 2){

    %>
    var messageInput = $("#text");
    // 设置输入框为只读
    messageInput.prop('readonly', true);
    // 设置输入框的提示信息
    messageInput.attr('placeholder', '你等级不足2级，不能发言');
    $("#sendMsg").prop('disabled',true);
    <%

    }
    %>

    //若室长已关闭自习室，还有人想加入就提示不能加入
    <%
    if(studyRoom.getOpenStatus() == 0){

    %>
    parent.layer.msg("自习室已关闭！");
    location.href='/user/joinStudyRoomPage';
    websocket.close();
    <%

    }
    %>

    var html = "";

    function create(userId) {
        //判断当前浏览器是否支持WebSocket
        if ('WebSocket' in window) {
            //改成你的地址
            socketPath = "ws://" + location.host + "${pageContext.request.contextPath}" + "/studyRoom/" + "<%=studyRoom.getId()%>/" + userId;
            websocket = new WebSocket(socketPath);
            init(websocket);
            html = "";
            $("#left").html(html);
            return websocket;
        } else {
            alert('当前浏览器 Not support websocket')
        }

    }



    function init(websocket){
        var isConnection = true;
        //连接发生错误的回调方法
        websocket.onerror = function () {
            // isConnection = false;
            // console.log("websocket请求被拒绝，因为人数已满");
            // setSystemMessageInnerHTML("WebSocket连接发生错误");

        };

        //连接成功建立的回调方法
        websocket.onopen = function () {
            // 连接已经成功建立，执行后续操作
            //websocket.send("连接成功");
            var msg = JSON.stringify({
                type: "user",
                userId: <%=user.getId()%>,
                name: "<%=user.getUserName()%>",
                content: "<%=user.getUserAvatar()%>"
            });
            websocket.send(msg);
            var join = JSON.stringify({
                type: "sysMsg",
                userId: <%=user.getId()%>,
                name: "<%=user.getUserName()%>",
                content: "系统消息：<%=user.getUserName()%>加入自习室"
            });
            websocket.send(join);
            //setSystemMessageInnerHTML("WebSocket连接成功");
            // if (isConnection) {
            //
            // }
        }
        //接收到消息的回调方法
        websocket.onmessage = function (event) {
            console.log(event);
            var res = JSON.parse(event.data);
            switch(res.type){
                case "user":
                    html += '<li class="subscribe-live-item">\n' +
                        ' <a>\n' +
                        ' <img src="' + res.content + '" style="width: 60px;height: 60px;border-radius: 50%;overflow: hidden;margin-top: 5px;" class="pic">\n' +
                        ' </a>\n' +
                        ' <div>\n' +
                        ' <p><a cursor="pointer" style="display: block;text-align: center;">' + res.name + '</a></p>\n' +
                        ' </div>\n' +
                        '</li>';
                    $("#left").html(html)
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
                case "close":
                    parent.layer.msg("室长已关闭自习室！");
                    closeWebSocket();
                    break;
                case "quit":
                    html = "";
                    $("#left").html(html);
                    break;
                case "kickOut":
                    console.log(res + <%=user.getId()%>);
                    var sysMsg = JSON.stringify({
                        type: "sysMsg",
                        userId: <%=user.getId()%>,
                        name: "<%=user.getUserName()%>",
                        content: "系统消息：<%=user.getUserName()%>被踢出了自习室"
                    });
                    websocket.send(sysMsg);
                    var quit = JSON.stringify({
                        type: "quit",
                        userId: <%=user.getId()%>,
                        name: "<%=user.getUserName()%>",
                        content: "<%=user.getUserAvatar()%>"
                    });
                    websocket.send(quit);
                    location.href='/user/joinStudyRoomPage';
                    websocket.close();
                    parent.layer.msg("你被踢出了自习室！");
                    break;
                case "time":
                    $("#hours").val(res.content.hours);
                    $("#minutes").val(res.content.minutes);
                    $("#seconds").val(res.content.seconds);
                    break;
                case "start":
                    setSystemMessageInnerHTML(res.content);
                    startStudy();
                    break;
                case "isStudy":
                    setSystemMessageInnerHTML(res.content);
                <%
                if(user.getRank() >= 2){

                %>
                    var messageInput = $("#text");
                    // 设置输入框为只读
                    messageInput.prop('readonly', true);
                    // 设置输入框的提示信息
                    messageInput.attr('placeholder', '正在学习中，不能发言');
                    $("#sendMsg").prop('disabled',true);
                <%

                }
                %>
                    break;
                case "endStudy":
                    setSystemMessageInnerHTML(res.content);
                <%
                if(user.getRank() >= 2){

                %>
                    var messageInput = $("#text");
                    // 设置输入框为只读
                    messageInput.prop('readonly', false);
                    // 设置输入框的提示信息
                    messageInput.attr('placeholder', '');
                    $("#sendMsg").prop('disabled',false);
                <%

                }
                %>

                    break;
                case "ban":
                    parent.layer.msg("自习室已被封禁！");
                    closeWebSocket();
                    break;

            }



        }

        //连接关闭的回调方法
        websocket.onclose = function (event) {
            if(event.code === 1013){
                parent.alert("自习室人数已满");
                location.href='/user/joinStudyRoomPage';
            }
        }

        <%--//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。--%>
        <%--window.onbeforeunload = function () {--%>
        <%--    //alert("你关闭了此子页面");--%>
        <%--    var msg = JSON.stringify({--%>
        <%--        type: "sysMsg",--%>
        <%--        name: "<%=user.getUserName()%>",--%>
        <%--        content: "系统消息：<%=user.getUserName()%>退出了自习室"--%>
        <%--    });--%>
        <%--    websocket.send(msg);--%>
        <%--    var quit = JSON.stringify({--%>
        <%--        type: "quit",--%>
        <%--        name: "<%=user.getUserName()%>",--%>
        <%--        content: "<%=user.getUserAvatar()%>"--%>
        <%--    });--%>
        <%--    websocket.send(quit);--%>
        <%--    closeWebSocket();--%>
        <%--}--%>

        // if(isConnection){
            window.addEventListener("unload", function(event) {
                console.log("你关闭了此子页面" + isConnection);
                var msg = JSON.stringify({
                    type: "sysMsg",
                    userId: <%=user.getId()%>,
                    name: "<%=user.getUserName()%>",
                    content: "系统消息：<%=user.getUserName()%>退出了自习室"
                });
                websocket.send(msg);
                var quit = JSON.stringify({
                    type: "quit",
                    userId: <%=user.getId()%>,
                    name: "<%=user.getUserName()%>",
                    content: "<%=user.getUserAvatar()%>"
                });
                websocket.send(quit);
                websocket.close();
            });
        // }

    }

    // // 监听自身的 beforeunload 事件
    // window.addEventListener('beforeunload', function(event) {
    //     // 在此处执行其他逻辑
    //     console.log('Child page is closing...');
    //     alert("你关闭了此子页面");
    //     // 如果需要阻止子页面关闭，可以取消事件的默认行为
    //     // event.preventDefault();
    // });

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
        var msg = JSON.stringify({
            type: "sysMsg",
            userId: <%=user.getId()%>,
            name: "<%=user.getUserName()%>",
            content: "系统消息：<%=user.getUserName()%>退出了自习室"
        });
        websocket.send(msg);
        var quit = JSON.stringify({
            type: "quit",
            userId: <%=user.getId()%>,
            name: "<%=user.getUserName()%>",
            content: "<%=user.getUserAvatar()%>"
        });
        websocket.send(quit);
        location.href='/user/joinStudyRoomPage';
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

    // 给输入框添加事件监听器(回车发送消息)
    $('#text').keypress(function(event) {
        // 检测用户是否按下了回车键
        if (event.keyCode == 13) {
            // 阻止默认的回车键行为，避免换行
            event.preventDefault();
            // 触发发送消息的函数
            send();
        }
    });

    $(function () {
        create(<%=user.getId()%>)
    })

    function startStudy() {
        if($("#seconds").val() == null || $("#seconds").val() == ''){
            alert("学习时间不能为空");
        }else {
            <%
            if(user.getRank() >= 2){

            %>
            var messageInput = $("#text");
            // 设置输入框为只读
            messageInput.prop('readonly', true);
            // 设置输入框的提示信息
            messageInput.attr('placeholder', '正在学习中，不能发言');
            $("#sendMsg").prop('disabled',true);
            <%

            }
            %>

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
                    <%
                    if(user.getRank() >= 2){

                    %>
                    var messageInput = $("#text");
                    messageInput.prop('readonly', false);
                    // 设置输入框的提示信息
                    messageInput.attr('placeholder', '');
                    $("#sendMsg").prop('disabled',false);
                    <%

                    }
                    %>

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
</script>
</html>
