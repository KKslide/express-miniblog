// import Vue from 'vue'
// import Router from 'vue-router'
import AdminComponent from '@/components/admin/index.vue'

/* ********* 管理端 ********** */
import AdmHomeComponent from '@/components/admin/home/Home.vue'
import UserManageComponent from '@/components/admin/user/UserManage.vue'
import CategoryManageComponent from '@/components/admin/category/CategoryManage.vue'
import ArticleManageComponent from '@/components/admin/article/ArticleManage.vue'
import MassageManageComponent from '@/components/admin/massage/MassageManagement.vue'
import LoginComponent from '@/components/admin/login/Login'
/* ********* 管理端 ********** */


/* ********* 前端 ********** */
import HomeComponent from '../components/client/Home' // 首页
import BlogComponent from '../components/client/BlogListComponent/BlogList.vue' // 博客列表页面
import VideoListComponent from '../components/client/VideoListComponent/VideoList.vue' // vlog列表页
import ContentComponent from '../components/client/ContentComponent/BlogContent.vue' // 内容详情页
import AboutComponent from '../components/client/AboutMeComponent/About.vue' // '关于我'页面
import WorksComponent from '../components/client/WorksComponent/Works.vue' // 代码列表页面
import ContactComponent from '../components/client/ContactComponent/Contact.vue' // '联系我'页面
/* ********* 前端 ********** */

// import CameraComponent from '../components/other/Camera.vue' // 测试单图上传组件

import test from '../components/test.vue'


// export default new Router({
export default new VueRouter({
    // mode:'history',
    routes: [
        {
            path: '/',
            name: 'home',
            component: HomeComponent,
        },
        {
            path: '/test',
            name: 'test',
            component: test
        },
        {
            path: '/blog',
            name: 'blog',
            component: BlogComponent
        },
        {
            path: '/vlog',
            name: 'vlog',
            component: VideoListComponent
        },
        {
            path: '/logcontent/:contentid',
            name: 'logcontent',
            component: ContentComponent
        },
        {
            path: '/about',
            name: 'about',
            component: AboutComponent
        },
        {
            path: '/works',
            name: 'works',
            component: WorksComponent
        },
        {
            path: '/contact',
            name: 'contact',
            component: ContactComponent
        },
        // 后台管理页登陆页面
        {
            path: '/login',
            name: 'login',
            component: LoginComponent
        },
        // 管理后台路由
        {
            path: '/admin',
            name: 'admin',
            component: AdminComponent,
            children: [
                {
                    path: 'admhome',
                    name: 'admhome',
                    component: AdmHomeComponent
                },
                {
                    path: 'user',
                    name: 'user',
                    component: UserManageComponent
                },
                {
                    path: 'category',
                    name: 'category',
                    component: CategoryManageComponent
                },
                {
                    path: 'article',
                    name: 'article',
                    component: ArticleManageComponent
                },
                {
                    path: 'massage',
                    name: 'massage',
                    component: MassageManageComponent
                },
            ]
        }
    ],
    scrollBehavior(to, from, savedPosition) {
        return {
            x: 0,
            y: 0
        }
    }
});

