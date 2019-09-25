<template>
  <div id="app">
    <div id="site-border-left"></div>
    <div id="site-border-right"></div>
    <div id="site-border-top"></div>
    <div id="site-border-bottom"></div>
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App',
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