package com.feng.service.impl;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.feng.dao.UserMapper;
import com.feng.entity.User;
import com.feng.enums.ErrorEnum;
import com.feng.exception.BusinessException;
import com.feng.service.UserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author rf
 * @since 2019-03-03
 */
@Service
public class UserServiceImpl implements UserService {
    @SuppressWarnings("SpringJavaAutowiringInspection")
    @Autowired
    private UserMapper userMapper;

    @Override
    public PageInfo<User> getUserPage(int num, int size, User search) {
        PageHelper.startPage(num, size);
        Wrapper<User> userWrapper = new EntityWrapper();
        List<User> userList = userMapper.selectList(userWrapper);
        return new PageInfo<>(userList);
    }

    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    @Override
    public User login(User user) {
        // 1. 账号校验（原有逻辑不变）
        List<User> userList = getByAccount(user.getAccount());
        if (userList.isEmpty()) {
            throw new BusinessException(ErrorEnum.USER_NAME_ERROR);
        }
        User loginUser = userList.get(0);

        // 2. 密码校验（明文对比，保持原有逻辑）
        if (!loginUser.getPassword().equals(user.getPassword())) {
            throw new BusinessException(ErrorEnum.USER_PASSWORD_ERROR);
        }

        // 3. 新增：登录成功后更新最后登录时间（核心修改）
        Date lastLoginTime = new Date(); // 生成当前时间字符串
        userMapper.updateLastLoginTime(loginUser.getId(), lastLoginTime); // 调用Mapper更新数据库
        loginUser.setLastLoginTime(lastLoginTime); // 更新用户对象的登录时间，返回给前端

        // 4. 新增：脱敏密码（避免密码泄露，关键！）
        loginUser.setPassword(null);

        return loginUser;
    }


    @Override
    public List<User> getByAccount(String account) {
        EntityWrapper<User> userEntityWrapper = new EntityWrapper<>();
        userEntityWrapper.eq("account", account);
        return userMapper.selectList(userEntityWrapper);
    }

    @Override
    public User getOneByAccount(String account) {
        List<User> userList = getByAccount(account);
        if (CollectionUtils.isEmpty(userList)) {
            return null;
        } else {
          return   userList.get(0);
        }
    }

    @Override
    public User add(User user) {
        userMapper.insert(user);
        return user;
    }

    @Override
    @CachePut(value = "user", key = "#user.id")
    public User updateById(User user) {
        userMapper.updateById(user);
        return user;
    }

    @Override
    @Cacheable(value = "user", key = "#id")
    public User getById(Serializable id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new BusinessException(ErrorEnum.BUSINESS_EXCEPTION.setMsg("该用户不存在"));
        }
        return user;
    }

    @Override
    @CacheEvict(value = "user", key = "#id")
    public void DeleteById(Serializable id) {
        userMapper.deleteById(id);
    }

    @Override
    public User register(User user) {
        // 3. 账号查重（简化：只判断账号是否存在，不判断是否激活）
        List<User> userList = getByAccount(user.getAccount());
        if (!userList.isEmpty()) {
            // 直接提示“账号已存在”，删掉激活相关判断
            throw new BusinessException(ErrorEnum.BUSINESS_EXCEPTION.setMsg("账号已存在，请更换账号"));
        }

        // 4. 填充默认值（保留，isActive 仍设为 false 或 true，按你需求）
        if (!StringUtils.hasText(user.getName())) {
            user.setName("");
        }
        if (!StringUtils.hasText(user.getInstitute())) {
            user.setInstitute("");
        }
        if (user.getActive() == null) {
            user.setActive(false); // 默认未激活，或改为 true（注册后直接激活）
        }
        if (user.getSex() == null) {
            user.setSex(0);
        }

        // 5. 保存用户
        userMapper.insert(user);
        user.setPassword(null);
        return user;
    }
}
