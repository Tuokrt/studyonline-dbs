<%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/4
  Time: 16:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>checkReportPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>

<table class="layui-hide" id="test" lay-filter="test"></table>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <%--        <button class="layui-btn layui-btn-sm" lay-event="deleteChecked">删除选中项</button>--%>
        <%--        <button class="layui-btn layui-btn-sm" lay-event="update">修改</button>--%>
    </div>
</script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-sm " style="background-color: #5FB878" lay-event="pass">处理完成</a>
<%--    <a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">不通过</a>--%>
</script>

<script>
    layui.use('table', function(){
        var table = layui.table;

        //工具条事件
        table.on('tool(test)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

            if(layEvent === 'pass'){ //删除
                layer.confirm('确认处理完成吗？', {
                    btn: ['确认', '取消'],
                    offset: ['100px','300px']

                },function(index){
                    obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，更新数据
                    $.ajax({
                        type: 'post',
                        url: '/admin/ideaReportById',
                        data: {
                            id: data.id,
                        },
                        success: function(res){
                            if(res == "success"){
                                layer.msg('处理成功');
                                location.href = "/admin/checkReportPage";
                            }else{
                                layer.msg('处理失败');
                            }
                        },
                        error: function(){
                            layer.msg('网络错误');
                        }
                    });
                });
            }

            // if(layEvent === 'notPass'){ //删除
            //     layer.confirm('确认审核不通过吗？', {
            //         btn: ['确认', '取消'],
            //         offset: ['100px','300px']
            //
            //     },function(index){
            //         obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
            //         layer.close(index);
            //         //向服务端发送删除指令
            //         // 发送ajax请求，更新数据
            //         $.ajax({
            //             type: 'post',
            //             url: '/admin/notPassStudyRoomById',
            //             data: {
            //                 id: data.id,
            //             },
            //             success: function(res){
            //                 if(res == "success"){
            //                     layer.msg('审核成功');
            //                 }else{
            //                     layer.msg('审核失败');
            //                 }
            //             },
            //             error: function(){
            //                 layer.msg('网络错误');
            //             }
            //         });
            //     });
            // }
        });

        table.render({
            elem: '#test'
            ,url:'<%=request.getContextPath()%>/admin/selectAllReport'
            ,toolbar: '#toolbarDemo'
            ,title: '举报审核表'
            ,totalRow: false
            ,cols: [[
                {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                ,{field:'userId', title:'UserId', width:80,}
                ,{field:'reportType', title:'举报类型', width:90,
                        templet: function(d) {
                            if (d.reportType === 1) {
                                return '<span style="color:red;">自习室举报</span>';
                            } else if (d.reportType === 2) {
                                return '<span style="color:green;">动态举报</span>';
                            } else if(d.reportType === 3){
                                return '<span style="color:blue;">评论举报</span>';
                            }
                        }
                }
                ,{field:'beReportedId', title:'被举报的ID', width:105}
                ,{field:'reportContent', title:'举报内容', width:220}
                ,{field:'photo', title:'photo', width:110,
                    templet: function (d) {
                        if (d.photo == '' || d.photo == null) {
                            return '无';
                        } else{
                            return '<img src="' + d.photo + '" height="50" class="roomCover">';
                        }

                    }}

                ,{field: 'status',
                    title: '状态',
                    width: 75,
                    templet: function(d) {
                        if (d.status === 0) {
                            return '<span style="color:red;">未处理</span>';
                        } else if (d.status === 1) {
                            return '<span style="color:green;">已处理</span>';
                        } else {
                            return '';
                        }
                    }}
                ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                }
                ,{field:'updateTime', title:'审核时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.updateTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                }
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:150}
            ]]
            ,page: true
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
