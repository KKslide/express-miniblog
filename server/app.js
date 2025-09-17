var createError = require('http-errors');
var express = require('express');
var bodyParser = require('body-parser');
var path = require('path');
var session = require('express-session');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var router = require('./lib/router');

var app = express();

app.use(bodyParser.json({limit: '200mb'})); // for parsing application/json
app.use(bodyParser.urlencoded({limit: '200mb', extended: true })); // for parsing application/x-www-form-urlencoded

// 跨域
app.all('*', function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    //Access-Control-Allow-Headers ,可根据浏览器的F12查看,把对应的粘贴在这里就行
    res.header('Access-Control-Allow-Headers', 'Content-Type, Content-Length, Authorization, Accept, X-Requested-With , whatever, sessionToken');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    // res.header('Access-Control-Allow-Credentials', true);
    res.header('Content-Type', 'application/json;charset=utf-8');
    res.header('Access-Control-Max-Age', '3600');
    if (req.method === 'OPTIONS') {
      return res.sendStatus(204) // 预检请求直接返回
    }
    next();
});

// session配置
app.use(session({
    name: 'sid',
    secret: "session_id",
    resave: false,
    saveUninitialized: true,
    cookie: {
        httpOnly: true,     // 防止前端通过 JS 读取 cookie
        maxAge: 10 * 60 * 1000  // 保存10分钟
    },
    rolling: true
}));

// view engine setup
// app.set('view engine', 'html')

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
// 静态资源托管
// app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'upload')));
app.use(express.static(path.join(__dirname, '../dist')));
// app.use(express.static(path.join(__dirname, '/')))

/* GET page. */
// app.get('/', function (req, res, next) {
//     res.type('html');
//     res.render('index');
// });

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../dist', 'index.html'));
});

app.use(router);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    res.status(err.status || 500);
    // res.render('error');
    res.send((`
        <h1>Error</h1>
        <p>${err.message}</p>
        <pre>${req.app.get('env') === 'development' ? err.stack : ''}</pre>
    `))
});

module.exports = app;
