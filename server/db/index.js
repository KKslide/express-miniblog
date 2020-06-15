var mysql = require("mysql");
var connection = mysql.createConnection({// 在家
    host: "localhost",
    user: "root",
    password: "root",
    database: "myblog",
});

/* 连接数据库 */
connection.connect(function (err) {
    if (err) {
        console.error('error connecting: ' + err.stack);
        return;
    }
    console.log('mysql connected');
});

module.exports = connection;