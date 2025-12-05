<%@ page import="com.wyu.studyonline.pojo.User" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/25
  Time: 1:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>updateStudyPlanPage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>

<table class="layui-hide" id="test" lay-filter="test"></table>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="deleteChecked">删除选中项</button>
        <button class="layui-btn layui-btn-sm" lay-event="update">修改</button>
    </div>
</script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-sm layui-btn-danger" style="margin-left: 15px" lay-event="del">删除</a>
</script>

<%
    User user = (User)session.getAttribute("user");
%>
<script>
    layui.use('table', function(){
        var table = layui.table;

        //工具条事件
        table.on('tool(test)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

            if(layEvent === 'del'){ //删除
                layer.confirm('确认删除该待办吗？', {
                    btn: ['确认', '取消'],
                    offset: ['100px','300px']

                },function(index){
                    obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，更新数据
                    $.ajax({
                        type: 'post',
                        url: '/user/deleteStudyPlanContent',
                        data: {
                            id: data.id,
                        },
                        success: function(res){
                            if(res == "success"){
                                layer.msg('删除成功');
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

        table.render({
            elem: '#test'
            ,url:'<%=request.getContextPath()%>/user/selectAllStudyPlanByUserId?userId=<%=user.getId()%>'
            ,toolbar: '#toolbarDemo'
            ,title: '学习待办表'
            ,totalRow: false
            ,cols: [[
                {type: 'checkbox', fixed: 'left'}
                ,{field:'id', title:'ID', width:80, fixed: 'left', unresize: true, sort: true,}
                ,{field:'userId', title:'用户id', width:120,}
                ,{field:'content', title:'待办内容', width:370}
                ,{field: 'status',
                    title: '状态',
                    width: 100,
                    templet: function(d) {
                        if (d.status === 0) {
                            return '<span style="color:red;">未完成</span>';
                        } else if (d.status === 1) {
                            return '<span style="color:green;">已完成</span>';
                        } else {
                            return '';
                        }
                    }}
                ,{field:'createTime', title:'创建时间', width:200, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                }
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:100}
            ]]
            ,page: true
        });

        //工具栏事件
        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'deleteChecked':
                    var data = checkStatus.data;
                    if (data.length === 0) { // 如果没有选中行，则提示用户选择至少一行
                        layer.msg('请至少选择一行');
                        return;
                    }
                    layer.confirm('确认删除选中行吗？', {
                        title: '确认删除',
                        offset: '80px',
                    },function (index) {
                        // 将选中行从数据源中删除
                        for (var i = 0; i < data.length; i++) {

                            // 这里执行删除操作，使用 AJAX 向后端发送请求
                            $.ajax({
                                type: 'post',
                                url: '/user/deleteStudyPlanContent',
                                data: {
                                    id: data[i].id,
                                },
                                success: function (res) {
                                    if (res == "success") {
                                        //layer.msg('删除成功');
                                        obj.del(data[i].id);
                                    } else {
                                        layer.msg('第' + i + '条数据删除失败');
                                    }
                                },
                                error: function () {
                                    layer.msg('网络错误,' + '第' + i + '条数据删除失败');
                                }
                            });
                        }
                        // 重新渲染表格
                        table.reload('test');
                        layer.close(index);
                    });
                    break;
                case 'update':
                    table.reload('test', {
                        cols: [[
                            {type: 'checkbox', fixed: 'left'}
                            ,{field:'id', title:'ID', width:80, fixed: 'left', unresize: true, sort: true,}
                            ,{field:'userId', title:'用户id', width:120,}
                            ,{field:'content', title:'待办内容', width:370, edit:true}
                            ,{field: 'status',
                                title: '状态',
                                width: 100,
                                templet: function(d) {
                                    if (d.status === 0) {
                                        return '<span style="color:red;">未完成</span>';
                                    } else if (d.status === 1) {
                                        return '<span style="color:green;">已完成</span>';
                                    } else {
                                        return '';
                                    }
                                }}
                            ,{field:'createTime', title:'创建时间', width:200, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                            }
                            ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:100}
                        ]]
                    });



                    // 监听单元格编辑事件
                    table.on('edit(test)', function(obj){
                        var field = obj.field; // 获取字段名
                        var updateContent = obj.value; // 获取修改后的值
                        var data = obj.data; // 获取当前行的数据
                        confirm("确定修改吗？");
                        // 发送ajax请求，更新数据
                        $.ajax({
                            type: 'post',
                            url: '/user/updateStudyPlanContent',
                            data: {
                                id: data.id,
                                updateContent: updateContent
                            },
                            success: function(res){
                                if(res == "success"){
                                    layer.msg('修改成功');
                                    table.reload('test', {
                                        cols: [[
                                            {type: 'checkbox', fixed: 'left'}
                                            ,{field:'id', title:'ID', width:80, fixed: 'left', unresize: true, sort: true,}
                                            ,{field:'userId', title:'用户id', width:120,}
                                            ,{field:'content', title:'待办内容', width:370,}
                                            ,{field: 'status',
                                                title: '状态',
                                                width: 100,
                                                templet: function(d) {
                                                    if (d.status === 0) {
                                                        return '<span style="color:red;">未完成</span>';
                                                    } else if (d.status === 1) {
                                                        return '<span style="color:green;">已完成</span>';
                                                    } else {
                                                        return '';
                                                    }
                                                }}
                                            ,{field:'createTime', title:'创建时间', width:200, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                                            }
                                            ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:100}
                                        ]]
                                    });
                                }else{
                                    layer.msg('修改失败');
                                }
                            },
                            error: function(){
                                layer.msg('网络错误');
                            }
                        });
                    });

                    break;
            };
        });

    });


</script>

</body>
</html>
