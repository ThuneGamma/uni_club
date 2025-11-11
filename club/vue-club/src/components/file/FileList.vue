<template>
	<el-container class="file-list-container">
		<el-header class="file-list-header">
			<div class="bread-nav">
				当前位置:
				<router-link :to="{ name: 'Home' }" class="nav-link">首页</router-link>
				<span class="nav-separator">></span>
				<span class="nav-text large_type">资料下载</span>
			</div>
		</el-header>
		<el-container class="file-list-body">
			<el-main class="file-list-main">
				<!-- 分类标题（统一靠左+强调线样式） -->
				<div class="category-title-wrap">
					<span class="category-title">资料下载</span>
				</div>
				<v-hr class="custom-hr" />
				<!-- 文件列表（统一flex布局） -->
				<ul class="file-list" v-if="files.length > 0">
					<li v-for="file in files" :key="file.id" class="file-list-item">
						<a 
							:href="'http://localhost:8013/fileServer/' + file.filePath" 
							class="file-name" 
							target="_blank"
						>
							{{ file.fileName }}
						</a>
						<span class="create-time">{{ file.createTime }}</span>
					</li>
				</ul>
			</el-main>
		</el-container>
		<!-- 分页（统一居中样式） -->
		<el-pagination
			class="file-pagination"
			v-if="filePageVo != null"
			background
			layout="prev, pager, next"
			:current-page.sync="currentPage"
			:total="filePageVo.total"
			@current-change="refreshPasagePage"
			:page-size="filePageVo.pageSize"
		></el-pagination>
	</el-container>
</template>

<script>
const OK = 200;
export default {
	data() {
		return {
			filePageVo: {},
			files: [],
			currentPage: 1,
			fileDownPath: ""
		};
	},
	methods: {
		getFileList: function(typeId, pageNum, pageSize) {
			this.$axios
				.get('/api/files', {
					params: {
						fileTypeId: typeId,
						pageNum: pageNum,
						pageSize: pageSize
					}
				})
				.then(res => {
					if (res.data.code == OK) {
						this.filePageVo = res.data.data;
						this.files = this.filePageVo.list;
					} else {
						this.$layer.alert(res.data.data);
					}
				});
		},
		refreshPasagePage: function() {
			this.getFileList(3, this.currentPage, 8);
		}
	},
	created() {
		var typeId = this.$route.query.typeId;
		this.getFileList(3, this.currentPage, 8);
	}
};
</script>

<style scoped>
/* 整体容器 - 与其他列表页完全一致 */
.file-list-container {
	min-height: 100vh;
}

/* 头部面包屑 - 复用统一样式 */
.file-list-header {
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
.file-list-body {
	flex: 1;
	background-color: #fff;
}

/* 主内容区 - 内边距统一，避开遮挡 */
.file-list-main {
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

/* 文件列表 - 替换float为flex，统一布局 */
.file-list {
	list-style: none;
	padding: 0;
	margin: 0;
}

.file-list-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0.9rem 0;
	border-bottom: 1px solid #f0f0f0; /* 底部分隔线统一 */
	transition: background-color 0.3s;
}

.file-list-item:hover {
	background-color: #fafafa; /* hover背景统一 */
}

.file-name {
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

.file-name:hover {
	color: #9a0e14; /* hover文字变色统一 */
	text-decoration: underline; /* 下载链接额外添加下划线hover效果，提升辨识度 */
}

.create-time {
	font-size: 0.9rem;
	color: #999;
	white-space: nowrap; /* 时间不换行统一 */
}

/* 分页样式 - 统一位置和间距 */
.file-pagination {
	text-align: center;
	margin: 2rem auto;
	padding-bottom: 2rem;
}

/* 响应式适配 - 与其他列表页1:1对齐 */
@media screen and (max-width: 768px) {
	/* 头部面包屑调整统一 */
	.file-list-header {
		height: 60px !important;
	}

	.bread-nav {
		line-height: 60px;
		font-size: 14px;
		padding: 0 1rem;
	}

	/* 主内容区内边距调整统一 */
	.file-list-main {
		padding: 1rem;
	}

	/* 分类标题调整统一 */
	.category-title {
		font-size: 1.25rem;
	}

	/* 列表项适配统一 - 取消float，改为上下布局 */
	.file-list-item {
		flex-direction: column;
		align-items: flex-start;
		padding: 1rem 0;
	}

	.file-name {
		max-width: 100%;
		font-size: 0.9375rem;
		margin-right: 0;
		margin-bottom: 0.3rem;
	}

	.create-time {
		font-size: 0.875rem;
	}

	/* 分页适配统一 */
	.file-pagination {
		margin: 1.5rem auto;
		padding-bottom: 1.5rem;
	}
}
</style>