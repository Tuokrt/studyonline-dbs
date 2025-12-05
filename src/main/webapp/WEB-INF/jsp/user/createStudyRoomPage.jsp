<%@ page import="com.wyu.studyonline.pojo.Category" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/5
  Time: 16:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>createStudyRoomPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
</head>
<body>
<style>
    .none{
        display: none;
    }
    #userAvatar {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
</style>
<%--<%--%>
<%--    if (request.getAttribute("createSuccess") != null) {--%>
<%--        out.println("<script language='JavaScript'>alert('创建成功');window.location.href='/user/personalCenterPage'</script>");--%>
<%--        return;--%>
<%--    }--%>
<%--%>--%>

<form class="layui-form" style="margin: 0px 130px" id="createStudyRoom">

    <input style="display: none" value="${user.id}" name="userId">
    <div class="layui-form-item">
        <label class="layui-form-label">自习室名称</label>
        <div class="layui-input-block">
            <input type="text" name="roomName" required  lay-verify="required" style="width: 200px; margin-top: 20px" placeholder="请输入内容" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">自习室描述</label>
        <div class="layui-input-block">
            <input type="text" name="roomDescride" required  lay-verify="required" placeholder="请输入内容" style="width: 200px" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">自习室分类</label>
        <div class="layui-inline" style="width: 200px;">
            <input name="category" placeholder="请输入内容" readonly=“true” class="layui-input" id="category">
            <input name="categoryId" style="display: none" id="categoryId">
        </div>
    </div>
    <label class="layui-form-label">自习室封面</label>
    <div style="width: 200px;height: 90px;  margin-top: -5px;padding: 0; display:table-cell; vertical-align: middle;" class="layui-upload-drag" id="icon">
        <img src="" alt="自习室封面" title="点击更换封面" id="userAvatar" class="layui-hide">
        <i id="icon-upload" class="layui-icon layui-icon-upload-drag" style="font-size: 30px; color: #999;margin-top: 10px;"></i>
        <p id="icon-p" style="font-size: 13px;">点击上传，或将文件拖拽到此处</p>
        <input name="roomCover" style="display: none" id="roomCover">
    </div>
    <div class="layui-form-item" style="margin-top: 10px">
        <label class="layui-form-label">身份证号码</label>
        <div class="layui-input-block">
            <input type="text" name="userCard" required  lay-verify="required|identity" placeholder="请输入内容" style="width: 200px" autocomplete="off" class="layui-input">
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

                            $("#icon-upload").addClass("none");
                            $("#icon-p").addClass("none");
                            $("#userAvatar").removeClass("layui-hide");
                            $("#userAvatar").attr("src",result.imgPath);
                            $("#roomCover").val(result.imgPath);

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

    $('#createStudyRoom').submit(function(e) {
        e.preventDefault();
        var userId = $('input[name="userId"]').val();
        var categoryId = $('input[name="categoryId"]').val();
        var roomName = $('input[name="roomName"]').val();
        var roomDescride = $('input[name="roomDescride"]').val();
        var roomCover = $('input[name="roomCover"]').val();
        var userCard = $('input[name="userCard"]').val();
        $.ajax({
            url: '/user/createStudyRoom',
            type: 'POST',
            data: {userId: userId, categoryId: categoryId, roomName: roomName, roomDescride: roomDescride, roomCover: roomCover, userCard: userCard},
            success: function(data) {
                if (data == 'success') {
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();
                    parent.location.href='/user/myStudyRoomPage';
                    layer.msg("创建成功");
                } else {
                    alert('创建失败！请重试');
                }
            }
        });
    });

    //分类选项下拉框
    layui.use(['dropdown', 'util', 'layer', 'table'], function() {
        var dropdown = layui.dropdown
            , util = layui.util
            , layer = layui.layer
            , table = layui.table

        //初演示 - 绑定输入框
        dropdown.render({
            elem: '#category'
            ,data: [
                <%
                List<Category> categoryList = (List<Category>)session.getAttribute("categoryList");
                for(Category category : categoryList){


            %>
                {
                    title: '<%=category.getName()%>'
                    ,id: <%=category.getId()%>
                },
                <%
                    }
                %>
            ]
            ,click: function(data,othis){
                this.elem.val(data.title);
                $("#categoryId").val(data.id);
            }
            ,style: 'width: 200px;'
        });

    });

</script>
</body>
</html>
