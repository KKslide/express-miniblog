var connection = require("../db/index"); // 数据库连接配置

function queryPromise(sql) {
    return new Promise((resolve, reject) => {
        connection.query(sql, (err, data) => {
            if (err) {
                reject(err)
            } else {
                resolve(data)
            }
        })
    })
}

/**
 * CRUD
 */
/* 查询 */
module.exports.doQuery = function (options, callback) {
    var table = options.table; // 要查询的表格
    var pageNo = options.pageNo; // 页码
    var pageSize = options.pageSize; // 页容量
    var searchType = options.type; // 条件- 是否全量查询
    // select * from table limit (pageNo-1)*pageSize,pageSize;
    var sql = ``;
    switch (searchType) {
        case 'all': // 0- 普通全量查询(多用于前端)
            sql += `SELECT * FROM ${table} where is_del='0'`;
            break;
        case 'articles': // 1- 文章管理端的查询
            // sql += `SELECT aaa.total, a.* FROM ${table} a,(select count(*) total from ${table}) aaa limit ${(pageNo - 1)*pageSize},${pageSize}`;
            sql += `
                select 
                (select count(*) from article) total,
                count(cm.a_id) comment_num,
                a.* 
                from article a 
                left join comment cm on a.id=cm.a_id 
                and cm.is_del='0'
                group by a.id 
                limit ${(pageNo - 1) * pageSize},${pageSize}`;
            break;
        default: // 2- 常规查询
            sql += `SELECT * FROM ${table} where is_del='0' limit ${(pageNo - 1) * pageSize},${pageSize}`
            break;
    }
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
/* 新增 */
module.exports.doAdd = function (options, callback) {
    var table = options.table;
    var keys = Object.keys(options.data);
    var values = Object.values(options.data);
    var sql = `insert into ${table} (${[...keys]}) values (${[...values]}) `;
    console.log(sql);
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
    var sql = `update ${table} set is_del='1' where ${table == 'comment' ? 't_id' : 'id'} = ${id}`;
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

/**
 * 后台管理页一些恶心查询↓
 */
/* 管理页首页数据 */
module.exports.getDashboardData = function (callback) {
    var sql = `
        SELECT
        ( SELECT count( * ) FROM visitors ) AS 'visitTotal', /*总访问量*/
        ( SELECT count( * ) FROM visitors WHERE time >= NOW( ) - INTERVAL 1 HOUR ) AS 'visitToday', /*今日访问量*/
        ( SELECT count( * ) FROM users ) AS 'userNum', /*用户数*/
        ( SELECT count( * ) FROM article ) AS 'arcticleNum', /*文章数*/
        ( SELECT count( * ) FROM category WHERE name = 'Fun' ) AS 'Fun',
        ( SELECT count( * ) FROM category WHERE name = 'Blog' ) AS 'Blog',
        ( SELECT count( * ) FROM category WHERE name = 'Vlog' ) AS 'Vlog',
        ( SELECT count( * ) FROM category WHERE name = 'Code' ) AS 'Code',
        ( SELECT count( * ) FROM category WHERE name != 'Fun' AND name != 'Blog' and name!='Vlog' AND name != 'Code' ) AS 'Other' 
    `;
    var resData;
    new Promise((resolve, reject) => {
        connection.query(sql, (err, data) => {
            resData = {
                "tag_list": [
                    { "tag": "总访问量", "value": data[0]['visitNum'] },
                    { "tag": "今日访问量", "value": data[0]['visitToday'] },
                    { "tag": "用户", "value": data[0]['userNum'] },
                    { "tag": "文章数", "value": data[0]['arcticleNum'] }
                ],
                "pie_chart_data": [
                    { "name": "Fun", "value": data[0]['Fun'] },
                    { "name": "Blog", "value": data[0]['Blog'] },
                    { "name": "Vlog", "value": data[0]['Vlog'] },
                    { "name": "Code", "value": data[0]['Code'] },
                    { "name": "Other", "value": data[0]['Other'] }
                ],
            }
            resolve(data)
        })
    }).then(resData => {
        // console.log(resData);
        var sql2 = `
                SET @hour_0 := date_format(now() - interval 0 hour,'%H:00');
                SET @hour_1 := date_format(now() - interval 1 hour,'%H:00');
                SET @hour_2 := date_format(now() - interval 2 hour,'%H:00');
                SET @hour_3 := date_format(now() - interval 3 hour,'%H:00');
                SET @hour_4 := date_format(now() - interval 4 hour,'%H:00');
                SET @hour_5 := date_format(now() - interval 5 hour,'%H:00');
                SET @hour_6 := date_format(now() - interval 6 hour,'%H:00');
                SET @hour_7 := date_format(now() - interval 7 hour,'%H:00');
                SET @hour_8 := date_format(now() - interval 8 hour,'%H:00');
                SET @hour_9 := date_format(now() - interval 9 hour,'%H:00');
                SET @hour_10 := date_format(now() - interval 10 hour,'%H:00');
                SET @hour_11 := date_format(now() - interval 11 hour,'%H:00');
                SET @hour_12 := date_format(now() - interval 12 hour,'%H:00');
                SET @hour_13 := date_format(now() - interval 13 hour,'%H:00');
                SET @hour_14 := date_format(now() - interval 14 hour,'%H:00');
                SET @hour_15 := date_format(now() - interval 15 hour,'%H:00');
                SET @hour_16 := date_format(now() - interval 16 hour,'%H:00');
                SET @hour_17 := date_format(now() - interval 17 hour,'%H:00');
                SET @hour_18 := date_format(now() - interval 18 hour,'%H:00');
                SET @hour_19 := date_format(now() - interval 19 hour,'%H:00');
                SET @hour_20 := date_format(now() - interval 20 hour,'%H:00');
                SET @hour_21 := date_format(now() - interval 21 hour,'%H:00');
                SET @hour_22 := date_format(now() - interval 22 hour,'%H:00');
                SET @hour_23 := date_format(now() - interval 23 hour,'%H:00');

                SET @query := CONCAT('select ', 
                '(select count(*) from visitors where  time >=(NOW() - interval 1 hour) and time < (NOW() - interval 0 hour) ) as "', @hour_0 ,'",',
                '(select count(*) from visitors where  time >=(NOW() - interval 2 hour) and time < (NOW() - interval 1 hour) ) as "', @hour_1, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 3 hour) and time < (NOW() - interval 2 hour)) as "', @hour_2, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 4 hour) and time < (NOW() - interval 3 hour)) as "', @hour_3, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 5 hour) and time < (NOW() - interval 4 hour)) as "', @hour_4, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 6 hour) and time < (NOW() - interval 5 hour)) as "', @hour_5, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 7 hour) and time < (NOW() - interval 6 hour)) as "', @hour_6, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 8 hour) and time < (NOW() - interval 7 hour)) as "', @hour_7, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 9 hour) and time < (NOW() - interval 8 hour)) as "', @hour_8, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 10 hour) and time < (NOW() - interval 9 hour)) as "', @hour_9, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 11 hour) and time < (NOW() - interval 10 hour)) as "', @hour_10, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 12 hour) and time < (NOW() - interval 11 hour)) as "', @hour_11, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 13 hour) and time < (NOW() - interval 12 hour)) as "', @hour_12, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 14 hour) and time < (NOW() - interval 13 hour)) as "', @hour_13, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 15 hour) and time < (NOW() - interval 14 hour)) as "', @hour_14, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 16 hour) and time < (NOW() - interval 15 hour)) as "', @hour_15, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 17 hour) and time < (NOW() - interval 16 hour)) as "', @hour_16, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 18 hour) and time < (NOW() - interval 17 hour)) as "', @hour_17, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 19 hour) and time < (NOW() - interval 18 hour)) as "', @hour_18, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 20 hour) and time < (NOW() - interval 19 hour)) as "', @hour_19, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 21 hour) and time < (NOW() - interval 20 hour)) as "', @hour_20, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 22 hour) and time < (NOW() - interval 21 hour)) as "', @hour_21, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 23 hour) and time < (NOW() - interval 22 hour)) as "', @hour_22, '",',
                '(select count(*) from visitors where  time >=(NOW() - interval 24 hour) and time < (NOW() - interval 23 hour)) as "', @hour_23, '"'
                );
                -- PREPARE dynamic_statement FROM @query;
                -- EXECUTE dynamic_statement; 
                select @query as 'aaa';
                `;

        connection.query(sql2,(err,data)=>{
            if(err){
                console.log(err);
            }
            console.log('AAAAAAAA',data[0]);
        })
    })
}
/* 文章评论管理查询 */
module.exports.queryCommentList = function (options, callback) {
    var id = options.id;
    var sql = ` select * from comment where a_id=${id} and is_del='0' `;
    connection.query(sql, (err, data) => {
        if (err) {
            console.log(err);
            callback(null, err);
        } else {
            callback(null, data);
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
    var sql =
        `SELECT
                a.id,
                a.title,
                cat.name AS 'category',
                a.composition,
                a.description,
                a.addtime,
                a.viewnum,
                a.minpic_url,
                a.video_src,
                a.is_show,
                a.is_del,
                IFNULL( temp.comment_num, 0 ) AS 'comment_num'
            FROM
                article a
                LEFT JOIN category cat ON a.category = cat.id
                LEFT JOIN ( SELECT a_id, count( a_id ) comment_num FROM COMMENT c where c.is_del='0' GROUP BY c.a_id ) temp ON a.id = temp.a_id 
            WHERE 1=1 `;
    sql += isVlog == 'Vlog'
        ? `and cat.name = '${isVlog}'`
        : `and cat.name != 'Vlog'`;
    sql += `and a.is_del='0'
           /*  GROUP BY a.id  */
            ORDER BY a.addtime desc`;
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
    var contentSql = `select 
    a.id,
    a.title,
    c.name AS 'category',
    a.composition,
    a.description,
    a.addtime,
    a.viewnum,
    a.minpic_url,
    a.video_src,
    a.is_show,
    a.is_del
    from article a, category c where a.category=c.id and a.id = ${id}`;
    var commentSql = `select * from comment where a_id = ${id}`;
    var contentList, newViewNum;
    connection.query(contentSql, (err, data) => {
        new Promise((resolve, reject) => {
            // 1.查询当前文章
            contentList = data;
            newViewNum = Number(contentList[0].viewnum) + 1;
            resolve(newViewNum);
        }).then((newViewNum) => {
            // 2.文章访问量++
            connection.query(`update article set viewnum=${newViewNum} where id=${id}`, (err, data) => {
                // 3.匹配评论
                connection.query(commentSql, (err, data) => {
                    var commentList = data; // 评论列表
                    contentList[0].comment = commentList;
                    contentList[0].viewnum = newViewNum;
                    callback(null, contentList);
                })
            })
        })
    })
}