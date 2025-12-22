<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/22
  Time: 19:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>自习室-首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <span class="layui-logo layui-hide-xs" style="font-size: 20px; font-family:楷体 ">自习室</span>
        <!-- 头部区域（可配合layui 已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">

<%--            <li class="layui-nav-item layui-hide-xs"><a href=""><img src="" height="48px" style="margin-top: 5px"></a></li>--%>

        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item layui-hide layui-show-md-inline-block" id="login">
                <a href="javascript:;">
                    <c:if test="${user == null}">
                        登录
                    </c:if>
                    <c:if test="${user != null}">
                        <img src="${user.userAvatar}" class="layui-nav-img">
                        ${user.userName}
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;">昵 称：${user.userName}</a></dd>
                            <dd><a href="javascript:;">手机号：${user.cellPhone}</a></dd>
                            <dd><a href="javascript:;">性 别：<c:if test="${user.gender == 0}">保密</c:if>
                                <c:if test="${user.gender == 1}">男</c:if>
                                <c:if test="${user.gender == 2}">女</c:if></a></dd>
                        </dl>
                    </c:if></a>
                </a>

            </li>
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}user/logout">
                <c:if test="${user != null}">
                    退出
                </c:if></a></li>
<%--            <li class="layui-nav-item" lay-header-event="menuRight" lay-unselect>--%>
<%--                <a href="javascript:;">--%>
<%--                    <i class="layui-icon layui-icon-more-vertical"></i>--%>
<%--                </a>--%>
<%--            </li>--%>
        </ul>
    </div>

    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <div>
                <div style="height: 60px; width: 60px; overflow: hidden; margin-left: 15px; margin-right:13px; margin-top: 13px;display: inline-block">
                    <c:if test="${user != null}">
                        <img src="${user.userAvatar}" style="height: 60px; width: 60px;border-radius: 50%;">
                    </c:if></a></li>
                    <c:if test="${user == null}">
                        <img src="user.webp" style="height: 60px; width: 60px;border-radius: 50%;">
                    </c:if></a></li>
                </div>
                <div style="display: inline; position: relative">

                    <div style="margin-top: 25px; display: inline-block; position: absolute; width: 90px">
                        <c:if test="${user == null}">
                            欢迎你！！
                        </c:if></a></li>
                        ${user.userName}
                        <br>
                        ${user.status == 0 ? "在线中..." : ""}
                        ${user.status == 1 ? "自习中..." : ""}

                    </div>
                </div>
                <hr>
            </div>
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-filter="test">
                <li class="layui-nav-item">
                    <a class="" href="javascript:;"><i class="layui-icon layui-icon-read" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;自习室</a>
                    <dl class="layui-nav-child">
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/myStudyRoomPage"
                                           data-id="myStudyRoomPage"
                                           data-title="<i class='layui-icon layui-icon-flag'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;我的自习室"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-flag" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;我的自习室</a></dd>
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/joinStudyRoomPage"
                                           data-id="joinStudyRoomPage"
                                           data-title="<i class='layui-icon layui-icon-add-circle'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;加入自习室"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-add-circle" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;加入自习室</a></dd>
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/studyAlonePage"
                                           data-id="studyAlonePage"
                                           data-title="<i class='layui-icon layui-icon-template-1'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;独自自习"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-template-1" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;独自自习</a></dd>

                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon layui-icon-list" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;学习待办</a>
                    <dl class="layui-nav-child">
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/addStudyPlanPage"
                                           data-id="addStudyPlanPage"
                                           data-title="<i class='layui-icon layui-icon-add-circle'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;添加学习待办"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-add-circle" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;添加学习待办</a></dd>
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/updateStudyPlanPage"
                                           data-id="updateStudyPlanPage"
                                           data-title="<i class='layui-icon layui-icon-util'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;修改学习待办"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-util" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;修改学习待办</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon layui-icon-date" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;备考日历</a>
                    <dl class="layui-nav-child">
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/addExamTimePage"
                                           data-id="addExamTimePage"
                                           data-title="<i class='layui-icon layui-icon-add-circle'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;添加备考日历"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-add-circle" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;添加备考日历</a></dd>
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/updateExamTimePage"
                                           data-id="updateExamTimePage"
                                           data-title="<i class='layui-icon layui-icon-util'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;修改备考日历"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-util" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;修改备考日历</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon layui-icon-share" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;学习动态</a>
                    <dl class="layui-nav-child">
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/myStudyStatusPage"
                                           data-id="myStudyStatusPage"
                                           data-title="<i class='layui-icon layui-icon-flag'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;我的动态"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-flag" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;我的动态</a></dd>
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/addStudyStatusPage"
                                           data-id="addStudyStatusPage"
                                           data-title="<i class='layui-icon layui-icon-release'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;发表动态"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-release" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;发表动态</a></dd>
                        <dd class="zjl"><a href="javascript:;"
                                           data-url="user/allStudyStatusPage"
                                           data-id="allStudyStatusPage"
                                           data-title="<i class='layui-icon layui-icon-theme'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;动态广场"
                                           class="site-demo-active"
                                           data-type="tabAdd"
                        ><i class="layui-icon layui-icon-theme" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;动态广场</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item"><a href="javascript:;"
                                              data-url="user/personalCenterPage"
                                              data-id="personalCenterPage"
                                              data-title="<i class='layui-icon layui-icon-friends'
                                            style='font-size: 20px; color: #1E9FFF;'></i>&nbsp;&nbsp;个人中心"
                                              class="site-demo-active"
                                              data-type="tabAdd"
                ><i class="layui-icon layui-icon-friends" style="font-size: 18px; color: #FFFFFF;"></i>&nbsp;&nbsp;个人中心</a></li>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 5px;">
            <div class="layui-tab layui-tab-card" lay-filter="demo" lay-allowclose="true">
                <ul class="layui-tab-title">
                    <li class="layui-this" data-close="false"><i class="layui-icon layui-icon-home"
                                              style="font-size: 20px; color: #1E9FFF; font-weight: bold"></i>&nbsp;&nbsp;首页
                    </li>
                </ul>
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show">
                        <iframe src="user/indexPage" width="100%" height="480px"></iframe>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div class="layui-footer">
        <!-- 底部固定区域 -->
        <center>@深圳大学</center>
    </div>
</div>
<%
    Object obj = session.getAttribute("user");
    if (obj == null) {
%>
<script>
    $(".layui-nav-item:not(#login)").click(function () {
        layer.open({
            content: '您还没登录！请先登录！',
            btn: ['好的','取消'] ,//按钮
            yes: function (index, layero) {
                // layer.msg('登录页面', {icon: 1});
                layer.close(index);
                layer.open({
                    type: 2,
                    title: '线上自习室欢迎你！请登录...',
                    shadeClose: true,
                    shade: false,
                    move:false,
                    //maxmin: true, //开启最大化最小化按钮
                    area: ['700px', '400px'],
                    content: 'user/loginPage'
                    ,cancel: function () {
                        //location.reload();
                        $(".layui-nav-item").removeClass("layui-nav-itemed");
                    }});
            }
            ,btn2: function (index, layero) {
                //location.reload();
                $(".layui-nav-item").removeClass("layui-nav-itemed");
            }
            ,cancel: function () {
                //location.reload();
                $(".layui-nav-item").removeClass("layui-nav-itemed");
            }
        });
    })

    $("#login").click(function () {
        //iframe 层

        layer.open({
            type: 2,
            title: '线上自习室欢迎你！请登录...',
            shadeClose: true,
            shade: false,
            move:false,
            //maxmin: true, //开启最大化最小化按钮
            area: ['700px', '400px'],
            content: 'user/loginPage'
        });
    })


</script>
<%
}
%>
<script>

    //JS
    layui.use(['element', 'layer', 'util'], function(){
        var element = layui.element
            ,layer = layui.layer
            ,util = layui.util
            ,$ = layui.$;

        //触发事件
        var active = {
            //在这里给active绑定几项事件，后面可通过active调用这些事件
            tabAdd: function (url, id, title) {
                //新增一个Tab项 传入三个参数，分别对应其标题，tab页面的地址，还有一个规定的id，是标签中data-id的属性值
                //关于tabAdd的方法所传入的参数可看layui的开发文档中基础方法部分
                element.tabAdd('demo', {
                    title: title,
                    content: '<iframe data-frameid="' + id
                        + '" scrolling="auto" frameborder="0" src="'
                        + url + '" style="width:100%;height: 480px"></iframe>',
                    id: id
                    //规定好的id
                })
                element.render('tab');

            },
            tabChange: function (id) {
                //切换到指定Tab项
                element.tabChange('demo', id); //根据传入的id传入到指定的tab项
            },
            tabDelete: function (id) {
                element.tabDelete("demo", id);//删除
                // element.on('tabDelete(demo)', function(data){
                //     var $li = $(this).parent();
                //     if ($li.attr('data-close') === 'false') {
                //         //如果tab页签不允许关闭，则取消关闭事件的默认行为
                //         return false;
                //     }
                // });
            },
            tabDeleteAll: function (ids) {//删除所有
                $.each(ids, function (i, item) {
                    element.tabDelete("demo", item); //ids是一个数组，里面存放了多个id，调用tabDelete方法分别删除
                })
            }
        };
//当点击有site-demo-active属性的标签时，即左侧菜单栏中内容 ，触发点击事件
        $('.site-demo-active').on(
            'click',
            function () {
                var dataid = $(this);

                //这时会判断右侧.layui-tab-title属性下的有lay-id属性的li的数目，即已经打开的tab项数目
                if ($(".layui-tab-title li[lay-id]").length <= 0) {
                    //如果比零小，则直接打开新的tab项
                    active
                        .tabAdd(dataid.attr("data-url"), dataid
                            .attr("data-id"), dataid
                            .attr("data-title"));
                } else {
                    //否则判断该tab项是否以及存在

                    var isData = false; //初始化一个标志，为false说明未打开该tab项 为true则说明已有
                    $.each($(".layui-tab-title li[lay-id]"),
                        function () {
                            //如果点击左侧菜单栏所传入的id 在右侧tab项中的lay-id属性可以找到，则说明该tab项已经打开
                            if ($(this).attr("lay-id") == dataid
                                .attr("data-id")) {
                                isData = true;
                            }
                        })
                    if (isData == false) {
                        //标志为false 新增一个tab项
                        active.tabAdd(dataid.attr("data-url"), dataid
                            .attr("data-id"), dataid
                            .attr("data-title"));
                    }
                }
                //最后不管是否新增tab，最后都转到要打开的选项页面上
                active.tabChange(dataid.attr("data-id"));
            });

    });
</script>
</body>
</html>
