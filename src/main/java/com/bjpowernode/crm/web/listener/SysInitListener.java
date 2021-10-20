package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SysInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {

        System.out.println("上下文对象创建了");
        System.out.println("服务器处理数据字典开始");
        ServletContext application = event.getServletContext();
        DicService ds  = (DicService) ServiceFactory.getService(new DicServiceImpl());
        /*
        * 管理业务层要7个list
        * 应该将它们打包成一个map
        *   map.put("application",dicList1);
        *   map.put("clueStateList",dicList2);
        * .......
        *
        * */

        Map<String, List<DicValue> >  map = ds.getAll();
        //将map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for(String key  : set){

            application.setAttribute(key,map.get(key ));
        }

        System.out.println("服务器处理数据字典结束");


    }
}
