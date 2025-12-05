<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/4
  Time: 1:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>allStudyStatusPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.15.3/css/all.min.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
</head>
<style>
    .user-info {
        display: flex;
        align-items: center;
        margin: 13px 10px;
    }
    .user-avatar {
        flex-shrink: 0;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 13px;
    }
    .user-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .user-content {
        flex-grow: 1;
    }
    .user-name {
        font-size: 16px;
        font-weight: bold;
        position: relative;
        margin-top: 10px;
    }
    .image-item {
        display: inline-block;
        position: relative;
        margin-right: 10px;
        margin-bottom: 10px;
        width: 100px;
        height: 100px;
    }
    .layui-upload-img {
        width: 100%;
        height: 100%;
        border-radius: 5px;
        cursor: pointer;
    }
    .icon-awesome{
        display: inline-block;
        width: 80px;
        margin: 5px 45px;
        color: #99a2aa;
        font-size: 14px;
    }
    #report{
        position: relative;
    }
    #report:hover::after {
        content: attr(title);
        background-color: #333;
        color: #fff;
        padding: 0px 8px;
        position: absolute;
        top: calc(100% + 5px);
        left: 50%;
        transform: translateX(-50%);
        border-radius: 5px;
    }

    .fixed-div {
        position: fixed;
        top: 20px; /* 固定顶部位置 */
        right: 60px; /* 固定左侧位置 */
        width: 250px; /* 固定宽度 */
        height: 350px; /* 固定高度 */
        background-color: #F6F6F6; /* 背景颜色 */
    }

    .todo-list {
        /*list-style: none; !* 去掉默认的列表样式 *!*/
        margin: 0;
        padding: 0;
        font-size: 16px;
        color: #2440b3;
    }

    .todo-list li {
        padding: 8px 0px; /* 添加内边距 */
        border-bottom: 1px solid #ddd; /* 添加底部边框 */
        min-height: 25px;
        white-space: nowrap; /* 不换行 */
        overflow: hidden; /* 超出部分隐藏 */
        text-overflow: ellipsis; /* 超出部分用省略符号表示 */
    }

    /* 设置前三名的样式 */
    .todo-list li:nth-child(1) {
        color: #FE2D46;
    }

    .todo-list li:nth-child(2) {
        color: #F60;
    }

    .todo-list li:nth-child(3) {
        color: #FAA90E;
    }

</style>
<%--展示所有动态--%>
<body style="background-color: #F6F6F6;" id="allStudyStatus">

<div style="padding: 10px;color: #5f5f5f!important">
    <div class="layui-row layui-col-space15" id="studyStatus-list"></div>
</div>

<div class="fixed-div">
    <p style="font-family: 'Adobe 宋体 Std L'; font-size: 16px; font-weight: bold;">热点动态排行<i class="layui-icon layui-icon-right"></i></p>
    <ul class="todo-list">
        <c:if test="${empty studyStatusRankList}">
            <li> </li>
            <li> </li>
            <li> </li>
            <li> </li>
        </c:if>
        <c:if test="${not empty studyStatusRankList}">
            <c:forEach var="studyStatusMap" items="${studyStatusRankList}" varStatus="status">
                <c:forEach var="studyStatus" items="${studyStatusMap}">
                    <li><a href="/user/commentPage/${studyStatus.key}?userId=${user.id}" target="_blank" style="color: inherit">${status.index + 1}  ${studyStatus.value}</a></li>
                </c:forEach>
            </c:forEach>
        </c:if>
    </ul>
</div>


<script>
    layui.use(['flow', 'util', 'laydate', 'layer'], function () {
        var flow = layui.flow;
        var util = layui.util,laydate = layui.laydate;
        flow.load({
            elem: '#studyStatus-list',
            scrollElem: '#studyStatus-list',
            isAuto: true,
            done: function (page, next) {
                $.get('/user/selectAllStudyStatus', { page: page, limit: 5, userId: ${user.id}}, function (res) {
                    var html = '';
                    layui.each(res.data, function (index, item) {
                        html += '<div class="layui-col-md6" style="margin: 0 auto; float: none; width: 550px; height: auto">';
                        html += '<div class="layui-card">';
                        html += '<div class="layui-card-header user-info" style="height: 60px;margin: 0;line-height: 25px">';
                        html += '<div class="user-avatar">';
                        html += '<img src="' + item.userAvatar + '" alt="用户头像">';
                        html += '</div>';
                        html += '<div class="user-content">';
                        html += '<div class="user-name">' + item.userName + '<span style="font-size: 12px;color: #99a2aa;display: block">' + util.toDateString(item.createTime) + '</span></div>';
                        html += '</div>';
                        html += '<div>';
                        html += '<button id="report" title="举报" class="layui-btn layui-btn-primary layui-btn-sm" style="border-color: #FFF"  onclick="report(' + item.id + ')"><i class="fa fa-exclamation-triangle" aria-hidden="true" style="color: #99a2aa"></i></button>';
                        html += '</div>';
                        html += '</div>';
                        html += '<pre class="layui-card-body" style="line-height: 20px;padding: 1px 15px" onclick="toComment(' + item.id + ')">' + item.content + '</pre>';

                        html += '<div style="padding-left: 11px;margin-top: 5px;">';
                        if(item.firstPhoto != "" && item.firstPhoto != null){
                            html += '<div class="image-item" style="width: 164px;">';
                            html += '<img src="' + item.firstPhoto + '" class="layui-upload-img" style="">';
                            html += '</div>';
                        }
                        if (item.secondPhoto != "" && item.secondPhoto != null){
                            html += '<div class="image-item" style="width: 164px;">';
                            html += '<img src="' + item.secondPhoto + '" class="layui-upload-img" style="">';
                            html += '</div>';
                        }
                        if (item.thirdPhoto != "" && item.thirdPhoto != null){
                            html += '<div class="image-item" style="width: 164px;">';
                            html += '<img src="' + item.thirdPhoto + '" class="layui-upload-img" style="">';
                            html += '</div>';
                        }

                        html += '</div>';

                        html += '<div style="height: 20px;padding-bottom: 10px;padding-left: 10px" data-index="' + item.id + '">';
                        html += '<div class="icon-awesome"><i class="far fa-share-square " aria-hidden="true" data-name="transmitCount" onclick="transmitByStudyStatusId(' + item.id + ')"> ' + item.transmitCount + '</i></div>';
                        html += '<div class="icon-awesome"><i class="far fa-comment " aria-hidden="true" data-name="commentCount" onclick="toComment(' + item.id + ')"> ' + item.commentCount + '</i></div>';
                        if(item.like){
                            html += '<div class="icon-awesome" style="color: #01AAED"><i class="far fa-thumbs-up" aria-hidden="true" data-name="likeCount" onclick="subLike(' + item.id + ')"> ' + item.likeCount + '</i></div>';
                        }else {
                            html += '<div class="icon-awesome"><i class="far fa-thumbs-up" aria-hidden="true" data-name="likeCount" onclick="addLike(' + item.id + ')"> ' + item.likeCount + '</i></div>';
                        }

                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    });
                    console.log("page = " + page, "pages = " + res.count);
                    next(html, page < res.count);
                });
            }
        });


        //固定块
        util.fixbar({
            bar1: false
            ,bar2: false
            ,showHeight: 30
            ,css: {right: 20, bottom: 20}
            ,bgcolor: '#9F9F9F'
            ,click: function(type){
                if(type === 'bar1'){
                    layer.msg('icon 是可以随便换的')
                } else if(type === 'bar2') {
                    layer.msg('两个 bar 都可以设定是否开启')
                }
            }
        });


    });

    //增加一个点赞
    function addLike(studyStatusId) {
        $.ajax({
            url: '/user/addStudyStatusLike',
            type: 'POST',
            data: {studyStatusId: studyStatusId, userId: ${user.id}},
            success: function(result) {
                if (result.code == 200) {
                    // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    // parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();

                    // location.href='/user/addStudyStatusPage';
                    // // layer.msg("创建成功");
                    var likeCountElement = document.querySelector('[data-index="' + studyStatusId + '"] [data-name="likeCount"]');
                    var likeCount = likeCountElement.textContent.trim();
                    var likeCountNumber = parseInt(likeCount);
                    likeCountNumber += 1;
                    console.log("likeCountNumber" + likeCountNumber);
                    likeCountElement.textContent = " " + likeCountNumber.toString();
                    likeCountElement.style.color = '#01AAED';
                    likeCountElement.setAttribute('onclick', 'subLike(' + studyStatusId + ')');
                    layer.msg("点赞成功",{offset: ['250px', '470px']});
                } else {
                    layer.msg("点赞失败，请重试",{offset: ['250px', '470px']});
                }
            }
        });
    }

    //减少一个点赞
    function subLike(studyStatusId) {
        $.ajax({
            url: '/user/subStudyStatusLike',
            type: 'POST',
            data: {studyStatusId: studyStatusId, userId: ${user.id}},
            success: function(result) {
                if (result.code == 200) {
                    // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    // parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();
                    layer.msg("取消点赞",{offset: ['250px', '470px']});
                    // location.href='/user/addStudyStatusPage';
                    // // layer.msg("创建成功");
                    var likeCountElement = document.querySelector('[data-index="' + studyStatusId + '"] [data-name="likeCount"]');
                    var likeCount = likeCountElement.textContent.trim();
                    var likeCountNumber = parseInt(likeCount);
                    likeCountNumber -= 1;
                    console.log("likeCountNumber" + likeCountNumber);
                    likeCountElement.textContent = " " + likeCountNumber.toString();
                    likeCountElement.style.color = '#99a2aa';
                    likeCountElement.setAttribute('onclick', 'addLike(' + studyStatusId + ')');
                } else {
                    layer.msg("点赞失败，请重试",{offset: ['250px', '470px']});
                }
            }
        });
    }

    //跳转评论页面
    function toComment(studyStatusId) {
        var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
        parent.layer.close(index); //再执行关闭
        //parent.parent.location.reload();
        location.href='/user/commentPage/'+ studyStatusId +'?userId=${user.id}';
    }

    //转发动态
    function transmitByStudyStatusId(studyStatusId) {
        //询问框
        layer.confirm('确定转发该动态吗？', {
            btn: ['确定','取消'] ,offset: ['200px', '370px']
        }, function(){
            $.ajax({
                url: '/user/transmitStudyStatus',
                type: 'POST',
                data: {studyStatusId: studyStatusId, userId: ${user.id}},
                success: function(result) {
                    if (result.code == 200) {
                        // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                        // parent.layer.close(index); //再执行关闭
                        //parent.parent.location.reload();
                        layer.msg("转发成功",{offset: ['250px', '470px']});
                        // location.href='/user/addStudyStatusPage';
                        // // layer.msg("创建成功");
                        var transmitCountElement = document.querySelector('[data-index="' + studyStatusId + '"] [data-name="transmitCount"]');
                        var transmitCount = transmitCountElement.textContent.trim();
                        var transmitCountNumber = parseInt(transmitCount);
                        transmitCountNumber += 1;
                        console.log("transmitCountNumber" + transmitCountNumber);
                        transmitCountElement.textContent = " " + transmitCountNumber.toString();

                    } else {
                        layer.msg("转发失败，请重试",{offset: ['250px', '470px']});
                    }
                }
            });
        }, function(){
            // layer.msg('也可以这样', {
            //     time: 2000, //20s后自动关闭
            //     btn: ['明白了', '知道了']
            // });
        });
    }

    //举报弹窗
    function report(studyStatusId){
        var reportType = 2;
        //iframe 层
        layer.open({
            type: 2,
            title: '我要举报！',
            shadeClose: true,
            shade: 0.8,
            area: ['390px', '90%'],
            offset: ['20px', '330px'],
            content: 'reportPage?reportType=' + reportType + '&beReportedId=' + studyStatusId//iframe的url
        });
    }

    // 查看图片
    $(document).on('click', '.layui-upload-img', function() {
        var index = $(this).parent().index();
        layer.photos({
            photos: {
                data: [{
                    "src": this.src
                }]
            },
            shade: 0.5,
            closeBtn: 1,
            offset: ['70px', '250px'],
            area: ['600px', '400px'], // 指定图片的尺寸
            anim: 0,
            init: function() {
                layer.photosIndex = index;
            }
        });
    });
</script>
</body>
</html>
