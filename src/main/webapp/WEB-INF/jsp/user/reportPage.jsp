<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/3
  Time: 16:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>reportPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.15.3/css/all.min.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
</head>
<body>
<div class="layui-form">
    <div class="layui-form-item" style="align-items: center;">
        <input type="text" style="display: none" name="userId" value="${user.id}">
        <input type="text" style="display: none" name="reportType" value="${reportType}">
        <input type="text" style="display: none" name="beReportedId" value="${beReportedId}">
        <label class="layui-form-label">举报理由：</label>
        <div class="layui-input-block">
            <input type="radio" name="reason" value="垃圾广告" title="垃圾广告">
            <input type="radio" name="reason" value="引战" title="引战">
            <input type="radio" name="reason" value="色情暴力" title="色情暴力">
            <input type="radio" name="reason" value="人身攻击" title="人身攻击">
            <input type="radio" name="reason" value="违法信息" title="违法信息">
            <input type="radio" name="reason" value="涉政谣言" title="涉政谣言">
            <input type="radio" name="reason" value="不实信息" title="不实信息">
            <input type="radio" name="reason" value="其他" title="其他">
        </div>
<%--        <input type="text" name="reportContent" style="display: none">--%>
        <textarea id="content" placeholder="补充举报的详细信息，可以帮助审核人员更快处理哦！" class="layui-textarea layui-card-body" style="min-height: 22px;width:90%; margin-left: 18px;margin-top: 10px;margin-bottom: 15px; background-color: #f4f5f7"></textarea>
        <label class="layui-form-label">添加图片：</label>
        <div style="width: 200px;height: 100px;padding: 0; display: table-cell; vertical-align: middle;" class="layui-upload-drag" id="icon">
            <img src="" alt="相关图片" title="点击更换图片" style="width: 200px;height: 100px;" id="userAvatar" class="layui-hide">
            <i id="icon-upload" class="layui-icon layui-icon-upload-drag" style="font-size: 30px; color: #999;margin-top: 10px;"></i>
            <p id="icon-p" style="font-size: 13px;">点击上传，或将文件拖拽到此处</p>
            <input name="photo" style="display: none" id="photo">
        </div>
        <button onclick="sendReport()" class="layui-btn" style="margin-left: 160px;margin-top: 15px;height: 30px;line-height: 30px">提交</button>
    </div>
</div>
<script>
    layui.use('upload', function(){
        var upload = layui.upload;
        var upFile;

        //执行实例
        var uploadInst = upload.render({
            elem: '#icon' //绑定元素
            ,url: '/user/uploadStudyRoomCover' //上传接口
            ,accept: 'images' //上传文件类型，只能选择图片文件
            <%--,data : {--%>
            <%--    userId : ${user.id}--%>
            <%--}--%>
            ,before : function(obj){
                //上传前回调
                //var suffix;
                obj.preview(function(index, file, result){
                    upFile = file;
                });
            }
            ,done: function(result){
                //上传完毕回调
                if(result.success == 1){
                    var observer = {                         //设置上传过程的监听函数
                        next(result){                        //上传中(result参数带有total字段的 object，包含loaded、total、percent三个属性)
                            Math.floor(result.total.percent);//查看进度[loaded:已上传大小(字节);total:本次上传总大小;percent:当前上传进度(0-100)]
                        },
                        error(err){                          //失败后
                            alert(err.message);
                        },
                        complete(res){                       //成功后
                            // ?imageView2/2/h/100：展示缩略图，不加显示原图
                            // ?vframe/jpg/offset/0/w/480/h/360：用于获取视频截图的后缀，0：秒，w：宽，h：高

                            $("#icon-upload").addClass("layui-hide");
                            $("#icon-p").addClass("layui-hide");
                            $("#userAvatar").removeClass("layui-hide");
                            $("#userAvatar").attr("src",result.imgPath);
                            $("#photo").val(result.imgPath);

                        }
                    };
                    var putExtra = {
                        fname: "",                          //原文件名
                        params: {},                         //用来放置自定义变量
                        mimeType: null                      //限制上传文件类型
                    };
                    var config = {
                        region:qiniu.region.z2,             //存储区域(z0:代表华东;z2:代表华南,不写默认自动识别)
                        concurrentRequestLimit:3            //分片上传的并发请求量
                    };
                    var observable = qiniu.upload(upFile,result.imgName,result.token,putExtra,config);
                    var subscription = observable.subscribe(observer);          // 上传开始
                    // 取消上传
                    // subscription.unsubscribe();
                }else{
                    alert(result.message);                  //获取凭证失败
                }
            }
            ,error: function(){
                alert("服务器繁忙,请重试");
            }
        });
    });

    function sendReport() {
        var textarea = document.getElementById('content');
        var content = textarea.value;
        console.log('文字内容是：' + content);
        var reason = $('input[name="reason"]:checked').val();
        var reportContent = '#' + reason + '#' + content;

        var userId = $('input[name="userId"]').val();
        var reportType = $('input[name="reportType"]').val();
        var beReportedId = $('input[name="beReportedId"]').val();
        var photo = $('input[name="photo"]').val();
        $.ajax({
            url: '/user/addReport',
            type: 'POST',
            data: {userId: userId, reportType: reportType, beReportedId: beReportedId, reportContent: reportContent, photo: photo},
            success: function(result) {
                if (result.code == 200) {
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();
                    //parent.location.href='/user/myStudyRoomPage';
                    parent.parent.layer.msg("举报成功，管理员待审核！");
                } else {
                    alert('举报失败！请重试');
                }
            }
        });
    }
</script>
</body>
</html>
