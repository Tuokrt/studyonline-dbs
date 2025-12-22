如何运行该软件：
使用IDEA打开此项目。
下载redis，网页https://github.com/microsoftarchive/redis/releases里点击redis-x64-3.0.504.mis,下载后添加到系统环境变量。
在mysqlworkbench里新建连接，在数据库内将sql/Studyonline.sql导入数据库并全部运行。
在IDea里配置数据库数据源即可。你可以在sql中添加插入自己账号的数据，方便你登陆。
软件入口在src/main/java/com.wyu.studentonline/StudyonlineApplication.java，运行它。
随后打开浏览器如edge，在地址栏输入 localhost:8686 即可进入网页。
如果出现No such file错误，返回IDEA，选择运行-编辑配置-修改选项，修改工作目录为 MODULE_DIR 即可。
