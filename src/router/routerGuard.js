import axios from 'axios'

export default function (to, from, next) {
    if (to.path.indexOf('login') != -1 || to.path.indexOf('admin') != -1) {
        axios.get('/admin/isadmin')
            .then(res => {
                let islogin = res.data.islogin == 'logined';
                if (to.name == 'login') { // 如果是登陆页 那就上
                    if (islogin) {
                        next('/admin')
                    } else {
                        next();
                    }
                }
                if (to.name != 'login') {
                    if (islogin) {
                        next()
                    } else {
                        next('/login')
                    }
                }
            })
    } else {
        next()
    }
}