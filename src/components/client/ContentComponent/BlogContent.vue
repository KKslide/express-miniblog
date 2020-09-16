<template>
    <div>
        <header-com></header-com>
        <div class="section-container" id="blog_content">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <img :src="banner" class="img-responsive" alt />
                        <div class="card-container">
                            <div class="text-center">
                                <h1 class="h2" v-html="content.title"></h1>
                            </div>
                            <!-- <p v-html="content.description"></p> -->
                            <!-- <p class="blog_info">{{$t('logContent.author')}}: {{content.user.username}} | {{$t('logContent.view')}}: {{content.num}} | {{$t('logContent.comments')}}: {{content.comment.length}} | {{$t('logContent.time')}}: {{content.addtime | date}}</p> -->
                            <p class="blog_info">
                                <!-- <i class="fa fa-user-o"></i>
                                {{content.user.username}} | -->
                                <i class="fa fa-eye"></i>
                                {{content.viewnum}} |
                                <i class="fa fa-comment-o"></i>
                                {{content.comment.length}} |
                                <i class="fa fa-tag"></i>
                                {{content.category}} |
                                <i class="fa fa-clock-o"></i>
                                {{content.addtime | date}} 
                            </p>
                            <blockquote v-if="content.description_sub">
                                <p v-html="content.description_sub"></p>
                                <small class="pull-right" v-if="false">Irina Martin</small>
                            </blockquote>
                        </div>
                    </div>
                    <!-- 这里是正文了 -->
                    <div class="col-xs-12">
                        <article id="article" class="ql-editor" v-html="content.composition"></article>
                        <!-- <article id="article">{{content.composition}}</article> -->
                        <!-- <article id="article">
                        </article>-->
                        <!-- 视频播放 -->
                        <video-com
                            v-if="content.category=='Vlog'"
                            :videoSrc="videoSrc"
                            :posterSrc="posterSrc"
                        ></video-com>
                        <!-- 视频播放 -->
                    </div>
                    <!-- 这里是正文了 -->
                    <!-- 上一篇和下一篇 -->
                    <div class="col-xs-12 content_nav">
                        <router-link :to="{name:'logcontent',params:{contentid:changePage('prev').id}}" @click.native="handleClick" class="pull-left" > <i class="el-icon-back"></i>&nbsp;{{$t('logContent.prev')}}: [{{changePage('prev').title}}] </router-link>
                        <router-link :to="{name:'logcontent',params:{contentid:changePage('next').id}}" @click.native="handleClick" class="pull-right" > {{$t('logContent.next')}}: [{{changePage('next').title}}]  <i class="el-icon-right"></i> </router-link>
                    </div>
                    <!-- 分割线 -->
                    <div class="col-xs-12">
                        <hr class="line" />
                    </div>
                    <!-- 评论 -->
                    <div class="col-xs-12">
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
import CommentCom from './comment/BlogComment'
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
            category: '', // 分类名称
            banner: '', // 分类banner
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
                if (v.id == curArticle) {
                    prevArc = (i - 1) < 0 ? allArticles[allArticles.length - 1] : allArticles[i - 1]
                }
            });
            return prevArc
        },
        nextData: function () {
            let allArticles = JSON.parse(sessionStorage.getItem('allArticles')),
                curArticle = this.$route.params.contentid, nextArc;
            allArticles.forEach((v, i) => {
                if (v.id == curArticle) {
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
                    contentid: contentid,
                    id: id
                }
            }).then(res => {
                if (res.status == 200) {
                    this.content = res.data[0];
                    this.content.comment.reverse();
                    this.category = res.data[0].category
                    this.videoSrc = res.data[0].video_src
                    this.posterSrc = res.data[0].minpic_url
                    this.banner = res.data[0].banner
                }
            })
        },
        changePage(params) { // 后期再解决执行N次的问题
            let allArticles = JSON.parse(sessionStorage.getItem('allArticles')),
                    curArticle = this.$route.params.contentid, prevOrNextPage;
                allArticles.forEach((v, i) => {
                    if (v.id == curArticle) {
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
            this.$parent.$el.children[0].scrollTop=0;
        }
    }
}
</script>

<style lang="less" scoped>
.card-container {
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.45) 5%, rgba(255, 255, 255, 0.75) 30%, #ffffff 60%);
    // border-radius: 15px;
}
.content_nav {
    margin-top: 15px;
    a {
        text-decoration: none;
        transition: background 0.3s, color 0.3s,color 0.3s, color 0.3s;
        color: rgb(54, 54, 54);
        font-weight: bold;
    }
    a:hover {
        background: rgb(54, 54, 54);
        color:aliceblue;
        cursor: pointer;
    }
}
#blog_content{
    .blog_info{
        text-align: center;
    }
}
</style>