<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/4
  Time: 16:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>noticePage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body style="background-color: #F6F6F6">
<div class="" style="padding: 30px;color: #5f5f5f!important;margin-top: 50px">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md6" style="margin: 0 auto; float: none; width: 550px; height: auto">
            <div class="layui-card">
                <div class="layui-card-header">
                    <span style="font-size: 14px">发布公告</span>
                    <button id="submit" class="layui-btn layui-btn-primary layui-border-blue layui-btn-radius layui-btn-xs" style="margin-left: 350px">发布<i class="layui-icon layui-icon-release" style="font-size: 30px; color: #1E9FFF;"></i></button>
                </div>
                <div class="layui-card-header" style="height: 50px;padding: 0px">
                    <textarea id="title" placeholder="公告标题" class="layui-textarea layui-card-body" style="min-height: 100%;width:535px;color: #5f5f5f;font-family: monospace;"></textarea>
                </div>
                <textarea id="content" placeholder="公告内容" class="layui-textarea layui-card-body" style="height: 240px;color: #5f5f5f;font-family: monospace;"></textarea>

            </div>
        </div>
    </div>
</div>
<script>
    $("#submit").click(function () {
        // 获取文字内容
        var textarea2 = document.getElementById('title');
        var title = textarea2.value;
        console.log('文字内容是：' + title);

        var textarea = document.getElementById('content');
        var content = textarea.value;
        console.log('文字内容是：' + content);

        $.ajax({
            url: '/admin/addNotice',
            type: 'POST',
            data: {adminId: ${admin.id}, title: title, content: content},
            success: function(data) {
                if (data == 'success') {
                    // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    // parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();
                    alert("发布成功！")
                    location.href='/admin/noticePage';
                    // layer.msg("创建成功");
                } else {
                    alert('发布失败！请重试');
                }
            }
        });
    });
</script>
</body>
</html>
