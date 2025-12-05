<%@ page import="com.wyu.studyonline.pojo.User" %><%--
  Created by IntelliJ IDEA.
  User: 檬zhu
  Date: 2023/3/26
  Time: 14:46
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
    </div>
</script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<%
    User user = (User)session.getAttribute("user");
%>
<script>
    layui.use('table', function(){
        var table = layui.table;

        //表格初始化
        table.render({
            elem: '#test'
            ,url:'<%=request.getContextPath()%>/user/selectAllExamTimeByUserId?userId=<%=user.getId()%>'
            ,toolbar: '#toolbarDemo'
            ,title: '学习待办表'
            ,totalRow: false
            ,cols: [[
                {type: 'checkbox', fixed: 'left'}
                ,{field:'id', title:'ID', width:80, fixed: 'left', unresize: true, sort: true,}
                ,{field:'userId', title:'用户id', width:120,}
                ,{field:'examName', title:'考试名称', width:200}
                ,{field:'examTime', title:'考试时间', width:200, sort:true, templet: "<div>{{layui.util.toDateString(d.examTime, 'yyyy-MM-dd')}}</div>"}
                ,{field:'createTime', title:'创建时间', width:240, sort:true, templet: "<div>{{layui.util.toDateString(d.createTime, 'yyyy-MM-dd HH:mm:ss')}}</div>"
                }
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:150}
            ]]
            ,page: true
        });

        //工具条事件
        table.on('tool(test)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）

            if(layEvent === 'del'){ //删除
                layer.confirm('确认删除该备考信息吗？', {
                    btn: ['确认', '取消'],
                    offset: ['100px','300px']

                },function(index){
                    obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    //向服务端发送删除指令
                    // 发送ajax请求，删除数据
                    $.ajax({
                        type: 'post',
                        url: '/user/deleteExamTime',
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
            }else if(obj.event === 'edit'){
                layer.open({
                    type: 1,
                    title: '修改备考信息',
                    offset: '20px',
                    area: ['600px', '400px'],
                    content: '<form class="layui-form" style="margin-top: 20px; margin-left: 70px">\
                    <div class="layui-form-item">\
                    <label class="layui-form-label">ID</label>\
                    <div class="layui-input-block">\
                      <input type="text" style="width: 273px;" disabled="disabled" name="id" value="'+ data.id +'" lay-verify="required" autocomplete="off" placeholder="请输入用户id" class="layui-input">\
                    </div>\
                  </div>\
                  <div class="layui-form-item">\
                    <label class="layui-form-label">考试名称</label>\
                    <div class="layui-input-block">\
                      <input type="text" name="examName" style="width: 273px" value="'+ data.examName +'" lay-verify="required" autocomplete="off" placeholder="请输入考试名称" class="layui-input">\
                    </div>\
                  </div>\
                  <div class="layui-form-item">\
                    <label class="layui-form-label">考试时间</label>\
                    <div class="layui-input-block">\
                      <input type="text" name="examTime" lay-key="1" style="width: 273px" id="selectDate" value="'+ layui.util.toDateString(data.examTime, 'yyyy-MM-dd') +'" lay-verify="required" onclick="laydate.render({elem: this})" autocomplete="off" placeholder="请选择考试时间" class="layui-input">\
                    </div>\
                  </div>\
                  <div class="layui-form-item">\
                    <div class="layui-input-block">\
                      <button class="layui-btn" lay-submit lay-filter="formDemo">提交</button>\
                    </div>\
                  </div>\
                </form>',
                    success: function(layero, index){
                        // 表单渲染
                        var form = layui.form;
                        form.render();

                        layui.use('laydate', function(){
                            var laydate = layui.laydate;
                            laydate.render({
                                elem: '#selectDate', // 指定日期输入框id
                                format: 'yyyy-MM-dd', // 日期格式
                                type: 'date', // 日期类型
                                showBottom: false,
                            });
                        });
                        // 表单提交事件
                        form.on('submit(formDemo)', function(formData){
                            // 获取表单数据
                            var id = formData.field.id;
                            var examName = formData.field.examName;
                            var examTime = formData.field.examTime;

                            // 发送数据到后台进行更新操作
                            $.ajax({
                                url: '/user/updateExamTime',
                                type: 'POST',
                                data: {
                                    id: id,
                                    examName: examName,
                                    examTime: examTime
                                },
                                success: function(res){
                                    if(res == 'success'){
                                        // 关闭弹出层
                                        layer.close(index);
                                        // 刷新页面
                                        window.location.reload();
                                        // 更新成功，提示用户
                                        //alert("更新成功");
                                        parent.layer.msg('考试信息更新成功');
                                        console.log('考试信息更新成功');
                                    }else{
                                        // 更新失败，提示用户
                                        layer.msg('考试信息更新失败');
                                    }
                                },
                                error: function(){
                                    // 请求失败，提示用户
                                    layer.msg('请求失败，请稍后再试');
                                }
                            });

                            return false;
                        });
                    }
                });
            }
        });


        //工具栏事件
        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event) {
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
                                url: '/user/deleteExamTime',
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
            }
        });

    });


</script>

</body>
</html>
