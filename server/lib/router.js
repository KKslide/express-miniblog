var express = require('express');
var router = express.Router();
var handler = require('./handler.js');

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
/* 登陆 */
router.post('/admin/login', handler.doAdmin);
/* 退出登陆 */

/* 后台-首页数据 */
router.get("/admin/getgeneral", handler.getDashboard);

/* 用户管理 */

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

/* 统计访问者IP和时间 */
router.post('/index/visit', handler.visitRecord);

module.exports = router;