<template>
  <div>
    <nav-com></nav-com>
    <keep-alive>
        <router-view></router-view>
    </keep-alive>
  </div>
</template>

<script>
import NavComponent from './public/NavMenu'
import FooterComponent from './public/Footer'
// import UserComponent from './user/UserManage' // 用户管理模块
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