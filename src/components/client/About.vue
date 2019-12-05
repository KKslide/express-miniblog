<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="section-container-spacer text-center">
              <!-- <h1 class="h2">About me</h1> -->
              <h1 class="h2" style="cursor:pointer" >{{$t("navbar.About")}}</h1>
            </div>

            <div class="row">
              <div class="col-md-10 col-md-offset-1">
                <div class="row">
                  <div class="col-xs-12 col-md-6">
                    <!-- <h3>Front End Engineer</h3> -->
                    <h3 v-text="$t('about.part1.title')"></h3>
                    <p v-text="$t('about.part1.content')">
                      <!-- A Two years working experience front end programmer, I started to get into this industrial in about 5 years ago.
                      So we had a course called 'HTML & CSS Web Design' in college which made me very impressed,
                      I used to wonder how those amazing Web effects were made by codes, and I have to figure it out.
                      That`s the motivation that keeps me moving on. -->
                    </p>
                    <h3 v-text="$t('about.part2.title')"><!-- My Hobbies --></h3>
                    <p v-text="$t('about.part2.‘content')">
                      <!-- Besides Coding, Basketball and RollingSkate also fullfill my spare life.
                      I dreamed of being a big Star when I was a kid 🤣but I stop growing taller when I was 18.
                      So I started to try something else to see if I could get a little bit taller,
                      and I bought my first skating shoes , and that changed my whole life.. -->
                    </p>
                    <h3 v-text="$t('about.part3.title')"><!-- Next Movement --></h3>
                    <p v-html="$t('about.part3.content')">
                      <!-- Keep trying and learing new things
                      <br />Keep challenge my limits and striving for excellence -->
                    </p>
                  </div>
                  <div class="col-xs-12 col-md-6">
                    <img src="../../assets/images/profil.jpg" class="img-responsive" alt />
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
import Header from './public/Header';
import Footer from "./public/Footer";
// import i18n, { setup } from "../../locales";
export default {
  components: {
    'header-com': Header,
    'footer-com': Footer
  },
  data() {
    return {
      msg: i18n.t('message.hello')
    }
  },
  methods: {
    switchLang() {
    //   localStorage.getItem('localeLanguage') == 'en' ? setup('zh') : setup('en');
    }
  }
}
</script>
