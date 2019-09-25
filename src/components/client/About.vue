<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="section-container-spacer text-center">
              <h1 class="h2">About me</h1>
            </div>

            <div class="row">
              <div class="col-md-10 col-md-offset-1">
                <div class="row">
                  <div class="col-xs-12 col-md-6">
                    <h3>Front End Engineer</h3>
                    <p>
                      <!-- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas luctus at sem quis varius.
                      Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. 
                      Cras ultrices hendrerit nisl.-->
                      A Two years working experience front end programmer, I started to get into this industrial in about 5 years ago.
                      So we had a course called 'HTML & CSS Web Design' in college which made me very impressed,
                      I used to wonder how those amazing Web effects were made by codes, and I have to figure it out.
                      That`s the motivation that keeps me moving on.
                    </p>
                    <h3>My Hobbies</h3>
                    <p>
                      <!-- Duis aute irure dolor in reprehenderit in voluptate velit esse
                      cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
                      proident, sunt in culpa qui officia deserunt mollit anim id est laborum.-->
                      Besides Coding, Basketball and RollingSkate also fullfill my spare life.
                      I dreamed of being a big Star when I was a kid 🤣but I stop growing taller when I was 18.
                      So I started to try something else to see if I could get a little bit taller,
                      and I bought my first skating shoes , and that changed my whole life..
                    </p>
                    <h3>Next Movement</h3>
                    <p>
                      Keep trying and learing new things
                      <br />Keep challenge my limits and striving for excellence
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
import Header from './public/Header'
import Footer from "./public/Footer";
export default {
  components: {
    'header-com': Header,
    'footer-com': Footer
  }
}
</script>
