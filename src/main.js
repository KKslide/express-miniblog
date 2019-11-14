// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
// import Vue from 'vue'
import App from './App'
// import qs from 'qs'
// import $ from 'jquery'

// import 'normalize.css' // 引入重置样式

// import ElementUI from 'element-ui' // 引入Element-UI
// import 'element-ui/lib/theme-chalk/index.css' // 引入Element-UI样式
// Vue.use(ElementUI) // 使用饿了么UI

// import 'bootstrap/dist/css/bootstrap.min.css' // 引入bootstrap样式
// import 'bootstrap/dist/js/bootstrap.min.js' // 引入bootstrap

import 'quill/dist/quill.core.css' // 引入编辑器样式
import 'quill/dist/quill.snow.css' // 引入编辑器样式
import 'quill/dist/quill.bubble.css' // 引入编辑器样式
import './styles/main.css' // 引入自己的样式

import Filter from "./filter/index"
Vue.use(Filter)

import router from './router'
// import axios from 'axios'
// axios.defaults.baseURL = 'http://localhost:8080'
const service = axios.create({
    // baseURL: 'http://localhost:8080', // 本地开发的时候..
    baseURL: 'http://47.107.164.180', // 线上发布的时候
    timeout: 5000
})
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=UFT-8'
service.interceptors.request.use( // 把默认的object类型请求转化为post
    config => { // onFullfilled:
        if (config === 'post') {
            config.data = qs.stringify(config.data)
        }
    },
    error => { // onRejected
        console.log(error);
        Promise.reject(error)
    }
)
Vue.prototype.$axios = axios

Vue.config.productionTip = false

import routerGuard from './router/routerGuard'
router.beforeEach(routerGuard)

/* eslint-disable no-new */
new Vue({
    el: '#app',
    router,
    components: { App },
    template: '<App/>'
})
