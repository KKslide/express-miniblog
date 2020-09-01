// 用户长时间未操作 退出登录
// import store from '@/store'
// import router from '@/router'

var timer = window.$timer

clearInterval(timer)

export function isOperateFun() {
    var lastTime = new Date().getTime() // 最后一次点击时间
    var currentTime = new Date().getTime() // 当前时间
    var timeOut = 5 * 1000 // 允许最长未操作时间
    var i = 1 // 辅助作用

    function handleReset() { // 重新赋值最后一次点击时间，清除定时器，重新开始定时器
        // console.log('又点击了！！！！！！')
        i = 1

        lastTime = new Date().getTime()

        if (timer) {
            clearInterval(timer)
            timer = null
        }

        if (!timer) {
            console.log('真好！重新开始')
            handleInterval()
        }
    }

    document.onclick = () => { // 单击事件
        handleReset()
    }

    document.ondblclick = () => { // 双击事件
        handleReset()
    }

    document.onmousedown = () => { // 按下鼠标键时触发
        handleReset()
    }

    document.onmouseup = () => { // 释放按下的鼠标键时触发
        handleReset()
    }

    document.onmousemove = () => { // 鼠标移动事件
        handleReset()
    }

    document.onmouseover = () => { // 移入事件
        handleReset()
    }

    document.onmouseout = () => { // 移出事件
        handleReset()
    }

    document.onmouseenter = () => { // 移入事件
        handleReset()
    }

    document.onmouseleave = () => { // 移出事件
        handleReset()
    }

    document.onkeydown = () => { // 键盘按下
        handleReset()
    }

    document.onkeyup = () => { // 键盘按起
        handleReset()
    }

    function handleInterval() { // 定时器
        timer = setInterval(() => {
            console.log(document.cookie);
            currentTime = new Date().getTime() // 当前时间

            console.log(`${i++}-currentTime`, currentTime)
            console.log('最后一次操作时间', lastTime)

            if (currentTime - lastTime > timeOut) {
                console.log('长时间未操作')

                clearInterval(timer) // 清除定时器

                // store.dispatch('user/logout').then(() => { // 执行退出并跳转到首页
                //     const path = window.location.href.split('#')[1]
                //     if (path !== '/home') { // 判断当前路由不是首页 则跳转至首页
                //         router.push('/home')
                //     }
                //     window.AndroidWebView.loginOut() // 执行安卓退出方法
                // })

                // 长时间未操作逻辑
                console.log('太久没动了!!!');

            }
        }, 1000)
    }

    handleInterval() // 一开始程序 默认执行定制器
}