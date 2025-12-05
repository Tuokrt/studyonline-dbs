<%@ page import="com.wyu.studyonline.pojo.StudyRoom" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/6
  Time: 15:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>adminJoinStudyRoom</title>
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
//    Vector<User> userVector = (Vector<User>) session.getAttribute("userVector");
//    User user = (User) session.getAttribute("user");
//    Object joinStudyRoomId = ;
//    int joinStudyRoomIdInt = (Integer) joinStudyRoomId;
%>

<div style="margin-left: 10px">
    <%--    <button onclick="create(${user.getId()})" class="layui-btn layui-btn-primary layui-border-blue" id="join">加入自习室</button>--%>
    <button onclick="closeWebSocket()" style="margin-left: 0px" class="layui-btn layui-btn-primary layui-border-orange" id="out">退出自习室</button>
        <button onclick="ban()" style="margin-left: 10px" class="layui-btn layui-btn-danger" id="out">封禁自习室</button>

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
    <div id="message" style="height: 500px; max-height: 500px"></div>

</div>
</body>
<script type="text/javascript">

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
            //setSystemMessageInnerHTML("WebSocket连接成功");

            var msg = JSON.stringify({
                type: "admin",
                userId: 0,
                name: "admin",
                content: "admin"
            });
            websocket.send(msg);
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
                    setMemberMessageInnerHTML(res.name + "：" + res.content);
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
        location.href='/admin/manageStudyRoomPage';
        websocket.close();
    }

    //封禁自习室
    function ban() {
        layer.confirm('确认封禁该自习室吗？', {
            btn: ['确认', '取消'],
            offset: ['190px','400px']

        },function(index){
            $.ajax({
                type: 'post',
                url: '/admin/banStudyRoomById',
                data: {
                    id: <%=studyRoom.getId()%>
                },
                success: function(res){
                    if(res == "success"){
                        //layer.msg('封禁成功');
                        //$("#studyRoom").click();

                        var msg = JSON.stringify({
                            type: "ban",
                            userId: 0,
                            name: "admin",
                            content: "ban"
                        });
                        websocket.send(msg);
                        parent.layer.msg("自习室已被封禁！");
                        location.href='/admin/manageStudyRoomPage';

                    }else{
                        layer.msg('封禁失败');
                    }
                },
                error: function(){
                    layer.msg('网络错误');
                }
            });
            layer.close(index);

        });

    }


    $(function () {
        create(0)
    })

</script>
</html>
