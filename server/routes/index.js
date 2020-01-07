var express = require('express');
var router = express.Router();
var Category = require("../models/category");
var Content = require("../models/content");
var Massage = require("../models/massage");
// var getClientIP = function (req) {
//     return req.headers['x-forwarded-for'] || // 判断是否有反向代理 IP
//         req.connection.remoteAddress || // 判断 connection 的远程 IP
//         req.socket.remoteAddress || // 判断后端的 socket 的 IP
//         req.connection.socket.remoteAddress;
// };
/**
* 获取用户ip
*/
function getClientIp(req) {
	try{
		return req.headers['x-wq-realip'] ||
        req.connection.remoteAddress ||
        req.socket.remoteAddress ||
        req.connection.socket.remoteAddress;
	}catch(e){
		logger.info("getClientIp error");
		return "";
	}
}
/* 前端 */
/* 获取文章列表页 */
router.get('/getpage', function (req, res, next) {
    // res.render('index', { title: 'Express' });
    //   var obj = {
    //     "name": "kk",
    //     "age": 18
    //   }
    console.log(getClientIp(req));
    Content.find({isShow:{$eq:1}}).sort({ addtime: -1 })/* .limit(6) */.then(contents => {
        res.json(contents)
    })
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
    var id = req.body.contentid || req.query.contentid || "";
    var commentdata = {
        comment: req.body.comment || req.query.comment || "",
        user: req.body.visitor || req.query.visitor || "",
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
