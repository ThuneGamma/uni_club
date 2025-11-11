<template>
	<div class="footer-wrap">
		<div class="footer">
			<p class="introduce">欢迎访问武汉大学社团管理系统</p>
		</div>
	</div>
</template>

<script>
export default {

}
</script>

<style scoped>
/* 页脚容器：背景图拼接填充 + 固定底部 */
.footer-wrap {
  /* 替换纯色背景为 header.png 拼接，同路径直接引用 */
  background-image: url('bkgd.png');
  background-repeat: repeat; /* 关键：图片横向+纵向拼接填充 */
  background-size: auto 100%; /* 图片高度适配页脚，宽度自动，保证拼接自然 */
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  height: 70px;
}

/* 内容容器：居中 + 高度继承 */
.footer-wrap .footer {
  width: 1024px;
  margin: 0 auto;
  height: 100%;
  display: flex; /* 辅助文字垂直居中 */
  align-items: center;
  justify-content: center;
}

/* 文字样式：优化可读性（适配背景图） */
.introduce {
  margin: 0;
  color: #fff; /* 白色文字，避免与背景图冲突 */
  font-size: 16px;
  font-weight: 500;
  text-shadow: 0 1px 2px rgba(0,0,0,0.3); /* 文字阴影，提升辨识度 */
}

/* 响应式适配：小屏幕调整 */
@media screen and (max-width: 600px) {
  .footer-wrap {
    padding: 0 15px;
  }
  .footer-wrap .footer {
    width: 100%;
  }
  .introduce {
    font-size: 14px;
    text-align: center;
  }
}
</style>