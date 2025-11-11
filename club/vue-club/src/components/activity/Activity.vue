<template>
	<div class="activity-detail-container" v-if="activity != null">
		<!-- 活动标题（与社团标题样式完全一致） -->
		<span class="activity-title">{{ activity.activityName }}</span>
		
		<!-- 活动基本信息（布局对齐，大小统一） -->
		<div class="activity-meta">
			<div class="meta-item time">
				<span class="meta-label">活动举办时间:</span>
				<span class="meta-value">{{ activity.holdTime }}</span>
			</div>
			<div class="meta-item site">
				<span class="meta-label">活动举办地点:</span>
				<span class="meta-value">{{ activity.site }}</span>
			</div>
		</div>

		<!-- 活动介绍（与社团介绍排版完全一致） -->
		<div v-html="activity.introduce" class="activity-content"></div>

		<!-- 附件/图片展示区（保持统一间距和大小） -->
		<div class="attachment-section" v-if="fileList.length > 0">
			<h3 class="attachment-title">相关附件/图片</h3>
			<div class="attachment-list">
				<div v-for="file in fileList" :key="file.id" class="attachment-item">
					<img 
						:src="'http://localhost:8013/fileServer' + file.filePath" 
						class="activity-image" 
						:alt="file.fileName" 
						v-if="isImage(file.fileName)"
						loading="lazy"
					/>
					<a 
						:href="'http://localhost:8013/fileServer' + file.filePath" 
						class="file-link" 
						target="_blank"
						v-else
					>
						<span class="file-name">{{ file.fileName }}</span>
					</a>
				</div>
			</div>
		</div>

		<!-- 分享组件（位置和分隔线统一） -->
		<div class="share-section">
			<Share />
		</div>
	</div>
</template>

<script>
import Share from '@/components/common/Share.vue';
const OK = 200;
export default {
	data() {
		return {
			activity: {},
			fileList: []
		};
	},
	components: { Share },
	methods: {
		get: function() {
			var id = this.$route.params.id;
			this.$axios.get('/api/activities/' + id).then(res => {
				console.log(res.data);
				if (res.data.code == OK) {
					this.activity = res.data.data;
					this.fileList = this.activity.fileList || [];
				} else {
					this.$layer.alert(res.data.data);
				}
			});
		},
		isImage: function(fileName) {
			const imageExts = ['png', 'jpg', 'jpeg', 'gif', 'webp'];
			const ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
			return imageExts.includes(ext);
		}
	},
	created() {
		this.get();
	},
	watch: {
		$route(to, from) {
			this.get();
		}
	}
};
</script>

<style scoped>
/* 容器样式 - 与社团详情页完全一致 */
.activity-detail-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 5rem 1.5rem 2rem; /* 顶部5rem避开header，与之前一致 */
	line-height: 1.5;
}

/* 标题样式 - 完全对齐社团标题 */
.activity-title {
	display: block;
	font-size: 1.875rem; /* 30px，与社团标题一致 */
	font-weight: 600;
	color: #9a0e14; /* 统一主题色 */
	margin-bottom: 1.25rem; /* 与社团标题间距一致 */
	border-bottom: 2px solid #e5e7eb; /* 分隔线样式统一 */
	padding-bottom: 0.75rem; /* 标题内边距一致 */
}

/* 活动基本信息 - 布局和大小统一 */
.activity-meta {
	display: flex;
	gap: 2.5rem; /* 间距与社团列表页meta一致 */
	flex-wrap: wrap;
	margin-bottom: 1.25rem; /* 与标题下方间距统一 */
	color: #666;
	font-size: 0.9375rem; /* 15px，与之前一致 */
}

.meta-item {
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.meta-label {
	font-weight: 500;
	color: #333;
}

.meta-value {
	color: #555;
}

/* 活动介绍 - 与社团内容排版完全一致 */
.activity-content {
	font-size: 1rem; /* 16px，统一正文大小 */
	color: #374151;
	line-height: 1.8; /* 行高统一 */
	margin-bottom: 1.5rem; /* 与附件区间距一致 */
}

/* 嵌套标签样式 - 完全复用社团详情页配置 */
.activity-content p {
	margin-bottom: 1rem;
	text-indent: 2em; /* 首行缩进统一 */
}

.activity-content h1,
.activity-content h2,
.activity-content h3 {
	color: #1f2937;
	font-weight: 600;
	margin: 1.5rem 0 0.75rem;
}

.activity-content h1 {
	font-size: 1.5rem;
}

.activity-content h2 {
	font-size: 1.25rem;
}

.activity-content h3 {
	font-size: 1.125rem;
}

.activity-content ul,
.activity-content ol {
	margin: 0 0 1rem 1.5rem;
	padding-left: 0.75rem;
}

.activity-content li {
	margin-bottom: 0.5rem;
}

/* 附件区 - 样式统一 */
.attachment-section {
	margin-bottom: 1.5rem;
}

.attachment-title {
	font-size: 1.125rem; /* 18px，与社团列表分类标题一致 */
	color: #333;
	font-weight: 600;
	margin-bottom: 1rem;
	padding-left: 0.75rem;
	border-left: 3px solid #9a0e14; /* 主题色强调线统一 */
}

.attachment-list {
	display: flex;
	flex-wrap: wrap;
	gap: 1.25rem; /* 间距与之前一致 */
}

.attachment-item {
	transition: transform 0.3s;
}

.attachment-item:hover {
	transform: translateY(-3px); /* 交互效果统一 */
}

/* 图片样式 - 大小和质感统一 */
.activity-image {
	max-width: 420px; /* 与用户之前代码图片宽度一致 */
	max-height: 360px; /* 保持原图片高度 */
	width: auto;
	height: auto;
	border-radius: 4px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.05); /* 阴影强度与之前一致 */
	object-fit: cover;
}

/* 文件链接 - 样式统一 */
.file-link {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 0.75rem 1rem;
	background-color: #f8f9fa;
	border-radius: 4px;
	color: #333;
	text-decoration: none;
	transition: all 0.3s;
}

.file-link:hover {
	background-color: #eee;
	color: #9a0e14; /* hover主题色统一 */
}

.file-name {
	white-space: nowrap;
	max-width: 200px;
	overflow: hidden;
	text-overflow: ellipsis;
}

/* 分享组件 - 样式统一 */
.share-section {
	margin-top: 1.5rem;
	padding-top: 1rem;
	border-top: 1px solid #e5e7eb; /* 分隔线与标题一致 */
}

/* 响应式适配 - 完全复用之前的断点和数值 */
@media (max-width: 768px) {
	.activity-detail-container {
		padding: 4rem 1rem 1.5rem; /* 小屏内边距统一 */
	}

	.activity-title {
		font-size: 1.5rem; /* 小屏标题大小统一 */
		margin-bottom: 1rem;
	}

	.activity-meta {
		gap: 1rem;
		font-size: 0.875rem; /* 小屏字体统一 */
	}

	.activity-content {
		font-size: 0.9375rem; /* 小屏正文大小统一 */
		line-height: 1.7;
	}

	.activity-content p {
		text-indent: 1.5em; /* 小屏缩进统一 */
	}

	.attachment-list {
		gap: 1rem;
	}

	.activity-image {
		max-width: 100%;
		max-height: 300px; /* 小屏图片高度统一 */
	}

	.file-name {
		max-width: 150px;
	}
}
</style>