package com.feng.controller;

import com.feng.entity.ResponseResult;
import com.feng.entity.User;
import com.feng.enums.ErrorEnum;
import com.feng.exception.BusinessException;
import com.feng.exception.ParamInvalidException;
import com.feng.service.UserService;
import com.feng.util.ResponseResultUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author rf
 * @since 2019-03-03
 */
@RestController
@Slf4j
@RequestMapping("user")
@CrossOrigin(origins = "*", allowCredentials = "true")
@Api(tags = "前台用户接口")
public class UserController {
    @Autowired
    private UserService userService;

    @ApiOperation("通过用户id获取一个用户")
    @GetMapping("get/{id}")
    public ResponseResult get(@PathVariable("id") Integer id) throws Exception {
        User user = userService.getById(id);
        return ResponseResultUtil.renderSuccess(user);
    }

    @ApiOperation("前台用户注册接口")
    @PostMapping("/register")
    // 关键修改1：删除多余的 String rePassword 参数，BindingResult 紧跟 User
    public ResponseResult register(@Valid @RequestBody User user, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            String msg = bindingResult.getFieldError().getDefaultMessage();
            throw new ParamInvalidException(ErrorEnum.INVALIDATE_PARAM_EXCEPTION.setMsg(msg));
        }
        // 关键修改2：调用 service 时去掉 rePassword 参数（需同步修改 UserService）
        userService.register(user);
        // 关键修改3：删除邮箱激活相关代码
        return ResponseResultUtil.renderSuccess("用户注册成功！");
    }

    @ApiOperation("用户邮箱激活")
    @GetMapping("/activeAccount")
    public ResponseResult activeAccount(User user, String code) {
        user.setActive(true);
        userService.updateById(user);
        return ResponseResultUtil.renderSuccess("账号激活成功！");
    }

    @ApiOperation("用户登录接口")
    @PostMapping("/doLogin")
    public ResponseResult login(@Valid @RequestBody User user, BindingResult bindingResult) {
        // 1. 复用原有参数校验逻辑（基于User实体类的@NotNull注解）
        if (bindingResult.hasErrors()) {
            String msg = bindingResult.getFieldError().getDefaultMessage();
            throw new ParamInvalidException(ErrorEnum.INVALIDATE_PARAM_EXCEPTION.setMsg(msg));
        }

        try {
            User loginUser = userService.login(user);
            loginUser.setPassword(null);
            Map<String, Object> data = new HashMap<>();
            data.put("msg", "登录成功！");
            data.put("userInfo", loginUser);
            return ResponseResultUtil.renderSuccess(200, data);
        } catch (BusinessException e) {
            log.error("登录业务失败：{}", e.getMsg(), e); // 新增：打印异常堆栈
            return ResponseResultUtil.renderError(e.getCode(), e.getMsg());
        } catch (Exception e) {
            log.error("登录系统异常：", e); // 关键：打印完整异常堆栈，方便排查
            // 暂时返回具体错误信息（而非系统繁忙），方便调试
            return ResponseResultUtil.renderError(ErrorEnum.BUSINESS_EXCEPTION.getCode(), "登录失败：" + e.getMessage());
        }
    }
}