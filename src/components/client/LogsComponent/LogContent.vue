<template>
    <div>
        <header-com></header-com>
        <div class="section-container">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <img src="http://example.kkslide.fun/banner.jpg" class="img-responsive" alt />
                        <div class="card-container">
                            <div class="text-center">
                                <h1 class="h2" v-html="content.title"></h1>
                            </div>
                            <!-- <p v-html="content.description"></p> -->
                            <p>{{$t('logContent.author')}}: {{content.user.username}} | {{$t('logContent.view')}}: {{content.num}} | {{$t('logContent.comments')}}: {{content.comment.length}} | {{$t('logContent.time')}}: {{content.addtime | date}}</p>
                            <blockquote v-if="content.description_sub">
                                <p v-html="content.description_sub"></p>
                                <small class="pull-right" v-if="false">Irina Martin</small>
                            </blockquote>
                        </div>
                    </div>
                    <!-- 这里是正文了 -->
                    <div class="col-xs-12">
                        <article id="article" v-html="content.composition"></article>
                        <!-- <article id="article">{{content.composition}}</article> -->
                        <!-- <article id="article">
                        </article>-->
                        <!-- 视频播放 -->
                        <video-com
                            v-if="category=='Video'"
                            :videoSrc="videoSrc"
                            :posterSrc="posterSrc"
                        ></video-com>
                        <!-- 视频播放 -->
                    </div>
                    <!-- 这里是正文了 -->
                    <!-- 上一篇和下一篇 -->
                    <div class="col-xs-12 content_nav">
                        <router-link :to="{name:'logcontent',params:{contentid:changePage('prev')._id}}" @click.native="handleClick" class="pull-left" > <i class="el-icon-back">&nbsp;{{$t('logContent.prev')}}: </i> [{{changePage('prev').title}}] </router-link>
                        <router-link :to="{name:'logcontent',params:{contentid:changePage('next')._id}}" @click.native="handleClick" class="pull-right" > {{$t('logContent.next')}}: [{{changePage('next').title}}]  <i class="el-icon-right"></i> </router-link>
                    </div>
                    <!-- 分割线 -->
                    <div class="col-xs-12">
                        <hr class="line" />
                    </div>
                    <!-- 评论 -->
                    <div class="col-xs-12">
                        <div class="comment" v-if="false">
                            <form class="form-inline" @submit.prevent="dontSubmit">
                                <div class="form-group">
                                    <span class="input input--isao">
                                        <div class="textArea">
                                            <!-- 改用文本域 -->
                                            <textarea
                                                class="form-control input__field input__field--isao"
                                                rows="3"
                                                :placeholder="$t('logContent.commentPlaceHolder')"
                                                v-model="commentData.comment"
                                            >
                                            </textarea>
                                            <!-- 黑框修饰 -->
                                            <label class="input__label input__label--isao" for="input-38" >
                                                <span class="input__label-content input__label-content--isao" ></span>
                                            </label>
                                            <div class="box"></div>
                                        </div>

                                        <label for="visitorEmail">
                                            <!-- <span>Name</span> -->
                                            <span v-text="$t('logContent.name')"></span>
                                            <input
                                                type="text"
                                                class="form-control"
                                                id="visitorEmail"
                                                :placeholder="$t('logContent.namePlaceHolder')"
                                                v-model="commentData.visitor"
                                            />
                                        </label>

                                        <button type="submit" class="btn btn-default btn-lg" @click="submitComment" v-text="$t('logContent.sendButton')"></button>
                                    </span>
                                </div>
                            </form>
                            <hr />
                            <!-- 评论列表 -->
                            <ul class="media-list">
                                <li class="media" v-for="item in content.comment" :key="item.time">
                                    <div class="media-left" v-if="false">
                                        <!-- 头像 - 后面再做 -->
                                        <a href="javascript:;">
                                            <img
                                                class="media-object img-circle"
                                                src="../../../../static/skull.png"
                                                width="50"
                                            />
                                        </a>
                                    </div>
                                    <!-- 评论内容 -->
                                    <div class="media-body">
                                        <h4 class="media-heading" v-if="item.user" style="font-size:18px;" >
                                            {{item.user}} <span class="ip">|{{item.ip}}|</span> 🎈
                                        </h4>
                                        <h4 class="media-heading" v-else style="font-size:18px;" >somebody</h4>

                                        <p v-html="item.comment"></p>

                                        <div class="ds-comment-footer">
                                            <span
                                                class="ds-time"
                                                datetime="2016-01-28T20:13:29+08:00"
                                                :title="item.time | date"
                                            >{{item.time | date}}</span>&nbsp;
                                            <!-- 先隐藏掉 后面再做这个功能 -->
                                            <a v-if="false">
                                                <span
                                                    class="glyphicon glyphicon-comment"
                                                    aria-hidden="true"
                                                ></span> 回复
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
                                                            <span
                                                                class="glyphicon glyphicon-comment"
                                                                aria-hidden="true"
                                                            ></span> 回复
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
                                                            <span
                                                                class="glyphicon glyphicon-comment"
                                                                aria-hidden="true"
                                                            ></span> 回复
                                                        </a>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul> -->
                                    </div>
                                </li>
                                <hr />
                            </ul>
                            <!-- 评论列表 -->
                        </div>
                        <log-comment :commentDataProp="content.comment" @refresh="getContent"></log-comment>
                    </div>
                    <!-- 评论 -->
                </div>
            </div>
        </div>
        <footer-com></footer-com>
    </div>
</template>

<script>
import Header from '../public/Header'
import Footer from '../public/Footer'
import CommentCom from './comment/LogComment'
import VideoCom from './Video'
export default {
    components: {
        'header-com': Header,
        'footer-com': Footer,
        'video-com': VideoCom,
        'log-comment': CommentCom
    },
    data() {
        return {
            category: '',
            content: { user: { username: "" }, comment: [] }, // 文章内容
            // commentData: { // 评论列表
            //     comment: '',
            //     visitor: ''
            // },
            videoSrc: '', // 视频七牛云地址
            posterSrc: '', // 视频封面
            isError: false
        }
    },
    computed: {
        prevData: function () {
            let allArticles = JSON.parse(sessionStorage.getItem('allArticles')),
                curArticle = this.$route.params.contentid, prevArc;
            allArticles.forEach((v, i) => {
                if (v._id == curArticle) {
                    prevArc = (i - 1) < 0 ? allArticles[allArticles.length - 1] : allArticles[i - 1]
                }
            });
            return prevArc
        },
        nextData: function () {
            let allArticles = JSON.parse(sessionStorage.getItem('allArticles')),
                curArticle = this.$route.params.contentid, nextArc;
            allArticles.forEach((v, i) => {
                if (v._id == curArticle) {
                    nextArc = (i + 1) >= allArticles.length ? allArticles[0] : allArticles[i + 1]
                }
            });
            return nextArc
        }
    },
    beforeMount() {
        this.getContent()
    },
    mounted() {
    },
    methods: {
        // dontSubmit() { return false },
        getContent() { // 获取文章内容
            let id = this.$route.params.id,
                contentid = this.$route.params.contentid;
            this.$axios({
                url: '/index/getcontent',
                method: 'post',
                data: {
                    contentid: contentid
                }
            }).then(res => {
                if (res.status == 200) {
                    this.content = res.data; this.content.comment.reverse()
                    this.category = res.data.category.name
                    this.videoSrc = res.data.video_src
                    this.posterSrc = res.data.minpic_url
                }
            })
        },
        // submitComment() { // 提交评论
        //     if (!this.commentData.comment) { // 评论内容为空
        //         // this.$message({ type: "warning", message: "The comment can`t be blank" })
        //         this.$message({ type: "warning", message: this.$t('logContent.emptyCommentTip') })
        //         return false;
        //     }
        //     if (!this.commentData.visitor) { // 不留名
        //         this.$message({ type: "warning", message: this.$t('logContent.emptyVisitor') })
        //         return false;
        //     }
        //     this.commentData.contentid = this.content._id;
        //     this.$axios({
        //         url: '/index/comment',
        //         method: "post",
        //         data: this.commentData
        //     }).then(res => {
        //         if (res.data.code == 1) { // 评论成功提示
        //             this.$message({ type: "success", message: res.data.msg });
        //             this.commentData.comment = '';
        //             this.commentData.visitor = '';
        //         }
        //         this.getContent()
        //     })
        // },
        changePage(params) { // 后期再解决执行N次的问题
            let allArticles = JSON.parse(sessionStorage.getItem('allArticles')),
                    curArticle = this.$route.params.contentid, prevOrNextPage;
                allArticles.forEach((v, i) => {
                    if (v._id == curArticle) {
                        if (params == 'prev') {
                            prevOrNextPage = (i - 1) < 0 ? allArticles[allArticles.length - 1] : allArticles[i - 1]
                        }
                        else if (params == 'next') {
                            prevOrNextPage = (i + 1) >= allArticles.length ? allArticles[0] : allArticles[i + 1]
                        }
                    }
                });
                return prevOrNextPage;
        },
        handleClick(){ // 跳转其他篇时的 类型判断
            this.category = '';
        }
    },
    watch: {
        '$route': function (nv, ov) {
            this.getContent();
            window.scrollTo(0,0)
        }
    }
}
</script>

<style lang="less" scoped>
.card-container {
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.45) 5%, rgba(255, 255, 255, 0.75) 30%, #ffffff 60%);
    border-radius: 15px;
}
.content_nav {
    a {
        text-decoration: none;
        transition: background 0.3s, color 0.3s,color 0.3s, color 0.3s;
    }
    a:hover {
        background: rgb(54, 54, 54);
        color:aliceblue;
        cursor: pointer;
    }
}
</style>