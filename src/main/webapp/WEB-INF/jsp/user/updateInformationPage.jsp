<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/30
  Time: 0:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>updateInformationPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
</head>
<body>
<style>
    .user-avatar {
    flex-shrink: 0;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    overflow: hidden;
    margin-left: 175px;
    margin-top: 30px;
    }
    .user-avatar img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    }
</style>
<%--<%--%>
<%--    if (request.getAttribute("updateSuccess") != null) {--%>
<%--        out.println("<script language='JavaScript'>alert('添加成功');window.location.href='/user/personalCenterPage'</script>");--%>
<%--        return;--%>
<%--    }--%>
<%--%>--%>

<form class="layui-form" style="margin: 0px 130px" id="updateInformation">
    <label class="layui-form-label">头像</label>
    <div class="user-avatar" id="icon">
        <img src="${user.userAvatar}" alt="用户头像" title="点击更换头像" id="userAvatar">
    </div>
    <input style="display: none" value="${user.id}" name="userId">
    <div class="layui-form-item">
        <label class="layui-form-label">昵称</label>
        <div class="layui-input-block">
            <input type="text" name="userName" required  lay-verify="required" style="width: 200px; margin-top: 20px" placeholder="请输入昵称" autocomplete="off" class="layui-input" value="${user.userName}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">手机号</label>
        <div class="layui-input-block">
            <input type="text" name="cellPhone" required  lay-verify="required" disabled style="width: 200px" autocomplete="off" class="layui-input" value="${user.cellPhone}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">性别</label>
        <div class="layui-input-block">
            <input type="radio" name="gender" value="1" title="男" >
            <input type="radio" name="gender" value="2" title="女">
            <input type="radio" name="gender" value="0" title="保密" checked="checked">
        </div>
    </div>
    <div class="layui-form-item" style="margin-left: 10px">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>

<script>
    layui.use('upload', function(){
        var upload = layui.upload;
        var upFile;

        //执行实例
        var uploadInst = upload.render({
            elem: '#icon' //绑定元素
            ,url: '/user/qiniuUpToken' //上传接口
            ,accept: 'images' //上传文件类型，只能选择图片文件
            ,data : {
                userId : ${user.id}
            }
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
                            $("#userAvatar").attr("src",result.imgPath);
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

    $('#updateInformation').submit(function(e) {
        e.preventDefault();
        var userId = $('input[name="userId"]').val();
        var userName = $('input[name="userName"]').val();
        var gender = $('input[name="gender"]').val();
        $.ajax({
            url: '/user/updateInformation',
            type: 'POST',
            data: {userId: userId, userName: userName, gender: gender},
            success: function(data) {
                if (data == 'success') {
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    parent.parent.location.reload();
                    //parent.location.href='/user/personalCenterPage';
                    layer.msg("修改成功");
                } else {
                    alert('修改失败！请重试');
                }
            }
        });
    });
</script>
</body>
</html>
