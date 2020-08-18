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

 Date: 17/08/2020 18:32:12
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
INSERT INTO `article` VALUES (1, '【git】强制覆盖本地代码', '35', '<p><strong>git强制覆盖</strong>：</p><p>&nbsp;&nbsp;&nbsp;git fetch --all</p><p>&nbsp;&nbsp;&nbsp;git reset --hard origin/master</p><p class=\"ql-align-justify\">&nbsp;&nbsp;&nbsp;git pull</p><p class=\"ql-align-justify\"><br></p><p><strong>git强制覆盖本地命令（单条执行）：</strong></p><p>&nbsp;&nbsp;&nbsp;<span style=\"color: rgb(255, 0, 0);\">git fetch --all &amp;&amp;&nbsp;git reset --hard origin/master &amp;&amp;&nbsp;git pull</span></p><p>&nbsp;</p><p>第一个是：拉取所有更新，不同步；</p><p>第二个是：本地代码同步线上最新版本(会覆盖本地所有与远程仓库上同名的文件)；</p><p class=\"ql-align-justify\">第三个是：再更新一次（其实也可以不用，第二步命令做过了其实）</p>', 'git强制覆盖本地代码,与git远程仓库保持一致', '2020-06-17 17:11:07', 109, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/daily.mp4', '0', '0');
INSERT INTO `article` VALUES (2, 'tesaaaaaa', '33', '<p>烦烦烦烦烦烦</p>', 'asdf', '2020-06-17 17:10:16', 36, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '1', '0');
INSERT INTO `article` VALUES (3, 'asdf', '34', '<p>asdfasdf</p>', 'asdfdfasd', '2020-06-17 14:45:01', 7, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', 'http://example.kkslide.fun/daily.mp4', '0', '0');
INSERT INTO `article` VALUES (4, 'ffffff', '32', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 21, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (5, 'ffffff', '33', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (6, 'ffffff', '34', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (7, 'ffffff', '32', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (8, 'ffffff', '33', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (9, 'ffffff', '36', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
INSERT INTO `article` VALUES (10, 'ffffff', '33', '<p>ffffffffffff</p>', 'ffffff', '2020-06-17 14:44:57', 17, 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca', '', '0', '0');
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
  `time` timestamp NOT NULL DEFAULT now() ON UPDATE CURRENT_TIMESTAMP,
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

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

SET FOREIGN_KEY_CHECKS = 1;
