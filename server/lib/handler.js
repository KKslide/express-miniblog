var util = require('../util/util');
/* sql操作 */
var dbMoudle = require('./sqlModule');

/* 七牛云图片上传 */
var qiniuUpload = require('./qiniu.config');
module.exports.doUpload = function (req, res) {
    qiniuUpload.picUpload(req, res);
}

/* --------------------------前端------------------------- */
/* 获取blog列表数据 或 vlog列表数据 */
module.exports.getIndexPage = function (req, res) {
    var opt = {
        'table': 'article',
        'listType': req.body.list_type || req.query.list_type || '' // 查询列表是否为vlog类型
    };
    dbMoudle.getIndexPageData(opt, (err, data) => {
        console.log(data, "\n----- 前端页面数据 -----");
        res.json(data);
    })
}

/* 获取详情页 */
module.exports.getContentPage = function (req, res) {
    var opt = {
        id: req.body.contentid || req.query.contentid
    }
    dbMoudle.getContentDetail(opt, (err, data) => {
        console.log(data);
        res.json(data);
    })
}

/* 评论文章 */
module.exports.Comment = function (req, res) {
    var opt = {
        'table': 'comment',
        'id': `'${req.body.contentid || req.query.contentid}'`,
        'data': {
            'a_id': `${req.body.contentid || req.query.contentid}`,
            'user': `'${req.body.visitor || req.query.visitor}'`,
            'comment': `'${req.body.comment || req.query.body.comment}'`,
            'ip': `'${util.getClientIp(req).match(/(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)/)[0]}'`,
            'time': `'${util.getNow()}'`
        }
    }
    dbMoudle.doAdd(opt, (err, data) => {
        if (err) {
            res.json(err)
        } else {
            res.json({ code: "1", msg: "ok" })
        }
    })
}

/* 用户留言 */
module.exports.leaveMessage = function (req, res) {
    var opt = {
        'table': 'messages',
        'data': {
            'addtime': `'${util.getNow()}'`,
            'viewer': `'${req.query.viewer || req.body.viewer}'`,
            'message': `'${req.query.message || req.body.message}'`,
            'ip': `'${util.getClientIp(req).match(/(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)/)[0]}'`
        }
    }
    dbMoudle.doAdd(opt, (err, data) => {
        if (err) {
            res.json(err)
        } else {
            res.json({ code: "1", msg: "ok" })
        }
    })
}

/* 访问统计 */
module.exports.visitRecord = function (req, res) {
    var opt = {
        'table': 'visitors',
        'data': {
            'ip': `'${util.getClientIp(req).match(/(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)/)[0]}'`,
            'time': `'${util.getNow()}'`,
        }
    }
    dbMoudle.doAdd(opt, (err, data) => {
        if (err) {
            res.json(err);
        } else {
            res.json({ code: "1", msg: "ok" });
        }
    })
}


/* --------------------------管理页------------------------- */
/* 登陆 */
module.exports.doLogin = function (req, res) {
    let opt = {
        username: req.body.username || req.query.username || "",
        password: req.body.password || req.query.password || ""
    }
    console.log('username', opt.username);
    console.log('password', opt.password);
    dbMoudle.loginQuery(opt, (err, data) => {
        if (err) {
            res.json({ code: 0, msg: '', err: err });
        }
        let userInfo = data;
        if (data.length == 0) {
            res.json({ code: 0, msg: "用户名或密码错误！" });
            return false;
        } else {
            res.cookie("userInfo", JSON.stringify({
                "id": userInfo[0].id,
                "username": userInfo[0].username
            }), { maxAge: 1000 * 60 * 60, httpOnly: true }) // cookie存储一个小时

            res.json({
                code: 1,
                msg: '登陆成功! ',
                userInfo: {
                    id: userInfo[0].id,
                    username: userInfo[0].username
                }
            });
        }
    });
}

/* *********************管理页首页********************* */
module.exports.getDashboard = function (req, res) {
    dbMoudle.getDashboardData((err, data) => {
        if (err) {
            res.json(err)
        } else {
            res.json(data)
        }
    })
}

/* *********************分类管理********************* */
/* 分类-获取 */
module.exports.getCategory = function (req, res) {
    var opt = {
        table: 'category',
        pageNo: req.body.pageNo || 1,
        pageSize: req.body.pageSize || 10,
        type: req.body.serchType || null
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
    dbMoudle.doAdd(obj, (err, data) => {
        res.json({ code: 1, msg: "success" });
    })
}
/* 分类-删除 */
module.exports.delCategory = function (req, res) {
    var opt = {
        table: 'category',
        id: req.body.id
    };
    dbMoudle.doDel(opt, (err, data) => {
        res.json({ code: 1, msg: "删除成功" });
    })
}
/* 分类-修改 */
module.exports.editCategory = function (req, res) {
    var obj = {
        'table': 'category',
        'id': req.body.id,
        'data': {
            'name': `"${req.body.name}"`,
            'banner': `"${req.body.banner}"`,
            'edittime': `"${util.getNow()}"`
        }
    }
    dbMoudle.doEdit(obj, (err) => {
        res.json({ code: 1, msg: "修改成功" });
    })
}

/* *********************文章管理********************* */
/* 文章-获取 */
module.exports.getArticle = function (req, res) {
    var opt = {
        table: 'article',
        type: 'articles',
        pageNo: req.body.pageNo || req.query.pageNo || 1,
        pageSize: req.body.pageSize || req.query.pageSize || 10
    };
    dbMoudle.doQuery(opt, (err, data) => {
        res.json({ data });
    });
}
/* 文章-新增 */
module.exports.addArticle = function (req, res) {
    var obj = {
        'table': 'article',
        'data': {
            'title': `'${req.body.title}'`,
            'category': `'${req.body.category}'`,
            'composition': `'${req.body.content}'`,
            'description': `'${req.body.description}'`,
            'addtime': `'${util.getNow()}'`,
            'viewnum': 0,
            'minpic_url': `'${req.body.minpic_url}'`,
            'video_src': `'${req.body.video_src}'`
        }
    }
    dbMoudle.doAdd(obj, (err, data) => {
        res.json({ code: 1, msg: "success" });
    })
}
/* 文章-删除 */
module.exports.delArticle = function (req, res) {
    var opt = {
        'table': 'article',
        'id': req.body.id
    }
    dbMoudle.doDel(opt, (err, data) => {
        res.json({ code: 1, msg: "删除成功" });
    });
}
/* 文章-修改 */
module.exports.editArticle = function (req, res) {
    var opt = {
        'table': 'article',
        'id': req.body.id,
        'data': {
            'title': `'${req.body.title}'`,
            'category': `'${req.body.category}'`,
            'composition': `'${req.body.content}'`,
            'description': `'${req.body.description}'`,
            'minpic_url': `'${req.body.minpic_url}'`,
            'video_src': `'${req.body.video_src}'`,
            'is_show': `'${req.body.is_show}'`
        }
    };
    dbMoudle.doEdit(opt, (err) => {
        if (err) {
            res.json({ code: 0, err: err })
        } else {
            res.json({ code: 1, msg: "修改成功" });
        }
    })
}

/* *********************评论管理********************* */
/* 文章评论-获取 */
module.exports.getComment = function (req, res) {
    var opt = {
        id: req.body.id || req.query.id
    }
    dbMoudle.queryCommentList(opt, (err, data) => {
        res.json(data);
    })
}
/* 文章评论-删除 */
module.exports.delComment = function (req, res) {
    var opt = {
        id: req.body.id || req.query.id,
        table: 'comment'
    }
    dbMoudle.doDel(opt, (err, data) => {
        res.json({ code: 1, msg: "删除成功" });
    })
}

/* *********************留言管理********************* */
/* 留言-获取 */
module.exports.getMessages = function (req, res) {
    var opt = {
        table: 'messages',
        type: 'all'
    }
    dbMoudle.doQuery(opt, (err, data) => {
        res.json(data);
    });
}
module.exports.adminGetMessages = function (req, res) {
    var opt = {
        table: 'messages',
        pageNo: req.body.pageNo || req.query.pageNo || 1,
        pageSize: req.body.pageSize || req.query.pageSize || 10
    }
    dbMoudle.queryMessageList().then(messageCount => {
        dbMoudle.doQuery(opt, (err, data) => {
            console.log('pages: ', Math.ceil(messageCount / opt.pageSize));
            console.log('total: ', messageCount);
            res.json({
                'messages': data,
                'pages': Math.ceil(messageCount / opt.pageSize), // 页数长度
                'total': messageCount
            });
        });
    })
}
/* 留言删除 */
module.exports.delMessage = function (req, res) {
    var opt = {
        table: 'messages',
        id: req.body.id || req.query.id
    }
    dbMoudle.doDel(opt, (err, data) => {
        res.json({ code: 1, msg: "删除成功" });
    });
}