<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="section-container-spacer text-center">
              <!-- <h1 class="h2">About me</h1> -->
              <h1 class="h2" style="cursor:pointer">{{$t("navbar.About")}}</h1>
            </div>

            <div class="row">
              <div class="col-md-10 col-md-offset-1">
                <div class="row">
                  <div class="col-xs-12 col-md-6">
                    <!-- <h3>Front End Engineer</h3> -->
                    <h3 v-text="$t('about.part1.title')"></h3>
                    <p v-text="$t('about.part1.content')">
                      <!-- <p> -->
                      <!-- I`m A Two-year working experience front end engineer, I started to get into this industrial in 2013. So then we had a course - 'HTML & CSS Web Design' during college which impressed me, that was so coool and so amazing!!! It turned out I was a visual effects lover. So I tried hard to teach myself html and css and catch up with JavaScript. I want to be a UI designer and front end engineer. That`s the motivation that keeps me moving on. -->
                    </p>
                    <h3 v-text="$t('about.part2.title')">
                      <!-- My Hobbies -->
                    </h3>
                    <p v-text="$t('about.part2.‘content')">
                      <!-- <p>
                      Besides Coding, Basketball and RollingSkate fullfill my spare time.
                      I dreamed of being a big Star when I was a kid 🤣but I stop growing taller when I was 18.
                      So I started to try something else to see if I could get a little bit taller,
                      and I bought myself a pair of skating shoes, and that changed my whole life..
                      </p>-->
                    </p>
                    <h3 v-text="$t('about.part3.title')">Next Movement</h3>
                    <p v-html="$t('about.part3.content')"></p>
                    <!-- <h3>Next Goal</h3>
                    <p>
                      Keep trying and learing new things
                      <br />Keep challenge my limits and striving for excellence
                    </p>-->
                  </div>
                  <div class="col-xs-12 col-md-6">
                    <div id="profil_img">
                      <img src="../../../assets/images/pic_loading.jpg" class="img-responsive loading">
                      <img src="../../../assets/images/profil.jpg" class="img-responsive old" alt />
                      <img src="../../../assets/images/profil.edit.jpg" class="img-responsive young" alt />
                    </div>
                  </div>
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
import Header from "../public/Header";
import Footer from "../public/Footer";
// import i18n, { setup } from "../../locales";
export default {
  components: {
    "header-com": Header,
    "footer-com": Footer
  },
  data() {
    return {
      msg: i18n.t("message.hello")
    };
  },
  methods: {
    switchLang() {
      //   localStorage.getItem('localeLanguage') == 'en' ? setup('zh') : setup('en');
    }
  }
};
</script>
<style lang="less" scope>
#profil_img {
  position: relative;
  img {
	position: absolute;
	z-index: 99;
  }
  img.loading:first-child{
	  position: unset;
  }
  img.old{
	  z-index: 98;
	  transition: opacity .3s;
  }
  img.old:hover{
	  opacity: 0;
  }
  img.young{
	  z-index: 97;
  }
  img:not(.loading){
	  top:0;
  }
}
</style>