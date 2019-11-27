<template>
  <div>
    <!-- Header部分 -->
    <header-com></header-com>
    <!-- Header部分 -->
    <div class="hero-full-container background-image-container white-text-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="hero-full-wrapper">
              <div class="text-content">
                <h1>
                  <!-- {{Hello}}, -->
                  <span v-text="$t('homepage.part1')+','"></span>
                  <br />
                  <span id="typed-strings">
                    <!-- <span>I'm Lykang.</span> -->
                    <span  v-text="$t('homepage.part2')"></span>
                    <!-- <span>Web Designer</span> -->
                    <span v-text="$t('homepage.part3')"></span>
                    <!-- <span>Work in GuangZhou</span> -->
                    <span v-text="$t('homepage.part4')"></span>
                  </span>
                  <span id="typed"></span>
                </h1>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import Typed from 'typed.js'
import Header from './public/Header'
export default {
  components: {
    'header-com': Header
  },
  methods: {
    type(strings) {
      var typed = new Typed('#typed', {
        stringsElement: '#typed-strings',
        typeSpeed: 100,
        backSpeed: 20,
        loop: true,
        loopCount: Infinity
      });
    },
    movingBackgroundImage() {
      var bg = document.querySelector('.hero-full-container');
      var windowWidth = window.innerWidth / 5;
      var windowHeight = window.innerHeight / 5;
      bg.addEventListener('mousemove', (e) => {
        var mouseX = e.clientX / windowWidth;
        var mouseY = e.clientY / windowHeight;
        bg.style.transform = `translate3d(-${mouseX * 1.5}px, -${mouseY * 1.5}px, 0)`;
      });
    }
  },
  beforeCreate() {
    $("body")[0].className = 'minimal'
  },
  beforeDestroy() {
    document.body.removeAttribute("class", "nimimal")
  },
  mounted() {
    this.type()
    this.movingBackgroundImage()
  }
}
</script>

<style lang="less" scoped>
.hero-full-container {
  background-image: url("http://example.kkslide.fun/space.jpg");
}
.text-content {
  h1 {
    word-wrap: break-word;
    word-break: break-all;
  }
}
</style>