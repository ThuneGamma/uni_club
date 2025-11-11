<template>
  <div class="login-container">
    <el-input 
      v-model="loginForm.account" 
      placeholder="请输入账号" 
      prefix-icon="el-icon-user" 
      class="login-input"
    ></el-input>
    <el-input 
      v-model="loginForm.password" 
      type="password" 
      placeholder="请输入密码" 
      prefix-icon="el-icon-lock" 
      class="login-input"
    ></el-input>
    <el-button 
      type="primary" 
      @click="handleLogin" 
      class="login-btn"
      :loading="isLoading"
    >
      登录
    </el-button>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        account: '', // 对应后端 account 字段
        password: '' // 对应后端 password 字段
      },
      isLoading: false
    };
  },
  methods: {
    async handleLogin() {
      // 简单表单校验（不新增依赖）
        this.isLoading = true;
        try {
        const res = await this.$axios.post('/api/user/doLogin', this.loginForm);
        
        // 适配后端响应格式：从 res.data 中获取 msg 和 userInfo
        const successMsg = res.data.data.msg; // 取 "登录成功！"
        const userInfo = res.data.data.userInfo; // 取用户信息
        
        // 1. 展示成功提示
        this.$message.success(successMsg);
        // 2. 存储登录状态和用户信息（路由守卫+后续页面可用）
        localStorage.setItem('isLogin', true);
        localStorage.setItem('userInfo', JSON.stringify(userInfo));
        // 3. 跳转到首页
        this.$router.push('/');
        } catch (error) {
        const errMsg = error.response 
            ? (error.response.data && error.response.data.msg) 
            : '网络异常';
        this.$message.error(errMsg || '登录失败');
        } finally {
        this.isLoading = false;
        }
    }
  }
}
</script>

<style scoped>
.login-container {
  width: 300px;
  margin: 100px auto;
  display: flex;
  flex-direction: column;
  gap: 15px;
}
.login-input {
  width: 100%;
}
.login-btn {
  width: 100%;
}
</style>