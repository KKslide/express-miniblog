const mysql = require("mysql");
// const connection = mysql.createConnection({
//     host: "47.112.232.140",
//     // host: "localhost", // 在家
//     user: "root",
//     // password: "rootroot", // 在家
//     port: '3306',
//     database: "myblog",
// });

/**
 * 创建连接池, 防止连接超时失效504 link👉https://github.com/mysqljs/mysql#pooling-connections
 */
const pool = mysql.createPool({
    // host: "47.112.232.140",
    host: "localhost", // 在家
    user: "root",
    // password: "Lykang1105*",
    password: "rootroot", // 在家
    port: '3306',
    database: "myblog"
})

/* 连接数据库 */
// connection.connect(function (err) {
//     if (err) {
//         console.error('error connecting: ' + err.stack);
//         return;
//     }
//     console.log('mysql connected');
// });

pool.getConnection(err => {
    if (err) throw err;
    console.log('数据库连上啦- -。');
})

module.exports = pool;