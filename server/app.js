var createError = require('http-errors');
var express = require('express');
// var session = require("express-session");
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var adminRouter = require('./routes/admin');
var uploadRouter = require('./routes/upload'); // 上传图片路由接口

//加载mongoose数据库，这个中间件是nodejs与mongoDB数据库的桥梁
var mongoose = require("mongoose");
// var Cookies = require('cookies');

// 连接数据库
// mongoose.connect("mongodb://localhost:27017/myBlog"); // 本地
mongoose.connect("mongodb://47.107.164.180:27017/myBlog"); // 线上
var db = mongoose.connection;
db.once("open", function () {
    console.log("Mongo Connected");
});
db.on("error", console.error.bind(console, "Mongoose Connection Error"));

var app = express();

// 跨域
// app.all('*', function (req, res, next) {
//     res.header('Access-Control-Allow-Origin', '*');
//     //Access-Control-Allow-Headers ,可根据浏览器的F12查看,把对应的粘贴在这里就行
//     res.header('Access-Control-Allow-Headers', 'Content-Type:text/html');
//     res.header('Access-Control-Allow-Methods', '*');
//     res.header('Content-Type', 'application/json;charset=utf-8');
//     next();
// });

// session配置
// app.use(session({
//     secret: "session_id",
//     resave: false,
//     saveUninitialized: true,
//     cookie: {
//         maxAge: 600 * 1000  // 保存一分钟
//     },
//     rolling: true
// }));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
// 静态资源托管(其实刚开始不是很需要啦)
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'upload')));
app.use(express.static(path.join(__dirname, 'dist')));

app.use('/index', indexRouter);
app.use('/users', usersRouter);
app.use('/admin', adminRouter);

app.use('/pic',uploadRouter);

/* GET page. */
app.get('/', function(req, res, next) {
    res.type('html');
    res.render('index');
  });

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.render('error');
});

//分模块开发，便于管理，分为前台展示模块，后台管理模块及逻辑接口模块
// app.use("/admin", require("./routes/admin"));
// app.use("/", require("./routers/main"));
// app.use("/api", require("./routers/api"));


module.exports = app;
