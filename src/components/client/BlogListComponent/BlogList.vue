<template>
    <div>
        <header-com></header-com>
        <div class="section-container">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="section-container-spacer text-center">
                            <h1 class="h2">{{$t('navbar.Blogs')}}</h1>
                        </div>
                        <div class="blog_list row">
                            <div class="shadow_outfit clearfix col-md-9">
                                <div class="blog_list_item col-xs-12 col-md-7 col-md-offset-2" v-for="(item,index) in blogList" :key="index" >
                                    <h3 class="blog_title" v-text="item.blogTitle"></h3>
                                    <p class="blog_info">
                                        <i class="fa fa-eye" ></i>
                                        {{item.blogViewNum}} |
                                        <i class="fa fa-comment-o" ></i>
                                        {{item.blogComment}} |
                                        <i class="fa fa-clock-o" ></i>
                                        {{item.blogAddTime.slice(0,10)}} | 
                                        <i class="fa fa-tag"></i>
                                        {{item.blogCategory}}
                                    </p>
                                    <h4 class="blog_intro" v-text="item.blogIntro"></h4>
                                        <!-- :dataIndex="index==0?(sub_index+1):(sub_index+1+item.length)" -->
                                    <router-link :to="{ name: 'logcontent', params: { contentid: item.id } }">
                                        <lazy-img
                                            :src="item.blogPic"
                                            :size="{'width':267,'height':200}"
                                            imgClass="img-responsive img-responsive-auto-width blog_link"
                                        ></lazy-img>
                                    </router-link>
                                    <a href="javascript:;" @click="goto(item.id)" class="blog_read_btn">阅读全文>></a>
                                    <el-divider></el-divider>
                                </div>
                            </div>
                            <div class="blog_nav_bar col-xs-3" role="complementary">
                                <nav class="bs-docs-sidebar hidden-print hidden-xs hidden-sm affix">
                                    <ul class="nav bs-docs-sidenav">
                                        <div class="nav_title">分类</div>
                                        <li class="active nav_li"><div data-catID="all" @click="listSortBy('all')"><span>ALL</span></div></li>
                                        <li v-for="(item,index) in catList" :key="index" class="nav_li">
                                            <div :data-catID="item.id" @click="listSortBy(item.id,$event)">
                                                <span v-html="item.name"></span>
                                            </div>
                                        </li>
                                    </ul>
                                </nav>
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
import Header from '../public/Header';
import Footer from "../public/Footer";
import LazyImg from '../public/LazyImg';
export default {
    data() {
        return {
            blogList: [
                // {
                //     blogTitle: "Title",
                //     blogViewNum: 999,
                //     blogComment: 999,
                //     blogAddTime: "2020-01-09T09:39:52.435Z",
                //     blogIntro: "JavaScript从入门到放弃",
                //     blogCategory: "javascript",
                //     blogPic:"http://example.kkslide.fun/upload_74dee262abdfd681d81c5e5d9b3b2439"
                // }
            ],
            catList: [], // 分类列表
        }
    },
    components: {
        'header-com': Header,
        'footer-com': Footer,
        'lazy-img': LazyImg
    },
    methods:{
        goto(id) {
            this.$router.push({ name: 'logcontent', params: { contentid: id } })
        },
        getArticles() {
            this.$axios({
                url: '/index/getpage',
                method: 'get',
                data:{
                    list_type:'blog'
                }
            }).then(res => {
                if (res.status == 200) {
                    sessionStorage.setItem('allArticles', JSON.stringify(res.data));
                    res.data.blogList.forEach(v => {
                        this.blogList.push({
                            "id" : v.id,
                            "blogTitle" : v.title,
                            "blogViewNum" : v.viewnum,
                            "blogComment" : v.comment_num,
                            "blogAddTime" : v.addtime,
                            "blogIntro" : v.description||'',
                            "blogCategory" : v.category,
                            "blogPic" : v.minpic_url
                        });
                    });
                    this.catList = res.data.catList;
                }
            })
        },
        listSortBy(catID,e){
            console.log(catID);
            // $("li.nav_li").forEach(v=>{
            //     v.removeClass("active")
            // })
            $(e.srcElement).parent().addClass('active')
        }
    },
    beforeMount(){
        this.getArticles()
    }
}
</script>

<style lang="less" scoped>
.blog_list{
    .shadow_outfit{
        box-shadow: 0 5px 10px rgba(0,0,0,.5);
        >.blog_list_item{
            h3.blog_title{
                white-space: nowrap;
            }
            // p.blog_info{}
            h4.blog_intro{
                margin: 15px 0;
            }
            img.blog_link{
                transition: transform .3s;
            }
            img.blog_link:hover {
                transform: scale(1.05);
            }
            a.blog_read_btn{
                display: inline-block;
                color:rgb(30, 30, 30);
                margin-top: 10px;
                position: relative;
                text-decoration: none;
                font-size: 12px;
                transition: font-size .3s;
            }
            a.blog_read_btn::after{
                content:"";
                width: 100%;
                height: 3px;
                background-color: #000;;
                position: absolute;
                left: 0;
                bottom: -3px;
                transition: width .3s;
            }
            a.blog_read_btn:hover{
                font-size: 16px;
            }
            a.blog_read_btn:hover::after{
                width: 0%;
            }
        }
    }
    .blog_nav_bar{
        nav.bs-docs-sidebar{
            ul.nav{
                padding-left: 15px;
                div.nav_title{
                    cursor: default;
                    padding: 0 0 10px 15px;
                }
                li.nav_li{
                    cursor: pointer;
                    div{
                        display: block;
                        padding: 4px 20px;
                        font-size: 13px;
                        font-weight: 500;
                        color: #767676;
                        transition: all .3s;
                    }
                    span{}
                }
                li.nav_li.active,li.nav_li:hover{
                    div{
                        padding-left: 18px;
                        font-weight: 700;
                        color: #17141b;
                        background-color: transparent;
                        border-left: 2px solid #17141b;
                    }
                }
            }
        }
    }
}
</style>