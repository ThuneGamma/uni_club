<template>
	<el-container class="club-list-container">
		<el-header class="club-list-header">
			<div class="bread-nav">
				当前位置:
				<router-link :to="{ name: 'Home' }" class="nav-link">首页</router-link>
				<span class="nav-separator">></span>
				<router-link 
					:to="{ name: 'ClubList', query: { typeId: clubPageVo.clubType.id } }" 
					class="nav-link" 
					v-if="clubPageVo.clubType != null"
				>社团检索</router-link>
			</div>
		</el-header>
		<el-container class="club-list-body">
			<el-aside width="200px" class="club-list-aside"><club-type-list /></el-aside>
			<el-main class="club-list-main" v-if="clubPageVo != null">
				<div class="category-title-wrap">
					<el-row>
						<span class="category-title" v-if="clubPageVo.clubType != null">{{ clubPageVo.clubType.type }}</span>
					</el-row>
				</div>
				<v-hr class="custom-hr" />
				<ul class="club-list" v-if="clubPageVo.clubPageInfo != null">
					<li v-for="club in clubPageVo.clubPageInfo.list" :key="club.num" class="club-list-item">
						<router-link :to="{ name: 'Club', params: { num: club.num } }" class="club-name">
							{{ club.name }}
						</router-link>
						<span class="publish-time">{{ club.publishTime }}</span>
					</li>
				</ul>
			</el-main>
		</el-container>
		<el-pagination
			class="club-pagination"
			v-if="clubPageVo.clubPageInfo != null"
			background
			layout="prev, pager, next"
			:current-page.sync="currentPage"
			:total="clubPageVo.clubPageInfo.total"
			@current-change="refreshClubPage"
			:page-size="clubPageVo.clubPageInfo.pageSize"
		></el-pagination>
	</el-container>
</template>

<script>
const OK = 200;
import clubTypeList from '@/components/club/ClubTypeList';
import Hr from '@/components/common/Hr.vue';
export default {
	data() {
		return {
			clubPageVo: {},
			currentPage: 1
		};
	},
	components: { clubTypeList, 'v-hr': Hr },
	methods: {
		getClubPage: function(pageNum, pageSize) {
			var typeId = this.$route.query.typeId;
			console.log(typeId);
			this.$axios
				.get('/api/clubs', {
					params: {
						clubTypeId: typeId,
						pageNum: pageNum,
						pageSize: pageSize
					}
				})
				.then(res => {
					if (res.data.code == OK) {
						this.clubPageVo = res.data.data;
					} else {
						this.$layer.alert(res.data.data);
					}
				});
		},
		refreshClubPage: function() {
			this.getClubPage(this.currentPage, 8);
		}
	},
	created() {
		this.getClubPage(this.currentPage, 8);
	},
	watch: {
		$route(to, from) {
			this.getClubPage(this.currentPage, 8);
		}
	}
};
</script>

<style scoped>
/* 整体容器 */
.club-list-container {
	min-height: 100vh;
}

/* 头部面包屑 */
.club-list-header {
	height: 70px !important; /* 保持原有高度 */
	background-color: #fff;
	box-shadow: 0 2px 4px rgba(0,0,0,0.05); /* 轻微阴影提升层次感 */
}

.bread-nav {
	height: 100%;
	line-height: 70px;
	font-size: 16px;
	color: #666;
	padding: 0 1.5rem; /* 左侧1.5rem内边距，避免文字贴容器边缘 */
	text-align: left; /* 明确指定文字靠左，优先级更高 */
}

.nav-link {
	color: #333;
	text-decoration: none;
	margin: 0 0.3rem;
	transition: color 0.3s;
}

.nav-link:hover {
	color: #9a0e14; /*  hover时匹配主题色 */
}

.nav-separator {
	margin: 0 0.5rem;
	color: #999;
}

/* 主体内容区 */
.club-list-body {
	flex: 1;
	background-color: #fff;
}

.club-list-aside {
	background-color: #f8f9fa;
	padding-top: 1.5rem;
}

/* 主内容区 */
.club-list-main {
	padding: 1.5rem 2rem 2.5rem; /* 上下内边距避免遮挡和贴边 */
}

/* 分类标题 */
.category-title-wrap {
	margin-bottom: 1rem;
}

.category-title {
	display: inline-block;
	font-size: 1.5rem; /* 24px 保持原有大小 */
	font-weight: 600;
	color: #9a0e14;
	padding-left: 0.8rem;
	border-left: 3px solid #9a0e14; /* 左侧边框强调 */
}

/* 自定义分隔线 */
.custom-hr {
	border: none;
	border-top: 2px solid #9a0e14;
	margin: 1rem 0;
}

/* 社团列表 */
.club-list {
	list-style: none;
	padding: 0;
	margin: 0;
}

.club-list-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0.9rem 0;
	border-bottom: 1px solid #f0f0f0; /* 底部细线分隔 */
	transition: background-color 0.3s;
}

.club-list-item:hover {
	background-color: #fafafa; /* hover背景色优化 */
}

.club-name {
	flex: 1;
	max-width: 70%; /* 限制宽度避免挤压时间 */
	font-size: 1rem;
	color: #333;
	text-decoration: none;
	/* 单行溢出处理 */
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	margin-right: 1rem;
	transition: color 0.3s;
}

.club-name:hover {
	color: #9a0e14; /* hover时变色 */
}

.publish-time {
	font-size: 0.9rem;
	color: #999;
	white-space: nowrap; /* 时间不换行 */
}

/* 分页样式 */
.club-pagination {
	text-align: center;
	margin: 2rem auto;
	padding-bottom: 2rem;
}

/* 响应式适配 */
@media screen and (max-width: 768px) {
	/* 隐藏侧边栏，保留面包屑 */
	.club-list-aside {
		display: none;
	}

	/* 调整头部面包屑 */
	.club-list-header {
		height: 60px !important;
	}

	.bread-nav {
		line-height: 60px;
		font-size: 14px;
		padding: 0 1rem;
	}

	/* 调整主内容区内边距 */
	.club-list-main {
		padding: 1rem;
	}

	/* 分类标题调整 */
	.category-title {
		font-size: 1.25rem;
	}

	/* 列表项适配 */
	.club-list-item {
		flex-direction: column;
		align-items: flex-start;
		padding: 1rem 0;
	}

	.club-name {
		max-width: 100%;
		font-size: 0.9375rem;
		margin-right: 0;
		margin-bottom: 0.3rem;
	}

	.publish-time {
		font-size: 0.875rem;
	}

	/* 分页适配 */
	.club-pagination {
		margin: 1.5rem auto;
		padding-bottom: 1.5rem;
	}
}
</style>