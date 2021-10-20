package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PagenationVo;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService  {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);



    @Override
    public boolean save(Activity a) {

        boolean flag = true;
        int count = activityDao.save(a);
        if(count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public PagenationVo<Activity> pageList(Map<String, Object> map) {

        //取得total
        int total = activityDao.getTotalByCondition(map);
        //取得dataList
        List<Activity> dataList =  activityDao.getActivityListByCondition(map);
        //将total和dataList封装到vo
        PagenationVo<Activity> vo = new PagenationVo<>();
        vo.setDataList(dataList);
        vo.setTotal(total);

        return vo;
    }

    @Override
    public Boolean delete(String[] ids) {
        boolean flag = true;

        //查询出需要删除备注的数量
        int count1 = activityRemarkDao.getCountByAids(ids);

        //删除备注，返回受到影响的条数
        int count2 = activityRemarkDao.deleteByAids(ids);
        if(count1 != count2 ) {
            flag = false;
        }

        //市场活动删除
        int count3 = activityDao.delete(ids);
        if(count3 != ids.length){
            flag = false;
        }


        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {

        //取uList
        List<User> uList = userDao.getUserList();


        //取a
        Activity a = activityDao.getById(id);


        //将uList和a打包成map
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("uList",uList);
        map.put("a",a);




        //返回map
        return map;
    }

    @Override
    public boolean update(Activity a) {
        boolean flag = true;
        int count = activityDao.update(a);
        if(count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Activity detail(String id) {

        Activity a = activityDao.detail(id);

        return a;
    }

    @Override
    public List<ActivityRemark> getRemarkByAid(String activityId) {

        List<ActivityRemark> arList = activityRemarkDao.getRemarkByAid(activityId);


        return arList;
    }

    @Override
    public Boolean deleteRemark(String id) {

        boolean flag = true;

        int count = activityRemarkDao.deleteById(id);

        if(count != 1){
            flag  = false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {

        boolean flag = true;

        int count = activityRemarkDao.saveRemark(ar);
        if(count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        boolean flag = true;

        int count = activityRemarkDao.updateRemark(ar);
        if(count != 1){
            flag = false;
        }

        return flag;
    }
}
