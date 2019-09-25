<template>
  <div>
    <ul>
      <li @click="goto('home')">01: HOME</li>
      <li @click="goto('log')">02: LOG</li>
      <li @click="goto('about')">03: ABOUT</li>
      <li @click="goto('contact')">04: CONTACT</li>
    </ul>
  </div>
</template>

<script>
export default {
  methods: {
    goto(url) {
      // console.log(url);
      this.$router.push({ name: url })
      // this.$router.push('log')
    }
  }
}
</script>

<style lang="scss" scoped>
li {
  cursor: pointer;
}
</style>