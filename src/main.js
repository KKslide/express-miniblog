// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import qs from 'qs'
import $ from 'jquery'
import ElementUI from 'element-ui' // 引入Element-UI

import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/dist/js/bootstrap.min.js'

import 'normalize.css' // 引入重置样式
import 'element-ui/lib/theme-chalk/index.css' // 引入Element-UI样式
import 'quill/dist/quill.core.css' // 引入编辑器样式
import 'quill/dist/quill.snow.css' // 引入编辑器样式
import 'quill/dist/quill.bubble.css' // 引入编辑器样式
import './styles/main.css' // 引入自己的样式
Vue.use(ElementUI) // 使用饿了么UI

import Filter from "./filter/index"
Vue.use(Filter)

import router from './router'
import axios from 'axios'
// axios.defaults.baseURL = 'http://localhost:8080'
const service = axios.create({
    baseURL: 'http://localhost:8080',
    timeout: 5000
})
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=UFT-8'
service.interceptors.request.use(
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
