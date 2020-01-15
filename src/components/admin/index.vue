<template>
  <div>
    <nav-com></nav-com>
    <!-- <h3 v-if="this.$route.name=='admin'" style="text-indent:2em;">这里啥都没有,先去逛逛别的页面吧... - -||</h3> -->
    <router-view></router-view>
    <!-- <footer-com></footer-com> -->
  </div>
</template>

<script>
import NavComponent from './public/NavMenu'
import FooterComponent from './public/Footer'
import UserComponent from './user/UserManage' // 用户管理模块
export default {
  data() {
    return {
        
    }
  },
  components: {
    'nav-com': NavComponent,
    'footer-com': FooterComponent,
  }
}
</script>

<style lang="less" scoped>
h1 {
  color: yellow;
  background: #000;
}
</style>