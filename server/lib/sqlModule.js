var connection = require("../db/index"); // 数据库连接配置

/**
 * CRUD
 */
/* 查询 */
module.exports.doQuery = function (options, callback) {
    var table = options.table; // 要查询的表格
    var pageNo = options.pageNo || 0; // 页码
    var pageSize = options.pageSize || 0; // 页容量
    var serchType = options.type; // 条件- 是否全量查询
    var indexType = options.indexType;
    // select * from table limit (pageNo-1)*pageSize,pageSize;
    var sql = serchType == 'all'
        ? `SELECT * FROM ${table} where is_del='0'`
        : `SELECT * FROM ${table} where is_del='0' limit ${pageNo - 1},${pageSize}`;
    connection.query(sql, (err, data) => {
        if (err) {
            console.log(err);
            callback(null, err);
        } else {
            callback(null, data);
        }
    })
}
/* 新增 */
module.exports.doAdd = function (options, callback) {
    var table = options.table;
    var keys = Object.keys(options.data);
    var values = Object.values(options.data);
    var sql = `insert into ${table} (${[...keys]}) values (${[...values]}) `;
    connection.query(sql, (err, res) => {
        if (res.affectedRows == 1) {
            callback();
        } else {
            callback(err);
        }
    })
}
/* 删除 */
module.exports.doDel = function (options, callback) {
    var id = options.id;
    var table = options.table;
    var sql = `update ${table} set is_del='1' where id=${id}`;
    connection.query(sql, (err, res) => {
        if (res.affectedRows == 1) {
            callback();
        } else {
            callback(err);
        }
    })
}
/* 修改 */
module.exports.doEdit = function (options, callback) {
    var table = options.table,
        id = options.id,
        keys = Object.keys(options.data),
        values = Object.values(options.data),
        queryStr = (function (key, value) {
            var str = "";
            key.forEach((v, i) => {
                str += v + "=" + value[i] + ","
            });
            return str.substr(0, str.length - 1);
        })(keys, values);

    var sql = `update ${table} set 
                        ${queryStr}
                    where id = ${id} `;
    connection.query(sql, (err, res) => {
        if (err) {
            console.log(err);
            callback(err);
        }
        if (res.affectedRows == 1) {
            callback();
        }
    })
}