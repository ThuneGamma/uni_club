<template>
  <div class="register-container">
    <!-- 注册表单卡片 -->
    <el-card class="register-card">
      <h2 class="register-title">用户注册</h2>
      <el-form 
        :model="registerForm" 
        :rules="registerRules" 
        ref="registerFormRef" 
        label-width="80px"
        class="register-form"
      >
        <!-- 用户名 -->
        <el-form-item label="用户名" prop="username">
          <el-input 
            v-model="registerForm.username" 
            placeholder="请输入用户名（3-20位）" 
            clearable
          ></el-input>
        </el-form-item>

        <!-- 密码 -->
        <el-form-item label="密码" prop="password">
          <el-input 
            v-model="registerForm.password" 
            type="password" 
            placeholder="请输入密码（6-16位）" 
            clearable
          ></el-input>
        </el-form-item>

        <!-- 确认密码 -->
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input 
            v-model="registerForm.confirmPassword" 
            type="password" 
            placeholder="请再次输入密码" 
            clearable
          ></el-input>
        </el-form-item>

        <!-- 性别 -->
        <el-form-item label="性别" prop="sex">
          <el-select 
            v-model="registerForm.sex" 
            placeholder="请选择性别"
          >
            <el-option label="男" value="男"></el-option>
            <el-option label="女" value="女"></el-option>
            <el-option label="未知" value="未知"></el-option>
          </el-select>
        </el-form-item>

        <!-- 手机号（可选，可根据需求增减字段） -->
        <el-form-item label="手机号" prop="phone">
          <el-input 
            v-model="registerForm.phone" 
            placeholder="请输入手机号（选填）" 
            clearable
          ></el-input>
        </el-form-item>

        <!-- 提交按钮 -->
        <el-form-item>
          <el-button 
            type="primary" 
            @click="submitRegister" 
            :loading="isLoading"
            class="submit-btn"
          >
            注册
          </el-button>
          <el-button 
            type="text" 
            @click="goToLogin"
            class="login-link"
          >
            已有账号？去登录
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import axios from 'axios'
const OK = 200 // 和你现有项目的响应码统一

export default {
  data() {
    return {
      registerForm: {
        username: '', // 用户名（对应后端 account 字段）
        password: '', // 密码
        confirmPassword: '', // 确认密码（对应后端 rePassword 参数）
        sex: '', // 性别（前端传字符串：男/女/未知，后端自动转数字）
        phone: '' // 手机号（后端无该字段，可保留但后端会忽略，或直接删除）
      },
      // 表单验证规则（完全不变）
      registerRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度在3-20位之间', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 16, message: '密码长度在6-16位之间', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认密码', trigger: 'blur' },
          { 
            validator: (rule, value, callback) => {
              if (value !== this.registerForm.password) {
                callback(new Error('两次密码输入不一致'))
              } else {
                callback()
              }
            },
            trigger: 'blur'
          }
        ],
        sex: [
          { required: true, message: '请选择性别', trigger: 'change' }
        ],
        phone: [
          { 
            pattern: /^1[3-9]\d{9}$/, 
            message: '请输入有效的手机号', 
            trigger: 'blur',
            required: false // 可选字段，后端无该字段，传了也不处理
          }
        ]
      },
      isLoading: false // 提交按钮loading状态
    }
  },
  methods: {
    // 提交注册（核心修改：参数包装）
    submitRegister() {
      // 先做前端表单验证（完全不变）
      this.$refs.registerFormRef.validate((isValid) => {
        if (isValid) {
          this.isLoading = true
          let sexNum = 2; // 默认未知
          if (this.registerForm.sex === "男") {
              sexNum = 0;
          } else if (this.registerForm.sex === "女") {
              sexNum = 1;
          }
          // 关键改动1：按后端要求包装参数
          const requestParams = {
            // // user 对象：包含后端需要的 username（对应account）、password、sex
            // user: {
              account: this.registerForm.username, // 前端username → 后端account（已通过@JsonProperty映射）
              password: this.registerForm.password, // 密码（明文，按你需求）
              sex: sexNum // 前端传字符串（男/女/未知），后端Controller会转数字
              // 后端需要的 name、institute 字段：前端未提供输入框，后端会自动填充默认空串，无需传递
            // },
            // // rePassWord：对应后端 register 方法的 rePassword 参数（确认密码）
            // rePassWord: this.registerForm.confirmPassword
          }

          // 提交到后端注册接口（参数换成包装后的 requestParams）
          axios.post('/api/user/register', requestParams)
            .then(res => {
              if (res.data.code === OK) {
                this.$message.success('注册成功！即将跳转到登录页')
                // 注册成功后跳转到登录页（完全不变）
                setTimeout(() => {
                  this.$router.push('/login')
                }, 1500)
              } else {
                this.$message.error(`注册失败：${res.data.msg}`)
              }
            })
            .catch(err => {
              console.error('注册请求失败：', err)
              this.$message.error('网络异常，请稍后重试')
            })
            .finally(() => {
              this.isLoading = false
            })
        } else {
          this.$message.warning('请完善表单信息')
          return false
        }
      })
    },
    // 跳转到登录页（完全不变）
    goToLogin() {
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.register-container {
  width: 100%;
  height: 100vh;
  background-color: #f5f5f5;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.register-card {
  width: 100%;
  max-width: 450px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.1);
  border-radius: 8px;
  padding: 30px;
}

.register-title {
  text-align: center;
  color: #9a0e14;
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 25px;
}

.register-form {
  margin-top: 15px;
}

.submit-btn {
  width: 100%;
  background-color: #9a0e14;
  border-color: #9a0e14;
}

.submit-btn:hover {
  background-color: #7c0a10;
  border-color: #7c0a10;
}

.login-link {
  display: block;
  text-align: center;
  margin-top: 15px;
  color: #9a0e14;
}
</style>