<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <div class="section-container-spacer text-center">
              <h1 class="h2">Contact me</h1>
            </div>

            <div class="row">
              <div class="col-md-10 col-md-offset-1">
                <!-- 留言表单 -->
                <form action class="reveal-content" @submit.prevent="submit">
                  <div class="row">
                    <div class="col-md-7">
                      <div class="form-group">
                        <input
                          type="text"
                          class="form-control"
                          id="email"
                          placeholder="Email or name"
                          v-model="viewer"
                        />
                      </div>
                      <div class="form-group">
                        <input
                          type="text"
                          class="form-control"
                          id="subject"
                          placeholder="Subject"
                          v-model="subject"
                        />
                      </div>
                      <div class="form-group">
                        <textarea
                          class="form-control"
                          rows="5"
                          placeholder="Enter your message"
                          v-model="massage"
                        ></textarea>
                      </div>
                      <button type="submit" class="btn btn-default btn-lg">Send</button>
                    </div>
                    <div class="col-md-5 address-container">
                      <ul class="list-unstyled">
                        <li>
                          <span class="fa-icon">
                            <i class="fa fa-phone" aria-hidden="true"></i>
                          </span> +86 131 4335 2449
                        </li>
                        <li>
                          <span class="fa-icon">
                            <i class="fa fa-at" aria-hidden="true"></i>
                          </span> rollercompanion@163.com
                        </li>
                        <li>
                          <span class="fa-icon">
                            <i class="fa fa fa-map-marker" aria-hidden="true"></i>
                          </span> GuangZhou MingPu-Garden China
                        </li>
                      </ul>
                      <h3>Follow me on social networks</h3>
                      <a
                        href="https://www.facebook.com/profile.php?id=100025250295698"
                        title
                        class="fa-icon"
                      >
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
                <hr>
                <ul class="media-list">
                  <li class="media" v-for="(item,index) in totalData.slice(0,a)" :key="index">
                    <!-- 评论内容 -->
                    <div class="media-body">
                      <h4
                        class="media-heading"
                        v-if="item.viewer"
                        v-html="item.viewer+':'"
                        style="font-size:18px;"
                      ></h4>

                      <p v-text="item.massage"></p>

                      <div class="ds-comment-footer">
                        <span
                          class="ds-time"
                          datetime="2019-01-28T20:13:29+08:00"
                          :title="item.addtime | date"
                        >{{item.addtime | date}}</span>&nbsp;
                        <!-- 先隐藏掉 后面再做这个功能 -->
                        <a v-if="false">
                          <span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 回复
                        </a>
                      </div>
                      <hr />
                    </div>
                  </li>
                  <li>
                    <a href="javascript:;" v-if="a<totalData.length" @click="loadmore">loadmore</a>
                    <span v-else style="text-decoration:none;">there is no more</span>
                  </li>
                  <hr />
                </ul>
              </div>
              <!-- <div class="col-md-10  col-md-offset-1">
              </div> -->
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
  data() {
    return {
      viewer: '',
      subject: '',
      massage: '',
      a: 5, // 显示留言的数量
      totalData: [] // 留言的列表数据
    }
  },
  methods: {
    submit() { // 留言
      this.$axios({
        url: '/index/massage/add',
        method: 'post',
        data: {
          viewer: this.viewer,
          subject: this.subject,
          massage: this.massage
        }
      }).then(res => {
        if (res.data.code == 1) {
          this.$message({ type: 'success', message: res.data.msg });
        } else {
          this.$message({ type: 'warning', message: res.data.msg });
        }
        this.getData();
        $(".reveal-content")[0].reset(); // 我也不晓得为啥这个不成功
        this.resetForm();
      })
    },
    resetForm(){this.viewer='';this.subject='';this.massage='';},
    getData() { // 获取留言
      this.$axios({
        url: "/index/massage"
      }).then(res => {
        console.log(res);
        this.totalData = res.data
      })
    },
    loadmore() { // 加载更多
      this.a += 5;
    }
  },
  mounted(){
      this.getData()
  }
}
</script>
