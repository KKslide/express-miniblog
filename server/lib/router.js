var express = require('express');
var router = express.Router();
var handler = require('./handler.js');
var path = require("path");
var formidable = require("formidable"); // 用来处理上传图片的

/* ********* 前端 ********* */
/* 获取blog列表数据 或 vlog列表数据 */
router.get('/index/getpage', handler.getIndexPage);
/* 获取详情页 */
router.post('/index/getcontent', handler.getContentPage);
/* 评论文章 */
router.post('/index/comment', handler.Comment);
/* 留言 */
router.post('/index/message/add', handler.leaveMessage);


/* ********* 管理端 ******** */
/* 检测是否登陆 */
router.get('/admin/isadmin', (req, res) => {
    if (JSON.stringify(req.cookies) == "{}") {
        res.json({ code: 0, msg: "请先登录啦" })
    } else {
        res.json({ code: 1, islogin: 'logined', msg: "登陆成功" })
    }
});
/* 登陆 */
router.post('/admin/login', handler.doLogin);
/* 退出登陆 */
router.get("/admin/logout", (req, res) => {
    res.cookie('userInfo', null, { expires: new Date(0) });
    res.json({ code: 1, msg: "退出成功" });
});

/* 后台-首页数据 */
router.get("/admin/getgeneral", handler.getDashboard);

/* 分类 */
/* 分类-获取 */
router.get('/admin/categories', handler.getCategory);
/* 分类-新增 */
router.post('/admin/categories/add', handler.addCategory);
/* 分类-删除 */
router.post('/admin/categories/del', handler.delCategory);
/* 分类-修改 */
router.post('/admin/categories/edit', handler.editCategory);

/* 文章 */
/* 文章-获取 */
router.get('/admin/articles', handler.getArticle);
/* 文章-新增 */
router.post('/admin/articles/add', handler.addArticle);
/* 文章-删除 */
router.post('/admin/articles/del', handler.delArticle);
/* 文章-修改 */
router.post('/admin/articles/edit', handler.editArticle)

/* 评论 */
/* 评论-获取 */
router.get('/admin/comment', handler.getComment);
/* 评论-删除 */
router.post('/admin/comment/del', handler.delComment);

/* 留言 */
/* 留言-获取-和前端同个接口 */
router.get('/index/message/get', handler.getMessages);
router.get('/admin/message/get', handler.adminGetMessages);
/* 留言-删除 */
router.post('/admin/massage/del', handler.delMessage);

/* 七牛云图片上传 */
router.post('/pic/upload', handler.doUpload);

/* 本地图片上传 */
router.post("/pic/img_upload", function (req, res) {
    var form = new formidable.IncomingForm()
    form.uploadDir = "./upload";
    form.keepExtensions = true;
    form.parse(req, function (err, fields, files) {
        // console.log(fields);
        // console.log(files);
        if (err) {
            console.log(err);
            res.json({ code: 0, msg: "上传失败！" })
        } else {
            var ip = req.headers['x-real-ip'] ? req.headers['x-real-ip'] : req.ip.replace(/::ffff:/, ''); // 有问题
            res.json({
                code: 1,
                msg: "上传成功！",
                errno: 0,
                // path: 'http://' + ip + '/' + path.basename(files.file.path),
                // data:[ 'http://' + ip + '/' + path.basename(files.file.path) ]
                path: 'http://' + ip + '/' + path.basename(Object.values(files)[0].path),
                data:[ 'http://' + ip + '/' + path.basename(Object.values(files)[0].path) ]
            })
        }
    })
});

/* 统计访问者IP和时间 */
router.post('/index/visit', handler.visitRecord);

module.exports = router;