@echo off
echo 正在检查Java环境...
java -version

echo.
echo 正在尝试使用Maven Wrapper编译项目...
if exist "mvnw.cmd" (
    echo 找到Maven Wrapper，开始编译...
    call mvnw.cmd clean compile
    if %errorlevel% neq 0 (
        echo 编译失败，尝试直接运行...
        goto :runapp
    )
) else (
    echo 未找到Maven Wrapper，尝试直接运行...
    goto :runapp
)

:runapp
echo.
echo 尝试运行Spring Boot应用...
if exist "target\classes\com\wyu\studyonline\StudyonlineApplication.class" (
    echo 找到已编译的类文件，启动应用...
    java -cp "target\classes;src\main\resources" -Dspring.config.location=src\main\resources\application.properties com.wyu.studyonline.StudyonlineApplication
) else (
    echo 错误：未找到编译的类文件，请先编译项目
    echo 建议：安装Maven并运行 mvn clean compile
    pause
)

pause