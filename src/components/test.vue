<template>
    <div>
        <div id="wangEditor"></div>
        <button @click="getText" style="position:absolute;bottom:2em;">get text</button>
    </div>
</template>

<script>
import { IsURL } from "../utils/utils.js";
export default {
    data () {
        return {
            editor: null
        }
    },
    methods: {
        editorInit () {
            this.editor = new wangEditor("#wangEditor");
            this.editor.highlight = hljs; // 代码高亮
            Object.assign(this.editor.config, {
                showFullScreen: true, // 是否显示全屏按钮
                uploadImgAccept: ["jpg", "jpeg", "png", "gif", "bmp"], // 限制上传图片类型
                uploadImgMaxLength: 1, // 一次最多上传 1张图片
                uploadImgServer: "/pic/img_upload", // 图片上传接口图片
                linkImgCallback: this.internetPic, // 上传网络图片成功回调
                uploadImgMaxSize: 2 * 1024 * 1024, // 限制上传图片大小为 2M
                uploadImgTimeout: 60 * 1000, // 上传图片超时时间
                uploadFileName: "file",
                // uploadImgParams :{
                //     param:"holy fuck...."
                // },
                // customUploadImg (resultFiles, insertImgFn) {
                //     // resultFiles 是 input 中选中的文件列表
                //     // insertImgFn 是获取图片 url 后，插入到编辑器的方法

                //     // 上传图片，返回结果，将图片插入到编辑器中
                //     insertImgFn(imgUrl)
                // },
                // linkImgCheck (imgSrc) { }, // 网络图片地址的校验... 不搞了
                linkCheck (text, link) {
                    return IsURL(link) ? true : "插入的不是URL地址, 请重新输入";
                },
                pasteFilterStyle: false, // 关闭粘贴样式过滤
                pasteIgnoreImg: false // 忽略粘贴的图片 - 先不忽略
            });
            // console.log(this.editor.config);
            let str = `<p><img src="http://127.0.0.1/upload_1dc2887034c5645174663dd260e5834c.png" style="max-width:100%;"><br></p>`;
            this.editor.create();
            this.editor.txt.html(str);
        },
        internetPic (src) { // 上传网络图片成功回调
            console.log(src);
        },
        getText () {
            let html = this.editor.txt.html()
            console.log(html);
        }
    },
    mounted () {
        this.editorInit()
    },
    beforeDestroy () {
        // 销毁编辑器
        this.editor.destroy()
        this.editor = null
    }
};
</script>

<style lang="scss" scoped>
#wangEditor {
    width: 100%;
    height: 100vh;
    padding: 10px;
}
</style>