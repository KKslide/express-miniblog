var express = require('express');
var router = express.Router();
var Category = require("../models/category");
var Content = require("../models/content");
var Massage = require("../models/massage");
var Visitor = require("../models/visitor");
/**
* 获取用户ip
*/
function getClientIp(req) {
    try {
        return req.headers['x-wq-realip'] ||
            req.connection.remoteAddress ||
            req.socket.remoteAddress ||
            req.connection.socket.remoteAddress;
    } catch (e) {
        logger.info("getClientIp error");
        return "";
    }
}
/* 统计访问者IP和时间 */
router.post('/visit', function (req, res, next) {
    var newvisitor = new Visitor({
        ip: getClientIp(req).replace(/::ffff:/, ''),
        time: new Date()
    });
    newvisitor.save()
    res.json({ msg: 'ok' })
});

/* 前端 */
/* 获取文章列表页 */
router.get('/getpage', function (req, res, next) {
    // res.render('index', { title: 'Express' });
    //   var obj = {
    //     "name": "kk",
    //     "age": 18
    //   }
    Content.find({ isShow: { $eq: 1 } }).populate('category').sort({ addtime: -1 })/* .limit(6) */.then(contents => {
        res.json(contents.filter(v=>{
            return v.category.name != 'Video';
        }));
    });
});

/* 获取视频类型的页面 */
router.get('/getvideolist', function (req,res,next) {
    Content.find({isShow:{$eq:1}}).populate({
        path:'category',
        select:'name',
        match:{name:{$eq:'Video'}}
    }).where().sort({ addtime: -1 }).then(contents=>{
        res.json(contents.filter(v=>{
            return v.category != null
        }));
    });
});

/* 获取文章详情 */
router.post('/getcontent', function (req, res, next) {
    var id = req.query.contentid || req.body.contentid || "";
    Content.findOne({ _id: id }).populate(["category", "user"]).then(contents => {
        contents.num++;
        contents.save();
        res.json(contents);
    })
});

/* 评论文章 */
router.post('/comment', function (req, res, next) {
    var id = req.body.contentid || req.query.contentid || ""; // 文章ID
    var ip = getClientIp(req).match(/(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)/)[0];
    var commentdata = {
        comment: req.body.comment || req.query.comment || "",
        user: req.body.visitor || req.query.visitor || "",
        ip: ip,
        time: new Date()
    }
    Content.findOne({ _id: id }).then(function (thiscon) {
        if (commentdata.comment != "") {
            thiscon.comment.push(commentdata);
        }
        //thiscon.comment.reverse();
        thiscon.save().then(function (newcon) {
            res.json({ code: 1, msg: "评论成功" });
        });
    });
});

/* 后端删除文章评论 - 后期做成前端也能删除 - 带标识 */
router.post('/comment/del', function (req, res, next) {
    var id = req.body.contentid || req.query.contentid || ""; // 文章ID
    var comment_time = req.body.time || req.query.time || ""; // 评论时间
    Content.findOne({ _id: id }).then(function (thiscon) {
        thiscon.comment.forEach((v, i) => {
            if ((v.time + '') === new Date(comment_time).toString()) {
                thiscon.comment.splice(i, 1)
            }
        })
        thiscon.save().then(function (newcon) {
            res.json({ code: 1, msg: "删除成功" });
        });
    });
});

/* 获取留言接口 */
router.get("/massage", function (req, res, next) {
    Massage.find().sort({ addtime: -1 }).then(contents => {
        res.json(contents);
    });
});

/* 留言接口 */
router.post("/massage/add", function (req, res, next) {
    var viewer = req.query.viewer || req.body.viewer || "nobody";
    var subject = req.query.subject || req.body.subject || "no subject";
    var massage = req.query.massage || req.body.massage || "";
    var newMsg = new Massage({
        viewer: viewer,
        subject: subject,
        massage: massage,
        addtime: new Date()
    });
    newMsg.save();
    res.json({ code: 1, msg: "哔~ 留言完毕~ 感谢支持" });
});

module.exports = router;
