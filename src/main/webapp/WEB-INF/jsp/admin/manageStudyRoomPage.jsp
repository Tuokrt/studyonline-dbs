<%@ page import="com.wyu.studyonline.pojo.Admin" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/5/4
  Time: 16:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>manageStudyRoomPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<style>
    .none{
        display: none;
    }
</style>
<body>
<div class="layui-inline" style="margin-top: 50px;margin-bottom: 15px;position: relative;left: 50%;transform: translateX(-50%);">
    <label class="layui-form-label" style="width: 130px">根据ID搜索自习室:</label>
    <div class="layui-input-inline">
        <input type="text" name="search" placeholder="输入自习室ID" class="layui-input">
    </div>
    <div class="layui-input-inline">
        <button class="layui-btn layui-btn-normal" id="search" lay-submit lay-filter="search">搜索</button>
        <button class="layui-btn " id="studyRoom">未封禁自习室</button>
        <button class="layui-btn layui-btn-danger" id="banStudyRoom">已封禁自习室</button>
    </div>
</div>
<table class="layui-hide none" id="searchUser" lay-filter="searchUser"></table>
<table class="layui-hide" id="test" lay-filter="test"></table>
<table class="layui-hide" id="ban" lay-filter="ban"></table>


<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <%--        <button class="layui-btn layui-btn-sm" lay-event="deleteChecked">删除选中项</button>--%>
        <%--        <button class="layui-btn layui-btn-sm" lay-event="update">修改</button>--%>
    </div>
</script>
<%--<script type="text/html" id="barDemo">--%>
<%--    <a class="layui-btn layui-btn-sm " style="background-color: #5FB878" lay-event="pass">通过</a>--%>
<%--    <a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">不通过</a>--%>
<%--</script>--%>

<script>
    //只显示未封禁自习室
    $("#studyRoom").click(function () {
        $('*[lay-id="searchUser"]').addClass('none');
        $('*[lay-id="ban"]').addClass('none');
        $('*[lay-id="test"]').removeClass('none');
        //未封禁自习室数据表格加载
        layui.use('table', function(){
            var table = layui.table;

            //工具条事件
            table.on('tool(test)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
                var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
                var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

                if(layEvent === 'pass'){ //解封
                    layer.confirm('确认解封该自习室吗？', {
                        btn: ['确认', '取消'],
                        offset: ['190px','400px']

                    },function(index){
                        // obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                        layer.close(index);
                        //向服务端发送删除指令
                        // 发送ajax请求，更新数据
                        $.ajax({
                            type: 'post',
                            url: '/admin/notBanStudyRoomById',
                            data: {
                                id: data.id,
                            },
                            success: function(res){
                                if(res == "success"){
                                    layer.msg('解封成功');
                                    location.reload();
                                }else{
                                    layer.msg('解封失败');
                                }
                            },
                            error: function(){
                                layer.msg('网络错误');
                            }
                        });
                    });
                }

                if(layEvent === 'notPass'){ //封禁

                    layer.confirm('确认封禁该自习室吗？', {
                        btn: ['确认', '取消'],
                        offset: ['190px','400px']

                    },function(index){
                        $.ajax({
                            type: 'post',
                            url: '/admin/banStudyRoomById',
                            data: {
                                id: data.id
                            },
                            success: function(res){
                                if(res == "success"){
                                    layer.msg('封禁成功');
                                    $("#studyRoom").click();
                                }else{
                                    layer.msg('封禁失败');
                                }
                            },
                            error: function(){
                                layer.msg('网络错误');
                            }
                        });
                        layer.close(index);

                    });

                }

                if(layEvent === 'joinStudyRoom'){ //进入自习室


                }
            });

            table.render({
                elem: '#test'
                ,url:'<%=request.getContextPath()%>/admin/selectAllStudyRoom'
                ,toolbar: '#toolbarDemo'
                ,title: '自习室表'
                ,totalRow: false
                ,cols: [[
                    {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                    ,{field:'userId', title:'UserId', width:85,}
                    ,{field:'roomName', title:'自习室名称', width:105}
                    ,{field:'roomDescride', title:'自习室描述', width:150}
                    ,{field:'roomCover', title:'封面图片', width:120,
                        templet: function (d) {
                            return '<img src="' + d.roomCover + '" height="50" class="roomCover">';
                        }}
                    ,{field:'userCard', title:'身份证号', width:175}
                    ,{field: 'auditStatus',
                        title: '状态',
                        width: 100,
                        templet: function(d) {
                            if (d.auditStatus === 0) {
                                return '<span style="color:red;">待审核</span>';
                            } else if (d.auditStatus === 1) {
                                return '<span style="color:green;">审核通过</span>';
                            } else if (d.auditStatus === 3) {
                                return '<span style="color:red;">已封禁</span>';
                            } else {
                                return '';
                            }
                        }}
                    ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                    }
                    ,{fixed: 'right', title:'操作', width:100,
                        templet: function(d) {
                            if (d.auditStatus === 1) {
                                if(d.openStatus === 0){
                                    return '<a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">封禁</a>';
                                }else if(d.openStatus === 1){
                                    return '<a class="layui-btn layui-btn-sm layui-btn-danger" href="/admin/adminJoinStudyRoom?roomId=' + d.id +  '" style="margin-left: 10px;" lay-event="joinStudyRoom" title="点击进入自习室">自习中</a>';
                                }
                            } else if (d.auditStatus === 3) {
                                return '<a class="layui-btn layui-btn-sm " style="background-color: #5FB878" lay-event="pass">解封</a>';
                            }
                        }}
                ]]
                ,page: true
            });


        });
    });
    //只显示已封禁自习室
    $("#banStudyRoom").click(function () {
        $('*[lay-id="searchUser"]').addClass('none');
        $('*[lay-id="test"]').addClass('none');
        $('*[lay-id="ban"]').removeClass('none');
        //已封禁自习室数据表格加载
        layui.use('table', function(){
            var table = layui.table;

            //工具条事件
            table.on('tool(ban)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
                var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
                var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

                if(layEvent === 'pass'){ //解封
                    layer.confirm('确认解封该自习室吗？', {
                        btn: ['确认', '取消'],
                        offset: ['190px','400px']

                    },function(index){
                        // obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                        layer.close(index);
                        //向服务端发送删除指令
                        // 发送ajax请求，更新数据
                        $.ajax({
                            type: 'post',
                            url: '/admin/notBanStudyRoomById',
                            data: {
                                id: data.id,
                            },
                            success: function(res){
                                if(res == "success"){
                                    layer.msg('解封成功');
                                    $("#banStudyRoom").click();
                                }else{
                                    layer.msg('解封失败');
                                }
                            },
                            error: function(){
                                layer.msg('网络错误');
                            }
                        });
                    });
                }

                if(layEvent === 'notPass'){ //封禁

                    layer.confirm('确认封禁该自习室吗？', {
                        btn: ['确认', '取消'],
                        offset: ['190px','400px']

                    },function(index){
                        $.ajax({
                            type: 'post',
                            url: '/admin/banStudyRoomById',
                            data: {
                                id: data.id
                            },
                            success: function(res){
                                if(res == "success"){
                                    layer.msg('封禁成功');
                                    location.reload();
                                }else{
                                    layer.msg('封禁失败');
                                }
                            },
                            error: function(){
                                layer.msg('网络错误');
                            }
                        });
                        layer.close(index);

                    });

                }

                if(layEvent === 'joinStudyRoom'){ //进入自习室


                }
            });

            table.render({
                elem: '#ban'
                ,url:'<%=request.getContextPath()%>/admin/selectAllBanStudyRoom'
                ,toolbar: '#toolbarDemo'
                ,title: '自习室表'
                ,totalRow: false
                ,cols: [[
                    {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                    ,{field:'userId', title:'UserId', width:85,}
                    ,{field:'roomName', title:'自习室名称', width:105}
                    ,{field:'roomDescride', title:'自习室描述', width:150}
                    ,{field:'roomCover', title:'封面图片', width:120,
                        templet: function (d) {
                            return '<img src="' + d.roomCover + '" height="50" class="roomCover">';
                        }}
                    ,{field:'userCard', title:'身份证号', width:175}
                    ,{field: 'auditStatus',
                        title: '状态',
                        width: 100,
                        templet: function(d) {
                            if (d.auditStatus === 0) {
                                return '<span style="color:red;">待审核</span>';
                            } else if (d.auditStatus === 1) {
                                return '<span style="color:green;">审核通过</span>';
                            } else if (d.auditStatus === 3) {
                                return '<span style="color:red;">已封禁</span>';
                            } else {
                                return '';
                            }
                        }}
                    ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                    }
                    ,{fixed: 'right', title:'操作', width:100,
                        templet: function(d) {
                            if (d.auditStatus === 1) {
                                if(d.openStatus === 0){
                                    return '<a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">封禁</a>';
                                }else if(d.openStatus === 1){
                                    return '<a class="layui-btn layui-btn-sm layui-btn-danger" href="/admin/adminJoinStudyRoom?roomId=' + d.id +  '" style="margin-left: 10px;" lay-event="joinStudyRoom" title="点击进入自习室">自习中</a>';
                                }
                            } else if (d.auditStatus === 3) {
                                return '<a class="layui-btn layui-btn-sm " style="background-color: #5FB878" lay-event="pass">解封</a>';
                            }
                        }}
                ]]
                ,page: true
            });


        });
    });

    //搜索相关
    layui.use(['form','table'], function(){
        var form = layui.form;
        var table = layui.table;

        //工具条事件
        table.on('tool(searchUser)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

            if(layEvent === 'pass'){ //删除
                layer.confirm('确认解封该自习室吗？', {
                    btn: ['确认', '取消'],
                    offset: ['190px','400px']

                },function(index){
                    // obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，更新数据
                    $.ajax({
                        type: 'post',
                        url: '/admin/notBanStudyRoomById',
                        data: {
                            id: data.id,
                        },
                        success: function(res){
                            if(res == "success"){
                                layer.msg('解封成功');
                                $('input[name="search"]').val(data.id);
                                $('#search').click();
                            }else{
                                layer.msg('解封失败');
                            }
                        },
                        error: function(){
                            layer.msg('网络错误');
                        }
                    });
                });
            }

            if(layEvent === 'notPass'){ //封禁

                layer.confirm('确认封禁该自习室吗？', {
                    btn: ['确认', '取消'],
                    offset: ['190px','400px']

                },function(index){
                    $.ajax({
                        type: 'post',
                        url: '/admin/banStudyRoomById',
                        data: {
                            id: data.id
                        },
                        success: function(res){
                            if(res == "success"){
                                layer.msg('封禁成功');
                                $('input[name="search"]').val(data.id);
                                $('#search').click();
                            }else{
                                layer.msg('封禁失败');
                            }
                        },
                        error: function(){
                            layer.msg('网络错误');
                        }
                    });
                    layer.close(index);

                });

            }
        });

        //监听表单提交
        form.on('submit(search)', function(data){
            $('*[lay-id="test"]').addClass('none');
            $('*[lay-id="ban"]').addClass('none');
            //处理搜索逻辑
            var id = $('input[name="search"]').val();
            console.log(id); //输出搜索关键字
            table.render({
                elem: '#searchUser'
                ,url:'<%=request.getContextPath()%>/admin/selectStudyRoomById?id=' + id
                ,toolbar: '#toolbarDemo'
                ,title: '自习室表'
                ,totalRow: false
                ,cols: [[
                    {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                    ,{field:'userId', title:'UserId', width:85,}
                    ,{field:'roomName', title:'自习室名称', width:105}
                    ,{field:'roomDescride', title:'自习室描述', width:150}
                    ,{field:'roomCover', title:'封面图片', width:120,
                        templet: function (d) {
                            return '<img src="' + d.roomCover + '" height="50" class="roomCover">';
                        }}
                    ,{field:'userCard', title:'身份证号', width:175}
                    ,{field: 'auditStatus',
                        title: '状态',
                        width: 100,
                        templet: function(d) {
                            if (d.auditStatus === 0) {
                                return '<span style="color:red;">待审核</span>';
                            } else if (d.auditStatus === 1) {
                                return '<span style="color:green;">审核通过</span>';
                            } else if (d.auditStatus === 3) {
                                return '<span style="color:red;">已封禁</span>';
                            } else {
                                return '';
                            }
                        }}
                    ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                    }
                    ,{fixed: 'right', title:'操作', width:100,
                        templet: function(d) {
                            if (d.auditStatus === 1) {
                                if(d.openStatus === 0){
                                    return '<a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">封禁</a>';
                                }else if(d.openStatus === 1){
                                    return '<a class="layui-btn layui-btn-sm layui-btn-danger" href="/admin/adminJoinStudyRoom?roomId=' + d.id +  '" style="margin-left: 10px;" lay-event="joinStudyRoom" title="点击进入自习室">自习中</a>';
                                }
                            } else if (d.auditStatus === 3) {
                                return '<a class="layui-btn layui-btn-sm " style="background-color: #5FB878" lay-event="pass">解封</a>';
                            }
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
