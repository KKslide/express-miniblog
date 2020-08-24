const connection = require("../db/index"); // 数据库连接配置
// const { data } = require("jquery");

/**
 * CRUD
 */
/* 查询 */
module.exports.doQuery = function (options, callback) {
    let table = options.table; // 要查询的表格
    let pageNo = options.pageNo; // 页码
    let pageSize = options.pageSize; // 页容量
    let searchType = options.type; // 条件- 是否全量查询
    // select * from table limit (pageNo-1)*pageSize,pageSize;
    let sql = ``;
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
    let table = options.table;
    let keys = Object.keys(options.data);
    let values = Object.values(options.data);
    let sql = `insert into ${table} (${[...keys]}) values (${[...values]}) `;
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
    let id = options.id;
    let table = options.table;
    let sql = `update ${table} set is_del='1' where ${table == 'comment' ? 't_id' : 'id'} = ${id}`;
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
    let table = options.table,
        id = options.id,
        keys = Object.keys(options.data),
        values = Object.values(options.data),
        queryStr = (function (key, value) {
            let str = "";
            key.forEach((v, i) => {
                // if (v == 'composition') {
                //     // 这一段正则表达式 需要改进为获取pre标签中(或者全局内容)中的单引号和双引号字符进行转义
                //     console.log(value[i].match(/<pre(([\s\S])*?)<\/pre>/ ));
                // }
                str += v + "=" + value[i] + ","
            });
            return str.substr(0, str.length - 1);
        })(keys, values);

    let sql = `update ${table} set 
                        ${queryStr}
                    where id = ${id} `;
    console.log('---- 修改语句 ---- \n', sql, '\n-------------');
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
    let dateStr = new Date().getFullYear() + '-'
        + (new Date().getMonth() + 1 >= 10 ? new Date().getMonth() + 1 : '0' + (new Date().getMonth() + 1))
        + '-' + new Date().getDate();
    let sql = `
        SELECT
        ( SELECT count( * ) FROM visitors ) AS 'visitTotal', /*总访问量*/
        ( SELECT count( * ) FROM visitors WHERE time like '${dateStr}%' ) AS 'visitToday', /*今日访问量*/
        ( SELECT count( * ) FROM users ) AS 'userNum', /*用户数*/
        ( SELECT count( * ) FROM article ) AS 'arcticleNum', /*文章数*/
        ( SELECT count( * ) FROM article a left join category c on a.category = c.id  WHERE c.name = 'Fun' ) AS 'Fun',
        ( SELECT count( * ) FROM article a left join category c on a.category = c.id  WHERE c.name = 'Blog' ) AS 'Blog',
        ( SELECT count( * ) FROM article a left join category c on a.category = c.id  WHERE c.name = 'Vlog' ) AS 'Vlog',
        ( SELECT count( * ) FROM article a left join category c on a.category = c.id  WHERE c.name = 'Code' ) AS 'Code',
        ( SELECT count( * ) FROM article a left join category c on a.category = c.id  WHERE c.name = 'Other' ) AS 'Other' 
    `;
    console.log(sql);
    let resData;
    new Promise((resolve, reject) => {
        connection.query(sql, (err, data) => {
            resData = {
                "tag_list": [
                    { "tag": "总访问量", "value": data[0]['visitTotal'] },
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
    }).then(_ => {
        let curHour = new Date().getHours();
        let sql2 = `
                select 
                (select count(*) from visitors where  time >=(NOW() - interval 1 hour) and time < (NOW() - interval 0 hour) ) as "from now: ${curHour - 0}", 
                (select count(*) from visitors where  time >=(NOW() - interval 2 hour) and time < (NOW() - interval 1 hour) ) as "from now: ${curHour - 1}", 
                (select count(*) from visitors where  time >=(NOW() - interval 3 hour) and time < (NOW() - interval 2 hour)) as "from now: ${curHour - 2}", 
                (select count(*) from visitors where  time >=(NOW() - interval 4 hour) and time < (NOW() - interval 3 hour)) as "from now: ${curHour - 3}", 
                (select count(*) from visitors where  time >=(NOW() - interval 5 hour) and time < (NOW() - interval 4 hour)) as "from now: ${curHour - 4}", 
                (select count(*) from visitors where  time >=(NOW() - interval 6 hour) and time < (NOW() - interval 5 hour)) as "from now: ${curHour - 5}", 
                (select count(*) from visitors where  time >=(NOW() - interval 7 hour) and time < (NOW() - interval 6 hour)) as "from now: ${curHour - 6}", 
                (select count(*) from visitors where  time >=(NOW() - interval 8 hour) and time < (NOW() - interval 7 hour)) as "from now: ${curHour - 7}", 
                (select count(*) from visitors where  time >=(NOW() - interval 9 hour) and time < (NOW() - interval 8 hour)) as "from now: ${curHour - 8}", 
                (select count(*) from visitors where  time >=(NOW() - interval 10 hour) and time < (NOW() - interval 9 hour)) as "from now: ${curHour - 9}", 
                (select count(*) from visitors where  time >=(NOW() - interval 11 hour) and time < (NOW() - interval 10 hour)) as "from now: ${curHour - 10}", 
                (select count(*) from visitors where  time >=(NOW() - interval 12 hour) and time < (NOW() - interval 11 hour)) as "from now: ${curHour - 11}", 
                (select count(*) from visitors where  time >=(NOW() - interval 13 hour) and time < (NOW() - interval 12 hour)) as "from now: ${curHour - 12}", 
                (select count(*) from visitors where  time >=(NOW() - interval 14 hour) and time < (NOW() - interval 13 hour)) as "from now: ${curHour - 13}", 
                (select count(*) from visitors where  time >=(NOW() - interval 15 hour) and time < (NOW() - interval 14 hour)) as "from now: ${curHour - 14}", 
                (select count(*) from visitors where  time >=(NOW() - interval 16 hour) and time < (NOW() - interval 15 hour)) as "from now: ${curHour - 15}", 
                (select count(*) from visitors where  time >=(NOW() - interval 17 hour) and time < (NOW() - interval 16 hour)) as "from now: ${curHour - 16}", 
                (select count(*) from visitors where  time >=(NOW() - interval 18 hour) and time < (NOW() - interval 17 hour)) as "from now: ${curHour - 17}", 
                (select count(*) from visitors where  time >=(NOW() - interval 19 hour) and time < (NOW() - interval 18 hour)) as "from now: ${curHour - 18}", 
                (select count(*) from visitors where  time >=(NOW() - interval 20 hour) and time < (NOW() - interval 19 hour)) as "from now: ${curHour - 19}", 
                (select count(*) from visitors where  time >=(NOW() - interval 21 hour) and time < (NOW() - interval 20 hour)) as "from now: ${curHour - 20}", 
                (select count(*) from visitors where  time >=(NOW() - interval 22 hour) and time < (NOW() - interval 21 hour)) as "from now: ${curHour - 21}", 
                (select count(*) from visitors where  time >=(NOW() - interval 23 hour) and time < (NOW() - interval 22 hour)) as "from now: ${curHour - 22}", 
                (select count(*) from visitors where  time >=(NOW() - interval 24 hour) and time < (NOW() - interval 23 hour)) as "from now: ${curHour - 23}"
                `;
        console.log(sql2);
        connection.query(sql2, (err, data2) => {
            if (err) {
                console.log(err);
                res.json({ code: 0, msg: '出错了' });
            }
            let timeLine = data2[0];
            let keyNames = Object.keys(timeLine).map((v, i) => {
                let _v = Number(v.replace('from now: ', ''));
                return _v >= 10
                    ? _v
                    : _v >= 0
                        ? '0' + _v
                        : 24 + _v
            })
            let values = Object.values(timeLine);
            let tempArr = keyNames.map((v, i) => {
                return {
                    'time': v,
                    'value': values[i]
                }
            });
            resData['line_chart_data'] = tempArr.reverse();
            callback(resData);
        })
    })
}
/* 文章评论管理查询 */
module.exports.queryCommentList = function (options, callback) {
    let id = options.id;
    let sql = ` select * from comment where a_id=${id} and is_del='0' `;
    connection.query(sql, (err, data) => {
        if (err) {
            console.log(err);
            callback(null, err);
        } else {
            callback(null, data);
        }
    })
}
/* 留言管理- 留言数量总数-做成promise的形式 */
module.exports.queryMessageList = function () {
    return new Promise((resolve, reject) => {
        let sql = `select count(*) as 'count' from messages where is_del='0';`
        connection.query(sql, (err, data) => {
            if (err) {
                console.log(err);
                reject(err);
            } else {
                resolve(data[0]['count'])
            }
        })
    })
}

/* ***************************************************** */
/**
 * 前端页面
 */
module.exports.getIndexPageData = function (options, callback) {
    let table = options.table || 'article';
    let isVlog = options.listType == 'vlog' ? 'Vlog' : ''; // 查询列表是否为vlog类型
    let sql =
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
    let id = options.id;
    let contentSql = `select 
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
    let commentSql = `select * from comment where a_id = ${id}`;
    let contentList, newViewNum;
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
                    let commentList = data; // 评论列表
                    contentList[0].comment = commentList;
                    contentList[0].viewnum = newViewNum;
                    callback(null, contentList);
                })
            })
        })
    })
}