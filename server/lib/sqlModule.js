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

/* ***************************************************** */
/**
 * 前端页面
 */
module.exports.getIndexPageData = function (options, callback) {
    var table = options.table || 'article';
    var isVlog = options.listType == 'vlog' ? 'Vlog' : ''; // 查询列表是否为vlog类型
    var sql = `
        SELECT
            a.id,
            a.title,
            c.name as 'category',
            a.composition,
            a.description,
            a.addtime,
            a.viewnum,
            a.minpic_url,
            a.video_src,
            a.is_show,
            a.is_del
        FROM ${table} a
        LEFT JOIN category c ON a.category = c.id
        WHERE a.is_del = '0'` ;
    sql += isVlog == 'Vlog'
        ? `and c.name = '${isVlog}'`
        : `and c.name != 'Vlog'`;
    sql += `ORDER BY a.addtime `;
    console.log(sql);
    connection.query(sql, (err, data) => {
        if (err) {
            console.log(err);
            callback(null, err);
        } else {
            callback(null, data);
        }
    })
}

/**
 * 获取文章详情, 包括评论部分
 */
module.exports.getContentDetail = function (options, callback) {
    var id = options.id;
    console.log(id);
    var contentSql = `select * from article where id = ${id}`;
    var commentSql = `select * from comment where id = ${id}`;
    connection.query(contentSql, (err, data) => {
        // 1.查询当前文章
        var contentList = data;
        connection.query(commentSql, (err, data) => {
            var commentList = data; // 评论列表
            // 过滤数据
            contentList[0].comment = commentList;
            callback(null, contentList);
        })
    })
}