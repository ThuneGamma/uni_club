<template>
  <el-carousel indicator-position="outside" height="400px">
    <el-carousel-item v-for="carousel in carouselImg" :key="carousel.id">
      <router-link :to="{ name: 'Passage', params: { id: carousel.passageId } }">
        <div class="slider-container">
          <img
            :src="'http://localhost:8013/fileServer/' + carousel.filePath"
            alt="carousel.fileName"
            class="slider-img"
          />
          <div class="slider-info">
            <span class="slider-title">{{ carousel.title }}</span>
            <span class="slider-time">{{ carousel.createTime }}</span>
          </div>
        </div>
      </router-link>
    </el-carousel-item>
  </el-carousel>
</template>

<script>
const OK = 200;
export default {
  data() {
    return {
      carouselImg: []
    };
  },
  methods: {
    getCarouselList(typeId, pageSize) {
      console.log('=== 轮播图接口开始调用 ===');
      console.log('调用参数：', { fileTypeId: typeId, pageNum: 1, pageSize: pageSize });
      
      this.$axios
        .get("/api/files", {
          params: {
            fileTypeId: typeId,
            pageNum: 1,
            pageSize: pageSize
          }
        })
        .then(res => {
          console.log('=== 接口返回结果 ===');
          console.log('完整返回数据：', res.data); // 打印接口全部返回
          console.log('返回状态码：', res.data.code);
          console.log('返回数据列表：', res.data.data.list); // 查看是否有轮播图数据
          
          if (res.data.code == OK) {
            this.carouselImg = res.data.data.list || [];
            console.log('=== 赋值后的数据 ===');
            console.log('carouselImg数组：', this.carouselImg);
            
            // 打印每个元素的字段和拼接后的图片路径
            this.carouselImg.forEach((item, index) => {
              console.log(`第${index+1}张轮播图：`);
              console.log('  字段结构：', item); // 查看是否有filePath等字段
              console.log('  拼接后图片路径：', `http://localhost:8013/fileServer/${item.filePath}`);
            });
          } else {
            this.$layer.alert(`接口错误：${res.data.data || '未知错误'}`);
            console.error('接口调用失败：', res.data.data);
          }
        })
        .catch(err => {
          // 捕获接口请求失败（如地址错误、网络问题）
          console.error('=== 接口请求异常 ===');
          console.error('错误信息：', err);
          this.$layer.alert('接口请求失败，请检查网络或接口地址');
        });
    },
    refreshPasagePage() {
      this.getCarouselList(4, 6);
    }
  },
  created() {
    console.log('=== 组件创建，开始调用轮播图接口 ===');
    this.getCarouselList(4, 6);
  }
};
</script>

<style scoped>
.slider-container {
  position: relative;
  width: 100%;
  height: 400px;
  overflow: hidden;
}

.slider-img {
  cursor: pointer;
  width: 100%;
  height: 100%;
  object-fit: cover; /* 防止拉伸 */
  display: block;
}

/* 标题和时间信息条 */
.slider-info {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between; /* 左右对齐 */
  align-items: center;
  padding: 8px 16px;
  background: rgba(0, 0, 0, 0.4);
  color: #fff;
  font-size: 16px;
}

.slider-title {
  text-align: left;
  font-weight: 600;
}

.slider-time {
  text-align: right;
  font-size: 14px;
  opacity: 0.8;
}
</style>
