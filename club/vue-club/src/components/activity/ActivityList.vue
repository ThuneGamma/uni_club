<template>
	<el-container class="activity-list-container">
		<el-header class="activity-list-header">
			<div class="bread-nav">
				当前位置:
				<router-link :to="{ name: 'Home' }" class="nav-link">首页</router-link>
				<span class="nav-separator">></span>
				<span class="nav-text">社团风采</span>
				<span class="nav-separator">></span>
				<router-link 
					:to="{ name: 'ActivityList', query: { typeId: activityPageVo.activityType.id } }" 
					class="nav-link" 
					v-if="activityPageVo.activityType != null"
				>
					{{ activityPageVo.activityType.type }}
				</router-link>
			</div>
		</el-header>
		<el-container class="activity-list-body">
			<el-aside width="200px" class="activity-list-aside"><activity-type-list /></el-aside>
			<el-main class="activity-list-main" v-if="activityPageVo != null">
				<div class="category-title-wrap">
					<el-row>
						<span class="category-title" v-if="activityPageVo.activityType != null">{{ activityPageVo.activityType.type }}</span>
					</el-row>
				</div>
				<v-hr class="custom-hr" />
				<ul class="activity-list" v-if="activityPageVo.activityPageInfo != null">
					<li v-for="activity in activityPageVo.activityPageInfo.list" :key="activity.id" class="activity-list-item">
						<router-link :to="{ name: 'Activity', params: { id: activity.id } }" class="activity-name">
							{{ activity.activityName }}
						</router-link>
						<span class="publish-time">{{ activity.publishTime }}</span>
					</li>
				</ul>
			</el-main>
		</el-container>
		<el-pagination
			class="activity-pagination"
			v-if="activityPageVo.activityPageInfo != null"
			background
			layout="prev, pager, next"
			:current-page.sync="currentPage"
			:total="activityPageVo.activityPageInfo.total"
			@current-change="refreshActivityPage"
			:page-size="activityPageVo.activityPageInfo.pageSize"
		></el-pagination>
	</el-container>
</template>

<script>
const OK = 200;
import activityTypeList from '@/components/activity/ActivityTypeList';
import Hr from '@/components/common/Hr.vue';
export default {
	data() {
		return {
			activityPageVo: {},
			currentPage: 1
		};
	},
	components: { activityTypeList, 'v-hr': Hr },
	methods: {
		getActivityPage: function(pageNum, pageSize) {
			var typeId = this.$route.query.typeId;
			console.log(typeId);
			this.$axios
				.get('/api/activities', {
					params: {
						activityTypeId: typeId,
						pageNum: pageNum,
						pageSize: pageSize
					}
				})
				.then(res => {
					console.log(res.data.data);
					if (res.data.code == OK) {
						this.activityPageVo = res.data.data;
					} else {
						this.$layer.alert(res.data.data);
					}
				});
		},
		refreshActivityPage: function() {
			this.getActivityPage(this.currentPage, 8);
		}
	},
	created() {
		this.getActivityPage(this.currentPage, 8);
	},
	watch: {
		$route(to, from) {
			this.getActivityPage(this.currentPage, 8);
		}
	}
};
</script>

<style scoped>
/* 整体容器 - 与社团列表页完全一致 */
.activity-list-container {
	min-height: 100vh;
}

/* 头部面包屑 - 复用社团列表页样式 */
.activity-list-header {
	height: 70px !important;
	background-color: #fff;
	box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.bread-nav {
	height: 100%;
	line-height: 70px;
	font-size: 16px;
	color: #666;
	padding: 0 1.5rem;
	text-align: left; /* 文字靠左，与之前一致 */
}

.nav-link {
	color: #333;
	text-decoration: none;
	margin: 0 0.3rem;
	transition: color 0.3s;
}

.nav-link:hover {
	color: #9a0e14; /* hover主题色统一 */
}

.nav-separator {
	margin: 0 0.5rem;
	color: #999;
}

.nav-text {
	color: #333;
}

/* 主体内容区 - 布局统一 */
.activity-list-body {
	flex: 1;
	background-color: #fff;
}

.activity-list-aside {
	background-color: #f8f9fa;
	padding-top: 1.5rem;
}

/* 主内容区 - 内边距与社团列表一致，避开遮挡 */
.activity-list-main {
	padding: 1.5rem 2rem 2.5rem;
}

/* 分类标题 - 与社团列表分类标题完全一致 */
.category-title-wrap {
	margin-bottom: 1rem;
}

.category-title {
	display: inline-block;
	font-size: 1.5rem; /* 24px，统一大小 */
	font-weight: 600;
	color: #9a0e14; /* 主题色统一 */
	padding-left: 0.8rem;
	border-left: 3px solid #9a0e14; /* 左侧强调线统一 */
}

/* 自定义分隔线 - 与社团列表一致 */
.custom-hr {
	border: none;
	border-top: 2px solid #9a0e14;
	margin: 1rem 0;
}

/* 活动列表 - 复用社团列表样式逻辑 */
.activity-list {
	list-style: none;
	padding: 0;
	margin: 0;
}

.activity-list-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0.9rem 0;
	border-bottom: 1px solid #f0f0f0; /* 底部分隔线统一 */
	transition: background-color 0.3s;
}

.activity-list-item:hover {
	background-color: #fafafa; /* hover背景统一 */
}

.activity-name {
	flex: 1;
	max-width: 70%; /* 限制宽度避免挤压时间 */
	font-size: 1rem;
	color: #333;
	text-decoration: none;
	/* 单行溢出处理统一 */
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	margin-right: 1rem;
	transition: color 0.3s;
}

.activity-name:hover {
	color: #9a0e14; /* hover文字变色统一 */
}

.publish-time {
	font-size: 0.9rem;
	color: #999;
	white-space: nowrap; /* 时间不换行统一 */
}

/* 分页样式 - 与社团列表完全一致 */
.activity-pagination {
	text-align: center;
	margin: 2rem auto;
	padding-bottom: 2rem;
}

/* 响应式适配 - 完全复用社团列表页断点和数值 */
@media screen and (max-width: 768px) {
	/* 隐藏侧边栏统一 */
	.activity-list-aside {
		display: none;
	}

	/* 头部面包屑调整统一 */
	.activity-list-header {
		height: 60px !important;
	}

	.bread-nav {
		line-height: 60px;
		font-size: 14px;
		padding: 0 1rem;
	}

	/* 主内容区内边距调整统一 */
	.activity-list-main {
		padding: 1rem;
	}

	/* 分类标题调整统一 */
	.category-title {
		font-size: 1.25rem;
	}

	/* 列表项适配统一 */
	.activity-list-item {
		flex-direction: column;
		align-items: flex-start;
		padding: 1rem 0;
	}

	.activity-name {
		max-width: 100%;
		font-size: 0.9375rem;
		margin-right: 0;
		margin-bottom: 0.3rem;
	}

	.publish-time {
		font-size: 0.875rem;
	}

	/* 分页适配统一 */
	.activity-pagination {
		margin: 1.5rem auto;
		padding-bottom: 1.5rem;
	}
}
</style>