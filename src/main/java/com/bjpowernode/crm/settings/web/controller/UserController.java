package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        System.out.println("进入到用户控制器");
        String path = request.getServletPath();
        if("/settings/user/login.do".equals(path)){
            //xxx(request,respone)
            login(request,response);

        }else if("/settings/user/login.do".equals(path)){

        }




    }

    private void login(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到登录验证操作");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文形式转换为MD5加密模式
        loginPwd = MD5Util.getMD5(loginPwd);

        //接受浏览器端的IP地址
        String ip = request.getRemoteAddr();
        System.out.println("ip----------" + ip);

        //未来业务层开发同一使用代理类形态的对象
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        System.out.println("2222");



        try {
            User user = us.login(loginAct,loginPwd,ip);

            request.getSession().setAttribute("user",user);
            // 如果程序执行到此处，说明业务层没有为controller抛出任何异常
            /*
            * 如果成功需要向前端返回json数据
            *{“success” ： true}
            *
            * */
            PrintJson.printJsonFlag(response,true);
            System.out.println("11111");

        }catch (Exception e){
            e.printStackTrace();

            //一旦执行了catch块，则说明业务层为我们验证登录失败，为controller抛出了异常
            //表示登录失败
            /*
             * 如果失败需要向前端返回json数据
             *{“success” ： true,"msg" :"错误原因"}
             *
             * */

            String msg = e.getMessage();
            /*
            * 作为controller，需要为ajax请求提供多项信息
            * 有两种手段
            *       （1）将多段信息打包成map，将map解析为json串
            *       （2）创建一个Vo
            *               private boolean success；
            *               private String msg；
            *
            * 如果展示的信息将来还会大量使用，我们创建一个vo类
            * 如果展示信息只在这个需求中使用，则使用map
            *
            * */

            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }


    }
}
