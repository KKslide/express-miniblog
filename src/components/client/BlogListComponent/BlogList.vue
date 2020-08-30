<template>
    <div>
        <header-com></header-com>
        <div class="section-container">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="section-container-spacer text-center">
                            <h1 class="h2">{{$t('navbar.Blogs')}}</h1>
                            <p>{{$t('logList.logIntro')}}</p>
                        </div>
                        <div class="blog_list row">
                            <div class="nothing col-md-9"></div>
                            <!-- 侧边分类导航条 -->
                            <div class="blog_nav_bar col-xs-3 col-md-3 col-md-offset-9" role="complementary">
                                <nav class="bs-docs-sidebar hidden-print hidden-xs hidden-sm affix">
                                    <ul class="nav bs-docs-sidenav">
                                        <div class="nav_title">{{$t('logList.categoryTitle')}}</div>
                                        <li class="active nav_li" data-catID="all" @click="navJump('all',$event)"><div>ALL</div></li>
                                        <li v-for="(item,index) in catList" :key="index" class="nav_li" :ref="item.name" @click="navJump(item.name,$event)">
                                            <div :data-catID="item.id" v-html="item.name"></div>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                        <!-- 全局分类排列 -->
                        <div class="blog_list row" v-if="isAll">
                            <div class="shadow_outfit clearfix col-md-9" v-for="(main_item,index) in formedBlogList" :key="index" :data-pos="index">
                                <div class="blog_list_item col-xs-12 col-md-7 col-md-offset-2" v-for="(item,index) in main_item" :key="index" >
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
                                <div class="blog_list_item_more col-xs-12 col-md-7 col-md-offset-2 float-right">
                                    <span @click="getMore(index)">{{$t('logList.checkMore')}}「{{index}}」</span>
                                </div>
                            </div>
                        </div>
                        <!-- 按照指定分类排列 -->
                        <div class="blog_list row" v-else>
                            <div class="shadow_outfit clearfix col-md-9">
                                <div class="blog_list_item col-xs-12 col-md-7 col-md-offset-2" v-for="(item,index) in sortList" :key="index">
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
            sortList:[], // 经过筛选的文章
            catList: [], // 分类列表
            formedBlogList:{},
            isAll:true
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
        deepClone(obj) {
            var target = {};
            for(var key in obj) {
                if (Object.prototype.hasOwnProperty.call(obj, key)) {
                    if (typeof obj[key] === 'object') {
                        target[key] = this.deepClone(obj[key]); 
                    } else {
                        target[key] = obj[key];
                    }
                }
            }
            return target;
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
                    sessionStorage.setItem('allArticles', JSON.stringify(res.data.blogList));
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
                    this.sortList = this.deepClone(this.blogList);
                    this.catList = res.data.catList.filter(v=>{return v.name!='Vlog'});

                    this.catList.forEach((cat_v)=>{
                        this.formedBlogList[cat_v.name] = this.blogList.filter((blog_v)=>{
                            return blog_v.blogCategory==cat_v.name;
                        }).splice(0,3);
                    });
                    
                }
            })
        },
        navJump(catID,e){ // 点击导航栏跳转
            this.sortList=[];
            if(catID=='all'){
                this.isAll=true;
                Array.from($("li.nav_li")).forEach(v=>{
                    v.classList.remove("active")
                });
                $(e.srcElement).parent().addClass('active');
                $(".el-scrollbar__wrap").animate({scrollTop:'0px'});
                return;
            }else{
                if(!this.isAll){ // 在内容列表页中
                    $(".el-scrollbar__wrap").animate({scrollTop:'0px'},300,()=>{
                        this.getMore(catID);
                    });
                    return;
                }
            }
            Array.from($("li.nav_li")).forEach(v=>{
                v.classList.remove("active")
            });
            $(e.srcElement).parent().addClass('active');
            this.scrollTop = $(".el-scrollbar__wrap").scrollTop(); // wrap页面滚动出去的距离
            this.ModuleTop = $("[data-pos='"+catID+"']").offset().top; // Code模块距离顶部距离
            // console.log('---------');
            // console.log('wrap页面滚动出去的距离: ',$(".el-scrollbar__wrap").scrollTop());
            // console.log(catID,'模块和浏览器顶部距离',this.ModuleTop);
            // console.log('需要滚动出去的距离: ',this.scrollTop+(this.ModuleTop-20-$("nav.navbar").height()));
            $(".el-scrollbar__wrap").animate({scrollTop:this.scrollTop+(this.ModuleTop-20-$("nav.navbar").height())+'px'});
        },
        getMore(catName){ // 选择某一分类列表显示
            $(".el-scrollbar__wrap").animate({scrollTop:'0px'},300,()=>{
                Array.from($("li.nav_li")).forEach(v=>{
                    v.classList.remove("active")
                });
                this.$refs[catName][0].classList.add("active");
                this.isAll=false;
                this.sortList= this.blogList.filter(v=>{
                    return v.blogCategory==catName;
                });
            });
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
        margin-bottom: 50px;
        .blog_list_item{
            h3.blog_title{
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;
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
        .blog_list_item_more{
            padding-bottom: 15px;
            text-align: center;
            >span{
                padding: 10px;
                cursor: pointer;
                transition: font-weight .3s;
            }
            >span:hover{
                font-weight: 800;
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
                    margin-bottom: 5px;
                    >div{
                        cursor: pointer;
                        display: block;
                        padding: 4px 20px;
                        font-size: 13px;
                        font-weight: 500;
                        color: #767676;
                        transition: all .3s;
                    }
                }
                li.nav_li.active,li.nav_li:hover{
                    >div{
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