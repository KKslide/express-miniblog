<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="section-container-spacer text-center">
              <h1 class="h2"> Contact me </h1>
            </div>

            <div class="row">
              <div class="col-md-10 col-md-offset-1">
                <form action class="reveal-content" @submit.prevent="submit">
                  <div class="row">
                    <div class="col-md-7">
                      <div class="form-group">
                        <input type="email" class="form-control" id="email" placeholder="Email" />
                      </div>
                      <div class="form-group">
                        <input type="text" class="form-control" id="subject" placeholder="Subject" />
                      </div>
                      <div class="form-group">
                        <textarea class="form-control" rows="5" placeholder="Enter your message"></textarea>
                      </div>
                      <button type="submit" class="btn btn-default btn-lg">Send</button>
                    </div>
                    <div class="col-md-5 address-container">
                      <ul class="list-unstyled">
                        <li>
                          <span class="fa-icon">
                            <i class="fa fa-phone" aria-hidden="true"></i>
                          </span>
                          +86 131 4335 2449
                        </li>
                        <li>
                          <span class="fa-icon">
                            <i class="fa fa-at" aria-hidden="true"></i>
                          </span>
                          rollercompanion@163.com
                        </li>
                        <li>
                          <span class="fa-icon">
                            <i class="fa fa fa-map-marker" aria-hidden="true"></i>
                          </span>
                          GuangZhou MingPu-Garden China
                        </li>
                      </ul>
                      <h3>Follow me on social networks</h3>
                      <a href="https://www.facebook.com/profile.php?id=100025250295698" title class="fa-icon">
                        <i class="fa fa-facebook"></i>
                      </a>
                      <a href="https://twitter.com/KK_slide" title class="fa-icon">
                        <i class="fa fa-twitter"></i>
                      </a>
                      <a href="https://www.instagram.com/kangkang1105_/" title class="fa-icon">
                        <i class="fa fa-instagram"></i>
                      </a>
                      <a href="https://weibo.com/kkslide" title class="fa-icon">
                        <i class="fa fa-weibo"></i>
                      </a>
                    </div>
                  </div>
                </form>
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
import Header from './public/Header'
import Footer from "./public/Footer";
export default {
  components: {
    'header-com': Header,
    'footer-com': Footer
  },
  methods:{
      submit(){
          this.$message({
              type:"warning",
              message:"T_T, it`s not ready yet..."
          })
          return false
      }
  }
}
</script>
