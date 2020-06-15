var express = require('express');
var router = express.Router();
var handler = require('./handler.js');

/* 前端 */
/* 获取blog列表数据 或 vlog列表数据 */
router.get('/index/getpage', handler.getIndexPage);
/* 获取详情页 */
router.get('/index/getcontent', handler.getContentPage);
/* 评论文章 */
router.post('/index/comment', handler.Comment);


/* 管理端 */
/* 登陆 */
router.post('/admin', handler.doAdmin);
/* 退出登陆 */

/* 后台-dashboard */

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
/* 文章-新增 */
// router.post('/admin/article/add', handler.addArticle);
/* 文章-删除 */
/* 文章-修改 */

/* 评论 */
/* 评论-获取 */
/* 评论-删除 */

/* 留言 */
/* 留言-获取 */
/* 留言-删除 */

/* 七牛云图片上传 */
// router.post('/upload', handler.doUpload);

module.exports = router;