<template>
  <el-form :model="user" status-icon ref="userForm" label-width="100px" class="userForm">
    <!-- 邮箱输入框 -->
    <el-form-item label="账号">
      <el-input v-model="user.account" placeholder="请输入你的邮箱"></el-input>
    </el-form-item>
    <!-- 密码输入框 -->
    <el-form-item label="密码" prop="password">
      <el-input placeholder="请输入密码" type="password" v-model="user.password"></el-input>
    </el-form-item>
    <!-- 按钮区域 -->
    <el-form-item>
      <el-button type="primary" @click="login">提交</el-button>
      <el-button @click="resetForm">重置</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
const OK = 200;
export default {
  data() {
    return {
      rules: {},
      // 1. 关键修复：初始化时声明 account 和 password，确保响应式
      user: {
        account: '', // 初始为空字符串
        password: '' // 初始为空字符串
      },
      code: '',
      token: '',
      captchaUrl: ''
    };
  },
  methods: {
    login() {
      this.$axios
        .post('/api/users/login', this.user)
        .then(res => {
          console.log('用户输入数据：', this.user);
          console.log('接口返回数据：', res.data);
          if (res.data.code === OK) {
            this.$message.success('登录成功');
            this.$cookies.set('token', res.data.data, 60 * 30); // 30分钟有效期
            this.token = res.data.data;
            this.$router.push({ name: 'Home' });
          } else {
            this.$message.error(res.data.message);
            this.refreshCode();
          }
        })
        // 2. 修复：catch 用箭头函数，避免 this 指向丢失
        .catch(error => {
          this.$message.error('请求失败：' + error.message);
        });
    },
    refreshCode() {
      this.captchaUrl = '/api/users/getKaptcha?time=' + new Date().getTime();
      console.log('更新验证码地址：', this.captchaUrl);
    },
    // 3. 修复：重置表单功能（之前是空实现）
    resetForm() {
      this.$refs.userForm.resetFields(); // 重置表单字段
    },
    tryToAminPage() {
      const token = this.$cookies.get('token');
      if (token) this.$router.push({ name: 'Home' });
    },
    test() {
      // 4. 优化：赋值语法规范（分号分隔）
      this.user.account = 'test@163.com';
      this.user.password = '123456';
    }
  },
  created() {
    // this.tryToAminPage();
    this.test(); // 初始化测试账号密码
    this.refreshCode(); // 生成验证码（模板未使用，可根据需求添加）
  }
};
</script>

<style scoped>
.userForm {
  width: 550px;
  margin: 0 auto;
  padding: 80px;
}
</style>
