<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-sm-8 col-sm-offset-2 section-container-spacer">
            <div class="text-center">
              <!-- <h1 class="h2">Logs</h1> -->
              <h1 class="h2" v-text="$t('navbar.Logs')"></h1>
              <!-- <p>So many ways to record life, I prefer to do it in my own way, Welcome to my life😎</p> -->
              <p v-text="$t('message.logs')"></p>
            </div>
          </div>
          <div class="col-md-12">
            <div id="myCarousel" class="carousel slide projects-carousel">
              <!-- Carousel items -->
              <div class="carousel-inner">
                <div
                  v-for="(item,index) in articles"
                  :key="index"
                  :class="{'item':true,'active':index==0?true:false}"
                >
                  <div class="row">
                    <div class="col-sm-4" v-for="(sub_item,sub_index) in item" :key="sub_index">
                      <a href="javascript:;" title class="black-image-project-hover">
                        <img
                          :src="sub_item.minpic_url"
                          class="img-responsive"
                          :onerror="defaultImg"
                          :data-index="index==0?(sub_index+1):(sub_index+1+item.length)"
                          @click="goto(sub_item,$event)"
                        />
                      </a>
                      <div class="card-container card-container-lg">
                        <!-- <h4>00{{sub_index+1}}/006</h4> -->
                        <h4>{{index==0?'00'+(sub_index+1):'00'+(sub_index+1+item.length)}}/00{{origenArticles.length}}</h4>
                        <h3 v-html="sub_item.title"></h3>
                        <p v-html="sub_item.description"></p>
                        <a
                          href="javascript:;"
                          title
                          class="btn btn-default"
                          :data-index="index==0?(sub_index+1):(sub_index+1+item.length)"
                          @click="goto(sub_item,$event)"
                        >Check</a>
                      </div>
                    </div>
                  </div>
                  <!--/row-->
                </div>
              </div>
              <!--/carousel-inner-->
              <a class="left carousel-control" href="#myCarousel" data-slide="prev"><</a>

              <a class="right carousel-control" href="#myCarousel" data-slide="next">></a>
            </div>

            <!--/myCarousel-->
          </div>
        </div>
      </div>
    </div>
    <footer-com></footer-com>
  </div>
</template>

<script>
import Header from './public/Header'
import Footer from './public/Footer'
export default {
  components: {
    'header-com': Header,
    'footer-com': Footer
  },
  data() {
    return {
      defaultImg: 'this.src="' + require('../../assets/images/space.jpg') + '"',
      origenArticles: [],
      articles: []
    }
  },
  methods: {
    goto(sub_item, event) {
      this.$router.push({ name: 'logcontent', params: { id: Number(event.target.getAttribute('data-index')) - 1, contentid: sub_item._id } })
    },
    getArticles() {
      this.$axios({
        url: '/index/getpage',
        method: 'get'
      }).then(res => {
        if (res.status == 200) {
          this.origenArticles = res.data;
          sessionStorage.setItem('allArticles', JSON.stringify(res.data));
          let splitArticleArr = [];
          for (var i = 0; i < res.data.length; i += 3) {
            splitArticleArr.push(res.data.slice(i, i + 3));
          }
          this.articles = splitArticleArr;
        }
      })
    },
  },
  created() {
    this.getArticles()
  },
  mounted() {
  }
}
</script>
<style lang="less" scoped>
.error-img {
  src: url("../../assets/images/space.jpg");
}
</style>