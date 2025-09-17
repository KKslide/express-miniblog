const mysql = require("mysql");
const util = require("util");

/**
 * 创建连接池, 防止连接超时失效504 link👉https://github.com/mysqljs/mysql#pooling-connections
 */
const pool = mysql.createPool({
    host: "localhost", // 在家
    user: "root",
    password: "rootroot", // 在家
    port: '3306',
    database: "myblog",
    charset: 'utf8mb4'
})

pool.getConnection(err => {
    if (err) throw err;
    console.log('数据库连上啦- -。');
})

// 绑定原始 query（保留原 callback 写法）
const originalQuery = pool.query.bind(pool)

// 添加一个 async 的 query 方法（支持 await）
pool.queryAsync = util.promisify(originalQuery)

module.exports = pool;