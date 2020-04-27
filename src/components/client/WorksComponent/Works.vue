<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="section-container-spacer text-center">
              <h1 class="h2"  v-text="$t('navbar.Works')"><!-- WORKS --></h1>
              <div id="content">
                <div class="list">
                  <ul class="scroll_content">
                    <li style="border-top:none;font-weight:bold;">
                      <a href="javascript:;" v-text="$t('work.click')"><!-- 👇 Chcek Here 👇 --></a>
                    </li>
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/02-scroll-behavior/index.html"
                         v-text="$t('work.tit1')"
                      ><!-- scroll-behavior --></a>
                    </li>
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/03-css-change-color/index.html"
                        v-text="$t('work.tit2')"
                      ><!-- css-change-color --></a>
                    </li>
                    <!-- <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/04-css-nav-underline/index.html"
                      >css-nav-underline</a>
                    </li> -->
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/05-thanos-snap-effect/index.html"
                        v-text="$t('work.tit3')"
                      ><!-- thanos-snap-effect --></a>
                    </li>
                    <!-- <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/06-hover-effects/index.html"
                      >hover-effects</a>
                    </li> -->
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/07-light-effect/index.html"
                        v-text="$t('work.tit4')"
                      ><!-- light-effects --></a>
                    </li>
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/08-Glitch/index.html"
                        v-text="$t('work.tit5')"
                      ><!-- Glitch-effects --></a>
                    </li>
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/09-waterfall/index.html"
                        v-text="$t('work.tit6')"
                      ><!-- WaterFall-effects --></a>
                    </li>
                    <li>
                      <a
                        target="_blank"
                        href="https://kkslide.github.io/CSS-Collection.github.io/10-echarts-drill-down/index.html"
                        v-text="$t('work.tit7')"
                      ><!-- Map-Drill-Down --></a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <footer-com></footer-com>
  </div>
</template>

<script>
import Header from '../public/Header'
import Footer from '../public/Footer'
export default {
  components: {
    'header-com': Header,
    'footer-com': Footer
  },
}
</script>

<style lang="less" scoped>
#content {
  width: 100%;
  text-align: center;
  background: #fff;
  box-sizing: border-box;
  margin: 0 auto;

  .title {
    text-align: center;
    cursor: default;
    font-size: 20px;
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
  }

  .list {
    box-sizing: border-box;
    height: 100%;
    padding-top: 35px;
    overflow: hidden;

    ul {
      margin: 0 auto;
      list-style: none;
      overflow-y: hidden;
      padding: 0;

      li {
        border-top: 1px solid rgba(0, 0, 0, 0.36);
        transition: background-color 0.3s;
        height: 30px;
        line-height: 30px;

        a {
          font-family: sans-serif;
          font-size: 16px;
          text-decoration: none;
          display: inline-block;
          width: 100%;
          height: 100%;
          transition: font-size 0.3s;
          color: #404040;
        }
      }

      li:last-child {
        border-bottom: 1px solid rgba(0, 0, 0, 0.36);
      }

      li:hover {
        background-color: bisque;

        a {
          font-size: 18px;
        }
      }
    }
  }
}

@media screen and (min-width: 700px) {
  #content {
    padding: 0 200px;
  }
}
</style>