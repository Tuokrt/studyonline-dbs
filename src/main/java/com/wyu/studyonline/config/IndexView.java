package com.wyu.studyonline.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class IndexView implements WebMvcConfigurer {

    @Autowired
    private UserLoginInterceptor userLoginInterceptor;

    @Autowired
    private AdminLoginInterceptor adminLoginInterceptor;

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("index");
        registry.addViewController("/admin").setViewName("admin/loginPage");
        registry.setOrder(Ordered.HIGHEST_PRECEDENCE);
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(userLoginInterceptor)
                .addPathPatterns("/user/**")   // 拦截用户请求
                .excludePathPatterns("/user/login", "/user/register","/user/loginPage","/user/registerPage","/user/authCode","/user/indexPage");  // 不拦截用户登录和注册请求
        registry.addInterceptor(adminLoginInterceptor)
                .addPathPatterns("/admin/**")   // 拦截管理员请求
                .excludePathPatterns("/admin/cellPhoneLogin","/admin/passwordLogin","/admin");  // 不拦截管理员登录请求
    }


}
