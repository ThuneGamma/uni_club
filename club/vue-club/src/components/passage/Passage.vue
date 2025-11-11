<template>
	<div v-if="passage != null" class="passage-container">
		<div class="header">
			<h1 class="title">{{ passage.title }}</h1>
			<div class="time-wrap">
				发布时间：
				<span class="time">{{ passage.publishTime }}</span>
			</div>
		</div>

		<!-- 关键修改：v-html 绑定处理后的富文本 -->
		<div v-html="processRichText(passage.content)" class="content"></div>

		<div class="file-list">
			<div v-for="file in fileList" :key="file.id" class="file-item">
				<img
					:src="'http://localhost:8013/fileServer' + file.filePath"
					class="show-image"
					:alt="file.fileName"
					v-if="isImage(file.fileName)"
				/>
				<a :href="'/fileServer' + file.filePath" v-else class="file-link">
					{{ file.fileName }}
				</a>
			</div>
		</div>

		<Share />
	</div>
</template>

<script>
import Share from '@/components/common/Share.vue';
const OK = 200;
export default {
	data() {
		return {
			passage: {},
			fileList: []
		};
	},
	components: { Share },
	methods: {
		get(id) {
			this.$axios.get('/api/passages/' + id).then(res => {
				if (res.data.code == OK) {
					this.passage = res.data.data;
					this.fileList = this.passage.fileList || []; // 增加空数组容错
				} else {
					this.$layer.alert(res.data.msg || '获取文章失败'); // 优化错误提示
				}
			}).catch(err => {
				this.$layer.alert('网络错误，请重试');
				console.error('文章请求失败：', err);
			});
		},
		isImage(fileName) {
			const ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
			return ['png', 'jpg', 'jpeg', 'gif'].includes(ext);
		},
		/**
		 * 动态处理富文本内容：给所有 img 标签追加强制样式
		 * @param {string} content - 原始富文本内容
		 * @returns {string} 处理后的富文本
		 */
		processRichText(content) {
			if (!content) return ''; // 容错：内容为空时返回空字符串
			
			// 正则匹配所有 img 标签（兼容带空格、换行的情况）
			// 匹配规则：<img 开头，后面跟任意字符（非>），最后以>结尾
			const imgReg = /<img([^>]*?)>/gi;
			
			// 替换逻辑：给每个 img 标签追加 style 和 class
			return content.replace(imgReg, (match) => {
				// 1. 定义强制控制图片尺寸的样式（核心）
				const forceStyle = 'max-width:100% !important;height:auto !important;display:block !important;margin:16px auto !important;max-height:800px !important;object-fit:contain !important;border-radius:4px !important;';
				
				// 2. 检查原有 img 标签是否已有 style 属性
				if (match.includes('style=')) {
					// 已有 style：在原有样式后追加（用 ; 分隔）
					return match.replace(/style="([^"]*)"/i, (styleMatch, oldStyle) => {
						return `style="${oldStyle};${forceStyle}"`;
					});
				} else {
					// 没有 style：直接添加 style 属性
					return match.replace('<img', `<img style="${forceStyle}"`);
				}
			});
		}
	},
	created() {
		this.get(this.$route.params.id);
	},
	watch: {
		$route() {
			this.get(this.$route.params.id);
		}
	}
};
</script>

<style scoped>
/* 全局字体设置 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
}

/* 保留原有的 .content img 样式（双重保障） */
.content img {
  max-width: 100% !important;
  height: auto !important;
  display: block !important;
  margin: 16px auto !important;
  border-radius: 4px !important;
}

.passage-container {
	max-width: 900px;
	margin: 40px auto;
	padding: 45px 50px;
	background-color: #fff;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
	border-radius: 12px;
}

.header {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: 12px;
	margin-bottom: 30px;
	border-bottom: 2px solid #9a0e14;
	padding-bottom: 16px;
}

.title {
	font-size: 32px;
	font-weight: 700;
	color: #2d3748;
	line-height: 1.3;
	letter-spacing: -0.5px;
}

.time-wrap {
	font-size: 14px;
	color: #718096;
	line-height: 1.5;
}

.time {
	font-weight: 500;
	color: #4a5568;
}

.content {
	line-height: 2.0;
	padding: 10px 0 30px;
	font-size: 18px;
	text-indent: 2em;
	text-align: justify;
	color: #343a40;
	letter-spacing: 0.3px;
}

/* 修复v-html内容的样式继承问题 */
.content * {
	font-size: inherit !important;
	line-height: inherit !important;
	color: inherit !important;
	letter-spacing: inherit !important;
}

.content p {
	margin-bottom: 1.2em !important;
}

.content strong {
	font-weight: 600 !important;
	color: #2d3748 !important;
}

.file-list {
	margin-top: 20px;
	padding-top: 20px;
	border-top: 1px solid #f0f0f0;
}

.file-item {
	margin-bottom: 22px;
	text-align: center;
}

.show-image {
  max-width: 100%;
  max-height: 600px;
  height: auto;
  width: auto;
  object-fit: contain;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
  transition: box-shadow 0.3s ease;
  margin: 0 auto 16px;
}

.show-image:hover {
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18);
}

.file-link {
	color: #9a0e14;
	font-weight: 500;
	text-decoration: none;
	font-size: 16px;
	line-height: 1.6;
	padding: 2px 4px;
	border-radius: 4px;
	transition: all 0.3s ease;
}

.file-link:hover {
	text-decoration: underline;
	background-color: #fef7f8;
	color: #7c0a10;
}

/* 响应式调整 */
@media (max-width: 768px) {
	.passage-container {
		padding: 30px 25px;
		margin: 20px auto;
	}

	.title {
		font-size: 28px;
	}

	.content {
		font-size: 17px;
		line-height: 1.9;
	}
}
</style>