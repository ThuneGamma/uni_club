<template>
	<div class="home-main-container">
		<!-- 轮播图（添加容器控制图片大小） -->
		<div class="slider-container">
			<Slider />
		</div>
		
		<!-- 新闻/公告双列模块 -->
		<el-row :gutter="60" class="news-row">
			<el-col :span="12" :xs="24" class="news-col">
				<div class="news-module" v-if="topNoticesVo != null">
					<div class="news-title-bar" v-if="topNoticesVo.passageType != null">
						<span class="news-title">{{ topNoticesVo.passageType.type }}</span>
						<router-link 
							:to="{ name: 'PassageList', query: { passageTypeId: 1 } }" 
							class="more-link" 
							tag="span"
						>更多>></router-link>
					</div>
					<ul class="news-list">
						<li v-for="notice in topNoticesVo.passageList" :key="notice.id" class="news-list-item">
							<div class="news-item-content">
								<router-link 
									:to="{ name: 'Passage', params: { id: notice.id } }" 
									tag="a" 
									class="news-link"
								>
									{{ notice.title }}
								</router-link>
								<span class="news-time">{{ notice.publishTime }}</span>
							</div>
						</li>
					</ul>
				</div>
			</el-col>

			<el-col :span="12" :xs="24" class="news-col">
				<div class="news-module" v-if="topNewsListVo != null">
					<div class="news-title-bar" v-if="topNewsListVo.passageType != null">
						<span class="news-title">{{ topNewsListVo.passageType.type }}</span>
						<router-link 
							:to="{ name: 'PassageList', query: { passageTypeId: 2 } }" 
							class="more-link" 
							tag="span"
						>更多>></router-link>
					</div>
					<ul class="news-list">
						<li v-for="news in topNewsListVo.passageList" :key="news.id" class="news-list-item">
							<div class="news-item-content">
								<router-link 
									:to="{ name: 'Passage', params: { id: news.id } }" 
									class="news-link"
								>
									{{ news.title }}
								</router-link>
								<span class="news-time">{{ news.publishTime }}</span>
							</div>
						</li>
					</ul>
				</div>
			</el-col>
		</el-row>
	</div>
</template>

<script>
const OK = 200;
import Slider from '@/components/common/Slider';
// 移除视展青春相关组件引入
// import IndexHotActivities from '@/components/home/IndexHotActivities';

export default {
	data() {
		return {
			topNoticesVo: {},
			topNewsListVo: {},
			topActivityVo: {},
			activityList: []
		};
	},
	components: {
		Slider,
		// 移除组件注册
		// IndexHotActivities
	},
	methods: {
		getTopNotices(typeId, n) {
			this.$axios
				.get('/api/passages/top/' + n, { params: { passageTypeId: typeId } })
				.then(res => {
					if (res.data.code == OK) this.topNoticesVo = res.data.data;
					else this.$layer.alert('error');
				});
		},
		getTopNewsList(typeId, n) {
			this.$axios
				.get('/api/passages/top/' + n, { params: { passageTypeId: typeId } })
				.then(res => {
					if (res.data.code == OK) this.topNewsListVo = res.data.data;
					else this.$layer.alert('error');
				});
		},
		// 移除视展青春相关接口调用
		// getTopActivityList(typeId, n) {
		// 	this.$axios
		// 		.get('/api/activities', { params: { activityTypeId: typeId, pageNum: 1, pageSize: n } })
		// 		.then(res => {
		// 			if (res.data.code == OK) {
		// 				this.topActivityVo = res.data.data;
		// 				this.activityList = this.topActivityVo.activityList;
		// 			} else {
		// 				this.$layer.alert('error');
		// 			}
		// 		});
		// }
	},
	created() {
		this.getTopNotices(1, 6);
		this.getTopNewsList(2, 6);
		// 移除接口调用
		// this.getTopActivityList(2, 4);
	}
};
</script>

<style scoped>
/* 整体容器 - 统一间距和布局 */
.home-main-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 1.5rem 1rem;
}

/* 轮播图容器 - 缩小图片尺寸（关键修改） */
.slider-container {
	max-width: 900px; /* 限制轮播图最大宽度，间接缩小图片 */
	margin: 0 auto; /* 轮播图居中 */
}
/* 穿透Slider组件，直接控制图片大小（确保图片缩小不拉伸） */
.slider-container ::v-deep img {
	max-width: 100%;
	max-height: 350px; /* 限制最大高度，实现图片缩小 */
	width: auto;
	height: auto;
	object-fit: cover;
	border-radius: 8px; /* 保持圆角一致性 */
}

/* 新闻双列布局 */
.news-row {
	margin: 1.5rem 0;
}

.news-col {
	background-color: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	padding: 0 !important; /* 清除el-col默认内边距，统一由模块控制 */
}

/* 新闻模块容器 */
.news-module {
	padding: 0 1.5rem 1.5rem;
}

/* 标题栏 - 椭圆颜色改为 #9a0e14（关键修改） */
.news-title-bar {
	background-color: #9a0e14; /* 替换原 #9a0e14 */
	border-radius: 8px 8px 0 0;
	height: 40px;
	line-height: 40px;
	padding: 0 1.5rem;
	margin: 0 -1.5rem; /* 与模块内边距抵消，实现通栏效果 */
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.news-title {
	color: #fff;
	font-family: '微软雅黑';
	font-weight: 600;
	font-size: 18px;
}

.more-link {
	color: #fff;
	font-size: 16px;
	cursor: pointer;
	transition: opacity 0.3s;
}

.more-link:hover {
	opacity: 0.8;
}

/* 新闻列表 - 与其他列表页统一风格 */
.news-list {
	list-style: none;
	padding: 0;
	margin: 0;
	margin-top: 1rem;
}

.news-list-item {
	padding: 0.75rem 0;
	border-bottom: 1px solid #f0f0f0;
	transition: background-color 0.3s;
}

.news-list-item:last-child {
	border-bottom: none;
}

.news-list-item:hover {
	background-color: #fafafa;
}

.news-item-content {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.news-link {
	flex: 1;
	color: #333;
	text-decoration: none;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	font-size: 16px;
	transition: color 0.3s;
}

/* 链接hover颜色同步改为 #9a0e14（关键修改） */
.news-link:hover {
	color: #9a0e14; /* 替换原 #9a0e14 */
	text-decoration: underline;
}

.news-time {
	flex-shrink: 0;
	color: #999;
	font-size: 14px;
	margin-left: 1rem;
	text-align: right;
}

/* 响应式适配 - 同步调整 */
@media screen and (max-width: 768px) {
	/* 整体容器内边距调整 */
	.home-main-container {
		padding: 1rem 0.5rem;
	}

	/* 轮播图小屏适配 */
	.slider-container {
		max-width: 100%;
	}
	.slider-container ::v-deep img {
		max-height: 250px; /* 小屏进一步缩小图片 */
	}

	/* 双列变单列，增加模块间距 */
	.news-row {
		gutter: 20;
		margin: 1rem 0;
	}

	.news-col {
		margin-bottom: 1.5rem !important;
	}

	/* 标题栏文字大小调整 */
	.news-title {
		font-size: 16px;
	}

	.more-link {
		font-size: 14px;
	}

	/* 新闻列表样式调整 */
	.news-module {
		padding: 0 1rem 1rem;
	}

	.news-title-bar {
		padding: 0 1rem;
		margin: 0 -1rem;
	}

	.news-link {
		font-size: 15px;
	}

	.news-time {
		font-size: 13px;
		margin-left: 0.5rem;
	}
}

</style>