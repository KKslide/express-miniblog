<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container">
        <div class="row">
          <div class="col-xs-12">
            <img src="../../assets/images/work001-01.jpg" class="img-responsive" alt />
            <div class="card-container">
              <div class="text-center">
                <h1 class="h2" v-html="content.title"></h1>
              </div>
              <!-- <p v-html="content.description"></p> -->
              <p>Author: {{content.user.username}} | View: {{content.num}} | Comments: {{content.comment.length}} | Time: {{content.addtime | date}}</p>
              <blockquote v-if="content.description_sub">
                <p v-html="content.description_sub"></p>
                <small class="pull-right" v-if="false">Irina Martin</small>
              </blockquote>
            </div>
          </div>
          <div class="col-md-8 col-md-offset-2 section-container-spacer" v-if="false">
            <div class="row">
              <div class="col-xs-12 col-md-6">
                <img src="../../assets/images/work001-02.jpg" class="img-responsive" alt />
                <p>Menphis skyline</p>
              </div>
              <div class="col-xs-12 col-md-6">
                <img src="../../assets/images/work001-03.jpg" class="img-responsive" alt />
                <p>Menphis skyline</p>
              </div>
            </div>
          </div>
          <!-- 这里是正文了 -->
          <div class="col-xs-12">
            <article id="article" v-html="content.composition"></article>
            <!-- <article id="article">{{content.composition}}</article> -->
            <!-- <article id="article">
				  <h1 class="ql-align-center">HAHAHA</h1><p class="ql-align-center"><strong>&nbsp;&nbsp;life isn`t about how to live through the storm but how to dance in the rain.</strong></p><p class="ql-align-center"><strong>---------------------------------------------------------------------------------------------------------------------------------------</strong></p><p class="ql-align-center"><br></p><p class="ql-align-center"><br></p><p class="ql-align-center"><br></p><p class="ql-align-center"><br></p><p class="ql-align-center"><br></p><p class="ql-align-center"><br></p><h1 class="ql-align-center"><span style="background-color: rgb(230, 0, 0); color: rgb(255, 255, 0);">I am bad, and that`s good,&nbsp;</span></h1><h1 class="ql-align-center"><span style="background-color: rgb(230, 0, 0); color: rgb(255, 255, 0);">I will never be good and that`s not bad,&nbsp;</span></h1><h1 class="ql-align-center"><span style="background-color: rgb(230, 0, 0); color: rgb(255, 255, 0);">there is no one I would rather be than me.</span></h1><p class="ql-align-center"><br></p><p class="ql-align-center"><img src="http://127.0.0.1/upload_83e39c8107f2a3b4b2b8fa006372cfb9"></p><p class="ql-align-center"><img src="http://127.0.0.1/upload_12a63371708bff71d9a564ac42848731"></p><p><br></p>
            </article>-->
          </div>
          <!-- 这里是正文了 -->
          <!-- 底部图片 -->
          <div class="col-xs-12" v-if="false">
            <img src="../../assets/images/work001-04.jpg" class="img-responsive" alt />
          </div>
          <!-- 底部图片 -->
          <div class="col-xs-12">
            <hr class="line" />
          </div>
          <!-- 评论 -->
          <div class="col-xs-12">
            <div class="comment">
              <form class="form-inline" @submit.prevent="dontSubmit">
                <div class="form-group">
                  <span class="input input--isao">
                    <!-- 改用文本域 -->
                    <textarea
                      class="form-control input__field input__field--isao"
                      rows="3"
                      placeholder="just say something"
                      v-model="commentData.comment"
                    ></textarea>
                    <!-- 黑框修饰 -->
                    <label class="input__label input__label--isao" for="input-38">
                      <span class="input__label-content input__label-content--isao"></span>
                    </label>

                    <label for="visitorEmail">Name</label>
                    <input
                      type="text"
                      class="form-control"
                      id="visitorEmail"
                      placeholder="Leave a name"
                      v-model="commentData.visitor"
                    />

                    <button type="submit" class="btn btn-default btn-lg" @click="submitComment">Send</button>
                  </span>
                </div>
              </form>
              <hr />
              <!-- 评论列表 -->
              <ul class="media-list">
                <li class="media" v-for="item in content.comment" :key="item.time">
                  <div class="media-left">
                    <!-- 头像 - 后面再做 -->
                    <a href="javascript:;">
                      <img
                        class="media-object img-circle"
                        src="../../../static/skull.png"
                        width="50"
                      />
                    </a>
                  </div>
                  <!-- 评论内容 -->
                  <div class="media-body">
                    <h4 class="media-heading" v-if="item.user" v-html="item.user"></h4>
                    <h4 class="media-heading" v-else>somebody</h4>

                    <p v-text="item.comment"></p>

                    <div class="ds-comment-footer">
                      <span
                        class="ds-time"
                        datetime="2016-01-28T20:13:29+08:00"
                        :title="item.time | date"
                      >{{item.time | date}}</span>&nbsp;
                      <!-- 先隐藏掉 后面再做这个功能 -->
                      <a v-if="false">
                        <span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 回复
                      </a>
                    </div>
                    <hr />
                    <!-- 这里是回复 - - 还不懂怎么做 -->
                    <!-- <ul class="media-list">
                      <li class="media">
                        <div class="media-left">
                          <a href="#">
                            <img
                              class="media-object img-circle"
                              src="../../assets/images/b.png"
                              alt="牛逼"
                            />
                          </a>
                        </div>
                        <div class="media-body">
                          <h4 class="media-heading">网名为空</h4>

                          <p>test. test. test. test. test. test. test. test.</p>

                          <div class="ds-comment-footer">
                            <span
                              class="ds-time"
                              datetime="2016-01-28T20:13:29+08:00"
                              title="2016年1月28日 下午8:13:29"
                            >2016年2月8日</span>&nbsp;
                            <a>
                              <span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 回复
                            </a>
                          </div>
                        </div>
                      </li>
                      <hr />
                      <li class="media">
                        <div class="media-left">
                          <a href="#">
                            <img
                              class="media-object img-circle"
                              src="../../assets/images/b.png"
                              alt="牛逼"
                            />
                          </a>
                        </div>
                        <div class="media-body">
                          <h4 class="media-heading">网名为空</h4>

                          <p>test. test. test. test. test. test. test. test.</p>

                          <div class="ds-comment-footer">
                            <span
                              class="ds-time"
                              datetime="2016-01-28T20:13:29+08:00"
                              title="2016年1月28日 下午8:13:29"
                            >2016年2月8日</span>&nbsp;
                            <a>
                              <span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 回复
                            </a>
                          </div>
                        </div>
                      </li>
                    </ul>-->
                  </div>
                </li>
                <hr />
              </ul>
              <!-- 评论列表 -->
            </div>
          </div>
          <!-- 评论 -->
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
      content: { user: { username: "" }, comment: [] },
      commentData: {
        comment: '',
        visitor: ''
      }
    }
  },
  beforeMount() {
    this.getContent()
  },
  methods: {
    dontSubmit() { return false },
    getContent() {
      let id = this.$route.params.id,
        contentid = this.$route.params.contentid;
      this.$axios({
        url: '/index/getcontent',
        method: 'post',
        data: {
          contentid: contentid
        }
      }).then(res => {
        if (res.status == 200) { this.content = res.data; this.content.comment.reverse() }
      })
    },
    submitComment() {
      if (!this.commentData.comment) {
        this.$message({ type: "warning", message: "The comment can`t be blank" })
        return false;
      }
      if ( !this.commentData.visitor) {
        this.$message({ type: "warning", message: "leave a name please~~~" })
        return false;
      }
      this.commentData.contentid = this.content._id;
      this.$axios({
        url: '/index/comment',
        method: "post",
        data: this.commentData
      }).then(res => {
        if (res.data.code == 1) {
          this.$message({ type: "success", msg: res.data.msg });
          this.commentData.comment = '';
          this.commentData.visitor = '';
        }
        this.getContent()
      })
    }
  },
  watch: {
    '$route': function (nv, ov) {
      this.getContent();
    }
  }
}
</script>

<style lang="less" scoped>
.ds-comment-footer {
  line-height: 1.5em;
}

/*.ds-comment-footer {*/
/*font-size: 12px;*/
/*color: #999;*/
/*}*/

h3 {
  border-bottom: 1px dotted #ccc;
  margin: 5px 0px;
  padding: 10px 0px;
  margin: 10px 0 30px;
}
p {
  margin: 0 0 10px;
}
.media-list a {
  text-decoration: none;
  color: #5f5f5f;
  cursor: pointer;
}
a:link {
  text-decoration: none;
}
a:visited {
  text-decoration: none;
}
a:hover {
  text-decoration: none;
  color: #e5e1ea;
}
a:active {
  text-decoration: none;
}

.input {
  position: relative;
  z-index: 1;
  display: inline-block;
  margin: 1em;
  width: calc(100% - 2em);
  vertical-align: top;
}

.input__field:focus {
  outline: none;
}

/* Isao */
.input__field {
  position: relative;
  display: block;
  //   float: right;
  padding: 0.8em;
  width: 60%;
  //   border: none;
  border-radius: 0;
  background: #f0f0f0;
  color: #aaa;
  font-weight: bold;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  -webkit-appearance: none; /* for box shadows to show on iOS */
}

.input__field--isao {
  z-index: 10;
  padding: 0.75em 0.2em 0.25em;
  width: 100%;
  background: transparent;
  color: #afb3b8;
}

.input__label--isao {
  position: relative;
  overflow: hidden;
  padding: 0;
  width: 100%;
  color: #dadada;
  text-align: left;
}

.input__label--isao::before {
  content: "";
  position: absolute;
  top: 0;
  width: 100%;
  height: 7px;
  background: #dadada;
  -webkit-transform: scale3d(1, 0.4, 1);
  transform: scale3d(1, 0.4, 1);
  -webkit-transform-origin: 50% 100%;
  transform-origin: 50% 100%;
  -webkit-transition: -webkit-transform 0.3s, background-color 0.3s;
  transition: transform 0.3s, background-color 0.3s;
  -webkit-transition-timing-function: cubic-bezier(0.2, 1, 0.3, 1);
  transition-timing-function: cubic-bezier(0.2, 1, 0.3, 1);
}

.input__label--isao::after {
  content: attr(data-content);
  position: absolute;
  top: 0;
  left: 0;
  padding: 0.75em 0.15em;
  //   color: #da7071; // 改为映衬一点的色调
  color: #333;
  opacity: 0;
  -webkit-transform: translate3d(0, 50%, 0);
  transform: translate3d(0, 50%, 0);
  -webkit-transition: opacity 0.3s, -webkit-transform 0.3s;
  transition: opacity 0.3s, transform 0.3s;
  -webkit-transition-timing-function: cubic-bezier(0.2, 1, 0.3, 1);
  transition-timing-function: cubic-bezier(0.2, 1, 0.3, 1);
  pointer-events: none;
}

.input__field--isao:focus + .input__label--isao::before {
  //   background-color: #da7071;
  background-color: #333;
  -webkit-transform: scale3d(1, 1, 1);
  transform: scale3d(1, 1, 1);
}

.input__field--isao:focus + .input__label--isao {
  pointer-events: none;
}

.input__field--isao:focus + .input__label--isao::after {
  opacity: 1;
  -webkit-transform: translate3d(0, 0, 0);
  transform: translate3d(0, 0, 0);
}

.input__label-content--isao {
  padding: 0.55em 0.15em;
  -webkit-transition: opacity 0.3s, -webkit-transform 0.3s;
  transition: opacity 0.3s, transform 0.3s;
  -webkit-transition-timing-function: cubic-bezier(0.2, 1, 0.3, 1);
  transition-timing-function: cubic-bezier(0.2, 1, 0.3, 1);
}

.input__field--isao:focus + .input__label--isao .input__label-content--isao {
  opacity: 0;
  -webkit-transform: translate3d(0, -50%, 0);
  transform: translate3d(0, -50%, 0);
}
// *****************************************************

.comment {
  .form-inline {
    .form-group {
      width: 100%;
    }
  }
}
</style>