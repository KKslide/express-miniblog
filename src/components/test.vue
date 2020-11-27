<template>
    <div id="Editor"></div>
</template>

<script>
export default {
    mounted() {
        const editor = new wangEditor("#Editor");
        editor.highlight = hljs; // 代码高亮
        Object.assign(editor.config, {
            showFullScreen: true, // 是否显示全屏按钮
            uploadImgAccept: ['jpg', 'jpeg', 'png', 'gif', 'bmp'], // 限制上传图片类型
            uploadImgMaxLength: 1, // 一次最多上传 1张图片
            uploadImgServer: "/pic/img_upload", // 图片上传接口图片
            linkImgCallback: this.internetPic, // 上传网络图片成功回调
            uploadImgMaxSize: 2 * 1024 * 1024, // 限制上传图片大小为 2M
            uploadImgTimeout: 60 * 1000, // 上传图片超时时间
            uploadFileName : 'file',
            uploadImgParams :{
                param:"holy fuck...."
            }
            // customUploadImg(resultFiles, insertImgFn) {
            //     console.log(resultFiles);
                // resultFiles 是 input 中选中的文件列表
                // insertImgFn 是获取图片 url 后，插入到编辑器的方法

                // 上传图片，返回结果，将图片插入到编辑器中
                // insertImgFn(imgUrl)
            // }
        });
        console.log(editor.config);
        editor.create();
    },
    methods: {
        internetPic(src) {
            console.log(src);
        }
    }
};
</script>

<style lang="scss" scoped>
#Editor {
    width: 100%;
    height: 100vh;
    padding: 10px;
}
</style>