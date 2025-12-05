package com.wyu.studyonline.service.impl;


import cn.hutool.core.io.FileUtil;
import com.alibaba.fastjson.JSON;
import com.wyu.studyonline.service.impl.UserServiceImpl;
import com.alibaba.fastjson.JSONObject;
import com.github.houbb.sensitive.word.core.SensitiveWordHelper;
import com.wyu.studyonline.config.GetHttpSessionConfigurator;
import com.wyu.studyonline.pojo.User;
import com.wyu.studyonline.pojo.WebSocketMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.CharsetUtil;
import com.github.houbb.sensitive.word.support.result.WordResultHandlers;

@Service
@Slf4j
@ServerEndpoint(value = "/studyRoom/{studyRoomId}/{sid}", configurator = GetHttpSessionConfigurator.class)
public class WebSocketServer {
    // 用于存储每个自习室的在线人数的 ConcurrentHashMap
    private static ConcurrentHashMap<String, Integer> onlineCountMap = new ConcurrentHashMap<>();
    // 用于存储每个自习室的 WebSocketServer 实例列表的 ConcurrentHashMap
    private static ConcurrentHashMap<String, CopyOnWriteArrayList<WebSocketServer>> webSocketMap = new ConcurrentHashMap<>();
    // 用于存储每个自习室的 WebSocketServer 实例列表的 ConcurrentHashMap
    private static ConcurrentHashMap<String, Vector<WebSocketMsg>> webSocketMsgMap = new ConcurrentHashMap<>();


    //静态变量,用来记录当前在线链接数,把他设计成一个线程安全的
    private int onlineCount = 0;
    //concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。
    private CopyOnWriteArrayList<WebSocketServer> webSocketSet = new CopyOnWriteArrayList<WebSocketServer>();
    //存放类型为“user”的通信信息
    private Vector<WebSocketMsg> webSocketMsgVector = new Vector<WebSocketMsg>();

    //与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;
    //接受的sid
    private String sid = "";
    //用户等级
    private boolean isMsg = false;

    //开始学习信号（是否在学习）
    private static boolean isStudy = false;

    private static UserServiceImpl userService;

    @Autowired
    public void setUserService(UserServiceImpl userService){
        WebSocketServer.userService = userService;
    }

    public int getUserRank(String userId){
        int rank = userService.selectRankByUserId(Integer.parseInt(userId));
//        System.out.println("用户等级=" + rank);
        return rank;
    }



    /**
     * 建立成功连接调用的方法
     */
    @OnOpen
    public void onOpen(Session session, EndpointConfig config,@PathParam("studyRoomId") String studyRoomId, @PathParam("sid") String sid) throws Exception {

        this.session = session;
        //如果有重复直接返回
        if(getWebSocketSet(studyRoomId) != null){
            this.webSocketSet = getWebSocketSet(studyRoomId);
            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                if (Objects.equals(item.sid, sid)) {
                    return;
                }
            }
        }else {
            webSocketSet = new CopyOnWriteArrayList<>();
            webSocketMap.put(studyRoomId, webSocketSet);
        }

        webSocketSet.add(this);         //加入set中
        //httpSession = (HttpSession)config.getUserProperties().get("httpSession");
        //userVector.add((User) httpSession.getAttribute("user"));//加入用户数据
        //httpSession.setAttribute("userVector",userVector);
        this.sid = sid;
        if(onlineCountMap.get(studyRoomId) == null){
            onlineCountMap.put(studyRoomId,0);
            this.onlineCount = onlineCountMap.get(studyRoomId);
        }

        addOnlineCount(studyRoomId);               //在线人数加1
        log.info("用户" + sid + "加入了自习室" + studyRoomId + "，该自习室在线人数为:" + getOnlineCount(studyRoomId));
        log.info("自习室" + studyRoomId + "所有用户对象" + webSocketSet);
        // 如果不满足条件，直接返回
        if (webSocketSet.size() > 21) {
            session.close(new CloseReason(CloseReason.CloseCodes.TRY_AGAIN_LATER, "Study room is full"));
            //            throw new RuntimeException("Study room is full");
        }

        //如果不是管理员
        if(!sid.equals("0")){
            if(getUserRank(sid) >= 2){
                isMsg = true;
            }
        }else {
            log.info("管理员进入");
        }

    }

    /**
     * 关闭连接的调用方法
     */
    @OnClose
    public void onClose(@PathParam("studyRoomId") String studyRoomId) {
        log.info("自习室" + studyRoomId + "所有用户对象" + webSocketSet);
        //如果自习室创建者关闭连接，则
//        if(webSocketSet.firstElement().equals(this)){
//            try {
//
//                this.sendMessage("over");
//            }catch (Exception exception){
//                exception.printStackTrace();
//            }
//        }
        webSocketSet.remove(this);   //从set中删除
        //userVector.remove((User) httpSession.getAttribute("user"));
        //httpSession.setAttribute("userVector",userVector);
//        if(this)
        subOnlineCount(studyRoomId);               //在线的人数减一
        //断开连接情况下,更新主板占用的情况为释放
        log.info("用户" + sid + "退出了自习室" + studyRoomId);
        log.info("有一个用户退出了自习室" + studyRoomId + "，当前在线的人数为" + getOnlineCount(studyRoomId));
    }

    /**
     * 收到客户端调用的方法
     */
    @OnMessage
    public void onMessage(String message, Session session,@PathParam("studyRoomId") String studyRoomId) {
        log.info("自习室" + studyRoomId + "所有用户对象" + webSocketSet);
        log.info("自习室" + studyRoomId + "，来自窗口:" + sid + "的消息" + message);
        WebSocketMsg messageParse = JSON.parseObject(message,WebSocketMsg.class);
//        JSONObject jsonObject = JSON.parseObject(message);
//        messageParse.setType(jsonObject.getString("type"));
//        messageParse.setName(jsonObject.getString("name"));
//        messageParse.setContent(jsonObject.getString("content"));
        //如果是重复的用户信息，则说明该用户离开了自习室
        if(messageParse.getType().equals("quit")){
            //log.info("退出一个成员");
            //群发消息
//            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
//                try {
//                    //发送的是json数据类型
//                    item.sendMessage(message);
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
            Iterator<WebSocketServer> socketServerIterator = webSocketSet.iterator();
            while (socketServerIterator.hasNext()){
                try {
                    //发送的是json数据类型
                    socketServerIterator.next().sendMessage(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
            //去除退出的用户
//            for(WebSocketMsg item : webSocketMsgVector){
//                log.info("成员" + item);
//                if(item.getContent().equals(messageParse.getContent())){
//                    webSocketMsgVector.remove(messageParse);
//                }
//            }
            Iterator<WebSocketMsg> iterator = webSocketMsgVector.iterator();
            while (iterator.hasNext()){
                WebSocketMsg webSocketMsg = iterator.next();
                if(webSocketMsg.getUserId() == messageParse.getUserId()){
                    iterator.remove();
                }
            }
            //重新给所有用户更新用户信息
            for(WebSocketMsg webSocketMsg : webSocketMsgVector){
                String userMsg = JSON.toJSONString(webSocketMsg);
                for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                    try {
                        //发送的是json数据类型
                        item.sendMessage(userMsg);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }else if(messageParse.getType().equals("user")){
            //log.info("加入一个成员");
            //如果没有该自习室的用户信息列表，则创建一个
            if(webSocketMsgMap.get(studyRoomId) == null){
                webSocketMsgVector = new Vector<>();
                webSocketMsgMap.put(studyRoomId,webSocketMsgVector);
            }else {
                this.webSocketMsgVector = webSocketMsgMap.get(studyRoomId);
            }
            //添加用户信息到对应自习室的用户信息列表
            webSocketMsgVector.add(messageParse);

            //群发用户信息
            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                if(item.equals(webSocketSet.get(webSocketSet.size()-1))){

                }else {
                    try {
                        //发送的是json数据类型
                        item.sendMessage(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

            }
//            Iterator<WebSocketServer> socketServerIterator = webSocketSet.iterator();
//            while (socketServerIterator.hasNext()){
//                if(socketServerIterator.next().equals(webSocketSet.get(webSocketSet.size()-1))){
//
//                }else {
//                    try {
//                        //发送的是json数据类型
//                        socketServerIterator.next().sendMessage(message);
//                    } catch (IOException e) {
//                        e.printStackTrace();
//                    }
//                }
//            }
            //给最后一个连接发所有用户信息
            for(WebSocketMsg webSocketMsg : webSocketMsgVector){
                String userMsg = JSON.toJSONString(webSocketMsg);
                try {
                    //发送的是json数据类型
                    webSocketSet.get(webSocketSet.size()-1).sendMessage(userMsg);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            //如果是在学习途中加入的用户给其发送错过此次学习的信息
            if(isStudy){
                WebSocketMsg isStudyMsg = new WebSocketMsg();
                isStudyMsg.setType("isStudy");
                isStudyMsg.setContent("系统消息：学习中，你错过了此次学习！");
                String jsonString = JSON.toJSONString(isStudyMsg);
                try {
                    webSocketSet.get(webSocketSet.size()-1).sendMessage(jsonString);
                }catch (IOException e){
                    e.printStackTrace();
                }
            }
        }else if(messageParse.getType().equals("admin")){
            this.webSocketMsgVector = webSocketMsgMap.get(studyRoomId);
            log.info("进入admin类型消息");
            log.info("webSocketMsgVector：" + webSocketMsgVector);
            //给管理员发所有用户信息
            for(WebSocketMsg webSocketMsg : webSocketMsgVector){
                String userMsg = JSON.toJSONString(webSocketMsg);
                try {
                    //发送的是json数据类型
                    log.info("给管理员发所有用户信息");
                    webSocketSet.get(webSocketSet.size()-1).sendMessage(userMsg);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }else if(messageParse.getType().equals("ban")){
            webSocketMsgVector.clear();
            webSocketSet.remove(this);
            //群发消息
            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                try {
                    //发送的是json数据类型
                    item.sendMessage(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            webSocketSet.clear();
        }else if(messageParse.getType().equals("close")){
            webSocketMsgVector.clear();
            webSocketSet.remove(this);
            //群发消息
            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                try {
                    //发送的是json数据类型
                    item.sendMessage(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            webSocketSet.clear();
        }else if(messageParse.getType().equals("kickOut")){
            //给要踢除的用户发消息
            log.info("踢出一个用户");
            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                if(Integer.parseInt(item.sid) == messageParse.getUserId()){
                    try {
                        //发送的是json数据类型
                        log.info("踢出信息发给:" + item.sid);
                        item.sendMessage(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else {
            //群发消息
            for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
                try {
                    if(messageParse.getType().equals("start")){
                        isStudy = true;
                    }
                    if(messageParse.getType().equals("endStudy")){
                        isStudy = false;
                    }
                    //发送的是json数据类型
                    if(messageParse.getType().equals("msg")){
                        //用户等级判断
                        if(isMsg){
                            //将敏感词替换成星号
                            String replaceStr = SensitiveWordHelper.replace(messageParse.getContent());
                            messageParse.setContent(replaceStr);
                            String jsonString = JSON.toJSONString(messageParse);
                            item.sendMessage(jsonString);
                        }else {
                            log.info("等级不足，不能发言");
                        }
                    }else {
                        item.sendMessage(message);
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    /**
     * 发生错误的时候
     */
    @OnError
    public void onError(Session session, Throwable error) {
        log.error("发送错误");
        error.printStackTrace();
    }

//    public static void sendInfo(String message) {
//        for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
//            try {
//                log.info("推送消息到窗口:" + item.sid + ",推送内容为:" + message);
//                item.sendMessage(message);
//            } catch (IOException e) {
//                throw new RuntimeException(e);
//            }
//        }
//    }
//
//    /**
//     * 群发自定义消息
//     */
//    public static void sendInfo(String message, @PathParam("sid") String sid) {
//        log.info("推送消息到窗口:" + sid + ",推送内容为:" + message);
//        for (com.wyu.studyonline.service.impl.WebSocketServer item : webSocketSet) {
//            try {
//                if (sid == null) {
//                    item.sendMessage(message);
//                } else if (item.sid.equals(sid)) {
//                    item.sendMessage(message);
//                }
//            } catch (IOException e) {
//                throw new RuntimeException(e);
//            }
//        }
//    }

    /**
     * 实现服务器主动推送
     */
    public void sendMessage(String message) throws IOException {
        this.session.getBasicRemote().sendText(message);
    }

    public static synchronized int getOnlineCount(String studyRoomId) {
        return onlineCountMap.get(studyRoomId);
    }

    public static synchronized void addOnlineCount(String studyRoomId) {
        com.wyu.studyonline.service.impl.WebSocketServer.onlineCountMap.replace(studyRoomId,onlineCountMap.get(studyRoomId) + 1);
    }

    public static synchronized void subOnlineCount(String studyRoomId) {
        com.wyu.studyonline.service.impl.WebSocketServer.onlineCountMap.replace(studyRoomId,onlineCountMap.get(studyRoomId) - 1);
    }

    public static CopyOnWriteArrayList<WebSocketServer> getWebSocketSet(String studyRoomId) {
        return webSocketMap.get(studyRoomId);
    }

    public static Vector<WebSocketMsg> getWebSocketMsg(String studyRoomId) {
        return webSocketMsgMap.get(studyRoomId);
    }
}
