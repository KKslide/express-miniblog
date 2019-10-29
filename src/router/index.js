import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import AdminComponent from '@/components/admin/index.vue'

/* ********* 管理端 ********** */
import UserManageComponent from '@/components/admin/user/UserManage.vue'
import CategoryManageComponent from '@/components/admin/category/CategoryManage.vue'
import ArticleManageComponent from '@/components/admin/article/ArticleManage.vue'
import MassageManageComponent from '@/components/admin/massage/MassageManagement.vue'
import LoginComponent from '@/components/admin/Login'
/* ********* 管理端 ********** */


/* ********* 前端 ********** */
import HomeComponent from '../components/client/Home'
import LogComponent from '../components/client/Log'
import AboutComponent from '../components/client/About'
import ContactComponent from '../components/client/Contact'
import LogContentComponent from '../components/client/LogContent'
/* ********* 前端 ********** */

// import routerGuard from './routerGuard'

import CameraComponent from '../components/Camera.vue'

Vue.use(Router)

export default new Router({
    routes: [
        {
            path: '/',
            name: 'home',
            component: HomeComponent,
        },
        {
            path: '/camera',
            name: 'camera',
            component: CameraComponent
        },
        {
            path: '/log',
            name: 'log',
            component: LogComponent
        },
        {
            path: '/logcontent/:id&:contentid',
            name: 'logcontent',
            component: LogContentComponent
        },
        {
            path: '/about',
            name: 'about',
            component: AboutComponent
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
    ]
})

