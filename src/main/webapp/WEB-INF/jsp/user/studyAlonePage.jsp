<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/4
  Time: 1:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>studyAlonePage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<style>
    #time{
        margin: 150px 120px 85px 120px;
        padding: 30px 22px;
        height: 145px;
        width: 789px;
        background: url(<%=request.getContextPath()%>score.png) no-repeat;
        position: relative;
        text-align: center;
    }

    span{
        font-size: 40px;
    }

    .btnlocation{
        margin-left: 800px;
        margin-top: -30px;
    }

    .none{
        display: none;
    }

</style>
<body>
<div id="time">
    <span id="hour">00</span>     <!-- //内容初始为00，由id来获取span这个元素，然后通过js来改变span内的文字内容 -->
    <span>:</span>
    <span id="min">00</span>　　<!-- //内容初始为00，由id来获取span这个元素，然后通过js来改变span内的文字内容 -->
    <span style="margin-left: -28px">:</span>
    <span id="sec">00</span>　　<!-- //内容初始为00，由id来获取span这个元素，然后通过js来改变span内的文字内容 -->
</div>
<div class="btnlocation">
    <button id="btn" class="layui-btn layui-btn-primary layui-border-blue">开始自习</button>
    <button id="stop" class="layui-btn layui-btn-primary layui-border-green none" >暂停自习</button>
</div>

<script>
    var i = 0;  　　　　　　　　　　 //使用i来充当秒数统计setinterval方法的刷新次数
    var timer = null;　　　　　　　　//接收setinterval的返回值，以便于暂停和重置功能的实现
    var isRunning = false;　　　　　　//来定义开始按钮和定时器的状态，默认定时器不启动，button文字为开始

    function doubleNumber(num) {　　　　//计时器辅助功能，因为计时器在小于10的时候只显示一位数，例如 1 ，2。。。
        //而我们习惯的方式为01,02.。。，所以定义一个函数方法来优化用户体验
        if (num < 10) {
            return '0' + num;
        } else {
            return num;
        }
    }

    window.onload = function(){  　　　　　　 //使用window.onload = function()来让页面所有元素加载完毕之后才执行js代码，可以优化用户体验应对网速较慢的情况
        function funcStart(){　　　　　　　　　　//这是计时器的开始功能
            timer = setInterval(function(){　　　　//使用timer来接收setinterval的值，setinterval是js内置的计时器功能，执行过程为，。　　　　　　　　　　　　　　　　　　　　
                //第一个参数为函数，第二个为毫秒数，经过指定的毫秒数来执行一次传入的函数
                i++;　　　　　　　　　　　　　　//这是计时器秒数分钟数和小时的基准“i”
                $("#sec").text(doubleNumber(i % 60));  　　　　//秒数等于i%60，然后被doubleNumber方法应用，也就是上面所定义的的辅助功能
                $("#min").text(doubleNumber(parseInt(i / 60) % 60));
                $("#hour").text(doubleNumber(parseInt(i / 3600) % 60));
            },1000)  　　//每一千毫秒 = 一秒 刷新一次
        }
        function funcPause(){
            clearInterval(timer);　　　　//使用js内置功能暂停计时器
        }


        $("#btn").click(function(){     //当id为btn的按钮被点击时，执行以下函数
            console.log($("#stop").text());
            if (!isRunning && ($("#stop").text() == "暂停自习" || $("#stop").text() == "")) {
                // console.log("开始");
                $("#btn").text("结束自习");　　　//设置btn标签内容为暂停
                funcStart();　　　　　　　　　　//  isRunning默认为false  那么isRunning的否就是true，就是代表当前计时器并没有运行，然后执行funcStart()功能
                i = 0;
                $("#sec").text('00');
                $("#min").text('00');
                $("#hour").text('00');
                $("#stop").removeClass("none");
                $("#btn").removeClass("layui-border-blue");
                $("#btn").addClass("layui-border-orange");
                isRunning = true　　　　//设置 isRunning = true，然后当再次点击btn按钮时则运行else函数，因为此时isRunning的否就是false了
            } else {
                $("#btn").text("开始自习");　　　　//设置btn标签内容为开始
                funcPause();　　　　　　　　　　//　　否则就执行funcPause()函数功能
                $("#stop").addClass("none");
                $("#stop").text("暂停自习");
                isRunning = false;　　　　　　//设置 isRunning =false，然后当再次点击btn按钮时则会运行if函数，因为此时isRunning的否就是true了
                $.ajax({
                    url: '<%=request.getContextPath()%>/user/addStudyTime',
                    type: 'POST',
                    data: {userId: ${user.id}, hour: $("#hour").text(), min: $("#min").text(), sec: $("#sec").text()},
                    success: function(data) {
                        if (data == 'success') {
                            console.log("学习时间存储成功");
                        } else {
                            console.log("学习时间存储失败");
                        }
                    }
                });
            }
        });

        $("#stop").click(function () {
            if (!isRunning) {
                $("#stop").text("暂停自习");
                funcStart();　　　　　　　　　　//  isRunning默认为false  那么isRunning的否就是true，就是代表当前计时器并没有运行，然后执行funcStart()功能
                isRunning = true　　　　//设置 isRunning = true，然后当再次点击btn按钮时则运行else函数，因为此时isRunning的否就是false了
            } else {
                $("#stop").text("继续自习");
                funcPause();
                isRunning = false;
            }
        });

    }
</script>
</body>
</html>
