<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/1
  Time: 17:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>commentPage</title>
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
    .user-info-comment {
        display: flex;
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
    .comment-avatar {
        flex-shrink: 0;
        width: 35px;
        height: 35px;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 13px;
        margin-left: 20px;
    }
    .user-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .comment-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    /*.user-content {*/
    /*    flex-grow: 1;*/
    /*}*/
    .user-name {
        font-size: 16px;
        font-weight: bold;
        position: relative;
        margin-top: 10px;
    }
    .user-name-comment {
        font-size: 12px;
        position: relative;
        margin-top: 10px;
    }
    .image-item {
        display: inline-block;
        position: relative;
        margin-right: 8px;
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
    #send:hover,
    #send:focus {
        background-color: #01AAED;
    }

    .getBack {
        position: fixed;
        top: 10px; /* 距离底部 10 像素 */
        left: 170px; /* 距离右侧 10 像素 */
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
    .none{
        display: none;
    }
</style>
<body style="background-color: #F6F6F6;" id="allStudyStatus">
<div class="getBack">
    <button class="layui-btn layui-btn-primary layui-border-blue layui-btn-radius layui-btn-sm" onclick="goBack()"><i class="layui-icon layui-icon-return"></i> 返回</button>
</div>
<div class="" style="padding: 10px;color: #5f5f5f!important">
    <div class="layui-row layui-col-space15" id="studyStatus-list">
        <div class="layui-col-md6" style="margin: 0 auto; float: none; width: 550px; height: auto">
            <div class="layui-card">
                <div class="layui-card-header user-info" style="height: 60px;margin: 0;line-height: 25px">
                    <div class="user-avatar">
                        <img src="${studyStatus.userAvatar}" alt="用户头像">
                    </div>
                    <div class="user-content">
                        <div class="user-name">${studyStatus.userName}<span style="font-size: 12px;color: #99a2aa;display: block"><fmt:formatDate value="${studyStatus.createTime}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
                        </div>
                    </div>
                </div>
                <pre class="layui-card-body" style="line-height: 20px;padding: 1px 15px">${studyStatus.content}</pre>
                <div style="padding-left: 11px;margin-top: 5px;">
                    <c:if test="${not empty studyStatus.firstPhoto}">
                        <div class="image-item" style="width: 164px;">
                            <img src="${studyStatus.firstPhoto}" class="layui-upload-img" style="">
                        </div>
                    </c:if>
                    <c:if test="${not empty studyStatus.secondPhoto}">
                        <div class="image-item" style="width: 164px;">
                            <img src="${studyStatus.secondPhoto}" class="layui-upload-img" style="">
                        </div>
                    </c:if>
                    <c:if test="${not empty studyStatus.thirdPhoto}">
                        <div class="image-item" style="width: 164px;">
                            <img src="${studyStatus.thirdPhoto}" class="layui-upload-img" style="">
                        </div>
                    </c:if>
                </div>
                <div style="height: 20px;padding-left: 10px" data-index="${studyStatus.id}">
                    <div class="icon-awesome"><i class="far fa-share-square " aria-hidden="true" data-name="transmitCount" onclick="transmitByStudyStatusId(${studyStatus.id})"> ${studyStatus.transmitCount}</i>
                    </div>
                    <div class="icon-awesome" style="color: #01AAED"><i class="far fa-comment " aria-hidden="true" data-name="commentCount"> ${studyStatus.commentCount}</i>
                    </div>
                    <c:choose>
                        <c:when test="${studyStatus.like}">
                            <div class="icon-awesome" style="color: #01AAED">
                                <i class="far fa-thumbs-up" aria-hidden="true" data-name="likeCount" onclick="subLike(${studyStatus.id})">${studyStatus.likeCount}</i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="icon-awesome">
                                <i class="far fa-thumbs-up" aria-hidden="true" data-name="likeCount" onclick="addLike(${studyStatus.id})">${studyStatus.likeCount}</i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <hr>
                <div class="layui-card-header user-info " style="height: 60px;margin: 0;padding-bottom: 8px;line-height: 25px">
                    <div class="comment-avatar">
                        <img src="${user.userAvatar}" alt="用户头像">
                    </div>
                    <div class="user-content">
                        <textarea id="content" placeholder="和大家一起讨论吧？" class="layui-textarea layui-card-body" style="min-height: 22px;width: 350px;background-color: #f4f5f7"></textarea>
                    </div>
                    <div style="margin-left: 10px">
                        <button id="send" onclick="sendComment(${studyStatus.id})" style="height: 53px;width: 53px;background-color: #9F9F9F;border: 2px solid #9F9F9F" ><i class="layui-icon layui-icon-release" style="font-size: 40px; color: #fff;"></i></button>
                    </div>
                </div>
                <div id="my-comment">

                </div>
                <div id="comment-list">

                </div>
            </div>
        </div>
    </div>
</div>


<script>
    //返回上一个页面
    function goBack() {
        // window.history.back();
        // window.location.reload();
        // history.go(-1);
        history.replaceState(null, '', document.referrer);
        location.reload();
    }

    layui.use(['flow', 'util', 'laydate', 'layer'], function () {
        var flow = layui.flow;
        var util = layui.util,laydate = layui.laydate
        flow.load({
            elem: '#comment-list',
            isAuto: true,
            end: "没有更多评论了！",
            done: function (page, next) {
                $.get('/user/selectAllCommentByStatusId', { page: page, limit: 2, studyStatusId: ${studyStatus.id}}, function (res) {
                    var html = '';
                    layui.each(res.data, function (index, item) {
                        html += '<div class="layui-col-md6" style="margin: 0 auto; float: none; width: 535px; height: auto;" data-commentId=' + item.id + '>';
                        html += '<div class="layui-card">';
                        html += '<div class="layui-card-header user-info-comment" style="height: auto;margin: 0;line-height: 25px">';
                        html += '<div class="comment-avatar" style="margin-top: 15px">';
                        html += '<img src="' + item.userAvatar + '" alt="用户头像">';
                        html += '</div>';
                        html += '<div class="user-content" style="width: 408px">';
                        html += '<div class="user-name-comment">' + item.userName + '<pre class="layui-card-body" style="line-height: 20px;padding: 1px 15px">' + item.commentContent + '</pre>' + '<span style="font-size: 12px;color: #99a2aa;display: block">' + util.toDateString(item.createTime) + '</span></div>';
                        html += '</div>';
                        html += '<div style="margin-top: 5px">';
                        if(item.userId == ${user.id}){
                            html += '<button id="report" title="删除" class="layui-btn layui-btn-primary layui-btn-sm" style="border-color: #FFF"  onclick="deleteCommentById(' + item.id + ')"><i class="fa fa-trash-alt" aria-hidden="true" style="color: #99a2aa"></i></button>';
                        }else {
                            html += '<button id="report" title="举报" class="layui-btn layui-btn-primary layui-btn-sm" style="border-color: #FFF"  onclick="report(' + item.id + ')"><i class="fa fa-exclamation-triangle" aria-hidden="true" style="color: #99a2aa"></i></button>';
                        }
                        html += '</div>';
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
                    layer.msg("点赞成功",{offset: ['250px', '470px']});
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

    //发送评论
    function sendComment(studyStatusId) {
        // 获取文字内容
        var textarea = document.getElementById('content');
        var content = textarea.value;
        console.log('文字内容是：' + content);
        const now = new Date();
        $.ajax({
            url: '/user/addComment',
            type: 'POST',
            data: {studyStatusId: studyStatusId, userId: ${user.id}, commentContent: content},
            success: function(result) {
                if (result.code == 200) {
                    console.log(result.count);
                    // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    // parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();
                    layer.msg("评论成功");
                    // location.href='/user/addStudyStatusPage';
                    // // layer.msg("创建成功");
                    var commentCountElement = document.querySelector('[data-index="' + studyStatusId + '"] [data-name="commentCount"]');
                    var commentCount = commentCountElement.textContent.trim();
                    var commentCountNumber = parseInt(commentCount);
                    commentCountNumber += 1;
                    console.log("commentCountNumber" + commentCountNumber);
                    commentCountElement.textContent = " " + commentCountNumber.toString();

                    var html = '';

                    // html += '<div class="layui-col-md6" style="margin: 0 auto; float: none; width: 550px; height: auto">';
                    html += '<div class="layui-card" style="margin-bottom: 0px" data-commentId=' + result.count + '>';
                    html += '<div class="layui-card-header user-info-comment" style="height: auto;margin: 0;line-height: 25px">';
                    html += '<div class="comment-avatar" style="margin-top: 15px">';
                    html += '<img src="${user.userAvatar}" alt="用户头像">';
                    html += '</div>';
                    html += '<div class="user-content" style="width: 408px">';
                    html += '<div class="user-name-comment">${user.userName}<pre class="layui-card-body" style="line-height: 20px;padding: 1px 15px">' + content + '</pre>' + '<span style="font-size: 12px;color: #99a2aa;display: block">' + layui.util.toDateString(now.getTime()) + '</span></div>';
                    html += '</div>';

                    html += '<div style="margin-top: 5px">';
                    html += '<button id="report" title="删除" class="layui-btn layui-btn-primary layui-btn-sm" style="border-color: #FFF"  onclick="deleteCommentById(' + result.count + ')"><i class="fa fa-trash-alt" aria-hidden="true" style="color: #99a2aa"></i></button>';
                    html += '</div>';

                    html += '</div>';
                    html += '</div>';
                    // html += '</div>';

                    //连着评论时拼接之前的评论
                    var myComment = document.getElementById('my-comment');
                    var elements = myComment.children;
                    for (var i = 0; i < elements.length; i++) {
                        html += elements[i].outerHTML;
                    }

                    $("#my-comment").html(html);
                    textarea.value = "";
                } else {
                    layer.msg("评论失败，请重试");
                }
            }
        });
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
    function report(commentId){
        var reportType = 3;
        //iframe 层
        layer.open({
            type: 2,
            title: '我要举报！',
            shadeClose: true,
            shade: 0.8,
            area: ['390px', '90%'],
            offset: ['20px', '330px'],
            content: '${pageContext.request.contextPath}/user/reportPage?reportType=' + reportType + '&beReportedId=' + commentId//iframe的url
        });
    }

    //删除评论
    function deleteCommentById(commentId){
        //询问框
        layer.confirm('确定删除你的评论吗？', {
            btn: ['确定','取消'] ,offset: ['200px', '370px']
        }, function(){
            $.ajax({
                url: '/user/deleteCommentById',
                type: 'POST',
                data: {commentId: commentId, studyStatusId: ${studyStatus.id}},
                success: function(result) {
                    if (result.code == 200) {
                        // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                        // parent.layer.close(index); //再执行关闭
                        //parent.parent.location.reload();
                        layer.msg("删除成功",{offset: ['250px', '470px']});
                        // location.href='/user/addStudyStatusPage';
                        // // layer.msg("创建成功");
                        var commentCountElement = document.querySelector('[data-index="' + ${studyStatus.id} + '"] [data-name="commentCount"]');
                        var commentCount = commentCountElement.textContent.trim();
                        var commentCountNumber = parseInt(commentCount);
                        commentCountNumber -= 1;
                        console.log("commentCountNumber" + commentCountNumber);
                        commentCountElement.textContent = " " + commentCountNumber.toString();

                        //var comment = document.querySelector('[data-commentId="' + commentId + '"]');
                        var comment = $('[data-commentId="' + commentId + '"]');
                        comment.addClass('none');

                    } else {
                        layer.msg("删除失败，请重试",{offset: ['250px', '470px']});
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
            anim: 0,
            offset: ['70px', '250px'],
            area: ['600px', '400px'], // 指定图片的尺寸
            init: function() {
                layer.photosIndex = index;
            }
        });
    });
</script>
</body>
</html>
