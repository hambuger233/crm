package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain Chain) throws IOException, ServletException {

        System.out.println("进入到验证有没有登陆过的过滤器");

        //
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;


        //获得访问的路径
        String path = request.getServletPath();
        System.out.println(path);
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){


            //放行资源

            Chain.doFilter(req,resp);
        }else {

            //从session中获取user对象
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            //如果user不为null，则表示登陆过
            if(user != null){

                //放行请求
                Chain.doFilter(req,resp);
            }else {

                //表示没有登录过,重定向到登录页
                /*
                 * 重定向
                 *   重定向的路径怎么写？
                 *       在实际开发中，对于路径的使用，不论是前端还是后端，都是用绝对路径
                 *
                 *       转发：
                 *           使用的是一种特殊的绝对路径方式，这是绝度路径前面不加/项目名，这种路径也称为内部路径/login.jsp
                 *
                 *       重定向：
                 *           使用的是传统绝对路径的写法，必须以/项目名开头，后面跟具体的资源路径
                 *            /crm/login.jsp
                 *
                 *
                 *   为什么使用重定向，而不是使用转发？
                 *         转发之后路径会停留在老路径上，而不是最新的路径，
                 *          应给用户跳转到登录页面时，将地址栏变为登录页路径
                 *
                 *
                 * */
                response.sendRedirect(request.getContextPath() +"/login.jsp");
            }

        }





    }
}
