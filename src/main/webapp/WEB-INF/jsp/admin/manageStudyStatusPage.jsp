<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/4
  Time: 16:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>manageStudyStatusPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>
<div class="layui-inline" style="margin-top: 50px;margin-bottom: 15px;position: relative;left: 50%;transform: translateX(-50%);">
    <label class="layui-form-label" style="width: 130px">根据ID搜索动态:</label>
    <div class="layui-input-inline">
        <input type="text" name="search" placeholder="输入动态ID" class="layui-input">
    </div>
    <div class="layui-input-inline">
        <button class="layui-btn layui-btn-normal" id="search" lay-submit lay-filter="search">搜索</button>
    </div>
</div>
<table class="layui-hide none" id="searchStudyStatus" lay-filter="searchStudyStatus"></table>


<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">

    </div>
</script>
<script>
    //搜索相关
    layui.use(['form','table'], function(){
        var form = layui.form;
        var table = layui.table;

        //工具条事件
        table.on('tool(searchStudyStatus)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

            if(layEvent === 'delete'){ //删除
                layer.confirm('确认删除该动态吗？', {
                    btn: ['确认', '取消'],
                    offset: ['190px','400px']

                },function(index){
                    obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，更新数据
                    $.ajax({
                        type: 'post',
                        url: '/admin/deleteStudyStatus',
                        data: {
                            studyStatusId: data.id,
                        },
                        success: function(result){
                            console.log(result.code);
                            if(result.code == 200){
                                layer.msg('删除成功');
                                // $('input[name="search"]').val(data.id);
                                // $('#search').click();
                            }else{
                                layer.msg('删除失败');
                            }
                        },
                        error: function(){
                            layer.msg('网络错误');
                        }
                    });
                });
            }

        });

        //监听表单提交
        form.on('submit(search)', function(data){
            $('*[lay-id="test"]').addClass('none');
            //处理搜索逻辑
            var id = $('input[name="search"]').val();
            console.log(id); //输出搜索关键字
            table.render({
                elem: '#searchStudyStatus'
                ,url:'<%=request.getContextPath()%>/admin/selectStudyStatusById?id=' + id
                ,toolbar: '#toolbarDemo'
                ,title: '动态表'
                ,totalRow: false
                ,cols: [[
                    {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                    ,{field:'userId', title:'用户ID', width:80,}
                    ,{field:'content', title:'动态内容', width:150}
                    ,{field:'firstPhoto', title:'图片1', width:100,
                        templet: function (d) {
                            if (d.firstPhoto == '' || d.firstPhoto == null) {
                                return '无';
                            } else{
                                return '<img src="' + d.firstPhoto + '" height="50" class="roomCover">';
                            }

                        }}
                    ,{field:'secondPhoto', title:'图片2', width:100,
                        templet: function (d) {
                            if (d.secondPhoto == '' || d.secondPhoto == null) {
                                return '无';
                            } else{
                                return '<img src="' + d.secondPhoto + '" height="50" class="roomCover">';
                            }

                        }}
                    ,{field:'thirdPhoto', title:'图片3', width:100,
                        templet: function (d) {
                            if (d.thirdPhoto == '' || d.thirdPhoto == null) {
                                return '无';
                            } else{
                                return '<img src="' + d.thirdPhoto + '" height="50" class="roomCover">';
                            }

                        }}
                    ,{field:'transmitCount', title:'转发数', width:78}
                    ,{field:'commentCount', title:'评论数', width:78}
                    ,{field:'likeCount', title:'点赞数', width:78}
                    ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                    }
                    ,{fixed: 'right', title:'操作', width:90,
                        templet: function(d) {
                            return '<a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="delete">删除</a>';
                        }}
                ]]
                ,page: true
            });
            $('input[name="search"]').val('');
            return false; //阻止表单跳转
        });
    });

    // 查看图片
    $(document).on('click', '.roomCover', function() {
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
