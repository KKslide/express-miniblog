/*
Navicat MySQL Data Transfer

Source Server         : AAA_localhost
Source Server Version : 50524
Source Host           : 127.0.0.1:3306
Source Database       : myblog

Target Server Type    : MYSQL
Target Server Version : 50524
File Encoding         : 65001

Date: 2020-06-15 17:21:49
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL COMMENT '文章标题',
  `category` varchar(255) DEFAULT NULL COMMENT '文章分类',
  `article` longtext COMMENT '文章内容',
  `description` varchar(255) DEFAULT NULL COMMENT '文章简介',
  `addtime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '文章添加时间',
  `viewnum` int(11) DEFAULT NULL COMMENT '文章浏览次数',
  `minpic_url` varchar(255) DEFAULT NULL COMMENT '文章缩略图',
  `video_src` varchar(255) DEFAULT NULL COMMENT '视频分类时候的url',
  `is_show` char(1) DEFAULT '0' COMMENT '是否显示 0-不显示 1-显示',
  `is_del` char(1) NOT NULL DEFAULT '0' COMMENT '0-未删除; 1-已删除',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article
-- ----------------------------

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '分类名称',
  `addtime` timestamp NULL DEFAULT NULL COMMENT '分类添加时间',
  `edittime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '分类修改时间',
  `banner` varchar(255) DEFAULT NULL COMMENT '分类缩略图',
  `is_del` char(1) NOT NULL DEFAULT '0' COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('17', '123123', '2020-06-15 11:05:43', '2020-06-15 11:56:50', 'http://example.kkslide.fun/banner.jpg', '0');
INSERT INTO `category` VALUES ('18', 'BBB', '2020-06-15 11:05:46', '2020-06-15 11:58:37', 'http://example.kkslide.fun/banner.jpg', '0');
INSERT INTO `category` VALUES ('16', 'Fun', '2020-06-15 11:05:20', '2020-06-15 11:05:20', 'http://example.kkslide.fun/banner.jpg', '0');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) DEFAULT NULL,
  `user` varchar(255) DEFAULT NULL COMMENT '读者 或 用户',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '评论时间',
  `ip` varchar(255) DEFAULT NULL COMMENT '用户IP',
  `is_del` char(1) NOT NULL DEFAULT '0' COMMENT '0-未删除  1-已删除',
  KEY `commentid` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` char(255) NOT NULL,
  `isadmin` tinyint(1) unsigned zerofill NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'kk', 'e10adc3949ba59abbe56e057f20f883e', '1');
