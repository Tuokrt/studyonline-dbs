<%--
  学习行为分析页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学习行为分析</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.15.3/css/all.min.css">
    <script src="${pageContext.request.contextPath}/webjars/layui/2.7.6/dist/layui.js" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/webjars/jquery/3.6.4/dist/jquery.js" charset="utf-8"></script>
</head>
<body>

<div class="layui-container" style="margin-top: 20px;">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    <i class="layui-icon layui-icon-chart"></i> 学习行为分析
                </div>
                <div class="layui-card-body">
                    
                    <!-- 用户参与度统计 -->
                    <div class="layui-row" style="margin-bottom: 20px;">
                        <div class="layui-col-md12">
                            <div class="layui-card">
                                <div class="layui-card-header">参与度统计</div>
                                <div class="layui-card-body" id="activityStats">
                                    <div class="layui-progress layui-progress-big" lay-filter="statsProgress">
                                        <div class="layui-progress-bar"></div>
                                    </div>
                                    <div style="text-align: center; margin-top: 5px;">
                                        <span id="progressText">0/4</span>
                                    </div>
                                    <div style="margin-top: 10px;">
                                        <span class="layui-badge layui-bg-blue">学习动态</span>
                                        <span class="layui-badge layui-bg-green">考试计划</span>
                                        <span class="layui-badge layui-bg-orange">学习待办</span>
                                        <span class="layui-badge layui-bg-red">自习室</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 学习活动时间线 -->
                    <div class="layui-row">
                        <div class="layui-col-md12">
                            <div class="layui-card">
                                <div class="layui-card-header">最近30天学习活动</div>
                                <div class="layui-card-body">
                                    <table class="layui-table" lay-filter="activityTable">
                                        <thead>
                                            <tr>
                                                <th>活动类型</th>
                                                <th>内容</th>
                                                <th>时间</th>
                                            </tr>
                                        </thead>
                                        <tbody id="activityList">
                                            <tr>
                                                <td colspan="3" style="text-align: center;">加载中...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 全参与用户展示 -->
                    <div class="layui-row" style="margin-top: 20px;">
                        <div class="layui-col-md12">
                            <div class="layui-card">
                                <div class="layui-card-header">全参与用户（参与所有学习活动）</div>
                                <div class="layui-card-body">
                                    <div id="fullParticipationUsers" class="layui-row">
                                        <div style="text-align: center; padding: 20px;">加载中...</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
layui.use(['element', 'table'], function(){
    var element = layui.element;
    var table = layui.table;
    var $ = layui.$;

    // 加载用户参与度统计
    function loadActivityStats() {
        $.ajax({
            url: '${pageContext.request.contextPath}/user/getUserActivityStats',
            type: 'GET',
            success: function(result) {
                if (result.code === 200) {
                    var data = result.data;
                    var total = 0;
                    var completed = 0;
                    
                    if (data.has_status == 1) completed++;
                    if (data.has_exam == 1) completed++;
                    if (data.has_plan == 1) completed++;
                    if (data.has_room == 1) completed++;
                    
                    total = 4;
                    
                    // 更新进度条百分比
                    element.progress('statsProgress', (completed/total*100).toFixed(2) + '%');
                    
                    // 更新进度条文本显示
                    $('#progressText').text(completed + '/' + total);
                    
                    // 更新徽章状态
                    updateBadgeStatus(data);
                }
            }
        });
    }

    // 更新徽章状态
    function updateBadgeStatus(data) {
        var badges = $('.layui-badge');
        badges.each(function(index) {
            var badge = $(this);
            if (index === 0 && data.has_status == 1) {
                badge.addClass('layui-bg-blue');
            } else if (index === 1 && data.has_exam == 1) {
                badge.addClass('layui-bg-green');
            } else if (index === 2 && data.has_plan == 1) {
                badge.addClass('layui-bg-orange');
            } else if (index === 3 && data.has_room == 1) {
                badge.addClass('layui-bg-red');
            } else {
                badge.addClass('layui-bg-gray');
            }
        });
    }

    // 加载学习活动列表
    function loadLearningActivities() {
        $.ajax({
            url: '${pageContext.request.contextPath}/user/getUserLearningActivities',
            type: 'GET',
            success: function(result) {
                if (result.code === 200) {
                    var activities = result.data;
                    var tbody = $('#activityList');
                    tbody.empty();
                    
                    if (activities.length === 0) {
                        tbody.append('<tr><td colspan="3" style="text-align: center;">暂无学习活动记录</td></tr>');
                        return;
                    }
                    
                    activities.forEach(function(activity) {
                        var typeText = getActivityTypeText(activity.activity_type);
                        var time = new Date(activity.createTime).toLocaleString();
                        
                        var row = '<tr>';
                        row += '<td><span class="layui-badge ' + getActivityBadgeClass(activity.activity_type) + '">' + typeText + '</span></td>';
                        row += '<td>' + (activity.activity_content || '无内容') + '</td>';
                        row += '<td>' + time + '</td>';
                        row += '</tr>';
                        
                        tbody.append(row);
                    });
                }
            }
        });
    }

    // 加载全参与用户
    function loadFullParticipationUsers() {
        $.ajax({
            url: '${pageContext.request.contextPath}/user/getFullParticipationUsers',
            type: 'GET',
            success: function(result) {
                if (result.code === 200) {
                    var users = result.data;
                    var container = $('#fullParticipationUsers');
                    container.empty();
                    
                    if (users.length === 0) {
                        container.append('<div style="text-align: center; padding: 20px;">暂无全参与用户</div>');
                        return;
                    }
                    
                    users.forEach(function(user) {
                        var userCard = '<div class="layui-col-md3" style="margin-bottom: 15px;">';
                        userCard += '<div class="layui-card">';
                        userCard += '<div class="layui-card-header">' + (user.userName || '匿名用户') + '</div>';
                        userCard += '<div class="layui-card-body">';
                        userCard += '<div>等级: ' + (user.rank || 0) + '</div>';
                        userCard += '<div>经验: ' + (user.exp || 0) + '</div>';
                        userCard += '</div>';
                        userCard += '</div>';
                        userCard += '</div>';
                        
                        container.append(userCard);
                    });
                }
            }
        });
    }

    // 获取活动类型文本
    function getActivityTypeText(type) {
        switch(type) {
            case 'study_status': return '学习动态';
            case 'exam_time': return '考试计划';
            case 'study_plan': return '学习待办';
            default: return type;
        }
    }

    // 获取活动徽章类
    function getActivityBadgeClass(type) {
        switch(type) {
            case 'study_status': return 'layui-bg-blue';
            case 'exam_time': return 'layui-bg-green';
            case 'study_plan': return 'layui-bg-orange';
            default: return 'layui-bg-gray';
        }
    }

    // 页面加载完成后执行
    $(document).ready(function() {
        loadActivityStats();
        loadLearningActivities();
        loadFullParticipationUsers();
    });

});
</script>

</body>
</html>