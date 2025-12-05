package com.wyu.studyonline.config;

import lombok.extern.slf4j.Slf4j;
import org.apache.catalina.session.StandardSessionFacade;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

/**
 * 主要的配置类
 *  本类必须要继承Configurator,因为@ServerEndpoint注解中的config属性只接收这个类型
 */
@Configuration
//@Slf4j
public class GetHttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    /* 修改握手,就是在握手协议建立之前修改其中携带的内容 */
//    @Override
//    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
//        /*如果没有监听器,那么这里获取到的HttpSession是null*/
//        StandardSessionFacade ssf = (StandardSessionFacade) request.getHttpSession();
//        if (ssf != null) {
//            javax.servlet.http.HttpSession session = (HttpSession) request.getHttpSession();
//            sec.getUserProperties().put("httpSession", session);
//            log.info("获取到的SessionID：{}",session.getId());
//        }
//        super.modifyHandshake(sec, request, response);
//    }




    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        //这个对象说一下，貌似只有服务器是tomcat的时候才需要配置,具体我没有研究
        return new ServerEndpointExporter();
    }
}
