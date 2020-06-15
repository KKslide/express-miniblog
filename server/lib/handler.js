var util = require('../util/util');
/* sql操作 */
var dbMoudle = require('./sqlModule');

/* 七牛云图片上传 */
var qiniuUpload = require('./qiniu.config');
module.exports.doUpload = function (req, res) {
    qiniuUpload.picUpload(req, res);
}

/* 前端 */
/* 获取blog列表数据 或 vlog列表数据 */
module.exports.getIndexPage = function (req, res) {

}

/* 获取详情页 */
module.exports.getContentPage = function (req, res) {

}

/* 评论文章 */
module.exports.Comment = function (req, res) {

}


/* --------------------------管理页------------------------- */
/* 登陆 */
module.exports.doAdmin = function (req, res) {

}
/* 退出登陆 */
/* 分类-获取 */
module.exports.getCategory = function (req, res) {
    var opt = {
        table: 'category',
        pageNo: req.body.pageNo || 1,
        pageSize: req.body.pageSize || 10
    };
    dbMoudle.doQuery(opt, (err, data) => {
        res.json({ data })
    })
}
/* 分类-新增 */
module.exports.addCategory = function (req, res) {
    var name = req.body.name;
    var banner = req.body.banner || 'http://example.kkslide.fun/banner.jpg';
    var obj = {
        'table': 'category',
        'data': {
            'name': `'${name}'`,
            'banner': "'http://example.kkslide.fun/banner.jpg'",
            'addtime': `'${util.getNow()}'`,
            'edittime': `'${util.getNow()}'`
        }
    }
    dbMoudle.addCategory(obj, (err, data) => {
        res.json({ code: 1, msg: "success" });
    })
}
/* 分类-删除 */
module.exports.delCategory = function (req, res) {
    var opt = {
        table: 'category',
        id: req.body.id
    };
    dbMoudle.delCategory(opt, (err, data) => {
        res.json({ code: 1, msg: "删除成功" });
    })
}
/* 分类-修改 */
module.exports.editCategory = function (req, res) {
    var obj = {
        'table': 'category',
        'id': req.body.id,
        'data': {
            'name': req.body.name,
            'banner': req.body.banner,
            'edittime': util.getNow()
        }
    }
    dbMoudle.editCategory(obj, (err) => {
        res.json({ code: 1, msg: "修改成功" });
    })
}

/* 文章-获取 */
/* 文章-新增 */
module.exports.addArticle = function (req, res) {

}
/* 文章-删除 */
/* 文章-修改 */