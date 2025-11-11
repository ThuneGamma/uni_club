<template>
	<el-container class="passage-list-container">
		<el-header class="passage-list-header">
			<div class="bread-nav">
				当前位置:
				<router-link :to="{ name: 'Home' }" class="nav-link">首页</router-link>
				<span class="nav-separator">></span>
				<span class="nav-text large_type">社团快讯</span>
				<span class="nav-separator">></span>
				<router-link 
					:to="{ name: 'PassageList', query: { typeId: newsPageVo.passageType.id } }" 
					class="nav-link" 
					v-if="newsPageVo.passageType != null"
				>
					{{ newsPageVo.passageType.type }}
				</router-link>
			</div>
		</el-header>
		<el-container class="passage-list-body">
			<el-aside width="200px" class="passage-list-aside"><pasage-type-list /></el-aside>
			<el-main class="passage-list-main" v-if="newsPageVo != null">
				<div class="category-title-wrap">
					<el-row>
						<span class="category-title" v-if="newsPageVo.passageType != null">{{ newsPageVo.passageType.type }}</span>
					</el-row>
				</div>
				<v-hr class="custom-hr" />
				<ul class="passage-list" v-if="newsPageVo.passagePageInfo != null">
					<li v-for="news in newsPageVo.passagePageInfo.list" :key="news.id" class="passage-list-item">
						<router-link :to="{ name: 'Passage', params: { id: news.id } }" class="passage-title">
							{{ news.title }}
						</router-link>
						<span class="publish-time">{{ news.publishTime }}</span>
					</li>
				</ul>
			</el-main>
		</el-container>
		<el-pagination
			class="passage-pagination"
			v-if="newsPageVo.passagePageInfo != null"
			background
			layout="prev, pager, next"
			:current-page.sync="currentPage"
			:total="newsPageVo.passagePageInfo.total"
			@current-change="refreshPasagePage"
			:page-size="newsPageVo.passagePageInfo.pageSize"
		></el-pagination>
	</el-container>
</template>

<script>
const OK = 200;
import pasageTypeList from '@/components/passage/PassageTypeList.vue';
import Hr from '@/components/common/Hr.vue';
export default {
	data() {
		return {
			newsPageVo: {},
			typeId: '',
			currentPage: 1
		};
	},
	components: { pasageTypeList, 'v-hr': Hr },
	methods: {
		getNewsPage: function(pageNum, pageSize) {
			var typeId = this.$route.query.passageTypeId;
			this.typeId = typeId;
			console.log(typeId);
			this.$axios
				.get('/api/passages', {
					params: {
						passageTypeId: typeId,
						pageNum: pageNum,
						pageSize: pageSize
					}
				})
				.then(res => {
					if (res.data.code == OK) {
						this.newsPageVo = res.data.data;
					} else {
						this.$layer.alert(res.data.data);
					}
				});
		},
		refreshPasagePage: function() {
			this.getNewsPage(this.currentPage, 8);
		}
	},
	created() {
		this.getNewsPage(1, 8);
	},
	watch: {
		$route(to, from) {
			this.getNewsPage(this.currentPage, 8);
		}
	}
};
</script>

<style scoped>
/* 整体容器 - 与社团/活动列表页完全一致 */
.passage-list-container {
	min-height: 100vh;
}

/* 头部面包屑 - 复用统一样式 */
.passage-list-header {
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
	text-align: left; /* 文字靠左，统一标准 */
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

.large_type {
	margin: 0 5px; /* 保留原间距，不破坏布局 */
}

/* 主体内容区 - 布局统一 */
.passage-list-body {
	flex: 1;
	background-color: #fff;
}

.passage-list-aside {
	background-color: #f8f9fa;
	padding-top: 1.5rem;
}

/* 主内容区 - 内边距统一，避开遮挡 */
.passage-list-main {
	padding: 1.5rem 2rem 2.5rem;
}

/* 分类标题 - 与其他列表页完全一致 */
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

/* 自定义分隔线 - 统一样式 */
.custom-hr {
	border: none;
	border-top: 2px solid #9a0e14;
	margin: 1rem 0;
}

/* 快讯列表 - 替换float为flex，统一布局 */
.passage-list {
	list-style: none;
	padding: 0;
	margin: 0;
}

.passage-list-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0.9rem 0;
	border-bottom: 1px solid #f0f0f0; /* 底部分隔线统一 */
	transition: background-color 0.3s;
}

.passage-list-item:hover {
	background-color: #fafafa; /* hover背景统一 */
}

.passage-title {
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

.passage-title:hover {
	color: #9a0e14; /* hover文字变色统一 */
}

.publish-time {
	font-size: 0.9rem;
	color: #999;
	white-space: nowrap; /* 时间不换行统一 */
}

/* 分页样式 - 统一位置和间距 */
.passage-pagination {
	text-align: center;
	margin: 2rem auto;
	padding-bottom: 2rem;
}

/* 响应式适配 - 与其他列表页1:1对齐 */
@media screen and (max-width: 768px) {
	/* 隐藏侧边栏统一 */
	.passage-list-aside {
		display: none;
	}

	/* 头部面包屑调整统一 */
	.passage-list-header {
		height: 60px !important;
	}

	.bread-nav {
		line-height: 60px;
		font-size: 14px;
		padding: 0 1rem;
	}

	/* 主内容区内边距调整统一 */
	.passage-list-main {
		padding: 1rem;
	}

	/* 分类标题调整统一 */
	.category-title {
		font-size: 1.25rem;
	}

	/* 列表项适配统一 - 取消float，改为上下布局 */
	.passage-list-item {
		flex-direction: column;
		align-items: flex-start;
		padding: 1rem 0;
	}

	.passage-title {
		max-width: 100%;
		font-size: 0.9375rem;
		margin-right: 0;
		margin-bottom: 0.3rem;
	}

	.publish-time {
		font-size: 0.875rem;
	}

	/* 分页适配统一 */
	.passage-pagination {
		margin: 1.5rem auto;
		padding-bottom: 1.5rem;
	}
}
</style>