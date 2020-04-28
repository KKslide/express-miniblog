<template>
  <div id="app">
    <div id="site-border-left"></div>
    <div id="site-border-right"></div>
    <div id="site-border-top"></div>
    <div id="site-border-bottom"></div>
    <!-- 翻译悬浮按钮 -->
    <lang-com v-show="isShow"></lang-com>
    <el-scrollbar style="height:100%">
        <router-view></router-view>
    </el-scrollbar>
  </div>
</template>

<script>
import TranslationBar from './components/client/public/TranslateBar';
export default {
  name: 'App',
  components: {
    'lang-com': TranslationBar
  },
  data() { return { isShow: true } },
  watch: {
    '$route': function (nv, ov) {
      if (!nv || nv.name == 'login' || nv.path.indexOf('admin') > -1) {
        this.isShow = false
      } else {
        this.isShow = true
      }
    }
  }
}
</script>

<style lang="less" scoped>
</style>