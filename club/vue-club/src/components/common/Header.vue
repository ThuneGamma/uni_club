<template>
	<div>
		<div class="header-wrap">
			<el-menu :default-active="activeIndex" class="header computerNav" background-color="#00A185" mode="horizontal" text-color="#fff" active-text-color="#ffd04b">
				<!-- 原有所有菜单项不变，保留原样 -->
				<el-menu-item index="1"><router-link :to="{ name: 'Home' }" tag="div">首页</router-link></el-menu-item>
				<el-menu-item index="2"><router-link :to="{ name: 'Passage', params: { id: 1 } }" tag="div">社指简介</router-link></el-menu-item>
				<el-submenu index="3">
					<template slot="title">社团快讯</template>
					<el-menu-item index="3-1"><router-link :to="{ name: 'PassageList', query: { passageTypeId: 1 } }" tag="div">重要通知</router-link></el-menu-item>
					<el-menu-item index="3-2"><router-link :to="{ name: 'PassageList', query: { passageTypeId: 2 } }" tag="div">社团要闻</router-link></el-menu-item>
				</el-submenu>
				<el-submenu index="4">
					<template slot="title">社团风采</template>
					<el-menu-item index="4-1"><router-link :to="{ name: 'ActivityList', query: { typeId: 1 } }" tag="div">活动预告</router-link></el-menu-item>
					<el-menu-item index="4-2"><router-link :to="{ name: 'ActivityList', query: { typeId: 2 } }" tag="div">精彩活动回顾</router-link></el-menu-item>
				</el-submenu>
				<el-menu-item index="5"><router-link :to="{ name: 'ClubList', query: { typeId: 1 } }" tag="div">社团检索</router-link></el-menu-item>
				<el-menu-item index="6"><router-link :to="{ name: 'FileList', query: { fileTypeId: 3 } }" tag="div">资料下载</router-link></el-menu-item>
				
				<!-- 核心修改：登录/未登录状态切换 -->
				<template v-if="userInfo">
					<!-- 登录后：显示用户名 + 退出登录 -->
					<el-menu-item index="8" class="rightMenu" style="color: #ffd04b;">
						{{ userInfo.name || userInfo.account }}
					</el-menu-item>
					<el-menu-item index="9" class="rightMenu">
						<a href="javascript:;" @click="handleLogout">退出登录</a>
					</el-menu-item>
				</template>
				<template v-else>
					<!-- 未登录：保持原有登录/注册按钮 -->
					<el-menu-item index="8" class="rightMenu"><router-link to="/login">登录</router-link></el-menu-item>
					<el-menu-item index="9" class="rightMenu"><router-link to="/register" class="register-link">注册</router-link></el-menu-item>
				</template>
			</el-menu>
		</div>
		<!-- 手机端菜单（保留原有结构，无需修改） -->
		<div class="phone-nav">
			<el-dropdown :hide-on-click="false">
				<span class="el-dropdown-link">
					菜单
					<i class="el-icon-arrow-down el-icon--right"></i>
				</span>
				<el-dropdown-menu slot="dropdown">
					<el-dropdown-item><router-link :to="{ name: 'Home' }">首页</router-link></el-dropdown-item>
					<el-dropdown-item divided><router-link :to="{ name: 'Passage', params: { id: 1 } }">社指简介</router-link></el-dropdown-item>
					<el-dropdown-item divided><router-link :to="{ name: 'Passage', params: { id: 1 } }">社指简介</router-link></el-dropdown-item>
					<el-dropdown-item divided><router-link :to="{ name: 'Passage', params: { id: 1 } }">社指简介</router-link></el-dropdown-item>
					<el-dropdown-item disabled>双皮奶</el-dropdown-item>
					<el-dropdown-item divided>蚵仔煎</el-dropdown-item>
				</el-dropdown-menu>
			</el-dropdown>
		</div>
	</div>
</template>

<script>
export default {
  data() {
    return {
      activeIndex: '1',
      userInfo: null
    }
  },
  created() {
    this.syncUserInfo(); // 初始化时读取
  },
  watch: {
    // 路由变化时（比如登录后跳转回来），重新读取用户信息
    $route: {
      immediate: true, // 确保初始时也执行（和created呼应，双重保险）
      handler() {
        this.syncUserInfo();
      }
    }
  },
  methods: {
    // 提取独立方法，复用读取逻辑
    syncUserInfo() {
      const userInfoStr = localStorage.getItem('userInfo');
      this.userInfo = userInfoStr ? JSON.parse(userInfoStr) : null;
    },
    handleLogout() {
      this.$router.push('/');
      localStorage.removeItem('isLogin');
      localStorage.removeItem('userInfo');
      this.userInfo = null;
      this.$message.success('退出登录成功！');
    }
  }
}
</script>

<style scoped>
/* 头部容器：保留原有背景色，优化间距 */
.header-wrap {
	background-color: #00A185;
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  height: 70px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.1); /* 轻微阴影，提升质感 */
  z-index: 999;
}

/* 导航容器：调整宽度，优化居中 */
.header {
	width: 1100px; /* 适度加宽，避免菜单拥挤 */
	height: 70px;
	line-height: 70px;
	margin: 0 auto;
}

/* 字体统一优化 */
.el-menu, .el-menu-item, .el-submenu__title, a {
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Microsoft YaHei", sans-serif;
	font-size: 16px; /* 统一字号，提升可读性 */
}

/* 菜单项间距优化 */
.el-menu--horizontal .el-menu-item, .el-menu--horizontal .el-submenu__title {
	padding: 0 18px !important; /* 增大间距，避免拥挤 */
}

/* 下拉菜单样式微调 */
.el-submenu .el-menu {
	background-color: #069a66 !important;
}
.el-submenu .el-menu-item {
	font-size: 15px !important; /* 下拉菜单字号稍小，区分层级 */
	padding: 0 25px !important;
}

/* 链接样式优化 */
a {
	text-decoration: none;
	color: #fff;
	transition: color 0.2s ease; /* hover过渡，更柔和 */
}
.el-menu-item a:hover, .el-submenu__title:hover {
	color: #ffd04b !important; /* hover时与激活色一致，更协调 */
}

/* 登录按钮微调 */
.rightMenu {
	float: right;
	height: 70px;
	line-height: 70px;
	background-color: rgba(0,0,0,0.2) !important; /* 半透明黑色，更柔和 */
	padding: 0 22px !important;
}

/* 手机端菜单样式微调 */
.phone-nav {
	display: none;
}
.el-dropdown-link {
	color: #fff;
	font-size: 16px;
}

/* 响应式适配（保留原有逻辑，微调间距） */
@media screen and (max-width: 1100px) {
	.header {
		width: 95%;
	}
}
@media screen and (max-width: 600px) {
	.computerNav {
		display: none;
	}
	.phone-nav {
		display: block;
		position: fixed;
		top: 20px;
		right: 20px;
	}
}
.register-link {
  color: #9a0e14;
  margin-left: 5px;
}
</style>