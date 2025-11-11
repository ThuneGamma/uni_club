package com.feng.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.feng.entity.User;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.util.Date;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author rf
 * @since 2019-03-03
 */
public interface UserMapper extends BaseMapper<User> {

    // 新增：根据account字段查询用户（注册查重核心方法）
    // @Param("account") 绑定参数名，避免SQL中参数名不匹配
    User getOneByAccount(@Param("account") String account);

    @Update("UPDATE user SET last_login_time = #{lastLoginTime} WHERE id = #{userId}")
    int updateLastLoginTime(
            @Param("userId") Integer userId, // 要更新的用户id
            @Param("lastLoginTime") Date lastLoginTime // 最后登录时间（字符串格式，与数据库字段一致）
    );
}