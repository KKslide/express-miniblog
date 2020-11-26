<template>
  <div id="Editor"></div>
</template>

<script>
export default {
  mounted() {
    const editor = new wangEditor("#Editor");
    editor.highlight = hljs; // 代码高亮
    Object.assign(editor.config, {
      showFullScreen: true, // 是否显示全屏按钮
      uploadImgServer:"/pic/img_upload",
      linkImgCallback:this.internetPic, // 上传网络图片回调
      uploadImgMaxSize : 2 * 1024 * 1024 // 限制上传图片大小为 2M
    });
    console.log(editor.config);
    editor.create();
  },
  methods:{
      internetPic(src){
          console.log(src);
      }
  }
};
</script>

<style lang="scss" scoped>
#Editor {
  width: 100%;
  height: 100vh;
  padding: 10px;
}
</style>