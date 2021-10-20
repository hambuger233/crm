<%--
  Created by IntelliJ IDEA.
  User: 31013
  Date: 2021/10/15
  Time: 20:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme
            () + "://" + request.getServerName() + ":" + request.getServerPort
            () + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="utf-8">
    <title>$Title$</title>
</head>
<body>
            $.ajax({
                    url:"",
                    data:{

                    },
                    type:"",
                    dataType:"",
                    success:function (data){

                    }


            })




            //创建时间应该是我们的系统时间
            String createTime = DateTimeUtil.getSysTime();
            //创建人：当前登录的用户
            String createBy = ((User) request.getSession().getAttribute("user")).getName();


            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
</body>
</html>