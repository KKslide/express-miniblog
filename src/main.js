// import Vue from 'vue'
import App from './App.vue'
import router from './router'


import './styles/main.moudle.scss' // 引入自己的样式

import i18n from './locales/index' // 使用自定义语言切换插件

// import Vuex from 'vuex'
// Vue.use(Vuex)

import Filter from "./filter/index"
Vue.use(Filter) // 使用路由守卫

// axios.defaults.baseURL = process.env.NODE_ENV == 'development'
//     ? 'http://127.0.0.1:8080'  // 开发
//     : 'http://47.112.232.140' // 生产
const service = axios.create({
    baseURL: process.env.NODE_ENV === 'development'
        ? 'http://47.112.232.140' // 生产- 线上发布的时候- 腾讯云
        : 'http://127.0.0.1:8080',  // 开发- 本地开发的时候..
    timeout: 5000
})

window.$timer = null

import routerGuard from './router/routerGuard'
router.beforeEach(routerGuard)

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

window.$timer = null

Vue.config.productionTip = false

new Vue({
    router,
    i18n,
    render: h => h(App)
}).$mount('#app')
