/*
 Navicat Premium Data Transfer

 Source Server         : AAA_localhost
 Source Server Type    : MySQL
 Source Server Version : 50540
 Source Host           : 127.0.0.1:3306
 Source Schema         : myblog

 Target Server Type    : MySQL
 Target Server Version : 50540
 File Encoding         : 65001

 Date: 21/08/2020 17:44:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章标题',
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章分类',
  `composition` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文章内容',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章简介',
  `addtime` timestamp NULL DEFAULT NULL COMMENT '文章添加时间',
  `viewnum` int(11) NULL DEFAULT NULL COMMENT '文章浏览次数',
  `minpic_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章缩略图',
  `video_src` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频分类的url',
  `is_show` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '是否显示 0-显示 1-不显示 ',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '0-未删除; 1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, '【git】强制覆盖本地代码', '35', '<p><strong>git强制覆盖</strong>：</p><p>&nbsp;&nbsp;&nbsp;git fetch --all</p><p>&nbsp;&nbsp;&nbsp;git reset --hard origin/master</p><p class=\"ql-align-justify\">&nbsp;&nbsp;&nbsp;git pull</p><p class=\"ql-align-justify\"><br></p><p><strong>git强制覆盖本地命令（单条执行）：</strong></p><p>&nbsp;&nbsp;&nbsp;<span style=\"color: rgb(255, 0, 0);\">git fetch --all &amp;&amp;&nbsp;git reset --hard origin/master &amp;&amp;&nbsp;git pull</span></p><p>&nbsp;</p><p>第一个是：拉取所有更新，不同步；</p><p>第二个是：本地代码同步线上最新版本(会覆盖本地所有与远程仓库上同名的文件)；</p><p class=\"ql-align-justify\">第三个是：再更新一次（其实也可以不用，第二步命令做过了其实）</p>', 'git强制覆盖本地代码,与git远程仓库保持一致', '2020-06-17 17:11:07', 110, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/daily.mp4', '0', '0');
INSERT INTO `article` VALUES (2, '【git】如何撤销git commit', '35', '<p>写完代码后，我们一般这样</p><p>git add . //添加所有文件</p><p>git commit -m \"本功能全部完成\"</p><p>&nbsp;</p><p>执行完commit后，想撤回commit，怎么办？</p><p>&nbsp;</p><p>这样凉拌：</p><p><strong>git reset --soft HEAD^</strong></p><p>&nbsp;</p><p>这样就成功的撤销了你的commit</p><p>注意，仅仅是撤回commit操作，您写的代码仍然保留。</p><p>&nbsp;</p><p>&nbsp;</p><h2>说一下个人理解：</h2><p>HEAD^的意思是上一个版本，也可以写成HEAD~1</p><p>如果你进行了2次commit，想都撤回，可以使用HEAD~2</p><p>&nbsp;</p><h2>至于这几个参数：--mixed&nbsp;</h2><p>意思是：不删除工作空间改动代码，撤销commit，并且撤销git add . 操作</p><p>这个为默认参数,git reset --mixed HEAD^ 和 git reset HEAD^ 效果是一样的。</p><p>&nbsp;</p><h2>--soft&nbsp;</h2><p>不删除工作空间改动代码，撤销commit，不撤销git add .&nbsp;</p><p>&nbsp;</p><h2>--hard</h2><p>删除工作空间改动代码，撤销commit，撤销git add .&nbsp;</p><p>注意完成这个操作后，就恢复到了上一次的commit状态。</p><p>&nbsp;</p><p>&nbsp;</p><h3>顺便说一下，如果commit注释写错了，只是想改一下注释，只需要：</h3><p>git commit --amend</p><p>此时会进入默认vim编辑器，修改注释完毕后保存就好了。</p>', 'git commit之后, 想撤销commit', '2020-06-17 17:10:16', 37, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (3, '【git】如何让git仅导出在特定版本中新增或修改过的文件', '35', '<p><strong>在 Linux 底下使用 Git 工具匯出變更檔案 (搭配 Shell 指令)</strong></p><p>利用 Git 取得變更的檔案清單，其指令是一樣的：</p><pre class=\"ql-syntax\" spellcheck=\"false\">git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT HEAD\n</pre><p>然後可以利用&nbsp;<strong>git archive</strong>&nbsp;這個 Git 內建命令來產生本次變更的所有檔案：</p><blockquote><strong class=\"ql-size-small\">git archive --output=files.tar&nbsp;HEAD&nbsp;$(git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT HEAD)</strong></blockquote><p>如果你想匯出 Zip 壓縮檔格式，可以改用以下指令：</p><blockquote><strong class=\"ql-size-small\">git archive&nbsp;--format=zip&nbsp;--output=files.tar&nbsp;HEAD&nbsp;$(git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT HEAD)</strong></blockquote><p>就這樣，很快地就能打包好這些變更的檔案，方便提供客戶更新與部署新版本。</p><p><br></p><p><strong>請注意</strong>: 如果沒輸入&nbsp;$(git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT HEAD)&nbsp;的話，執行&nbsp;<strong>git archive</strong>&nbsp;會把該版本所有的檔案，全部匯出成 tar 檔，也就如同<strong>匯出最新版本的原始碼</strong>的意思，因此若要繪出完整原始碼，比較簡短的寫法如下：（以下指令同時適用於 Windows / Linux / Mac 作業平台）</p><pre class=\"ql-syntax\" spellcheck=\"false\">git archive HEAD &gt; export.tar\n</pre><p>或是 Zip 壓縮檔格式：</p><pre class=\"ql-syntax\" spellcheck=\"false\">git archive --format=zip HEAD &gt; export.zip\n</pre>', 'git只导出修改或新增文件', '2020-06-17 14:45:01', 10, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/daily.mp4', '0', '0');
INSERT INTO `article` VALUES (4, '【css】滤镜让图片模糊', '32', '<h5>CSS代码：</h5><pre class=\"ql-syntax\" spellcheck=\"false\">.blur {	\n    filter: url(blur.svg#blur); /* FireFox, Chrome, Opera */\n    \n    -webkit-filter: blur(10px); /* Chrome, Opera */\n       -moz-filter: blur(10px);\n        -ms-filter: blur(10px);    \n            filter: blur(10px);\n    \n    filter: progid:DXImageTransform.Microsoft.Blur(PixelRadius=10, MakeShadow=false); /* IE6~IE9 */\n}\n</pre><h5>HTML代码：</h5><pre class=\"ql-syntax\" spellcheck=\"false\">&lt;img src=\"mm1.jpg\" /&gt;\n&lt;img src=\"mm1.jpg\" class=\"blur\" /&gt;\n</pre><h5><br></h5><h5>效果：</h5><p><br></p><p><img src=\"http://example.kkslide.fun/upload_c18053415b8d0682545d0b5497611316\"></p>', 'CSS模糊效果', '2020-06-17 14:44:57', 21, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (5, '【git】删除远程分支和本地分支', '35', '<p>问题描述：</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当我们集体进行项目时，将自定义分支push到主分支master之后，如何删除远程的自定义分支呢</p><p>问题解决：</p><p><span style=\"background-color: rgb(245, 245, 245);\">（1）使用命令git branch -a 查看所有分支</span></p><p><img src=\"http://example.kkslide.fun/upload_e10297a436f2fdff2fd3ebd4fe43597f\"></p><p>注：其中，<span style=\"color: rgb(230, 0, 0);\">remote/xxxx/xxxx</span> 表示的是远程分支</p><p><br></p><p>（2）删除远程分支&nbsp;&nbsp;&nbsp;</p><p>如图片所示，使用命令 git push origin --delete <span style=\"color: rgb(230, 0, 0);\">分支名称</span>&nbsp;&nbsp;可以删除指定远程分支&nbsp;&nbsp;&nbsp;</p><p>再次使用命令 git branch -a&nbsp;&nbsp;可以发现，远程分支已经被删除。</p><p><img src=\"http://example.kkslide.fun/upload_f26de3554fccd8ce86fbaa42b1c66d73\"></p><p><br></p><p>（3）删除本地分支</p><p>使用命令，git branch -d Chapater8 可以删除本地分支（在主分支或者其他分支中）</p><p>如图所示，在从Chapater8分支切换到master分支，git checkout&nbsp;master</p><p>然后使用 git branch -d Chapater8 可以删除Chapater8分支。</p><p><img src=\"http://example.kkslide.fun/upload_93104ac577536c414e7cd8ce9a58722d\"></p>', 'git关于分支的操作', '2020-06-17 14:44:57', 18, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (6, '从来没有被岁月偏爱的美人, 只有和岁月死磕的决心与自律', '34', '<h2 class=\"ql-align-center\"><span class=\"ql-size-huge\">just like that</span></h2>', '2019年7月篮球小集锦', '2020-06-17 14:44:57', 20, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/daily.mp4', '0', '0');
INSERT INTO `article` VALUES (7, '【爱·桂林】 x Gopro 桂林街拍', '34', '<h1 class=\"ql-align-center\"><span class=\"ql-size-huge\">Love GuiLin</span></h1>', '桂林旅游街拍', '2020-06-17 14:44:57', 22, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/trip-in-guilin_v2.mp4', '0', '0');
INSERT INTO `article` VALUES (8, '抓住2019年的尾巴,一起养生篮球吧', '34', '<h3 class=\"ql-align-center\"><span class=\"ql-size-huge\">和南天小伙伴们一起</span></h3>', '2019年12月篮球小基金', '2020-06-17 14:44:57', 19, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/me_edit.mp4', '0', '0');
INSERT INTO `article` VALUES (9, 'GoPro x Basketball', '34', '<p>yessss.. basketball..again</p>', 'what would I see when I pay basketball', '2020-06-17 14:44:57', 18, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/gopro-first-sight.mp4', '0', '0');
INSERT INTO `article` VALUES (10, 'express 413 Request Entity Too Large', '35', '<p><strong>1.配置nginx</strong></p><p>原因是请求实体太长了。一般出现种情况是Post请求时Body内容Post的数据太大了</p><p>如上传大文件过大; 如POST数据比较多</p><p><br></p><p>处理方法修改nginx.conf的值就可以解决了。</p><p>client_max_body_size 2M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;改为&nbsp;&nbsp;</p><p>client_max_body_size 10M</p><p><br></p><p><strong style=\"color: rgb(51, 51, 51);\">2.配置express</strong></p><pre class=\"ql-syntax\" spellcheck=\"false\">var app = require(\'express\')();?var bodyParser = require(\'body-parser\');??app.use(bodyParser.json({limit: \'10mb\'})); // for parsing application/json?app.use(bodyParser.urlencoded({limit: \'10mb\', extended: true })); // for parsing application/x-www-form-urlencoded?</pre>', '413请求码报错处理', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (11, 'ffffff', '35', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (12, 'ffffff', '35', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `addtime` timestamp NULL DEFAULT NULL COMMENT '分类添加时间',
  `edittime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '分类修改时间',
  `banner` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类缩略图',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (32, 'Fun', '2020-06-17 17:26:38', '2020-06-17 17:26:38', 'http://example.kkslide.fun/banner.jpg', '0');
INSERT INTO `category` VALUES (33, 'Blog', '2020-06-17 17:26:44', '2020-06-17 17:26:44', 'http://example.kkslide.fun/banner.jpg', '0');
INSERT INTO `category` VALUES (34, 'Vlog', '2020-06-17 17:26:52', '2020-06-17 17:26:52', 'http://example.kkslide.fun/banner.jpg', '0');
INSERT INTO `category` VALUES (35, 'Code', '2020-06-17 17:26:59', '2020-06-17 17:26:59', 'http://example.kkslide.fun/banner.jpg', '0');
INSERT INTO `category` VALUES (36, 'Other', '2020-08-17 17:39:10', '2020-08-17 17:39:10', 'http://example.kkslide.fun/banner.jpg', '0');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `t_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表格id',
  `a_id` int(11) NULL DEFAULT NULL COMMENT '与文章关联的id',
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '读者 或 用户',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '评论时间',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户IP',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论内容',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`t_id`) USING BTREE,
  INDEX `commentid`(`a_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 1, 'aaa', '2020-08-17 10:55:38', '127.0.0.1', '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈', '1');
INSERT INTO `comment` VALUES (2, 1, 'bbb', '2020-08-12 10:42:48', '127.0.0.1', '呵呵呵呵呵呵', '0');
INSERT INTO `comment` VALUES (3, 2, 'test', '2020-08-12 10:42:51', '127.0.0.1', '按实际到货发顺丰卢卡斯的话', '0');
INSERT INTO `comment` VALUES (4, 3, 'gggg', '2020-08-12 10:42:51', '127.0.0.1', '自行车那边v你装修成本v名不虚传', '0');
INSERT INTO `comment` VALUES (5, 3, 'rrrr', '2020-08-12 10:42:52', '127.0.0.1', '请问u人情味有人陪我却依然', '0');
INSERT INTO `comment` VALUES (6, 2, 'fffffff', '2020-08-12 10:42:53', '127.0.0.1', '12346789', '0');
INSERT INTO `comment` VALUES (7, 4, 'qweasd', '2020-08-12 10:42:53', '127.0.0.1', 'abcdefchijklmnopqrstuvwxyz', '0');
INSERT INTO `comment` VALUES (8, 4, 'cast', '2020-08-12 10:42:54', '127.0.0.1', '11111111111111111111111111', '0');
INSERT INTO `comment` VALUES (9, 4, 'hhh', '2020-08-12 10:42:55', '127.0.0.1', 'hhhh', '0');
INSERT INTO `comment` VALUES (10, 4, 'fff', '2020-08-12 10:42:55', '127.0.0.1', 'fffffff', '0');
INSERT INTO `comment` VALUES (11, 4, 'aa', '2020-08-12 10:42:56', '127.0.0.1', 'aaaa<span class=\"emoji-item-common emoji-disappointed_relieved emoji-size-small\" ></span>', '0');
INSERT INTO `comment` VALUES (12, 1, 'aaaa', '2020-08-12 10:42:59', '127.0.0.1', 'aaaaaaaaaaaa', '0');

-- ----------------------------
-- Table structure for messages
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '留言时间',
  `viewer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'stranger' COMMENT '访客名字或者邮箱',
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '留言信息',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户IP',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '该留言是否删除- 或屏蔽-',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of messages
-- ----------------------------
INSERT INTO `messages` VALUES (1, '2020-08-17 10:59:59', 'hhhhh', '大连地铁回应“两外国人攀爬扶手”：在中国必须尊重中国法律', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (2, '2020-08-12 11:09:48', 'gggg', '“中国的帮助增强了我们抗疫信心”（患难见真情 共同抗疫情）', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (3, '2020-08-12 11:09:39', 'aaa', '国家卫健委：各地要开展农贸集贸市场风险大排查', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (4, '2020-08-12 11:09:30', 'bbbb', '广东居民赴澳门旅游签注，8月26日起恢复办理', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (5, '2020-08-12 11:10:27', 'vvv', '张玉环无罪释放后办理新身份证<span class=\"emoji-item-common emoji-disappointed emoji-size-small\" ></span>', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (6, '2020-08-17 10:59:56', '手动阀手动阀', '痛心！致敬！冲锋在前，持续奋战在抗击疫情一线', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (7, '2020-08-17 10:59:55', '啊手动阀手动阀 ', '羊要来了！蒙古国正式启动3万只羊捐赠程序', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (8, '2020-08-17 10:56:19', 'viewer_1', '31省区市新增确诊22例', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (9, '2020-08-16 09:57:17', 'stranger', '男子发文称被副局长锁在家中殴打', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (10, '2020-08-14 08:57:46', 'stranger', '中央气象台继续发布暴雨橙色预警', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (11, '2020-08-12 15:58:34', 'stranger', '镇安7.1亿豪华中学学生发声', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (12, '2020-08-13 10:58:45', 'stranger', '袁冰妍回应直播中亲成毅', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (13, '2020-08-17 11:02:35', 'stranger', '葡萄牙总统采访中跳海救人', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (14, '2020-08-17 16:50:55', 'aaa', 'it`s just a test', '127.0.0.1', '0');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `isadmin` tinyint(1) UNSIGNED ZEROFILL NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'kk', 'e10adc3949ba59abbe56e057f20f883e', 1);

-- ----------------------------
-- Table structure for visitors
-- ----------------------------
DROP TABLE IF EXISTS `visitors`;
CREATE TABLE `visitors`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of visitors
-- ----------------------------
INSERT INTO `visitors` VALUES (1, '2020-08-17 09:15:14', '127.0.0.1');
INSERT INTO `visitors` VALUES (2, '2020-08-17 08:18:58', '127.0.0.1');
INSERT INTO `visitors` VALUES (3, '2020-08-17 07:19:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (4, '2020-08-17 07:19:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (5, '2020-08-17 10:51:09', '127.0.0.1');
INSERT INTO `visitors` VALUES (6, '2020-08-17 10:51:51', '127.0.0.1');
INSERT INTO `visitors` VALUES (7, '2020-08-17 11:38:03', '127.0.0.1');
INSERT INTO `visitors` VALUES (8, '2020-08-17 12:04:13', '127.0.0.1');
INSERT INTO `visitors` VALUES (9, '2020-08-17 15:18:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (10, '2020-08-17 15:18:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (11, '2020-08-17 15:38:21', '127.0.0.1');
INSERT INTO `visitors` VALUES (12, '2020-08-17 16:38:23', '127.0.0.1');
INSERT INTO `visitors` VALUES (13, '2020-08-17 16:38:24', '127.0.0.1');
INSERT INTO `visitors` VALUES (14, '2020-08-17 16:38:26', '127.0.0.1');
INSERT INTO `visitors` VALUES (15, '2020-08-17 16:38:39', '127.0.0.1');
INSERT INTO `visitors` VALUES (16, '2020-08-17 16:38:41', '127.0.0.1');
INSERT INTO `visitors` VALUES (17, '2020-08-17 17:33:13', '127.0.0.1');
INSERT INTO `visitors` VALUES (18, '2020-08-17 17:40:27', '127.0.0.1');
INSERT INTO `visitors` VALUES (19, '2020-08-17 17:40:29', '127.0.0.1');
INSERT INTO `visitors` VALUES (20, '2020-08-17 17:40:31', '127.0.0.1');
INSERT INTO `visitors` VALUES (21, '2020-08-18 11:12:41', '127.0.0.1');
INSERT INTO `visitors` VALUES (22, '2020-08-18 11:21:38', '127.0.0.1');
INSERT INTO `visitors` VALUES (23, '2020-08-18 11:21:40', '127.0.0.1');
INSERT INTO `visitors` VALUES (24, '2020-08-18 16:45:38', '127.0.0.1');
INSERT INTO `visitors` VALUES (25, '2020-08-18 17:07:43', '127.0.0.1');
INSERT INTO `visitors` VALUES (26, '2020-08-19 09:36:07', '127.0.0.1');
INSERT INTO `visitors` VALUES (27, '2020-08-19 10:13:00', '127.0.0.1');
INSERT INTO `visitors` VALUES (28, '2020-08-19 10:47:37', '127.0.0.1');
INSERT INTO `visitors` VALUES (29, '2020-08-19 10:47:37', '127.0.0.1');
INSERT INTO `visitors` VALUES (30, '2020-08-19 10:47:42', '127.0.0.1');
INSERT INTO `visitors` VALUES (31, '2020-08-19 10:48:16', '127.0.0.1');
INSERT INTO `visitors` VALUES (32, '2020-08-19 10:48:23', '127.0.0.1');
INSERT INTO `visitors` VALUES (33, '2020-08-21 11:07:32', '127.0.0.1');

SET FOREIGN_KEY_CHECKS = 1;
