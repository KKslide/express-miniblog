<template>
    <div id="app">
        <div id="site-border-left"></div>
        <div id="site-border-right"></div>
        <div id="site-border-top"></div>
        <div id="site-border-bottom"></div>
        <!-- 翻译悬浮按钮 -->
        <lang-com v-show="isShow"></lang-com>
        <el-scrollbar style="height:100%" ref="elScrollBar" v-if="!isMobile">
            <router-view></router-view>
        </el-scrollbar>
        <router-view v-else></router-view>
    </div>
</template>

<script>
// import { isOperateFun } from './utils/isOperateFun'
import TranslationBar from "./components/client/public/TranslateBar";
export default {
    name: "App",
    components: {
        "lang-com": TranslationBar
    },
    data() {
        return {
            isShow: true,
            isMobile: null
        };
    },
    methods: {
        version() {
            var u = navigator.userAgent,
                app = navigator.appVersion;
            return {
                trident: u.indexOf("Trident") > -1, //IE内核
                presto: u.indexOf("Presto") > -1, //opera内核
                webKit: u.indexOf("AppleWebKit") > -1, //苹果、谷歌内核
                gecko: u.indexOf("Gecko") > -1 && u.indexOf("KHTML") == -1, //火狐内核
                mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
                ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
                android: u.indexOf("Android") > -1 || u.indexOf("Linux") > -1, //android终端或者uc浏览器
                iPhone: u.indexOf("iPhone") > -1, //是否为iPhone或者QQHD浏览器
                iPad: u.indexOf("iPad") > -1, //是否iPad
                webApp: u.indexOf("Safari") == -1, //是否web应该程序，没有头部与底部
                weixin: u.indexOf("MicroMessenger") > -1, //是否微信 （2015-01-22新增）
                qq: u.match(/\sQQ/i) == " qq" //是否QQ
            };
        }
    },
    watch: {
        $route: function (nv, ov) {
            if (!nv || nv.name == "login" || nv.path.indexOf("admin") > -1) {
                this.isShow = false;
            } else {
                this.isShow = true;
            }
        }
    },
    beforeCreate() {
        this.$nextTick(_ => {
            this.isMobile = this.version().mobile;
        });
    },
    created() {
        // isOperateFun()
    }
};
</script>

<style lang="less" scoped>
</style>