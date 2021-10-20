package com.bjpowernode.settings.test;

import com.bjpowernode.crm.utils.DateTimeUtil;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Test {
    public static void main(String[] args) {

//        //验证失效时间
//        String expireTime = "2019-10-10 10:10:10";
//       //当前系统时间
//        String currentTime = DateTimeUtil.getSysTime();
//        int count = expireTime.compareTo(currentTime);
//
//        System.out.println(count);

//        //验证锁定状态
//        String lockState = "0";
//        if("0".equals(lockState)){
//            System.out.println("账号已锁定");
//        }

        //浏览器的ip地址
        String ip = "192.168.1.3";
        //允许访问的ip地址
        String allowIp = "192.168.1.1,192.168.1.2";
        if(allowIp.contains(ip)){
            System.out.println("有效的ip地址，允许访问地址");
        }else {
            System.out.println("ip地址无效");
        }
    }
}
