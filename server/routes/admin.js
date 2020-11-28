var express = require("express");
var path = require("path");
var md5 = require("md5");

var router = express.Router();
var User = require("../models/user");
var Category = require("../models/category");
var Content = require("../models/content");
var Massage = require("../models/massage");
var Visitor = require("../models/visitor");
var formidable = require("formidable"); // 用来处理上传图片的

// 检测是否登陆
router.get('/isadmin', (req, res, next) => {
    if (JSON.stringify(req.cookies) == "{}") {
        res.json({ code: 0, msg: "请先登录啦" })
    } else {
        res.json({ code: 1, islogin: 'logined', msg: "登陆成功" })
    }
});

// 登陆接口
router.post('/login', (req, res, next) => {
    var username = req.body.username || req.query.username || "";
    var password = req.body.password || req.query.password || "";

    console.log('username', username);
    console.log('password', password);

    User.findOne({
        username: username,
        // password: md5(password)
        password: password
    }, function (err, userinfo) {
        if (err) {
            console.log(err);
        }
        if (!userinfo) {
            res.json({ code: 0, msg: "用户名或密码错误！" });
            return false;
        }

        res.cookie("userInfo", JSON.stringify({
            "_id": userinfo._id,
            "username": userinfo.username,
            "isadmin": userinfo.isadmin
        }), { maxAge: 1000 * 60 * 60, httpOnly: true }) // 现在先存一个小时吧

        res.json({
            code: 1,
            msg: "登录成功！",
            userinfo: {
                id: userinfo._id,
                username: userinfo.username
            }
        });

    })

});

// 退出登陆接口
router.get('/logout', (req, res, next) => {
    res.cookie('userInfo', null, { expires: new Date(0) });
    res.json({ code: 1, msg: "退出成功" })
})

// 后台首页接口
router.get('/getgeneral', (request, response, next) => {
    let tempUserNum, tempAtcNum;
    let pieData = [];
    User.find()
        .then(res => {
            tempUserNum = res
            return Content.find().populate('category')
                .then(res => {
                    tempAtcNum = res // 查询出的文章内容信息
                    // 分类名去重
                    let temp = Array.from(new Set(tempAtcNum.map(v => { return v.category.name })))
                    for (let i = 0; i < temp.length; i++) {
                        let tempObj = {}
                        let tempAtcArr = []
                        for (let j = 0; j < tempAtcNum.length; j++) {
                            if (temp[i] == tempAtcNum[j].category.name) {
                                tempAtcArr.push(tempAtcNum[j])
                            }
                        }
                        tempObj.name = temp[i]
                        tempObj.value = tempAtcArr.length
                        pieData.push(tempObj)
                    }
                    return Visitor.find().then(result => {
                        let toDayData = result.filter((v, i) => { // 过滤今日数据
                            return new Date().getTime() - new Date(v.time) < 86400000
                        })
                        // console.log(toDayData.length, '----', toDayData);
                        let line_chart_data = []
                        let curHour = new Date().getHours()
                        // for (let i = 0; i < 24; i++) {
                        //     let _temparr = toDayData.filter(v => {
                        //         return new Date(v.time).getHours() == i
                        //     })
                        //     line_chart_data.push({ time: i, value: _temparr.length })
                        // }
                        for (let i = curHour; i > (curHour - 24); i--) {
                            let _temparr = toDayData.filter(v => {
                                let tempHour = i < 0 ? (i + 24) : i;
                                return new Date(v.time).getHours() == tempHour
                            })
                            // if(i<0){

                            // }else{
                            // }
                            line_chart_data.push({ time: i < 0 ? (i + 24) : i, value: _temparr.length })
                        }
                        response.json({
                            tag_list: [
                                { tag: "总访问量", value: result.length },
                                { tag: "今日访问量", value: toDayData.length },
                                { tag: "用户", value: tempUserNum.length },
                                { tag: "文章数", value: tempAtcNum.length }
                            ],
                            pie_chart_data: pieData,
                            line_chart_data: line_chart_data.reverse()
                        })
                    })
                })
        })
})

// 获取用户列表接口
router.get("/getuser", function (req, res, next) {

    var page = Number(req.query.page || 1);
    var limit = 8;
    var skip = (page - 1) * limit;
    var total;
    var counts;
    User.count().then(function (count) {
        total = Math.ceil(count / limit);
        page = Math.max(1, page);
        page = Math.min(page, total);
        counts = count;
    });
    User.find().limit(limit).skip(skip).then(function (users) {

        res.json({
            userInfo: req.userInfo,
            users: users,
            page: page,
            total: total,
            counts: counts
        })
    });

});

// 获取文章分类接口
router.get("/categories", (req, res, next) => {
    Category.find().sort({ _id: -1 }).then(function (categories) {
        res.json({
            userInfo: req.userInfo,
            categories: categories
        });
    });
});

// 新增文章分类
router.post("/categories/add", (req, res, next) => {
    var name = req.body.name || "";
    var banner = req.body.banner || "";
    Category.findOne({ name: name }, function (err, info) {
        if (err) console.log(err);
        if (info) {
            res.json({ code: 0, msg: "出错了！请联系我！" });
            return false;
        }
        var newcate = new Category({
            name: name,
            addtime: new Date(),
            edittime: new Date(),
            banner: banner
        });
        newcate.save();
        res.json({ code: 1, msg: "新增成功！" });
    });
    // }
});

// 删除文章分类
router.post('/categories/del', (req, res, next) => {
    var id = req.body.id || "";
    Category.deleteOne({ _id: id }, function (err) {
        if (err) {
            res.json({ code: 0, msg: "出错了 !" })
            return false;
        } else {
            res.json({ code: 1, msg: "删除成功 !" });
        }
    });
});

// 修改文章分类名称
router.post('/categories/edit', (req, res, next) => {
    var name = req.body.name || "";
    var id = req.body.id || "";
    var banner = req.body.banner || "";
    // console.log(req.query);
    // console.log(req.body);
    Category.findOne({ _id: id }, function (err, info) {
        if (err) {
            res.json({ code: 0, msg: "更新失败，打电话给我吧！" })
            console.log(err);
        }
        if (info) {
            // console.log(info);
            info.name = name;
            info.banner = banner;
            info.edittime = new Date();
            info.save();
            res.json({ code: 1, msg: "更新成功，哥要睡觉了！" })
        }

    });
});

// 获取文章接口
router.get("/articles", (req, res, next) => {
    var resObj = {
        // category : req.query.category||req.body.category||"",
        count: 0, // 总数
        page: Number(req.query.page || req.body.page || 1), // 当前页
        limit: 6, // 页容量(每页有多少条数据)
        pages: 0, // 页总数
    };

    Content.count().then(count => {
        resObj.count = count; // 
        resObj.pages = Math.ceil(resObj.count / resObj.limit); // 页总数
        resObj.page = Math.min(resObj.page, resObj.pages); // 取值不能超过总页数
        resObj.page = Math.max(resObj.page, 1); // 取值不能小于1
        var skip = (resObj.page - 1) * resObj.limit;
        return Content.find().limit(resObj.limit).skip(skip).populate(["category", "user"]).sort({ addtime: -1 });
    }).then(contents => {
        res.json({
            userInfo: req.userInfo,
            contents: contents,
            total: resObj.count,
            pages: resObj.pages,
            pageSize: resObj.limit
        });
    })

    // Content.find().populate(["category", "user"]).sort({ _id: -1 }).then(function (contents) {
    //     res.json({
    //         userInfo: req.userInfo,
    //         contents: contents
    //     });
    // });
})

// 添加文章接口
router.post('/articles/add', (req, res, next) => {
    var title = req.body.title || "";
    var category = req.body.category || "";
    var description = req.body.description || "";
    var video_src = req.body.video_src || "";
    var content = req.body.content || "";
    var minpic_url = req.body.minpic_url || req.query.minpic_url || "";
    var isShow = req.body.isShow || req.query.isShow || 1;
    var newcontent = new Content({
        title: title,
        category: category,
        description: description,
        video_src: video_src,
        composition: content,
        minpic_url: minpic_url,
        addtime: new Date(),
        num: 0,
        isShow: isShow,
        // user: "5d9163d84bc06239aa26d9c3" // 暂时写死这个 后期再加cookie
        user: JSON.parse(req.cookies.userInfo)._id || 'unknown'
    });
    newcontent.save();
    res.json({ code: 1, msg: "添加文章成功 !" })
})

// 删除文章接口
router.post('/articles/del', (req, res, next) => {
    var id = req.body.id || req.query.id || "";
    Content.deleteOne({ _id: id }, function (err) {
        if (err) {
            res.json({ code: 0, msg: "出错了 !" })
            return false;
        } else {
            res.json({ code: 1, msg: "删除成功 !" });
        }
    });
});

// 编辑文章接口
router.post("/content/edit", function (req, res) {
    var id = req.query.id || req.body.id || "";
    var title = req.body.title || "";
    var category = req.body.category || "";
    var description = req.body.description || "";
    var video_src = req.body.video_src || "";
    var minpic_url = req.body.minpic_url || "";
    var content = req.body.content || "";
    var isShow = req.body.isShow || req.query.isShow || 1;
    var comment = req.body.comment || req.query.comment || [];
    Content.update({ _id: id }, {
        title: title,
        category: category,
        description: description,
        video_src: video_src,
        minpic_url: minpic_url,
        composition: content,
        // addtime: new Date(),
        comment: comment,
        isShow: isShow,
        user: JSON.parse(req.cookies.userInfo)._id
    }).then(function () {
        res.json({
            // userInfo: req.userInfo,
            code: 1,
            message: "ok!修改成功"
        });
    }).catch(err => {
        console.log(err);
    })
});

// 图片上传接口
router.post("/content/img_upload", function (req, res) {
    var form = new formidable.IncomingForm()
    form.uploadDir = "./upload";
    form.keepExtentsions = true;
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
                // path: 'http://' + ip + '/' + path.basename(files.image.path)
                path: 'http://47.112.232.140/' + path.basename(files.image.path)
            })
        }
    })
});

// 文章缩略图上传接口
router.post("/content/mpic_upload", function (req, res, next) {
    var form = new formidable.IncomingForm()
    form.uploadDir = "./upload";
    form.keepExtentsions = true;
    form.parse(req, function (err, fields, files) {
        console.log(files);
        if (err) {
            console.log(err);
            res.json({ code: 0, msg: "上传失败！" });
        } else {
            var ip = req.headers['x-real-ip'] ? req.headers['x-real-ip'] : req.ip.replace(/::ffff:/, '');
            res.json({
                code: 1,
                msg: "上传成功！",
                // path: 'http://' + ip + '/' + path.basename(files.file.path)
                path: 'http://47.112.232.140/' + path.basename(files.file.path) // 腾讯云- 现在的上传接口
            })
        }

    })
});

// 获取留言列表
router.get("/massage", function (req, res, next) {
    var resObj = {
        count: 0, // 总数
        page: Number(req.query.page || req.body.page || 1), // 当前页
        limit: 5, // 页容量(每页有多少条数据)
        pages: 0, // 页总数
    };
    Massage.count().then(count => {
        resObj.count = count; // 
        resObj.pages = Math.ceil(resObj.count / resObj.limit); // 页总数
        resObj.page = Math.min(resObj.page, resObj.pages); // 取值不能超过总页数
        resObj.page = Math.max(resObj.page, 1); // 取值不能小于1
        var skip = (resObj.page - 1) * resObj.limit;
        return Massage.find().limit(resObj.limit).skip(skip).sort({ addtime: -1 });
    }).then(contents => {
        res.json({
            userInfo: req.userInfo,
            massages: contents,
            total: resObj.count,
            pages: resObj.pages,
            pageSize: resObj.limit
        });
    })
    // Massage.find().sort({ addtime: -1 }).then(function (contents) {
    //     res.json({
    //         userInfo: req.userInfo,
    //         massages: contents
    //     });
    // });
});

// 留言删除接口
router.post("/massage/del", function (req, res, next) {
    var id = req.body.ids || req.query.ids || [];
    Massage.deleteMany({ _id: { $in: id } }).then((err, resData) => {
        // if (err) {
        console.log(err);
        //     res.json({ code: 0, msg: "删除失败!" })
        // } else {
        res.json({
            code: 1,
            msg: "删除成功!",
            resData: resData
        })
        // }
    })
});

module.exports = router;