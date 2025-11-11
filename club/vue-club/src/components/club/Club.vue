<template>
	<div class="club-detail-container" v-if="club != null">
		<span class="club-title">{{ club.name }}</span>
		<div v-html="club.introduce" class="club-content"></div>
	</div>
</template>

<script>
const OK = 200;
export default {
	data() {
		return {
			club: {}
		};
	},
	methods: {
		get: function() {
			var num = this.$route.params.num;
			this.$axios.get('/api/clubs/' + num).then(res => {
				console.log(res.data);
				if (res.data.code == OK) {
					this.club = res.data.data;
				} else {
					this.$layer.alert(res.data.data);
				}
			});
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
/* 容器样式 - 重点添加顶部内边距避开header */
.club-detail-container {
	max-width: 1200px;
	margin: 0 auto;
	/* 顶部内边距增加到80px（适配常见header高度），保留原有上下内边距逻辑 */
	padding: 5rem 1.5rem 2rem; /* 上：80px 右左：24px 下：32px */
	line-height: 1.5;
}

/* 标题样式 */
.club-title {
	display: block;
	font-size: 1.875rem; /* 30px */
	font-weight: 600;
	color: #1f2937;
	margin-bottom: 1.25rem;
	border-bottom: 2px solid #e5e7eb;
	padding-bottom: 0.75rem;
}

/* 内容区域样式 - 新增 text-align: left 强制居左 */
.club-content {
	font-size: 1rem; /* 16px */
	color: #374151;
	line-height: 1.8;
	text-align: left !important; /* 强制文字居左，覆盖富文本自带对齐样式 */
}

/* 内容区域嵌套元素样式 - 继承居左对齐，确保所有子元素（p/div/h 等）都居左 */
.club-content * {
	text-align: inherit !important; /* 继承父元素的居左对齐 */
	font-size: inherit !important;
	line-height: inherit !important;
	color: inherit !important;
}

.club-content h1,
.club-content h2,
.club-content h3 {
	color: #1f2937;
	font-weight: 600;
	margin: 1.5rem 0 0.75rem;
}

.club-content h1 {
	font-size: 1.5rem;
}

.club-content h2 {
	font-size: 1.25rem;
}

.club-content h3 {
	font-size: 1.125rem;
}

.club-content ul,
.club-content ol {
	margin: 0 0 1rem 1.5rem;
	padding-left: 0.75rem;
}

.club-content li {
	margin-bottom: 0.5rem;
}

/* 响应式适配 - 同步调整顶部内边距 */
@media (max-width: 768px) {
	.club-detail-container {
		/* 小屏幕header高度通常更小，顶部内边距调整为4rem（64px） */
		padding: 4rem 1rem 1.5rem;
	}

	.club-title {
		font-size: 1.5rem;
		margin-bottom: 1rem;
	}

	.club-content {
		font-size: 0.9375rem;
		line-height: 1.7;
	}
}

/* 若header是固定定位（fixed），可添加以下备选方案（按需启用） */
/* 
.club-detail-container {
	position: relative;
	top: 0;
	// 若80px仍被挡，可调整为100px（header高度+10px冗余）
	padding-top: 6.25rem; 
}
*/
</style>