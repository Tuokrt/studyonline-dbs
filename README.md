# 项目介绍
线上自习室平台项目后端主要是基于 SpringBoot、Spring MVC 、和 Mybatis 框架，使用 Maven 进行项目管理，使用 MySQL 数据库进行数据操作，项目前端主要是基于 JSP 技术编写前端代码，整体是使用 Layui 框架辅助页面设计，使用 jQuery 框架实现前端动态交互的设计以及与后端的数据交互。在自习室的实现上使用websocket技术，自习室聊天功能利用sensitive-word技术加入了敏感词过滤功能，系统所产生的图片采用七牛云对象存储。相关图表的展示使用的是Chart.js库。
# 主要功能
## 1.前台用户  
### (1)注册与登录；  
手机号或账号登录，不设置游客登录，未登录的用户仅可浏览平台首页，不可使用其他功能。  
### (2)用户等级制；  
设置用户经验值，经验值达到一等数值便提高等级，经验值与自习时间、每日打卡挂钩。某些功能需要达到一定等级才可使用。  
### (3)加入自习室与其他用户共同学习；  
进入自习室模块，可选择加入其他用户所创建的自习室，可通过分类查看并加入适合自己的自习室。自习室内室长可以设置学习时间并开始学习，学习期间关闭聊天功能。聊天功能限制用户等级，未达到相应等级不能发言。根据室长设置的学习时间帮助用户累计自习时间。  
### (4)独自学习；  
进入自习室模块，可选择独自自习，有计时功能。  
### (5)创建自习室（等级限制，需要审核）；  
进入自习室模块，可选择创建自习室，但用户需要达到相应的等级，需要提供身份证等证件证明身份，管理员审核通过后即可创建自习室。需要填写自习室标题与分类，创建者可以踢除加入者。  
### (6)添加学习待办；  
进入添加学习待办模块，可编辑多条学习待办，所添加的学习待办会展示在网站首页。选择该条学习待办已完成则不会再展示在网站首页。可以删除学习待办。  
### (7)创建备考日历；  
进入创建备考日历模块，可以添加、修改、删除考试名称、考试时间，考试倒计时会展示在网站首页，添加多个考试，则会倒计时最近的考试。  
### (8)查看累计学习时间；  
进入个人中心模块，可以查看个人累计的学习时间。  
### (9)发表学习动态；  
进入个人中心模块，可以发表学习动态。可以发布文字与图片。  
### (10)每日打卡；  
进入个人中心模块，可以进行每日打卡。  
### (11)举报不良言论及自习室；  
当其他用户发表不良言论时，用户可以对其他用户进行举报。亦可对自习室与用户发表的动态进行举报，举报需提供相关截图与原因，提交后台管理员处理。  
### (12)学习时间排行榜。  
学习时间排行榜前10名会展示在网站首页。  
## 2.后台管理员  
### (1)账户的登录；  
账户不能注册，只能用默认账户进行登录。  
### (2)发布公告。  
可以编辑并发布公告到网站首页。  
### (3)自习室创建审核；  
可以查看用户的自习室创建申请并是否同意创建。  
### (4)审核举报；  
可以查看审核用户发起的举报并对用户与自习室进行相应的处理。  
### (5)用户管理；  
可结合用户的举报对违规用户进行封号处理。  
### (6)自习室管理；  
可结合用户的举报对自习室进行封禁处理。  
### (7)动态管理  
可结合用户的举报对平台上的违规动态进行删除。  
### (8)评论管理  
可结合用户的举报对平台上的违规评论进行删除。  
# 部分功能截图
## 用户首页（未登录）
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E7%94%A8%E6%88%B7%E9%A6%96%E9%A1%B5%EF%BC%88%E6%B2%A1%E7%99%BB%E5%BD%95%EF%BC%89.png)
## 用户首页（登录后）
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E7%94%A8%E6%88%B7%E9%A6%96%E9%A1%B5%EF%BC%88%E7%99%BB%E5%BD%95%E5%90%8E%EF%BC%89.png)
## 登录页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E7%99%BB%E5%BD%95.png)
## 注册页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E6%B3%A8%E5%86%8C.png)
## 我的自习室页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E6%88%91%E7%9A%84%E8%87%AA%E4%B9%A0%E5%AE%A4.png)
## 加入自习室页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%8A%A0%E5%85%A5%E8%87%AA%E4%B9%A0%E5%AE%A4.png)
## 室长自习室页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%AE%A4%E9%95%BF%E9%A1%B5%E9%9D%A2.png)
## 踢出自习室页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E8%B8%A2%E5%87%BA%E6%88%BF%E9%97%B4.png)
## 学习模式（室长）页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%BC%8F%EF%BC%88%E5%AE%A4%E9%95%BF%EF%BC%89.png)
## 学习待办页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E4%BF%AE%E6%94%B9%E5%AD%A6%E4%B9%A0%E5%BE%85%E5%8A%9E.png)
## 备考日历页面
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E4%BF%AE%E6%94%B9%E5%A4%87%E8%80%83%E6%97%A5%E5%8E%86.png)
## 动态广场
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%8A%A8%E6%80%81%E5%B9%BF%E5%9C%BA.png)
## 我的动态
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E6%88%91%E7%9A%84%E5%8A%A8%E6%80%81.png)
## 发布动态
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%8F%91%E5%B8%83%E5%8A%A8%E6%80%81.png)
## 个人中心
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E4%B8%AA%E4%BA%BA%E4%B8%AD%E5%BF%83.png)
## 后台首页
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%90%8E%E5%8F%B0%E9%A6%96%E9%A1%B5.png)
## 自习室创建审核
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E8%87%AA%E4%B9%A0%E5%AE%A4%E5%AE%A1%E6%A0%B8.png)
## 举报审核
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E4%B8%BE%E6%8A%A5%E5%AE%A1%E6%A0%B8.png)
## 用户管理
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86.png)
## 自习室管理
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E8%87%AA%E4%B9%A0%E5%AE%A4%E7%AE%A1%E7%90%86.png)
## 动态管理
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E5%8A%A8%E6%80%81%E7%AE%A1%E7%90%86.png)
## 评论管理
![加载失败](https://gitee.com/fhvk-wvfp/img_storage/raw/master/studyonline_img/%E8%AF%84%E8%AE%BA%E7%AE%A1%E7%90%86.png)