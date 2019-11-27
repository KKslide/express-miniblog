<template>
  <div id="app">
    <div id="site-border-left"></div>
    <div id="site-border-right"></div>
    <div id="site-border-top"></div>
    <div id="site-border-bottom"></div>
    <!-- 悬浮球 -->
    <float-ball></float-ball>
    <router-view />
  </div>
</template>

<script>
import FloatBall from './components/client/public/Setting';
export default {
  name: 'App',
  components: {
    'float-ball': FloatBall
  },
  // beforeCreate() {
  //   this.$axios({
  //     url: '/index/getpage',
  //     method: 'get'
  //   }).then(res => {
  //     console.log(res);
  //   })
  // }
}
</script>