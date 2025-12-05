<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/4/4
  Time: 1:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>addStudyStatusPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/qiniu-js/2.5.5/dist/qiniu.min.js" charset="utf-8"></script>
    <style>
        [contenteditable=true] {
            outline: none;
        }

        /* 图片预览样式 */
        .layui-upload-list {
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
        .layui-icon-close-circle {
            display: block;
            position: absolute;
            top: 0;
            right: 0;
            font-size: 20px;
            color: #FF5722;
            cursor: pointer;
        }
        .layui-icon-close-circle:hover {
            color: #FFB800;
        }
    </style>
</head>
<body style="background-color: #F6F6F6">
<div class="" style="padding: 30px;color: #5f5f5f!important">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md6" style="margin: 0 auto; float: none; width: 550px; height: auto">
            <div class="layui-card">
                <div class="layui-card-header">
                    <span style="font-size: 14px">发布学习动态</span>
                    <button id="submit" class="layui-btn layui-btn-primary layui-border-blue layui-btn-radius layui-btn-xs" style="margin-left: 350px">发布<i class="layui-icon layui-icon-release" style="font-size: 30px; color: #1E9FFF;"></i></button>
                </div>
<%--                <div class="layui-card-body" id="content" contenteditable="true" style="font-size: 14px; line-height: 22px; height: 220px;" onfocus="if (this.innerText === '有什么想和大家分享的？') this.innerText = ''" onblur="if (this.innerText === '') this.innerText = '有什么想和大家分享的？'">--%>
<%--                    有什么想和大家分享的？--%>
<%--                </div>--%>
                <textarea id="content" placeholder="有什么想和大家分享的？" class="layui-textarea layui-card-body" style="height: 240px;color: #5f5f5f;font-family: monospace;"></textarea>
                <div class="layui-upload" style="height: 180px">
                    <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" style="margin-left: 450px" id="upload-btn">上传图片</button>
                    <div class="layui-upload-list" id="image-list">
                        <!-- 图片预览列表 -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    // 初始化图片上传组件
    layui.use(['upload', 'layer'], function() {
        var upload = layui.upload;
        var layer = layui.layer;
        var upFile;
        var uploadedImages = 0;
        var maxImageCount = 3;

        // 执行实例
        var uploadInst = upload.render({
            elem: '#upload-btn', // 绑定上传按钮
            url: '/user/uploadStudyRoomCover', // 上传接口地址
            multiple: false, // 允许多文件上传
            accept: 'images', // 只允许上传图片文件
            number: maxImageCount-1, // 最多上传三张图片
            before: function(obj) {
                // 上传前的回调函数
                layer.msg('正在上传，请稍候...', {icon: 16, shade: 0.01, time: 0});
                obj.preview(function(index, file, result){
                    upFile = file;
                });
            },
            done: function(result) {


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

                            // $("#icon-upload").addClass("none");
                            // $("#icon-p").addClass("none");
                            // $("#userAvatar").removeClass("layui-hide");
                            // $("#userAvatar").attr("src",result.imgPath);
                            // $("#roomCover").val(result.imgPath);
                            // 上传成功的回调函数
                            layer.close(layer.msg()); // 关闭上传提示框


                            // 添加图片预览
                            var $list = $('#image-list');
                            var $li = $('<div class="image-item" style="width: 168px;"></div>');
                            var $img = $('<img class="layui-upload-img" src="' + result.imgPath + '">');
                            var $del = $('<i class="layui-icon layui-icon-close"></i>');
                            $del.on('click', function() {
                                // 删除图片预览
                                $li.remove();
                                uploadInst.config.number++; // 增加可上传数量
                                uploadedImages--;
                                if (uploadedImages < maxImageCount) {
                                    $('#upload-btn').show();
                                }
                            });
                            $li.append($del).append($img);
                            $list.append($li);

                            // 减少可上传数量
                            uploadInst.config.number--;
                            uploadedImages++;
                            if (uploadedImages >= maxImageCount) {
                                $('#upload-btn').hide();
                            }

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
            },
            error: function() {
                // 上传失败的回调函数
                layer.close(layer.msg()); // 关闭上传提示框
                layer.msg('上传失败，请重试！', {icon: 2});
            }
        });
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
    });

    $("#submit").click(function () {
        // 获取文字内容
        var textarea = document.getElementById('content');
        var content = textarea.value;
        console.log('文字内容是：' + content);
// 获取图片预览列表中每张图片的地址
        var firstPhoto = null;
        var secondPhoto = null;
        var thirdPhoto = null;
        var $imageList = $('#image-list');
        $imageList.find('.image-item').each(function(index, element) {
            var src = $(element).find('img').attr('src');
            console.log('第' + (index + 1) + '张图片的地址为：' + src);
            if (index === 0) {
                firstPhoto = src;
            } else if (index === 1) {
                secondPhoto = src;
            } else if (index === 2) {
                thirdPhoto = src;
            }
        });
        $.ajax({
            url: '/user/addStudyStatus',
            type: 'POST',
            data: {userId: ${user.id}, content: content, firstPhoto: firstPhoto, secondPhoto: secondPhoto, thirdPhoto: thirdPhoto},
            success: function(data) {
                if (data == 'success') {
                    // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    // parent.layer.close(index); //再执行关闭
                    //parent.parent.location.reload();
                    alert("发布成功！")
                    location.href='/user/addStudyStatusPage';
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
