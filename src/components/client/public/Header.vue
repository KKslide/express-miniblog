<template>
    <div>
        <header>
            <nav ref="nav" class="navbar navbar-fixed-top navbar-inverse">
                <div class="container">
                    <button
                        type="button"
                        class="navbar-toggle collapsed"
                        data-toggle="collapse"
                        data-target="#navbar-collapse"
                        aria-expanded="false"
                    >
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbar-collapse">
                        <ul class="nav navbar-nav">
                            <li>
                                <!-- <router-link :to="{name:'home'}">01 : Home</router-link> -->
                                <router-link :to="{name:'home'}" v-text="'01 : '+$t('navbar.Home')"></router-link>
                            </li>
                            <li>
                                <router-link :to="{name:'blog'}" v-text="'02 : '+$t('navbar.Blogs')"></router-link>
                            </li>
                            <li>
                                <!-- <router-link :to="{name:'log'}">02 : Blogs</router-link> -->
                                <router-link :to="{name:'vlog'}" v-text="'03 : '+$t('navbar.Vlogs')"></router-link>
                            </li>
                            <li>
                                <!-- <router-link :to="{name:'works'}">04 : Works</router-link> -->
                                <router-link
                                    :to="{name:'works'}"
                                    v-text="'04 : '+$t('navbar.Works')"
                                ></router-link>
                                <!-- **************** -->
                            </li>
                            <li>
                                <!-- <router-link :to="{name:'about'}">03 : About me</router-link> -->
                                <router-link
                                    :to="{name:'about'}"
                                    v-text="'05 : '+$t('navbar.About')"
                                ></router-link>
                            </li>
                            <li>
                                <!-- <router-link :to="{name:'contact'}">05 : Contact</router-link> -->
                                <router-link
                                    :to="{name:'contact'}"
                                    v-text="'05 : '+$t('navbar.Contact')"
                                ></router-link>
                            </li>
                            <li v-if="false">
                                <a href="javascript:;">
                                    <div class="dropdown">
                                        <div
                                            id="dropdownMenu"
                                            data-toggle="dropdown"
                                            aria-haspopup="true"
                                            aria-expanded="true"
                                        >
                                            Dropdown
                                            <span class="caret"></span>
                                        </div>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu">
                                            <li>
                                                <a href="#">中文</a>
                                            </li>
                                            <li>
                                                <a href="#">English</a>
                                            </li>
                                        </ul>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <!-- 文章导航 -->
                        <!-- v-if="this.$route.name=='logcontent'" -->
                        <ul v-if="false" class="nav navbar-nav navbar-right navbar-small visible-md visible-lg" >
                            <li v-for="(item,index) in currentArticles" :key="index">
                                <a
                                    href="javascript:;"
                                    v-html="'00'+(index+1)"
                                    :data-index="index"
                                    v-active
                                    @click="changePage(item,index)"
                                ></a>
                            </li>
                        </ul>
                        <!-- 文章导航 -->
                    </div>
                </div>
            </nav>
        </header>
    </div>
</template>

<script>
export default {
    data() {
        return {
            currentArticles: [],
        }
    },
    directives: {
        'active': {
            inserted(el, binding, node) {
                let index = el.getAttribute('data-index'), contentIndex = node.context.$route.params.id, isActive = index == contentIndex;
                if (isActive) el.classList.add('active');
            },
            update(el, binding, node) {
                let index = el.getAttribute('data-index'), contentIndex = node.context.$route.params.id
                $("ul.navbar-right li a").eq(index).removeClass('active')
                $("ul.navbar-right li a").eq(contentIndex).addClass('active')
            },
        }
    },
    mounted() {
        if (this.$route.name == 'home') {
            this.$refs.nav.classList.add('navbar-inverse')
            this.$refs.nav.classList.remove('navbar-default')
        } else {
            this.$refs.nav.classList.add('navbar-default')
            this.$refs.nav.classList.remove('navbar-inverse')
        }
        this.currentArticles = JSON.parse(sessionStorage.getItem('allArticles'))
    },
    methods: {
        changePage(item, index) {
            if (index == this.$route.params.id) return false;
            var _this = this,
                obj = JSON.parse(JSON.stringify(_this.$router.currentRoute.query)) // 这里我们需要的应该是值，因此必须转为深拷贝
            Object.assign(obj, { id: index, contentid: item._id })
            _this.$router.push({
                params: obj
            })
        },
    }
}
</script>

<style lang="less" scoped>
#navbar-collapse {
    ul {
        li {
            a:hover,
            a:focus {
                color: #333;
                text-decoration: none;
            }
            a:focus {
                outline: 5px auto -webkit-focus-ring-color;
                outline-offset: -2px;
            }
        }
    }
}
.minimal {
    #navbar-collapse {
        ul {
            li {
                a:hover,
                a:focus {
                    color: #fff;
                    text-decoration: none;
                }
                a:focus {
                    outline: 5px auto -webkit-focus-ring-color;
                    outline-offset: -2px;
                }
            }
        }
    }
}
</style>