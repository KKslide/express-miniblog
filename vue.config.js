module.exports = {
    publicPath: process.env.NODE_ENV === 'production'
        ? 'http://127.0.0.1:80'  // 开发
        : 'http://134.175.129.219', // 生产
    outputDir: './dist',
    assetsDir: './', //放置生成的静态资源 (js、css、img、fonts) 的 (相对于 outputDir 的) 目录。
    indexPath: 'index.html', //指定生成的 index.html 的输出路径 (相对于 outputDir)。也可以是一个绝对路径。
    productionSourceMap: false, // 生产环境是否生成 sourceMap 文件
    filenameHashing: true, // 文件后缀哈希值, 用于控制缓存
    lintOnSave: false, //设置是否在开发环境下每次保存代码时都启用 eslint验证
    
}