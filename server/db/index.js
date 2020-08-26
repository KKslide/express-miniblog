var mysql = require("mysql");
var connection = mysql.createConnection({
    host: "134.175.129.219",
    // host: "localhost", // 在家
    user: "root",
    password: "Lyk1105*",
    // password: "rootroot", // 在家
    port:'3306',
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