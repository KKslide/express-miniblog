<template>
    <div>
        <header-com></header-com>
        <div class="section-container">
            <div class="container">
                <div class="row">
                    <div class="col-sm-8 col-sm-offset-2 section-container-spacer">
                        <div class="text-center">
                            <!-- <h1 class="h2">Blogs</h1> -->
                            <h1 class="h2" v-text="$t('navbar.Vlogs')"></h1>
                            <!-- <p>So many ways to record life, I prefer to do it in my own way, Welcome to my lifeĂ°Ĺ¸ËśĹ˝</p> -->
                            <p v-text="$t('message.slogan')"></p>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div id="myCarousel" class="carousel slide projects-carousel">
                            <!-- Carousel items -->
                            <div class="carousel-inner">
                                <div v-for="(item,index) in articles" :key="index" :class="{'item':true,'active':index==0?true:false}" >
                                    <div class="row">
                                        <div class="col-sm-4" v-for="(sub_item,sub_index) in item" :key="sub_index" >
                                            <a href="javascript:;" @click="goto(sub_item,$event)" :title="sub_item.title" class="black-image-project-hover tag" :tag="sub_item.category.name">
                                            <!-- <a href="javascript:;" :title="sub_item.title" class="black-image-project-hover tag"> -->
                                                <i class="fa fa-play-circle-o"></i>
                                                <lazy-img 
                                                    :src="sub_item.minpic_url" 
                                                    :dataIndex="index==0?(sub_index+1):(sub_index+1+item.length)"
                                                    imgClass="img-responsive img-responsive-auto-width"
                                                    :size="{'width':'100%'}"
                                                ></lazy-img>
                                            </a>
                                            <div class="card-container card-container-lg">
                                                <h4>{{pageIndex(sub_item)}}/00{{origenArticles.length}}</h4>
                                                <h3 v-html="sub_item.title"></h3>
                                                <p v-html="sub_item.description"></p>
                                                <a href="javascript:;"
                                                    title
                                                    class="btn btn-default"
                                                    :data-index="index==0?(sub_index+1):(sub_index+1+item.length)"
                                                    @click="goto(sub_item,$event)"
                                                    v-if="false"
                                                >Check</a>
                                            </div>
                                        </div>
                                    </div>
                                    <!--/row-->
                                </div>
                            </div>
                            <!--/carousel-inner-->
                            <a class="left carousel-control" href="#myCarousel" data-slide="prev" >&lt;</a>
                            <a class="right carousel-control" href="#myCarousel" data-slide="next" >&gt;</a>
                        </div>

                        <!--/myCarousel-->
                    </div>
                    <div class="col-md-6 col-md-offset-3 other_link">
                        <el-divider></el-divider>
                        <div v-html="$t('message.blogIntro')"></div>
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
import LazyImg from '../public/LazyImg'
export default {
    components: {
        'header-com': Header,
        'footer-com': Footer,
        'lazy-img': LazyImg
    },
    data() {
        return {
            origenArticles: [],
            articles: []
        }
    },
    computed: {
        pageIndex() {
            return function (params) {
                let tempIndex;
                this.origenArticles.forEach((v, i) => {
                    if (params.id == v.id) {
                        tempIndex = i + 1
                    }
                })
                return '00' + tempIndex
            }
        }
    },
    methods: {
        goto(sub_item, event) {
            this.$router.push({ name: 'logcontent', params: { contentid: sub_item.id } })
        },
        getArticles() {
            this.$axios.get('/index/getpage', {
                params: {
                    'table':'article',
                    'list_type':'vlog'
                }
            }).then(res => {
                // 等下再调查为什么会请求两次
                if (res.status == 200) {
                    this.origenArticles = res.data;
                    sessionStorage.setItem('allArticles', JSON.stringify(res.data));
                    let splitArticleArr = [];
                    // 因为bootstrap的轮播图形式 是每三个元素为一组 所以要分割对应的数组
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
    src: url("../../../assets/images/space.jpg");
}
.img-responsive-auto-width{
    width: 100%;
}
.black-image-project-hover.tag {
    position: relative;
    margin-bottom: 15px;
    i.fa-play-circle-o{
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%,-50%);
        font-size: 6em;
        color:rgb(255,255,255);
        z-index: 999;
        opacity: .3;
        transition: opacity .3s;
    }
    &:hover{
        i{
            opacity: .8;
        }
    }
}
.black-image-project-hover.tag::after{
    content: attr(tag);
    position: absolute;
    top: 0;
    left: 0;
    color:#fff;
    background-color: rgba(0, 0, 0, .5);
    font-size: 1em;
    padding: 0em 0.5em;
    border-bottom-right-radius: 10%;
}
.other_link{
    p{
        // text-align: center;
        text-indent: 3em;
        font-size: 18px;
        margin: 0px 5px;
        a{
            text-decoration: none;
        }
    }
}
</style>