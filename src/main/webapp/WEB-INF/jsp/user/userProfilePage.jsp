<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>完善个人信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        .user-profile-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 10px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
            min-height: 800px;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .profile-header h2 {
            color: #1E9FFF;
            font-weight: bold;
            font-size: 16px;
            margin: 0;
        }
        .profile-header p {
            color: #999;
            margin-top: 5px;
            font-size: 11px;
        }
        .profile-item {
            margin-bottom: 12px;
        }
        .profile-label {
            display: block;
            margin-bottom: 3px;
            font-weight: bold;
            color: #333;
            font-size: 12px;
        }
        .btn-submit {
            width: 100%;
            margin-top: 20px;
            margin-bottom: 10px;
            position: sticky;
            bottom: 0;
            background: #fff;
            padding: 10px 0;
            border-top: 1px solid #eee;
        }
        .layui-textarea {
            min-height: 50px;
        }
        .layui-input {
            height: 32px;
            line-height: 32px;
        }
    </style>
</head>
<body>
<div class="user-profile-container">
    <div class="profile-header">
        <h2><i class="layui-icon layui-icon-username"></i> 完善个人信息</h2>
        <p style="color: #999;margin-top: 10px;">完善您的个人资料，让其他用户更好地了解您</p>
    </div>
    
    <form class="layui-form" id="userProfileForm">
        <div class="profile-item">
            <label class="profile-label">个性签名</label>
            <textarea name="signature" placeholder="请输入您的个性签名" class="layui-textarea" rows="3">${userProfile.signature}</textarea>
        </div>
        
        <div class="profile-item">
            <label class="profile-label">出生日期</label>
            <input type="text" name="birthday" id="birthday" placeholder="请选择出生日期" 
                   autocomplete="off" class="layui-input" value="${userProfile.birthday}">
        </div>
        
        <div class="profile-item">
            <label class="profile-label">学校</label>
            <input type="text" name="school" placeholder="请输入您的学校" 
                   autocomplete="off" class="layui-input" value="${userProfile.school}">
        </div>
        
        <div class="profile-item">
            <label class="profile-label">专业</label>
            <input type="text" name="major" placeholder="请输入您的专业" 
                   autocomplete="off" class="layui-input" value="${userProfile.major}">
        </div>
        
        <div class="profile-item">
            <label class="profile-label">家乡</label>
            <input type="text" name="hometown" placeholder="请输入您的家乡" 
                   autocomplete="off" class="layui-input" value="${userProfile.hometown}">
        </div>
        
        <div class="layui-form-item">
            <button type="button" class="layui-btn layui-btn-fluid layui-btn-normal btn-submit" id="submitBtn">
                <i class="layui-icon layui-icon-ok"></i> 保存信息
            </button>
        </div>
    </form>
</div>

<script src="/layui/layui.js"></script>
<script>
layui.use(['form', 'laydate', 'layer'], function(){
    var form = layui.form;
    var laydate = layui.laydate;
    var layer = layui.layer;
    var $ = layui.$;
    
    // 日期选择器初始化
    laydate.render({
        elem: '#birthday',
        type: 'date',
        format: 'yyyy-MM-dd',
        max: new Date().toISOString().split('T')[0]
    });
    
    // 表单提交
    $('#submitBtn').on('click', function(){
        var formData = $('#userProfileForm').serialize();
        
        $.ajax({
            url: '/user/saveUserProfile',
            type: 'POST',
            data: formData,
            success: function(result){
                if(result.code == 200){
                    layer.msg('保存成功', {icon: 1});
                    // 延迟1秒后返回个人中心
                    setTimeout(function(){
                        parent.layui.admin.closeThisTab();
                        parent.layui.admin.events.navClick('personalCenterPage');
                    }, 1000);
                } else {
                    layer.msg(result.msg || '保存失败', {icon: 2});
                }
            },
            error: function(){
                layer.msg('网络错误，请稍后重试', {icon: 2});
            }
        });
    });
    
    // 表单验证
    form.verify({
        signature: function(value){
            if(value && value.length > 255){
                return '个性签名不能超过255个字符';
            }
        },
        school: function(value){
            if(value && value.length > 100){
                return '学校名称不能超过100个字符';
            }
        },
        major: function(value){
            if(value && value.length > 100){
                return '专业名称不能超过100个字符';
            }
        },
        hometown: function(value){
            if(value && value.length > 100){
                return '家乡名称不能超过100个字符';
            }
        }
    });
    
    // 绑定表单验证
    form.on('submit(userProfileForm)', function(data){
        return false; // 阻止表单跳转。如果需要表单跳转，去掉这段即可。
    });
});
</script>
</body>
</html>