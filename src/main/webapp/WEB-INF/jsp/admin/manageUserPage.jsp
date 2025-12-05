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
    <title>manageUserPage</title>
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
    <label class="layui-form-label" style="width: 130px">根据用户ID搜索用户:</label>
    <div class="layui-input-inline">
        <input type="text" name="search" placeholder="输入用户ID" class="layui-input">
    </div>
    <div class="layui-input-inline">
        <button class="layui-btn layui-btn-normal" id="search" lay-submit lay-filter="search">搜索</button>
        <button class="layui-btn " id="latelyUser">近5天注册用户</button>
    </div>
</div>
<table class="layui-hide none" id="searchUser" lay-filter="searchUser"></table>
<table class="layui-hide" id="test" lay-filter="test"></table>


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
    $("#latelyUser").click(function () {
        $('*[lay-id="searchUser"]').addClass('none');
        $('*[lay-id="test"]').removeClass('none');
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
                layer.confirm('确认解封该用户吗？', {
                    btn: ['确认', '取消'],
                    offset: ['190px','400px']

                },function(index){
                    // obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，更新数据
                    $.ajax({
                        type: 'post',
                        url: '/admin/notBanUserById',
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

            if(layEvent === 'notPass'){

                layer.prompt({
                    title: '请输入封禁天数',
                    formType: 0
                },function(value, index, elem,){
                    //alert(value); //得到value
                    if(isNaN(value)){
                        alert("你输入的不是数值，请重试！")
                        layer.close(index);
                    }else {
                        $.ajax({
                            type: 'post',
                            url: '/admin/banUserByDay',
                            data: {
                                id: data.id,
                                banDay: value
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
                    }

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
                elem: '#searchUser'
                ,url:'<%=request.getContextPath()%>/admin/selectUserById?id=' + id
                ,toolbar: '#toolbarDemo'
                ,title: '用户表'
                ,totalRow: false
                ,cols: [[
                    {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                    ,{field:'userName', title:'昵称', width:120,}
                    ,{field:'cellPhone', title:'手机号', width:150}
                    ,{field:'gender', title:'性别', width:70,
                        templet: function(d) {
                            if (d.gender === 0) {
                                return '<span style="">保密</span>';
                            } else if (d.gender === 1) {
                                return '<span style="color:green;">男</span>';
                            } else if(d.gender === 2){
                                return '<span style="color:blue;">女</span>';
                            }
                        }
                    }
                    ,{field:'exp', title:'用户经验', width:90}
                    ,{field:'rank', title:'用户等级', width:90}
                    ,{field: 'auditStatus',
                        title: '状态',
                        width: 75,
                        templet: function(d) {
                            if (d.status === 0) {
                                return '<span style="color:green;">正常</span>';
                            } else if (d.status === 1) {
                                return '<span style="color:red;">封禁中</span>';
                            }
                        }}
                    ,{field:'banDay', title:'封禁剩余天数', width:115}
                    ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                    }
                    ,{fixed: 'right', title:'操作', width:150,
                        templet: function(d) {
                            if (d.status === 0) {
                                return '<a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">封禁</a>';
                            } else if (d.status === 1) {
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

    //数据表格加载
    layui.use('table', function(){
        var table = layui.table;

        //工具条事件
        table.on('tool(test)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

            if(layEvent === 'pass'){ //删除
                layer.confirm('确认解封该用户吗？', {
                    btn: ['确认', '取消'],
                    offset: ['190px','400px']

                },function(index){
                    // obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，更新数据
                    $.ajax({
                        type: 'post',
                        url: '/admin/notBanUserById',
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

            if(layEvent === 'notPass'){ //删除

                layer.prompt({
                    title: '请输入封禁天数',
                    formType: 0
                },function(value, index, elem,){
                    //alert(value); //得到value
                    if(isNaN(value)){
                        alert("你输入的不是数值，请重试！")
                        layer.close(index);
                    }else {
                        $.ajax({
                            type: 'post',
                            url: '/admin/banUserByDay',
                            data: {
                                id: data.id,
                                banDay: value
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
                    }

                });

            }
        });

        table.render({
            elem: '#test'
            ,url:'<%=request.getContextPath()%>/admin/selectLatelyUser'
            ,toolbar: '#toolbarDemo'
            ,title: '用户表'
            ,totalRow: false
            ,cols: [[
                {field:'id', title:'ID', width:70, fixed: 'left', unresize: true, sort: true,}
                ,{field:'userName', title:'昵称', width:120,}
                ,{field:'cellPhone', title:'手机号', width:150}
                ,{field:'gender', title:'性别', width:70,
                        templet: function(d) {
                            if (d.gender === 0) {
                                return '<span style="">保密</span>';
                            } else if (d.gender === 1) {
                                return '<span style="color:green;">男</span>';
                            } else if(d.gender === 2){
                                return '<span style="color:blue;">女</span>';
                            }
                        }
                }
                ,{field:'exp', title:'用户经验', width:90}
                ,{field:'rank', title:'用户等级', width:90}
                ,{field: 'auditStatus',
                    title: '状态',
                    width: 75,
                    templet: function(d) {
                        if (d.status === 0) {
                            return '<span style="color:green;">正常</span>';
                        } else if (d.status === 1) {
                            return '<span style="color:red;">封禁中</span>';
                        }
                    }}
                ,{field:'banDay', title:'封禁剩余天数', width:115}
                ,{field:'createTime', title:'创建时间', width:160, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                }
                ,{fixed: 'right', title:'操作', width:150,
                    templet: function(d) {
                        if (d.status === 0) {
                            return '<a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 10px;" lay-event="notPass">封禁</a>';
                        } else if (d.status === 1) {
                            return '<a class="layui-btn layui-btn-sm " style="background-color: #5FB878;margin-left: 10px" lay-event="pass">解封</a>';
                        }
                    }}
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
