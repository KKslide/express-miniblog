const connection = require("../db/index"); // 数据库连接配置

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
                cate.name as cate_name,
                a.* 
                from article a 
                left join category cate on a.category = cate.id
                left join comment cm on a.id=cm.a_id 
                and cm.is_del='0'
                where a.is_del='0'
                group by a.id 
                order by a.addtime desc 
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
    let placeholders = keys.map(() => '?').join(', ')
    let sql = `insert into ${table} (${keys.join(', ')}) values (${placeholders}) `;
    console.log('-----新增sql语句-----\n', sql, '\n----------');
    connection.query(sql, values, (err, res) => {
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
    console.log('id是什么 ===> ', id, '查看删除SQL语句:', sql);
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
  const table = options.table;
  const id = options.id;
  const data = options.data;

  const keys = Object.keys(data);               // ['title', 'content', ...]
  const values = Object.values(data);           // ['xxx', 'yyy', ...]
  const setStr = keys.map(key => `${key} = ?`).join(', ');  // title = ?, content = ? ...

  const sql = `UPDATE ${table} SET ${setStr} WHERE id = ?`;
  values.push(id); // 添加到 values 末尾，匹配 WHERE id = ?

  connection.query(sql, values, (err, res) => {
    if (err) {
      console.error(err);
      return callback(err);
    }
    if (res.affectedRows === 1) {
      callback(null, res); // 可返回更新结果
    } else {
      callback(new Error('Update failed'));
    }
  });
}
/* 登陆查询 */
module.exports.loginQuery = function (options, callback) {
    let sql = `select id,username from users where username='${options.username}' and password='${options.password}'`;
    connection.query(sql, (err, data) => {
        if (err) {
            console.log(err);
            callback(err);
        } else {
            callback(null, data);
        }
    })
}

/**
 * 后台管理页一些复杂查询↓
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
    let isVlog = options.listType == 'vlog'; // 查询列表是否为vlog类型
    let { listType } = options
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
                LEFT JOIN ( SELECT a_id, count( a_id ) comment_num FROM comment c where c.is_del='0' GROUP BY c.a_id ) temp ON a.id = temp.a_id 
            WHERE 1=1 `;
    sql += isVlog ? `and cat.name = 'Vlog' ` : ``
    sql += listType ? `and cat.name = '${listType}' ` : ``
        // ? `and cat.name = '${isVlog}'`
        // : `and cat.name != 'Vlog'`;
    sql += `and a.is_del='0'
                and a.is_show='0'
           /*  GROUP BY a.id  */
            ORDER BY a.addtime desc`;
    console.log(sql);
    console.log('-***************************-');
    new Promise((resolve, reject) => {
        connection.query("select c.id,c.name from category c where c.is_del='0' group by c.id", (err, data) => {
            if (err) {
                reject(err)
            } else {
                resolve(data)
            }
        })
    }).then(catList => {
        connection.query(sql, (err2, data2) => {
            if (err2) {
                console.log(err2);
                callback(null, err2);
            } else {
                // data2.catList = catList;
                var responseData = {
                    catList: catList,
                    blogList: data2
                }
                callback(null, responseData);
            }
        })
    })
}

/* 2025-07-18 新增blogList页面查询 */
module.exports.getIndexPageData_v2 = function(options, callback) {
  try {
    const categoryQuery = "SELECT id, name FROM category WHERE is_del = '0' ORDER BY id;";
    const articleQuery = `
      WITH RankedArticles AS (
          SELECT
              a.id, a.title, cat.name AS category, a.composition, a.description, a.addtime,
              a.viewnum, a.minpic_url, a.video_src, a.is_show, a.is_del,
              ROW_NUMBER() OVER(PARTITION BY a.category ORDER BY a.addtime DESC) AS rn
          FROM article a
          INNER JOIN category cat ON a.category = cat.id
          WHERE a.is_del = '0' AND a.is_show = '0' AND cat.is_del = '0'
      )
      SELECT
          ra.*, IFNULL(c.comment_num, 0) AS comment_num
      FROM RankedArticles ra
      LEFT JOIN
          (SELECT a_id, COUNT(*) AS comment_num FROM comment WHERE is_del = '0' GROUP BY a_id) c 
      ON ra.id = c.a_id
      WHERE ra.rn <= 3
      ORDER BY ra.category, ra.addtime DESC;
    `;
    
    new Promise((resolve, reject) => {
      connection.query(categoryQuery, (err, data) => {
        if (err) {
          reject(err)
        } else {
          resolve(data)
        }
      })
    }).then(catList => {
      console.log('catList ====>', catList)
      connection.query(articleQuery, (err2, articleList) => {
        if (err2) {
          console.log(err2);
          callback(null, err2);
        }
        else {
          // 初始化 blogList 对象，将所有分类名作为key，value为空数组
          // 这样可以确保即使某个分类下没有文章，前端也能收到该分类的空数组
          const blogList = {};
          catList.forEach(cat => {
            blogList[cat.name] = [];
          });
      
          // 遍历查询到的文章列表，填充到 blogList 对象中
          articleList.forEach(article => {
            // 从结果中删除不再需要的排名列 `rn`
            delete article.rn; 
            
            // 因为SQL返回的结果中已经包含了category名称，可以直接使用
            if (blogList[article.category]) {
              blogList[article.category].push(article);
            }
          });
      
          // 构造最终返回给前端的数据结构
          const responseData = {
            catList,
            blogList
          };
          callback(null, responseData)
        }
      })
    })

  } catch (error) {
    console.error("获取首页数据时出错:", error);
    callback(null, {
      code: 500,
      message: '服务器内部错误'
    })
  }
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
    c.banner AS 'banner',
    a.composition,
    a.description,
    a.addtime,
    a.viewnum,
    a.video_src,
    a.minpic_url,
    a.is_show,
    a.is_del
    from article a, category c where a.category=c.id and a.id = ${id}`;
    let commentSql = `select * from comment where a_id = ${id} and is_del='0'`;
    let contentList, newViewNum;
    connection.query(contentSql, (err, data) => {
        new Promise((resolve, reject) => {
            if (data.length == 0) {
              callback(null, { code: 0, msg: '没有数据!' })
              return
            }
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


module.exports.getContentDetail_v2 = async function (options, callback) {
  const { id } = options;

  function formatDateToSQLString(date) {
    const d = new Date(date);
    const pad = (n) => (n < 10 ? '0' + n : n);
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ` +
           `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
  }

  const curSql = `
          SELECT
              a.id,
              a.title,
              a.category AS categoryID,
              c.name AS category,
              c.banner,
              a.composition,
              a.description,
              a.addtime,
              a.viewnum,
              a.video_src,
              a.minpic_url,
              a.is_show,
              a.is_del,
              -- 修改部分：使用 COUNT() 作为判断条件
              -- 如果评论数量大于0，则聚合评论，否则返回空数组
              IF(COUNT(comm.t_id) > 0,
                  JSON_ARRAYAGG(
                      JSON_OBJECT(
                          't_id', comm.t_id,
                          'a_id', comm.a_id,
                          'user', comm.user,
                          'time', comm.time,
                          'ip', comm.ip,
                          'comment', comm.comment,
                          'is_del', comm.is_del
                      )
                  ),
                  JSON_ARRAY() -- 如果没有评论，返回一个空的JSON数组 '[]'
              ) AS "comment"
          FROM
              article a
          JOIN
              category c ON a.category = c.id
          LEFT JOIN
              comment comm ON a.id = comm.a_id AND comm.is_del = '0'
          WHERE
              a.id = ?
              AND a.is_del = '0'
              AND a.is_show = '0'
          GROUP BY
              a.id; -- GROUP BY 主键 a.id 即可，其他 a.* 和 c.* 字段在MySQL中被认为是功能依赖于主键的
  `;
  const [cur] = await connection.queryAsync(curSql, [id]);

  if (!cur) {
    console.log('文章不存在');
    callback(null, { code: 0, msg: '没有数据!' })
    return
  }

  // 修改一下comment的数据类型
  if (cur.comment && typeof cur.comment == 'string') {
    cur.comment = JSON.parse(cur.comment)
  }

  const category = cur.categoryID;
  const addtime = formatDateToSQLString(cur.addtime);

  const prevSql = `SELECT a.*
                   FROM article a
                   JOIN category c ON a.category = c.id
                   WHERE a.category = ?
                     AND a.is_del = '0'
                     AND a.is_show = '0'
                     AND a.addtime < ?
                   ORDER BY a.addtime DESC
                   LIMIT 1;`;
  const [prev] = await connection.queryAsync(prevSql, [category, addtime]);

  const nextSql = `SELECT a.*
                   FROM article a
                   JOIN category c ON a.category = c.id
                   WHERE a.category = ?
                     AND a.is_del = '0'
                     AND a.is_show = '0'
                     AND a.addtime > ?
                   ORDER BY a.addtime ASC
                   LIMIT 1;`;
  const [next] = await connection.queryAsync(nextSql, [category, addtime]);

  // 新增viewNum
  const viewnumSql = `update article set viewnum=${++cur.viewnum} where id=${id}`
  await connection.queryAsync(viewnumSql)
  
  const res = {
    prev: prev || null,
    cur,
    next: next || null,
  };

  callback(null, res)
};