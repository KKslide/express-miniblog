/*
 Navicat Premium Data Transfer

 Source Server         : Tencent-cloud
 Source Server Type    : MySQL
 Source Server Version : 50731
 Source Host           : 134.175.129.219:3306
 Source Schema         : myblog

 Target Server Type    : MySQL
 Target Server Version : 50731
 File Encoding         : 65001

 Date: 17/11/2020 17:27:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章标题',
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章分类',
  `composition` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文章内容',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章简介',
  `addtime` timestamp(0) NULL DEFAULT NULL COMMENT '文章添加时间',
  `viewnum` int(11) NULL DEFAULT NULL COMMENT '文章浏览次数',
  `minpic_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章缩略图',
  `video_src` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频分类的url',
  `is_show` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '是否显示 0-显示 1-不显示 ',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '0-未删除; 1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, '【git】强制覆盖本地代码', '35', '<p><strong>git强制覆盖</strong>：</p><p>&nbsp;&nbsp;&nbsp;git fetch --all</p><p>&nbsp;&nbsp;&nbsp;git reset --hard origin/master</p><p class=\"ql-align-justify\">&nbsp;&nbsp;&nbsp;git pull</p><p class=\"ql-align-justify\"><br></p><p><strong>git强制覆盖本地命令（单条执行）：</strong></p><p>&nbsp;&nbsp;&nbsp;<span style=\"color: rgb(255, 0, 0);\">git fetch --all &amp;&amp;&nbsp;git reset --hard origin/master &amp;&amp;&nbsp;git pull</span></p><p>&nbsp;</p><p>第一个是：拉取所有更新，不同步；</p><p>第二个是：本地代码同步线上最新版本(会覆盖本地所有与远程仓库上同名的文件)；</p><p class=\"ql-align-justify\">第三个是：再更新一次（其实也可以不用，第二步命令做过了其实）</p>', 'git强制覆盖本地代码,与git远程仓库保持一致', '2020-06-17 17:11:07', 128, 'http://example.kkslide.fun/upload_103405a8152c0ecffb62f5654be67899', '', '0', '0');
INSERT INTO `article` VALUES (2, '上传文件报413 Request Entity Too Large错误解决办法', '35', '<p>产生这种原因是因为服务器限制了上传大小</p><p><br></p><h3>1、nginx服务器的解决办法</h3><p>修改nginx.conf的值就可以解决了</p><p>将以下代码粘贴到nginx.conf内</p><pre class=\"ql-syntax\" spellcheck=\"false\">client_max_body_size 20M;\n</pre><p><br></p><p>可以选择在http{ }中设置：client_max_body_size 20m;</p><p>也可以选择在server{ }中设置：client_max_body_size 20m;</p><p>还可以选择在location{ }中设置：client_max_body_size 20m;</p><p>三者有区别</p><p>设置到http{}内，控制全局nginx所有请求报文大小</p><p>设置到server{}内，控制该server的所有请求报文大小</p><p>设置到location{}内，控制满足该路由规则的请求报文大小</p><p>同时记得修改php.ini内的上传限制</p><p>upload_max_filesize = 20M</p><p>注意:如果以上修改完毕后还会出现413错误的话 , 可能是域名问题 , 本人遇到过此类情况 , 记录</p><p><br></p><h3>2、apache服务器修改</h3><p>在apache环境中上传较大软件的时候，有时候会出现413错误，出现这个错误的原因，是因为apache的配置不当造成的，找到apache的配置文件目录也就是conf目录，和这个目录平行的一个目录叫conf.d打开这个conf.d，里面有一个php.conf</p><pre class=\"ql-syntax\" spellcheck=\"false\">目录内容如下： \n# \n# PHP is an HTML-embedded scripting language which attempts to make it \n# easy for developers to write dynamically generated webpages. \n# \n\nLoadModule php4_module modules/libphp4.so \n\n# \n# Cause the PHP interpreter handle files with a .php extension. \n# \n\nSetOutputFilter PHP \nSetInputFilter PHP \nLimitRequestBody 6550000 \n\n# \n# Add index.php to the list of files that will be served as directory \n# indexes. \n# \nDirectoryIndex index.php \n</pre><p><br></p><p><span style=\"color: rgb(64, 64, 64);\">误就发生在这个LimitRequestBody配置上，将这个的值改大到超过你的软件大小就可以了</span></p><p><span style=\"color: rgb(64, 64, 64);\">如果没有这个配置文件请将</span></p><pre class=\"ql-syntax\" spellcheck=\"false\">SetOutputFilter PHP \nSetInputFilter PHP \nLimitRequestBody 6550000 \n</pre><p><span style=\"color: rgb(64, 64, 64);\">写到apache的配置文件里面即可。</span></p><p><br></p><h3>3、IIS服务器（Windows Server 2003系统IIS6）</h3><p>先停止IIS Admin Service服务，然后</p><p>找到windowssystem32inesrv下的metabase.xml，打开，找到ASPMaxRequestEntityAllowed 修改为需要的值，然后重启IIS Admin Service服务</p><p>1、在web服务扩展 允许active server pages和在服务器端的包含文档</p><p>2、修改各站点的属性 主目录－配置－选项－启用父路径</p><p>3、使之可以上传大文档(修改成您想要的大小就可以了，以字节为单位)</p><p>c:WINDOWSsystem32inetsrvMetaBase.xml</p><p>！企业版的windows2003在第592行</p><p>默认的预设置值 AspMaxRequestEntityAllowed=\"204800\" 即200K</p><p>将其加两个0，即改为，现在最大就可以上传20M了。</p><p>AspMaxRequestEntityAllowed=\"20480000\"</p>', '413报错解决办法', '2020-06-17 17:10:16', 52, 'http://example.kkslide.fun/upload_cef9097a11e355d2d303eae7d105c192', '', '0', '0');
INSERT INTO `article` VALUES (3, '2019年7月11日-篮球集锦', '34', '<p class=\"ql-align-center\"><span class=\"ql-size-large\">下班后和同事去打球</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">对手全是小区里的大叔</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">对抗难度不是很强</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">整个过程打得非常非常轻松</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">结束后, 老大爷们都在叹息地说</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">”哎呀 年轻真好“</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">哈哈哈哈哈哈是啊</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">年轻真好 我也觉得 </span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">可是,</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">哪有被命运偏爱的美人呢</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\">只有和岁月死磕的决心与自律</span></p><p class=\"ql-align-center\"><span class=\"ql-size-large\"><span class=\"ql-cursor\">﻿</span></span><img src=\"http://example.kkslide.fun/upload_b672ce4536871d362a97b9454b6bcbbf\"></p><p><br></p>', '从来就没有被命运偏爱的美人,只有和岁月死磕的决心与自律', '2020-06-17 14:45:01', 68, 'http://example.kkslide.fun/upload_ef41b6ed3b28cc34909738ded6825e13', 'http://example.kkslide.fun/daily.mp4', '0', '0');
INSERT INTO `article` VALUES (4, '对酒有感', '32', '<p><span class=\"ql-size-large\">中国的酒文化甚是严重，希望下一代的年轻人可以改善，多一点体谅，少一点酒量！多喝酒有害健康！朋友相聚你逼人家喝等于侵害他人健康，就比如打牌玩盅，其实就是在互残身体。</span></p><p><span class=\"ql-size-large\">良好的酒文化需要大家努力，等老一辈退下了，我们可以引导一个良好的氛围。将来如果我们不逼人喝酒，那将是开开心心吃饭，开开心心回家，即使喝酒，也是品酒，品几杯酒有益健康啊，这样的气氛何乐不为呢？为什么要让人家倒下了才放过人家呢？其实自己在内心偷笑。</span></p><p><span class=\"ql-size-large\">老一代或许会跟你说：“不会喝酒交不到朋友的。”其实我们谁都可以反问这句话。适当喝酒为什么不行？！！！我国公众在饮酒常识、饮酒量上均存在着严重的问题。很多人去聚餐刚想拿起筷子吃块肉就被敬酒，很多人喝多酒中毒，很多人喝酒做错事，也难怪中国法律前不久出台了“禁酒令”，查得挺严的，醉酒驾车你就完了，当时在电视上经常可以看到醉酒的丑态！</span></p><p><span class=\"ql-size-large\">我们探究一下酒的味道，我敢说大部分酒都不好喝，主要成分是酒精和水，有些又苦又熏，有些还烧喉。很多人其实不喜欢喝酒的，是假喜欢。现代生活朋友客户相聚集在一起,吃饭时候喝酒成了一种男人的应酬，有些人本来不会喝酒或者纯粹就不喜欢喝酒的,可是出于自己的面子,交际等种种原因而不得不喝酒。其实是一种习俗在作怪！我们可以改变的！</span></p><p><span class=\"ql-size-large\">有一部分人喝酒是为了面子、风度、气魄、感觉……这当中有的人是自我认为渴酒会显得自己成熟、老练、沧桑，不一定是喝给别人看，而是喝给自己看的——为了自己心里的一种满足感或者成就感。</span></p><p><span class=\"ql-size-large\">而另一部分人则是喝给别人看的，他们要使自己的形象在别人眼里显得成熟、老练，有水准；要显得自己很帅，很强，很牛，很“男人”，很仗义，很有气量，很有魄力，很能成事，很谙世故，很懂江湖，很经沧桑，很有人缘，很够朋友，很够意思，很有想法，很有目的，很点点点点点点，总之，不管他是放眼世界纵横古今，还是家长里短柴米油盐，喝给别人看的人总是要喝出点名堂来的，其中的目的或近或远，或浓或淡；有战略性的，有战术性的；有点到为止鸣金收兵的，也有短兵相接空手白刃的，一时间觥筹交错，碗筷皆兵，香烟四起，杯声震天……林林总总，形形色色，不达目的誓不罢休。你们觉得这种人，如何？我不觉得能喝很多酒算什么本事！</span></p><p><span class=\"ql-size-large\">路上本没有路，走的人多了，也就成了路。希望新一批的我们营造出一个和谐的酒氛围。改变下死观念！</span></p>', '反正少喝点吧- -', '2020-06-17 14:44:57', 78, 'http://example.kkslide.fun/upload_8abb21a88f991d79efd8f3d1901cc208', '', '0', '0');
INSERT INTO `article` VALUES (5, '【git】删除远程分支和本地分支', '35', '<p>问题描述：</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当我们集体进行项目时，将自定义分支push到主分支master之后，如何删除远程的自定义分支呢</p><p>问题解决：</p><p><span style=\"background-color: rgb(245, 245, 245);\">（1）使用命令git branch -a 查看所有分支</span></p><p><img src=\"http://example.kkslide.fun/upload_e10297a436f2fdff2fd3ebd4fe43597f\"></p><p>注：其中，<span style=\"color: rgb(230, 0, 0);\">remote/xxxx/xxxx</span> 表示的是远程分支</p><p><br></p><p>（2）删除远程分支&nbsp;&nbsp;&nbsp;</p><p>		如图片所示，使用命令 git push origin --delete <span style=\"color: rgb(230, 0, 0);\">分支名称</span>&nbsp;&nbsp;可以删除指定远程分支&nbsp;&nbsp;&nbsp;</p><p>		再次使用命令 git branch -a&nbsp;&nbsp;可以发现，远程分支已经被删除。</p><p><img src=\"http://example.kkslide.fun/upload_f26de3554fccd8ce86fbaa42b1c66d73\"></p><p><br></p><p>（3）删除本地分支</p><p>		使用命令，git branch -d Chapater8 可以删除本地分支（在主分支或者其他分支中）</p><p>		如图所示，在从Chapater8分支切换到master分支，git checkout&nbsp;master</p><p>		然后使用 git branch -d Chapater8 可以删除Chapater8分支。</p><p><img src=\"http://example.kkslide.fun/upload_93104ac577536c414e7cd8ce9a58722d\"></p>', 'git关于分支的操作', '2020-06-17 14:44:57', 26, 'http://example.kkslide.fun/upload_48c69fb8e08421acc964cbc6685f41e5', '', '0', '0');
INSERT INTO `article` VALUES (6, '一些常用命令', '35', '<p>登陆腾讯云服务器</p><p>ssh root@134.175.129.219</p><p><br></p><p>启动mongodb</p><p>sh ./mongodb.sh</p><p><br></p><p>上传文件</p><p><strong>命令格式：scp 文件名 用户名@服务器ip:目标路径</strong></p><p>scp /Users/spirit/Documents/WechatIMG135.jpeg root@134.175.129.219:/usr/local</p><p><br></p><p><strong>上传文件夹到服务器</strong></p><p><strong>命令格式：scp -r 文件名 用户名@服务器ip:目标路径</strong></p><p>scp -r /Users/spirit/Documents/fileFolder root@192.168.1.1:/usr/local</p><p><br></p><p><strong>服务器下载文件到mac</strong></p><p><strong>命令格式：scp 用户名@服务器ip:文件路径 目标路径</strong></p><p>scp root@192.168.1.1:/usr/local/WechatIMG135.jpeg /Users/spirit/Documents</p><p><br></p><p><strong>服务器下载文件夹到mac</strong></p><p><strong>命令格式：scp -r 用户名@服务器ip:文件路径 目标路径</strong></p><p>scp -r root@192.168.1.1:/usr/local/fileFolder /Users/spirit/Documents</p>', '一些自己电脑上用的常用命令', '2020-06-17 14:44:57', 29, 'http://example.kkslide.fun/upload_54f5f8dec560f1bd45be02b1f078dace', '', '0', '0');
INSERT INTO `article` VALUES (7, '2019年7月剪辑-【爱桂林】-街拍-集锦', '34', '<p><span class=\"ql-size-huge\">那是去年5、6、7月待在桂林出差的时候拍的视频集锦</span></p><p><span class=\"ql-size-huge\">幸好是桂林, 感谢这座城市让我有机会又见到了多年未见的小伙伴</span></p><p><span class=\"ql-size-huge\">当年心心念念的这座城 哈哈哈哈 留下了90天的生命 舒服了</span></p>', '-', '2020-06-17 14:44:57', 79, 'http://example.kkslide.fun/upload_f5775b20fce5d152445eb50f0020c4a4', 'http://example.kkslide.fun/trip-in-guilin_v2.mp4', '0', '0');
INSERT INTO `article` VALUES (8, 'package-lock和package有什么区别?', '35', '<p>根据官方文档，package-lock.json 是生成的系统当前安装的库的具体来源和版本号。</p><p>是根据npm install 生成的。</p><p><br></p><p>当我们使用最新的Node运行‘npm instal --save xxx\'，的时候，他会优先考虑使用插入符号（^）而不是波浪符号（~）了。</p><p>这对于你来说意味这什么呢？首先我们需要理解这两者（~和^）的区别。</p><p><strong>波浪符号（~）</strong>：他会更新到当前minor version（也就是中间的那位数字）中最新的版本。放到我们的例子中就是：body-parser:~1.15.2，这个库会去匹配更新到1.15.x的最新版本，如果出了一个新的版本为1.16.0，则不会自动升级。波浪符号是曾经npm安装时候的默认符号，现在已经变为了插入符号。</p><p><strong>插入符号（^）</strong>：这个符号就显得非常的灵活了，他将会把当前库的版本更新到当前major version（也就是第一位数字）中最新的版本。放到我们的例子中就是：bluebird:^3.3.4，这个库会去匹配3.x.x中最新的版本，但是他不会自动更新到4.0.0。</p><p><br></p><p>1. npm安装package.json时&nbsp;直接转到当前项目目录下用命令npm install 或npm install --save-dev安装即可，自动将package.json中的模块安装到node-modules文件夹下</p><p>2. package.json 中添加中文注释会编译出错</p><p>3. 每个项目的根目录下面，一般都有一个package.json文件，定义了这个项目所需要的各种模块，以及项目的配置信息（比如名称、版本、许可证等元数据）。npm install 命令根据这个配置文件，自动下载所需的模块，也就是配置项目所需的运行和开发环境。</p><p>4. package.json文件可以手工编写，也可以使用<strong>npm init</strong>命令自动生成。</p><p><br></p>', 'package-lock.json和package.json', '2020-08-29 14:44:57', 31, 'http://example.kkslide.fun/upload_d79d383f3221faedb33a9831bbc1c17f', '', '0', '0');
INSERT INTO `article` VALUES (9, '当人大了，喜悦还是忧愁？', '36', '<p class=\"ql-align-justify\"><span class=\"ql-size-large\">小时候，我们总希望自己能快长快大，去过那只属于大人的生活，去摆脱大人对自己的约束，尽情地在公园游玩，买所有想买的东西。。。。。。</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">小时候的我们，如此无忧无虑，每日与伙伴嬉戏。我们并不需要去关心什么考试，什么就业，什么结婚，生子，买房。。。。。。等等问题。那时的我们所关心的，只有动画片中的剧情，父母是否会买给自己那个自己心怡依旧的玩具，明天要和小朋友们玩什么。一切都死那么美好，一切都死那么的无忧无虑。</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">渐渐的，我们长大了，接触的事多了，空闲的时间少了。长大了，我们开始接触以前渴望接触的事，买自己喜欢的东西，去自己爱去的地方，我们尝到了再打的甜和喜悦。长大后，我们也渐渐开始明白事理&nbsp;，开始学会关心身边的人和事，担忧随之而来，忧愁渐渐成为我们的主要情绪。</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">我们无法去评判一个人长大是好或是坏，我们所能做的自由接受它。当人们长大以后，接触的东西会变多，关心的事情会变多，心中的挂碍自然也就多了。既然担忧与挂碍不能改变什么，那么，何不将其放下呢？佛曰：“无挂碍故，无有恐怖，远离颠倒梦想，究竟涅槃。”担忧的事情越多，心灵的负担越重，这样如何能让我们走得更远？这样终究会被担忧压垮，如林黛玉一般郁郁而终。</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">岁月如一条大河，奔流向前，我们无法阻挡，更无法逆流而上，成长是任何人都无法改变的，人终究会长大。但我们依旧可以留有一颗童心，一颗纯真，没有担忧的童心。让自己还能如孩提时开怀大笑，如孩提时看到这个世界美好的一面。</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">没有担忧并非是对外界漠不关心，而是明白即使担忧也无法改变什么，不如做好自己该做的。留有一颗童心并非是沉浸于过去，不肯面对现在与将来。而是为了能穿行世俗之中而不沾己身，独处苦难之中也能满怀希望，是为了能更开心，更轻松的活！</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">当人大了，喜悦还是忧愁&nbsp;？由我们自己决定。放下则是轻松，则是喜悦。执念则生负担，则生忧愁。担忧不能改变什么，不如以童心看世界，无需担忧，做真实的自己。</span></p><p class=\"ql-align-justify\"><span class=\"ql-size-large\">肉身虽已长大，但我心依旧如一，童心未泯，则无担忧，开开心心于世间走一遭！&nbsp;</span></p><p class=\"ql-align-justify\"><img src=\"http://example.kkslide.fun/upload_e360e9c2ce8234111b666aecb5b2999f\"></p>', '-转载自晓恒的日志', '2020-06-17 14:44:57', 23, 'http://example.kkslide.fun/upload_9d74fe6e0ec0cc166d961f8fa55fd113', '', '0', '0');
INSERT INTO `article` VALUES (10, 'Ted。——给自己一颗永远长不大的心', '33', '<p><span class=\"ql-size-large\">《泰迪熊》这部片的预告片看得笑得不行，于是网上一有资源马上就下载看了。</span></p><p><span class=\"ql-size-large\"> 可是不知道为什么，到了最后居然掉了眼泪。——我真的不是文艺青年了啦TAT。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 从哪里说起好呢。最开始的镜头就是John被所有的小男孩拒绝的镜头，然后他许愿，美梦成真，Ted突然就开口说话，三观突然就被刷新。</span></p><p><span class=\"ql-size-large\"> 岁月这个玩意儿不吭一声就斗转星移，那个操着一口正太音的正太突然就变音成大叔，披着萌物的皮爆着粗口抽大烟，载着John去上班的时候很有潘长江开车的效果，一张粗眉毛囧脸颇有喜感。</span></p><p><span class=\"ql-size-large\"> Ted跟John一起27年，打下了无比坚固的基情。他们一起在雷声滚滚的时候对着雷声比中指，话说我一直在想Ted有手指这种东西么...Ted可以让John翘班去跟他一起抽大麻，可以让John从妹子的Party上赶来去见自己心中的英雄。</span></p><p><span class=\"ql-size-large\"> 妹子说，如果Ted不搬出去的话他们就没办法继续生活。所以Ted说我懂了然后就双目痴呆地搬了出去。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 可是他对John影响太大了。Ted一边打着John一边说了“她和你才认识四年，我跟你都二十七年了我特么的戒指呢”之后，Laura打开John送的礼物，里面并不是一只戒指...- -，好吧事实证明了基情是真实存在的...</span></p><p><span class=\"ql-size-large\"> 我只是在开玩笑，可是所有人都认为John是因为总和Ted呆着一起才会变得永远长不大。所以当Laura愤怒地把车开走要离开John的时候，John把一切都怪在了Ted身上。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 我看到John转身离去，留下孤零零的Ted站在那里，看Ted抬起手按向自己的心，“I love you”。</span></p><p><span class=\"ql-size-large\"> 真心就突然掉泪了。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 可是真的就跟Ted说的一样，他不过是只teddy bear，毫不费力地就能得到工作跟升迁，可以毫无顾忌地摸妹子的胸，甚至可以轻易得到美女cashier的心，他不用担负人生的责任（或者熊生...）。可是John不一样，他总会长大，总要担负起责任，总要为工作和爱情烦恼，他是个人。他拥有Ted，可是不能变成Ted。那根本不是Ted的错。</span></p><p><span class=\"ql-size-large\"> Ted和John终于打了一架，天昏地暗惨不忍睹，真的是认真地打了一架。其实离开Ted的John也没有好过很多，他在Ted的帮助下站在舞台上五音不全地为妹子唱了首歌，虽然最后还是以暴力结尾被cop带走了但是毕竟还是打动了美人心。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 但是这么坚固的基情必然会遭到愤恨。原谅我实在是记不清人名，反正就就是遭人嫉恨然后Ted就被绑架了...绑架犯的弱智儿子还硬生生地撕下了Ted的一只耳朵，然后Ted很硬汉地找了个订书器就把自己的耳朵钉上了...看着我都觉得疼啊。</span></p><p><span class=\"ql-size-large\"> Ted骗小弱智说来玩捉迷藏吧，然后悄悄地去找了个电话给John求救——所以你看，最困难的时候，Ted唯一能想到的就是John。</span></p><p><span class=\"ql-size-large\"> 其实想一想，作为一个人来说，John已经拥有很多了，可是Ted除了左拥右抱一堆美女，呼朋唤友一起吃吃喝喝，就只剩下一个John，或者说，还好，他还剩下一个John。</span></p><p><span class=\"ql-size-large\"> Ted说，我只属于John。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 就算是身体被撕裂成了两半，Ted也还不忘了告诫John说，别忘了Laura对你来说才是最重要的。</span></p><p><span class=\"ql-size-large\"> Ted的死对于John来说几乎是个毁灭性的打击，但是Laura的愿望让Ted又死而复生，刚刚“活”过来的时候Ted也还不忘搞怪一把。</span></p><p><span class=\"ql-size-large\"> 最后的结局自然是三个人快快乐乐地生活在了一起咯。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 怎么说呢，这部片子看预告好像根本就是部喜剧片，可是人家的级别限制在那里摆着呢，自然是免不了低级趣味和黑色幽默，但是还是觉得很有代入感。</span></p><p><span class=\"ql-size-large\"> 泰迪熊本身就是童年的代表，所以这部片子真真地是毁了童年刷了三观啊。</span></p><p><span class=\"ql-size-large\"> 回头想想，每个人都会长大，总有一天要面对那些我们可能毫无准备的事情，总有一天要承担起对家庭对社会的责任。总有一天，会变成一个大人。</span></p><p><span class=\"ql-size-large\"> 简单的生活背后，谁还有一颗永不长大的心。为什么Ted对John来说那么重要，还不就是因为在忙碌和压力之后，他还有Ted可以解解闷抽抽烟爆粗口扯闲篇儿，可以一起做一些平常不能做的事情。</span></p><p><span class=\"ql-size-large\"> Ted是他永远忠实的朋友，是他苍白生活里的英雄梦想，是他不忍心放弃的童年记忆，更是他不能舍下的美好情谊。</span></p><p><span class=\"ql-size-large\"> </span></p><p><span class=\"ql-size-large\"> 每个人的心里都有一只泰迪熊，代表着我们美好得五颗星都打不住的童年生活。我还记得那些动画片，葫芦娃猫和老鼠鸭子侦探蜡笔小新樱桃小丸子聪明的一休多啦A梦七龙珠四驱兄弟...我可以无穷无尽地列举下去。还有那些现在还在我屋子里的毛绒玩具，我根本就离不开。</span></p><p><span class=\"ql-size-large\"> 那是我的永无乡，是我的移动城堡。那是我们可以短暂离开现实生活的唯一一小块净土。</span></p><p><span class=\"ql-size-large\"> 请给自己一颗永不长大的心，在你的衣冠楚楚的外表下面，让自己尽情地撒野。</span></p><p><br></p>', '电影《泰迪熊》观后感', '2020-06-17 14:44:57', 30, 'http://example.kkslide.fun/upload_083d632b64b0862137d29a1b884af1c9', '', '0', '0');
INSERT INTO `article` VALUES (11, '关于轮滑', '33', '<p><span class=\"ql-size-large\">其实不是对66无感或放弃了</span></p><p><span class=\"ql-size-large\">最近频率下降的原因主要有几个</span></p><p><span class=\"ql-size-large\">周遭的轮滑氛围越来愈凉</span></p><p><span class=\"ql-size-large\">总写不完的代码和改不尽的需求</span></p><p><span class=\"ql-size-large\">打篮球很爽的 结交了很多志同道合 又很刚很猛又很能喝的朋友</span></p><p><span class=\"ql-size-large\">新旧事物的学习积累和犯错和改正</span></p><p><span class=\"ql-size-large\">渐渐让人感到无奈的 除了工作上的责任 还有日渐下降的精力 也有在人际关系上的把控</span></p><p><span class=\"ql-size-large\">有时吧约了挺多6友刷街或是玩鞋 但也却像是任务一样了了刷刷 集合/慢. 交流/淡. 练习/懒. 沟通/难. 总觉是换了地方玩手机. 缺失了往日的纯粹 速度的追求 还有进步突破时的爽.</span></p><p><span class=\"ql-size-large\">思想又掉进了通哥的黑洞金句’大家都忙…’</span></p><p><span class=\"ql-size-large\">轮滑6年间 七成以上的朋友都是透过这玩具结识的 它给予我许多从未有过的体验 也为我开了许多扇门 会玩Photoshop是因为做海报做服装 爱上剪辑和摄影是因为接了宣传片的任务 小孩子中也能孩子王是因为黄哥给了我教练的身份和广阔的平台</span></p><p><span class=\"ql-size-large\">地方刷了一处接一处 鞋子废了一双接一双 6友更是换了一批又一批 ‘像是在搭公车.陪你坐到终点的又剩下哪几个’</span></p><p><span class=\"ql-size-large\">反思后愕然发觉活得越来越酷朋友丢了一路也不是没有原由&nbsp;***啊原来我挺烂的…***</span></p><p><span class=\"ql-size-large\">一直相信相遇皆缘分</span></p><p><span class=\"ql-size-large\">若干年后如果你想起来 似乎以前认识个超爱玩轮滑的 挺有个性 emmm 差不多就行了</span></p><p><span class=\"ql-size-large\">平花挺爽的</span></p><p><span class=\"ql-size-large\">速滑挺爽的</span></p><p><span class=\"ql-size-large\">刹车挺爽的</span></p><p><span class=\"ql-size-large\">玩极限痛爽痛爽的</span></p><p><span class=\"ql-size-large\">还有就是</span></p><p><span class=\"ql-size-large\">我会继续玩下去的</span></p><p><br></p><p><img src=\"http://example.kkslide.fun/upload_a14bdadee27d9da810cf9124d576803f\"></p><p><br></p><p><img src=\"http://example.kkslide.fun/upload_395de88b07ccd5b4f2661f2215b434f4\"></p>', '-今年对于轮滑的感悟', '2020-06-17 14:44:57', 29, 'http://example.kkslide.fun/upload_af3490fc901a0b8f26d88bc19899c429', '', '0', '0');
INSERT INTO `article` VALUES (12, '2020-05-22-车陂MVP篮球集锦', '34', '<p>哈哈哈哈哈哈哈 一不小心就又打嗨了 </p>', '-', '2020-06-17 14:44:57', 31, 'http://example.kkslide.fun/upload_9a6323d8478e0e0e2487ee0c60ef5f87', 'http://example.kkslide.fun/kk_mvp.MP4', '0', '0');
INSERT INTO `article` VALUES (13, '-刷街Solo-被自己帅到', '34', '<p>现在call友出来刷街变得越来越难了!!!</p>', '-', '2020-08-30 23:36:58', 28, 'http://example.kkslide.fun/upload_36edb5f64572eaeb602dd42ad4d16508', 'http://example.kkslide.fun/main.mov', '0', '0');
INSERT INTO `article` VALUES (14, '东晟球馆-养生篮球', '34', '<p><span style=\"color: rgb(166, 166, 166);\" class=\"ql-size-large\">球场遇到一个小可爱<img src=\"http://qzonestyle.gtimg.cn/qzone/em/e252.png\"></span></p><p><span style=\"color: rgb(166, 166, 166);\" class=\"ql-size-large\">哈哈哈哈不要看GoPro啦<img src=\"http://qzonestyle.gtimg.cn/qzone/em/e120.png\"></span></p><p><span style=\"color: rgb(166, 166, 166);\" class=\"ql-size-large\">看我打球不好吗<img src=\"http://qzonestyle.gtimg.cn/qzone/em/e251.png\"></span></p>', '-', '2020-08-31 00:29:32', 26, 'http://example.kkslide.fun/upload_394c7c7652ab667530429acccdeeb420', 'http://example.kkslide.fun/8-21-30s.mov', '0', '0');
INSERT INTO `article` VALUES (15, '东莞刷街-mini-vlog', '34', '<p><strong class=\"ql-size-large\">虽然那天很不爽, 不过算了吧, 得人恩果千年记. 勿忘初心!!</strong></p>', '-', '2020-08-31 00:37:32', 29, 'http://example.kkslide.fun/upload_7e7379a93d95f4108c4e14de0f1f4cfc', 'http://example.kkslide.fun/roll_in_DG.MP4', '0', '0');
INSERT INTO `article` VALUES (16, '如果将AE定位用在篮球上会怎样的效果', '34', '<p><span style=\"color: rgb(92, 0, 0);\" class=\"ql-size-huge\">很喜欢去华师打篮球啊,因为有好多小姐姐一起哈哈哈哈哈哈</span></p>', '-', '2020-08-31 00:42:03', 14, 'http://example.kkslide.fun/upload_bdf36f6d5f8c3f536fc2b58ed06cde32', 'http://example.kkslide.fun/eye-on-the-ball.MP4', '1', '0');
INSERT INTO `article` VALUES (17, '谷歌浏览器截屏! Full-Size!!!', '35', '<p><span class=\"ql-size-large\">1- 打开控制台</span></p><p><br></p><p><span class=\"ql-size-large\">2- 打开输入命令窗口- Ctrl+Shift+P</span></p><p><span class=\"ql-size-large\">		输入命令: capture...</span></p><p><span class=\"ql-size-large\">		然后就会出现:</span></p><p><span class=\"ql-size-large\">		<img src=\"http://example.kkslide.fun/upload_e4d2356e1a5c2ac4f9d0ff93d91541fb\"></span></p><p><span class=\"ql-size-large\">		</span></p><p>			<span class=\"ql-size-large\">接着, 保存就可以了</span></p><p><br></p><p><span class=\"ql-size-large\">超级容易!!!!</span></p><p><br></p>', '无需插件!谷歌浏览器截取整个网页!', '2020-09-15 16:39:32', 17, 'http://example.kkslide.fun/upload_a339108f6cd261c8054f20592c989a84', '', '0', '0');
INSERT INTO `article` VALUES (18, '关于Linux', '35', '<p><strong class=\"ql-size-large\">一、linux添加用户并赋予root权限:</strong></p><p><strong style=\"color: rgb(51, 102, 255);\">1、添加用户，首先用adduser命令添加一个普通用户，命令如下：</strong></p><pre class=\"ql-syntax\" spellcheck=\"false\">#adduser eric\n\n\n//添加一个名为eric的用户\n#passwd eric//修改密码\nChanging password for user eric.\nNew UNIX password:&nbsp; &nbsp;//在这里输入新密码\nRetype new UNIX password: //再次输入新密码\npasswd: all authentication tokens updated successfully.\n</pre><p><br></p><p><strong style=\"color: rgb(51, 102, 255);\">2、赋予root权限</strong></p><p><strong>修改 /etc/passwd 文件，找到如下行，把用户ID修改为 0</strong></p><p>如下所示：</p><p><img src=\"http://example.kkslide.fun/upload_a5d9fad8d28092439c90d30a0b7b8e6d\"></p><p><br></p><p><br></p><p><strong class=\"ql-size-large\">二</strong><strong>、</strong><strong class=\"ql-size-large\">虚拟机与宿主机共享文件夹不显示的解决办法:</strong></p><p><strong style=\"color: rgb(77, 77, 77);\">root用户下执行：</strong></p><pre class=\"ql-syntax\" spellcheck=\"false\">vmhgfs-fuse .host:/ /mnt/hgfs -o nonempty\n</pre><p><br></p><p><br></p>', 'some command about linux', '2020-10-10 11:21:52', 2, 'http://example.kkslide.fun/upload_39ef94fe819690348bbc76ebaa2dc94d', '', '0', '0');
INSERT INTO `article` VALUES (19, '10月份国内新增确诊病例559例', '33', '<p class=\"ql-align-justify\"><strong>(健康时报记者毛圆圆)</strong>国家卫建委发布新冠肺炎疫情最新情况显示，截至10月30日24时，据31个省（自治区、直辖市）和新疆生产建设兵团报告，现有确诊病例355例（其中重症病例9例），累计治愈出院病例80984例，累计死亡病例4634例，累计报告确诊病例85973例，现有疑似病例5例。累计追踪到密切接触者859748人，尚在医学观察的密切接触者13280人。</p><p class=\"ql-align-justify\"><br></p><p class=\"ql-align-justify\">记者梳理了国内10月1日～30日的新冠肺炎疫情情况：10月份新增确诊病例，为559例，其中境外输入病例494例，国内确诊病例65例，其中山东省累计确诊14例，即在12日确诊6例，13日确诊6例，14日确诊1例，29日确诊1例；新疆维吾尔自治区累计确诊51例，即在27日确诊22例，28日确诊23例，30日确诊6例。</p><p><span style=\"color: rgb(51, 51, 51);\">在新增的确诊病例中，境外输入病例494例，10月23日境外输入病例最多，为28例。而在近一周，境外输入病例所在的18个省市中，上海市输入病例最多，为53例；其次是广东省，为15例；内蒙古自治区、陕西省境外输入病例数量都是13例，排名第三。</span></p>', '10月份国内新增确诊病例559例！上海市近一周境外输入病例最多', '2020-10-31 22:22:00', 1, 'http://example.kkslide.fun/upload_265526d64445101486001e612770ad33', '', '0', '0');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `addtime` timestamp(0) NULL DEFAULT NULL COMMENT '分类添加时间',
  `edittime` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '分类修改时间',
  `banner` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类缩略图',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (32, 'Fun', '2020-06-17 17:26:38', '2020-08-27 02:52:02', 'http://example.kkslide.fun/upload_dbbe9de42a8574a144ba04542f0289c9', '0');
INSERT INTO `category` VALUES (33, 'Blog', '2020-06-17 17:26:44', '2020-08-31 00:02:10', 'http://example.kkslide.fun/upload_c98e7b0556edc2ac83a517002398b1a5', '0');
INSERT INTO `category` VALUES (34, 'Vlog', '2020-06-17 17:26:52', '2020-08-27 02:52:18', 'http://example.kkslide.fun/upload_e0afef4ea755a480d55be35b8b4d274b', '0');
INSERT INTO `category` VALUES (35, 'Code', '2020-06-17 17:26:59', '2020-08-27 02:51:41', 'http://example.kkslide.fun/upload_ca23bdad143c0c48b25e079880042d88', '0');
INSERT INTO `category` VALUES (36, 'Other', '2020-08-17 17:39:10', '2020-08-27 02:52:33', 'http://example.kkslide.fun/upload_8a5cb83875e12cd410ea6804f1ae8823', '0');
INSERT INTO `category` VALUES (37, 'VVV', '2020-08-29 04:40:46', '2020-08-30 22:20:21', 'http://example.kkslide.fun/banner.jpg', '1');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `t_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表格id',
  `a_id` int(11) NULL DEFAULT NULL COMMENT '与文章关联的id',
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '读者 或 用户',
  `time` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '评论时间',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户IP',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论内容',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`t_id`) USING BTREE,
  INDEX `commentid`(`a_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 33 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 1, 'aaa', '2020-08-17 10:55:38', '127.0.0.1', '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈', '1');
INSERT INTO `comment` VALUES (2, 1, 'bbb', '2020-08-12 10:42:48', '127.0.0.1', '呵呵呵呵呵呵', '0');
INSERT INTO `comment` VALUES (3, 2, 'test', '2020-08-12 10:42:51', '127.0.0.1', '按实际到货发顺丰卢卡斯的话', '0');
INSERT INTO `comment` VALUES (4, 3, 'gggg', '2020-08-30 22:30:21', '127.0.0.1', '自行车那边v你装修成本v名不虚传', '1');
INSERT INTO `comment` VALUES (5, 3, 'rrrr', '2020-08-12 10:42:52', '127.0.0.1', '请问u人情味有人陪我却依然', '0');
INSERT INTO `comment` VALUES (6, 2, 'fffffff', '2020-08-12 10:42:53', '127.0.0.1', '12346789', '0');
INSERT INTO `comment` VALUES (7, 4, 'qweasd', '2020-08-12 10:42:53', '127.0.0.1', 'abcdefchijklmnopqrstuvwxyz', '0');
INSERT INTO `comment` VALUES (8, 4, 'cast', '2020-08-12 10:42:54', '127.0.0.1', '11111111111111111111111111', '0');
INSERT INTO `comment` VALUES (9, 4, 'hhh', '2020-08-12 10:42:55', '127.0.0.1', 'hhhh', '0');
INSERT INTO `comment` VALUES (10, 4, 'fff', '2020-08-12 10:42:55', '127.0.0.1', 'fffffff', '0');
INSERT INTO `comment` VALUES (11, 4, 'aa', '2020-08-12 10:42:56', '127.0.0.1', 'aaaa<span class=\"emoji-item-common emoji-disappointed_relieved emoji-size-small\" ></span>', '0');
INSERT INTO `comment` VALUES (12, 1, 'aaaa', '2020-08-12 10:42:59', '127.0.0.1', 'aaaaaaaaaaaa', '0');
INSERT INTO `comment` VALUES (13, 5, '亲爱的kk', '2020-08-27 03:07:50', '127.0.0.1', '<span class=\"emoji-item-common emoji-expressionless emoji-size-small\" ></span> 还有这种操作...', '0');
INSERT INTO `comment` VALUES (14, 4, '某某', '2020-08-27 03:08:35', '127.0.0.1', '中国酒文化太可怕了...<span class=\"emoji-item-common emoji-cold_sweat emoji-size-small\" ></span>', '0');
INSERT INTO `comment` VALUES (15, 3, 'hh', '2020-08-27 03:09:04', '127.0.0.1', '帅爆了', '0');
INSERT INTO `comment` VALUES (16, 7, 'somebody', '2020-08-27 03:23:54', '127.0.0.1', '太帅了!!!!', '0');
INSERT INTO `comment` VALUES (17, 7, '剪辑师', '2020-08-27 03:28:16', '127.0.0.1', '好喜欢这种风格的剪辑!!!!', '1');
INSERT INTO `comment` VALUES (18, 8, 'haha', '2020-08-29 05:24:44', '127.0.0.1', '666', '0');
INSERT INTO `comment` VALUES (19, 11, 'kk', '2020-08-31 00:23:42', '127.0.0.1', '生命不息 轮滑不止 !!! 继续玩下去! 加油!<span class=\"emoji-item-common emoji-relaxed emoji-size-small\" ></span>', '0');
INSERT INTO `comment` VALUES (20, 5, 'test', '2020-08-31 02:05:44', '113.65.231.186', 'test', '0');
INSERT INTO `comment` VALUES (21, 13, 'comander@gopro.com', '2020-08-31 02:08:07', '113.65.231.186', 'cooooLLLL !!!!!', '0');
INSERT INTO `comment` VALUES (22, 8, 'hhhhhh', '2020-08-31 02:10:12', '113.65.231.186', 'another test', '0');
INSERT INTO `comment` VALUES (23, 8, 'aaa', '2020-08-31 02:10:45', '113.65.231.186', 'that is not ok ', '0');
INSERT INTO `comment` VALUES (24, 6, '小测试', '2020-08-31 02:32:10', '127.0.0.1', '封面图片很赞哦哈哈哈哈哈', '0');
INSERT INTO `comment` VALUES (25, 14, '测试', '2020-08-31 02:32:32', '113.65.231.186', '妹子是谁???', '0');
INSERT INTO `comment` VALUES (26, 1, 'gitignore', '2020-08-31 02:52:49', '113.65.231.186', 'gitignore', '0');
INSERT INTO `comment` VALUES (27, 6, 'iPad', '2020-08-31 03:25:17', '113.65.231.186', 'iPad测试', '0');
INSERT INTO `comment` VALUES (28, 4, '哈哈哈', '2020-09-01 21:50:23', '113.65.231.85', '喝!!!', '0');
INSERT INTO `comment` VALUES (29, 15, '哈哈哈', '2020-09-07 01:30:31', '113.65.208.0', '帅!', '0');
INSERT INTO `comment` VALUES (30, 4, '127.0.0.1', '2020-09-16 17:07:02', '127.0.0.1', 'hhhh', '0');
INSERT INTO `comment` VALUES (31, 14, '59.41.65.161', '2020-09-18 03:38:05', '59.41.65.161', 'test<span class=\"emoji-item-common emoji-disappointed_relieved emoji-size-small\" ></span>', '0');
INSERT INTO `comment` VALUES (32, 17, '112.96.101.43', '2020-09-30 17:26:40', '112.96.101.43', '<span class=\"emoji-item-common emoji-disappointed_relieved emoji-size-small\" ></span><span class=\"emoji-item-common emoji-disappointed_relieved emoji-size-small\" ></span><span class=\"emoji-item-common emoji-disappointed_relieved emoji-size-small\" ></span>', '0');

-- ----------------------------
-- Table structure for messages
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addtime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '留言时间',
  `viewer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'stranger' COMMENT '访客名字或者邮箱',
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '留言信息',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户IP',
  `is_del` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '该留言是否删除- 或屏蔽-',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of messages
-- ----------------------------
INSERT INTO `messages` VALUES (1, '2020-08-27 03:31:06', 'hhhhh', '大连地铁回应“两外国人攀爬扶手”：在中国必须尊重中国法律', '127.0.0.1', '1');
INSERT INTO `messages` VALUES (2, '2020-08-12 11:09:48', 'gggg', '“中国的帮助增强了我们抗疫信心”（患难见真情 共同抗疫情）', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (3, '2020-08-12 11:09:39', 'aaa', '国家卫健委：各地要开展农贸集贸市场风险大排查', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (4, '2020-08-12 11:09:30', 'bbbb', '广东居民赴澳门旅游签注，8月26日起恢复办理', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (5, '2020-08-12 11:10:27', 'vvv', '张玉环无罪释放后办理新身份证<span class=\"emoji-item-common emoji-disappointed emoji-size-small\" ></span>', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (6, '2020-08-17 10:59:56', '手动阀手动阀', '痛心！致敬！冲锋在前，持续奋战在抗击疫情一线', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (7, '2020-08-17 10:59:55', '啊手动阀手动阀 ', '羊要来了！蒙古国正式启动3万只羊捐赠程序', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (8, '2020-08-17 10:56:19', 'viewer_1', '31省区市新增确诊22例', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (9, '2020-08-16 09:57:17', 'stranger', '男子发文称被副局长锁在家中殴打', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (10, '2020-08-27 03:31:48', 'stranger', '中央气象台继续发布暴雨橙色预警', '127.0.0.1', '1');
INSERT INTO `messages` VALUES (11, '2020-08-12 15:58:34', 'stranger', '镇安7.1亿豪华中学学生发声', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (12, '2020-08-13 10:58:45', 'stranger', '袁冰妍回应直播中亲成毅', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (13, '2020-08-17 11:02:35', 'stranger', '葡萄牙总统采访中跳海救人', '127.0.0.1', '0');
INSERT INTO `messages` VALUES (14, '2020-08-27 03:31:33', 'aaa', 'it`s just a test', '127.0.0.1', '1');
INSERT INTO `messages` VALUES (15, '2020-08-27 03:35:05', '848744804@qq.com', '最新留言<span class=\"emoji-item-common emoji-astonished emoji-size-small\" ></span>', '127.0.0.1', '1');
INSERT INTO `messages` VALUES (16, '2020-08-31 03:29:54', 'bug报告', '视频播放页跳转下一篇的时候有bug<span class=\"emoji-item-common emoji-angry emoji-size-small\" ></span>', '113.65.231.186', '0');

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
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'kk', '', 1);

-- ----------------------------
-- Table structure for visitors
-- ----------------------------
DROP TABLE IF EXISTS `visitors`;
CREATE TABLE `visitors`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 378 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of visitors
-- ----------------------------
INSERT INTO `visitors` VALUES (1, '2020-08-18 09:15:14', '127.0.0.1');
INSERT INTO `visitors` VALUES (2, '2020-08-18 08:18:58', '127.0.0.1');
INSERT INTO `visitors` VALUES (3, '2020-08-18 07:19:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (4, '2020-08-18 07:19:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (5, '2020-08-18 10:51:09', '127.0.0.1');
INSERT INTO `visitors` VALUES (6, '2020-08-18 10:51:51', '127.0.0.1');
INSERT INTO `visitors` VALUES (7, '2020-08-18 11:38:03', '127.0.0.1');
INSERT INTO `visitors` VALUES (8, '2020-08-18 12:04:13', '127.0.0.1');
INSERT INTO `visitors` VALUES (9, '2020-08-18 15:18:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (10, '2020-08-18 15:18:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (11, '2020-08-18 15:38:21', '127.0.0.1');
INSERT INTO `visitors` VALUES (12, '2020-08-18 16:38:23', '127.0.0.1');
INSERT INTO `visitors` VALUES (13, '2020-08-18 16:38:24', '127.0.0.1');
INSERT INTO `visitors` VALUES (14, '2020-08-18 16:38:26', '127.0.0.1');
INSERT INTO `visitors` VALUES (15, '2020-08-18 16:38:39', '127.0.0.1');
INSERT INTO `visitors` VALUES (16, '2020-08-18 16:38:41', '127.0.0.1');
INSERT INTO `visitors` VALUES (17, '2020-08-18 17:33:13', '127.0.0.1');
INSERT INTO `visitors` VALUES (18, '2020-08-18 17:40:27', '127.0.0.1');
INSERT INTO `visitors` VALUES (19, '2020-08-18 17:40:29', '127.0.0.1');
INSERT INTO `visitors` VALUES (20, '2020-08-18 17:40:31', '127.0.0.1');
INSERT INTO `visitors` VALUES (21, '2020-08-18 20:30:47', '127.0.0.1');
INSERT INTO `visitors` VALUES (22, '2020-08-18 20:54:23', '127.0.0.1');
INSERT INTO `visitors` VALUES (23, '2020-08-18 20:54:24', '127.0.0.1');
INSERT INTO `visitors` VALUES (24, '2020-08-18 20:54:26', '127.0.0.1');
INSERT INTO `visitors` VALUES (25, '2020-08-18 20:54:27', '127.0.0.1');
INSERT INTO `visitors` VALUES (26, '2020-08-18 20:54:28', '127.0.0.1');
INSERT INTO `visitors` VALUES (27, '2020-08-24 21:57:02', '127.0.0.1');
INSERT INTO `visitors` VALUES (28, '2020-08-25 00:20:55', '127.0.0.1');
INSERT INTO `visitors` VALUES (29, '2020-08-25 20:03:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (30, '2020-08-27 02:12:33', '127.0.0.1');
INSERT INTO `visitors` VALUES (31, '2020-08-27 02:25:21', '127.0.0.1');
INSERT INTO `visitors` VALUES (32, '2020-08-27 02:34:03', '127.0.0.1');
INSERT INTO `visitors` VALUES (33, '2020-08-27 02:49:09', '127.0.0.1');
INSERT INTO `visitors` VALUES (34, '2020-08-27 03:02:03', '127.0.0.1');
INSERT INTO `visitors` VALUES (35, '2020-08-27 09:47:52', '127.0.0.1');
INSERT INTO `visitors` VALUES (36, '2020-08-27 09:56:47', '127.0.0.1');
INSERT INTO `visitors` VALUES (37, '2020-08-27 22:05:26', '127.0.0.1');
INSERT INTO `visitors` VALUES (38, '2020-08-27 23:55:07', '127.0.0.1');
INSERT INTO `visitors` VALUES (39, '2020-08-28 00:36:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (40, '2020-08-28 21:53:52', '127.0.0.1');
INSERT INTO `visitors` VALUES (41, '2020-08-28 22:56:51', '127.0.0.1');
INSERT INTO `visitors` VALUES (42, '2020-08-28 23:01:04', '127.0.0.1');
INSERT INTO `visitors` VALUES (43, '2020-08-28 23:27:02', '127.0.0.1');
INSERT INTO `visitors` VALUES (44, '2020-08-28 23:27:15', '127.0.0.1');
INSERT INTO `visitors` VALUES (45, '2020-08-29 01:36:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (46, '2020-08-29 04:12:23', '127.0.0.1');
INSERT INTO `visitors` VALUES (47, '2020-08-29 04:12:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (48, '2020-08-29 04:13:06', '127.0.0.1');
INSERT INTO `visitors` VALUES (49, '2020-08-29 04:13:17', '127.0.0.1');
INSERT INTO `visitors` VALUES (50, '2020-08-29 04:22:18', '127.0.0.1');
INSERT INTO `visitors` VALUES (51, '2020-08-29 04:38:58', '127.0.0.1');
INSERT INTO `visitors` VALUES (52, '2020-08-29 05:07:53', '127.0.0.1');
INSERT INTO `visitors` VALUES (53, '2020-08-29 05:08:12', '127.0.0.1');
INSERT INTO `visitors` VALUES (54, '2020-08-29 05:08:21', '127.0.0.1');
INSERT INTO `visitors` VALUES (55, '2020-08-29 05:09:28', '127.0.0.1');
INSERT INTO `visitors` VALUES (56, '2020-08-29 05:09:41', '127.0.0.1');
INSERT INTO `visitors` VALUES (57, '2020-08-29 05:09:49', '127.0.0.1');
INSERT INTO `visitors` VALUES (58, '2020-08-29 05:13:17', '127.0.0.1');
INSERT INTO `visitors` VALUES (59, '2020-08-29 05:13:37', '127.0.0.1');
INSERT INTO `visitors` VALUES (60, '2020-08-29 05:13:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (61, '2020-08-29 05:14:02', '127.0.0.1');
INSERT INTO `visitors` VALUES (62, '2020-08-29 05:14:09', '127.0.0.1');
INSERT INTO `visitors` VALUES (63, '2020-08-29 05:14:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (64, '2020-08-29 05:14:11', '127.0.0.1');
INSERT INTO `visitors` VALUES (65, '2020-08-29 05:14:12', '127.0.0.1');
INSERT INTO `visitors` VALUES (66, '2020-08-29 05:14:13', '127.0.0.1');
INSERT INTO `visitors` VALUES (67, '2020-08-29 05:14:14', '127.0.0.1');
INSERT INTO `visitors` VALUES (68, '2020-08-29 05:29:54', '127.0.0.1');
INSERT INTO `visitors` VALUES (69, '2020-08-29 05:40:31', '127.0.0.1');
INSERT INTO `visitors` VALUES (70, '2020-08-29 05:40:42', '127.0.0.1');
INSERT INTO `visitors` VALUES (71, '2020-08-29 06:12:15', '127.0.0.1');
INSERT INTO `visitors` VALUES (72, '2020-08-29 06:32:34', '127.0.0.1');
INSERT INTO `visitors` VALUES (73, '2020-08-29 06:32:30', '127.0.0.1');
INSERT INTO `visitors` VALUES (74, '2020-08-29 17:39:29', '127.0.0.1');
INSERT INTO `visitors` VALUES (75, '2020-08-29 20:11:18', '127.0.0.1');
INSERT INTO `visitors` VALUES (76, '2020-08-29 20:11:33', '127.0.0.1');
INSERT INTO `visitors` VALUES (77, '2020-08-30 03:55:59', '127.0.0.1');
INSERT INTO `visitors` VALUES (78, '2020-08-30 17:21:11', '127.0.0.1');
INSERT INTO `visitors` VALUES (79, '2020-08-30 17:21:02', '127.0.0.1');
INSERT INTO `visitors` VALUES (80, '2020-08-30 17:23:22', '127.0.0.1');
INSERT INTO `visitors` VALUES (81, '2020-08-30 17:27:53', '127.0.0.1');
INSERT INTO `visitors` VALUES (82, '2020-08-30 17:28:00', '127.0.0.1');
INSERT INTO `visitors` VALUES (83, '2020-08-30 17:29:15', '127.0.0.1');
INSERT INTO `visitors` VALUES (84, '2020-08-30 17:29:26', '127.0.0.1');
INSERT INTO `visitors` VALUES (85, '2020-08-30 17:30:34', '127.0.0.1');
INSERT INTO `visitors` VALUES (86, '2020-08-30 17:31:21', '127.0.0.1');
INSERT INTO `visitors` VALUES (87, '2020-08-30 17:31:47', '127.0.0.1');
INSERT INTO `visitors` VALUES (88, '2020-08-30 22:13:24', '127.0.0.1');
INSERT INTO `visitors` VALUES (89, '2020-08-30 22:21:51', '127.0.0.1');
INSERT INTO `visitors` VALUES (90, '2020-08-31 00:21:14', '127.0.0.1');
INSERT INTO `visitors` VALUES (91, '2020-08-31 00:22:00', '127.0.0.1');
INSERT INTO `visitors` VALUES (92, '2020-08-31 00:44:22', '127.0.0.1');
INSERT INTO `visitors` VALUES (93, '2020-08-31 01:01:53', '127.0.0.1');
INSERT INTO `visitors` VALUES (94, '2020-08-31 01:07:50', '127.0.0.1');
INSERT INTO `visitors` VALUES (95, '2020-08-31 01:08:57', '127.0.0.1');
INSERT INTO `visitors` VALUES (96, '2020-08-31 01:46:41', '113.65.231.186');
INSERT INTO `visitors` VALUES (97, '2020-08-31 02:04:20', '113.65.231.186');
INSERT INTO `visitors` VALUES (98, '2020-08-31 02:06:36', '113.65.231.186');
INSERT INTO `visitors` VALUES (99, '2020-08-31 02:09:43', '113.65.231.186');
INSERT INTO `visitors` VALUES (100, '2020-08-31 02:17:00', '127.0.0.1');
INSERT INTO `visitors` VALUES (101, '2020-08-31 02:17:00', '127.0.0.1');
INSERT INTO `visitors` VALUES (102, '2020-08-31 02:21:08', '127.0.0.1');
INSERT INTO `visitors` VALUES (103, '2020-08-31 02:32:36', '113.65.231.186');
INSERT INTO `visitors` VALUES (104, '2020-08-31 02:36:39', '127.0.0.1');
INSERT INTO `visitors` VALUES (105, '2020-08-31 02:36:52', '127.0.0.1');
INSERT INTO `visitors` VALUES (106, '2020-08-31 02:36:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (107, '2020-08-31 02:52:13', '113.65.231.186');
INSERT INTO `visitors` VALUES (108, '2020-08-31 03:24:30', '113.65.231.186');
INSERT INTO `visitors` VALUES (109, '2020-08-31 03:25:44', '113.65.231.186');
INSERT INTO `visitors` VALUES (110, '2020-08-31 03:31:28', '113.65.231.186');
INSERT INTO `visitors` VALUES (111, '2020-08-31 03:32:30', '113.65.231.186');
INSERT INTO `visitors` VALUES (112, '2020-08-31 03:39:00', '113.65.231.186');
INSERT INTO `visitors` VALUES (113, '2020-08-31 10:32:27', '127.0.0.1');
INSERT INTO `visitors` VALUES (114, '2020-08-31 10:44:04', '127.0.0.1');
INSERT INTO `visitors` VALUES (115, '2020-08-31 10:45:58', '112.96.194.107');
INSERT INTO `visitors` VALUES (116, '2020-08-31 10:54:20', '127.0.0.1');
INSERT INTO `visitors` VALUES (117, '2020-08-31 10:54:20', '127.0.0.1');
INSERT INTO `visitors` VALUES (118, '2020-08-31 11:04:26', '127.0.0.1');
INSERT INTO `visitors` VALUES (119, '2020-08-31 11:10:04', '127.0.0.1');
INSERT INTO `visitors` VALUES (120, '2020-08-31 11:11:01', '127.0.0.1');
INSERT INTO `visitors` VALUES (121, '2020-08-31 11:20:32', '112.96.194.107');
INSERT INTO `visitors` VALUES (122, '2020-08-31 11:22:34', '127.0.0.1');
INSERT INTO `visitors` VALUES (123, '2020-08-31 11:30:53', '127.0.0.1');
INSERT INTO `visitors` VALUES (124, '2020-08-31 21:09:57', '113.65.231.186');
INSERT INTO `visitors` VALUES (125, '2020-08-31 21:23:01', '113.65.231.186');
INSERT INTO `visitors` VALUES (126, '2020-08-31 21:39:13', '113.65.231.186');
INSERT INTO `visitors` VALUES (127, '2020-08-31 21:41:49', '113.65.231.186');
INSERT INTO `visitors` VALUES (128, '2020-08-31 21:41:55', '113.65.231.186');
INSERT INTO `visitors` VALUES (129, '2020-08-31 21:52:38', '127.0.0.1');
INSERT INTO `visitors` VALUES (130, '2020-08-31 21:53:35', '113.65.231.186');
INSERT INTO `visitors` VALUES (131, '2020-08-31 21:57:08', '113.65.231.186');
INSERT INTO `visitors` VALUES (132, '2020-08-31 22:00:19', '113.65.231.186');
INSERT INTO `visitors` VALUES (133, '2020-08-31 22:01:12', '113.65.231.186');
INSERT INTO `visitors` VALUES (134, '2020-09-01 09:52:09', '127.0.0.1');
INSERT INTO `visitors` VALUES (135, '2020-09-01 21:50:06', '113.65.231.85');
INSERT INTO `visitors` VALUES (136, '2020-09-02 02:33:07', '111.206.221.101');
INSERT INTO `visitors` VALUES (137, '2020-09-02 02:33:13', '111.206.198.103');
INSERT INTO `visitors` VALUES (138, '2020-09-02 02:33:13', '111.206.198.19');
INSERT INTO `visitors` VALUES (139, '2020-09-05 07:30:38', '203.208.60.73');
INSERT INTO `visitors` VALUES (140, '2020-09-06 04:49:47', '51.77.129.167');
INSERT INTO `visitors` VALUES (141, '2020-09-06 15:26:07', '203.208.60.39');
INSERT INTO `visitors` VALUES (142, '2020-09-07 01:29:26', '113.65.208.0');
INSERT INTO `visitors` VALUES (143, '2020-09-07 01:31:46', '113.65.208.0');
INSERT INTO `visitors` VALUES (144, '2020-09-07 01:37:35', '113.65.208.0');
INSERT INTO `visitors` VALUES (145, '2020-09-07 22:19:55', '113.65.229.114');
INSERT INTO `visitors` VALUES (146, '2020-09-11 22:48:12', '113.65.231.214');
INSERT INTO `visitors` VALUES (147, '2020-09-13 13:07:20', '218.17.40.106');
INSERT INTO `visitors` VALUES (148, '2020-09-13 13:07:45', '218.17.40.106');
INSERT INTO `visitors` VALUES (149, '2020-09-13 13:08:13', '218.17.40.106');
INSERT INTO `visitors` VALUES (150, '2020-09-13 13:10:09', '218.17.40.106');
INSERT INTO `visitors` VALUES (151, '2020-09-13 16:50:50', '218.17.40.106');
INSERT INTO `visitors` VALUES (152, '2020-09-13 16:51:12', '218.17.40.106');
INSERT INTO `visitors` VALUES (153, '2020-09-13 16:53:03', '218.17.40.106');
INSERT INTO `visitors` VALUES (154, '2020-09-13 16:54:21', '218.17.40.106');
INSERT INTO `visitors` VALUES (155, '2020-09-13 16:55:06', '218.17.40.106');
INSERT INTO `visitors` VALUES (156, '2020-09-13 16:55:20', '218.17.40.106');
INSERT INTO `visitors` VALUES (157, '2020-09-13 16:55:39', '218.17.40.106');
INSERT INTO `visitors` VALUES (158, '2020-09-13 16:55:42', '218.17.40.106');
INSERT INTO `visitors` VALUES (159, '2020-09-13 16:59:40', '218.17.40.106');
INSERT INTO `visitors` VALUES (160, '2020-09-13 21:34:12', '113.65.211.147');
INSERT INTO `visitors` VALUES (161, '2020-09-14 16:27:05', '112.96.39.90');
INSERT INTO `visitors` VALUES (162, '2020-09-14 16:40:08', '112.96.39.90');
INSERT INTO `visitors` VALUES (163, '2020-09-14 17:48:28', '203.208.60.59');
INSERT INTO `visitors` VALUES (164, '2020-09-15 13:10:16', '127.0.0.1');
INSERT INTO `visitors` VALUES (165, '2020-09-15 13:13:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (166, '2020-09-15 14:25:29', '127.0.0.1');
INSERT INTO `visitors` VALUES (167, '2020-09-15 15:39:13', '127.0.0.1');
INSERT INTO `visitors` VALUES (168, '2020-09-15 15:40:00', '127.0.0.1');
INSERT INTO `visitors` VALUES (169, '2020-09-15 15:40:31', '127.0.0.1');
INSERT INTO `visitors` VALUES (170, '2020-09-15 15:42:27', '127.0.0.1');
INSERT INTO `visitors` VALUES (171, '2020-09-15 15:42:56', '112.96.67.184');
INSERT INTO `visitors` VALUES (172, '2020-09-15 15:51:29', '127.0.0.1');
INSERT INTO `visitors` VALUES (173, '2020-09-15 16:13:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (174, '2020-09-15 17:47:05', '122.235.85.154');
INSERT INTO `visitors` VALUES (175, '2020-09-15 17:50:29', '122.235.85.154');
INSERT INTO `visitors` VALUES (176, '2020-09-15 17:54:00', '122.235.85.154');
INSERT INTO `visitors` VALUES (177, '2020-09-16 14:59:08', '127.0.0.1');
INSERT INTO `visitors` VALUES (178, '2020-09-16 14:59:21', '112.96.64.152');
INSERT INTO `visitors` VALUES (179, '2020-09-16 15:09:05', '112.96.64.152');
INSERT INTO `visitors` VALUES (180, '2020-09-16 15:09:29', '112.96.64.152');
INSERT INTO `visitors` VALUES (181, '2020-09-16 15:09:34', '127.0.0.1');
INSERT INTO `visitors` VALUES (182, '2020-09-16 15:09:46', '127.0.0.1');
INSERT INTO `visitors` VALUES (183, '2020-09-16 16:08:41', '127.0.0.1');
INSERT INTO `visitors` VALUES (184, '2020-09-16 17:22:08', '127.0.0.1');
INSERT INTO `visitors` VALUES (185, '2020-09-16 17:22:11', '127.0.0.1');
INSERT INTO `visitors` VALUES (186, '2020-09-18 00:49:27', '218.17.40.106');
INSERT INTO `visitors` VALUES (187, '2020-09-18 00:49:33', '218.17.40.106');
INSERT INTO `visitors` VALUES (188, '2020-09-18 00:51:12', '218.17.40.106');
INSERT INTO `visitors` VALUES (189, '2020-09-18 00:53:41', '218.17.40.106');
INSERT INTO `visitors` VALUES (190, '2020-09-18 00:53:49', '218.17.40.106');
INSERT INTO `visitors` VALUES (191, '2020-09-18 00:55:04', '218.17.40.106');
INSERT INTO `visitors` VALUES (192, '2020-09-18 02:11:47', '127.0.0.1');
INSERT INTO `visitors` VALUES (193, '2020-09-18 02:11:54', '127.0.0.1');
INSERT INTO `visitors` VALUES (194, '2020-09-18 02:12:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (195, '2020-09-18 02:12:17', '127.0.0.1');
INSERT INTO `visitors` VALUES (196, '2020-09-18 02:23:31', '127.0.0.1');
INSERT INTO `visitors` VALUES (197, '2020-09-18 02:24:19', '127.0.0.1');
INSERT INTO `visitors` VALUES (198, '2020-09-18 02:28:55', '127.0.0.1');
INSERT INTO `visitors` VALUES (199, '2020-09-18 02:34:25', '59.41.65.161');
INSERT INTO `visitors` VALUES (200, '2020-09-18 02:34:35', '59.41.65.161');
INSERT INTO `visitors` VALUES (201, '2020-09-18 02:36:43', '127.0.0.1');
INSERT INTO `visitors` VALUES (202, '2020-09-18 02:36:38', '127.0.0.1');
INSERT INTO `visitors` VALUES (203, '2020-09-18 02:37:50', '59.41.65.161');
INSERT INTO `visitors` VALUES (204, '2020-09-18 02:37:59', '59.41.65.161');
INSERT INTO `visitors` VALUES (205, '2020-09-18 02:38:53', '59.41.65.161');
INSERT INTO `visitors` VALUES (206, '2020-09-18 02:38:55', '59.41.65.161');
INSERT INTO `visitors` VALUES (207, '2020-09-18 02:38:57', '59.41.65.161');
INSERT INTO `visitors` VALUES (208, '2020-09-18 02:43:01', '127.0.0.1');
INSERT INTO `visitors` VALUES (209, '2020-09-18 02:43:08', '59.41.65.161');
INSERT INTO `visitors` VALUES (210, '2020-09-18 02:43:10', '59.41.65.161');
INSERT INTO `visitors` VALUES (211, '2020-09-18 02:51:10', '59.41.65.161');
INSERT INTO `visitors` VALUES (212, '2020-09-18 03:01:40', '59.41.65.161');
INSERT INTO `visitors` VALUES (213, '2020-09-18 03:02:37', '59.41.65.161');
INSERT INTO `visitors` VALUES (214, '2020-09-18 03:17:48', '59.41.65.161');
INSERT INTO `visitors` VALUES (215, '2020-09-18 03:20:08', '59.41.65.161');
INSERT INTO `visitors` VALUES (216, '2020-09-18 03:23:58', '59.41.65.161');
INSERT INTO `visitors` VALUES (217, '2020-09-18 03:31:33', '59.41.65.161');
INSERT INTO `visitors` VALUES (218, '2020-09-18 03:32:59', '59.41.65.161');
INSERT INTO `visitors` VALUES (219, '2020-09-18 03:32:59', '59.41.65.161');
INSERT INTO `visitors` VALUES (220, '2020-09-18 03:33:29', '59.41.65.161');
INSERT INTO `visitors` VALUES (221, '2020-09-18 03:33:29', '59.41.65.161');
INSERT INTO `visitors` VALUES (222, '2020-09-18 03:35:49', '59.41.65.161');
INSERT INTO `visitors` VALUES (223, '2020-09-18 03:36:07', '59.41.65.161');
INSERT INTO `visitors` VALUES (224, '2020-09-18 03:36:07', '59.41.65.161');
INSERT INTO `visitors` VALUES (225, '2020-09-18 03:38:19', '59.41.65.161');
INSERT INTO `visitors` VALUES (226, '2020-09-18 03:45:56', '59.41.65.161');
INSERT INTO `visitors` VALUES (227, '2020-09-18 03:45:58', '59.41.65.161');
INSERT INTO `visitors` VALUES (228, '2020-09-18 03:52:29', '59.41.65.161');
INSERT INTO `visitors` VALUES (229, '2020-09-18 08:09:33', '59.41.65.161');
INSERT INTO `visitors` VALUES (230, '2020-09-18 09:41:04', '112.96.198.95');
INSERT INTO `visitors` VALUES (231, '2020-09-18 09:41:04', '112.96.198.95');
INSERT INTO `visitors` VALUES (232, '2020-09-18 09:51:11', '127.0.0.1');
INSERT INTO `visitors` VALUES (233, '2020-09-18 09:51:52', '127.0.0.1');
INSERT INTO `visitors` VALUES (234, '2020-09-18 10:10:55', '127.0.0.1');
INSERT INTO `visitors` VALUES (235, '2020-09-20 11:21:35', '111.206.221.111');
INSERT INTO `visitors` VALUES (236, '2020-09-20 11:21:41', '111.206.198.88');
INSERT INTO `visitors` VALUES (237, '2020-09-20 11:21:41', '111.206.198.82');
INSERT INTO `visitors` VALUES (238, '2020-09-20 11:21:44', '111.206.198.79');
INSERT INTO `visitors` VALUES (239, '2020-09-20 11:21:44', '111.206.221.74');
INSERT INTO `visitors` VALUES (240, '2020-09-20 22:07:56', '127.0.0.1');
INSERT INTO `visitors` VALUES (241, '2020-09-20 22:08:38', '127.0.0.1');
INSERT INTO `visitors` VALUES (242, '2020-09-20 22:08:44', '127.0.0.1');
INSERT INTO `visitors` VALUES (243, '2020-09-20 22:10:34', '59.41.64.181');
INSERT INTO `visitors` VALUES (244, '2020-09-20 22:10:43', '59.41.64.181');
INSERT INTO `visitors` VALUES (245, '2020-09-20 22:32:20', '127.0.0.1');
INSERT INTO `visitors` VALUES (246, '2020-09-21 23:05:47', '59.41.64.181');
INSERT INTO `visitors` VALUES (247, '2020-09-23 11:21:51', '112.96.194.26');
INSERT INTO `visitors` VALUES (248, '2020-09-23 11:21:51', '112.96.194.26');
INSERT INTO `visitors` VALUES (249, '2020-09-24 18:48:59', '119.3.204.16');
INSERT INTO `visitors` VALUES (250, '2020-09-25 03:39:00', '111.206.198.31');
INSERT INTO `visitors` VALUES (251, '2020-09-25 03:39:00', '111.206.198.124');
INSERT INTO `visitors` VALUES (252, '2020-09-25 03:39:04', '111.206.198.37');
INSERT INTO `visitors` VALUES (253, '2020-09-25 03:39:04', '111.206.221.31');
INSERT INTO `visitors` VALUES (254, '2020-09-26 03:38:51', '203.208.60.112');
INSERT INTO `visitors` VALUES (255, '2020-09-27 15:46:49', '223.166.74.235');
INSERT INTO `visitors` VALUES (256, '2020-09-28 07:06:21', '203.208.60.49');
INSERT INTO `visitors` VALUES (257, '2020-09-29 08:33:30', '111.206.198.39');
INSERT INTO `visitors` VALUES (258, '2020-09-29 08:33:37', '111.206.198.68');
INSERT INTO `visitors` VALUES (259, '2020-09-29 08:33:37', '111.206.198.30');
INSERT INTO `visitors` VALUES (260, '2020-09-29 08:33:52', '111.206.221.108');
INSERT INTO `visitors` VALUES (261, '2020-09-29 08:33:52', '111.206.221.50');
INSERT INTO `visitors` VALUES (262, '2020-09-29 12:00:36', '112.96.101.43');
INSERT INTO `visitors` VALUES (263, '2020-09-29 16:39:45', '127.0.0.1');
INSERT INTO `visitors` VALUES (264, '2020-09-29 16:41:10', '127.0.0.1');
INSERT INTO `visitors` VALUES (265, '2020-09-30 14:27:12', '124.64.16.174');
INSERT INTO `visitors` VALUES (266, '2020-09-30 14:27:56', '124.64.16.174');
INSERT INTO `visitors` VALUES (267, '2020-09-30 17:21:15', '112.96.101.43');
INSERT INTO `visitors` VALUES (268, '2020-09-30 17:26:09', '112.96.101.43');
INSERT INTO `visitors` VALUES (269, '2020-10-01 22:11:38', '127.0.0.1');
INSERT INTO `visitors` VALUES (270, '2020-10-01 22:12:14', '127.0.0.1');
INSERT INTO `visitors` VALUES (271, '2020-10-01 22:12:18', '127.0.0.1');
INSERT INTO `visitors` VALUES (272, '2020-10-01 22:12:39', '127.0.0.1');
INSERT INTO `visitors` VALUES (273, '2020-10-03 08:30:40', '111.206.198.80');
INSERT INTO `visitors` VALUES (274, '2020-10-03 08:30:44', '111.206.198.125');
INSERT INTO `visitors` VALUES (275, '2020-10-03 08:30:44', '111.206.198.98');
INSERT INTO `visitors` VALUES (276, '2020-10-03 17:05:39', '40.77.188.205');
INSERT INTO `visitors` VALUES (277, '2020-10-03 17:05:59', '40.77.188.22');
INSERT INTO `visitors` VALUES (278, '2020-10-04 19:47:59', '113.15.134.24');
INSERT INTO `visitors` VALUES (279, '2020-10-04 19:48:58', '113.15.134.24');
INSERT INTO `visitors` VALUES (280, '2020-10-04 23:00:58', '210.52.224.201');
INSERT INTO `visitors` VALUES (281, '2020-10-04 23:00:59', '210.52.224.201');
INSERT INTO `visitors` VALUES (282, '2020-10-04 23:05:00', '210.52.224.201');
INSERT INTO `visitors` VALUES (283, '2020-10-04 23:05:01', '210.52.224.201');
INSERT INTO `visitors` VALUES (284, '2020-10-04 23:05:04', '210.52.224.201');
INSERT INTO `visitors` VALUES (285, '2020-10-04 23:05:05', '210.52.224.201');
INSERT INTO `visitors` VALUES (286, '2020-10-05 12:18:35', '119.3.204.16');
INSERT INTO `visitors` VALUES (287, '2020-10-06 07:35:14', '51.77.129.159');
INSERT INTO `visitors` VALUES (288, '2020-10-07 02:56:08', '111.206.221.71');
INSERT INTO `visitors` VALUES (289, '2020-10-07 02:56:23', '111.206.222.22');
INSERT INTO `visitors` VALUES (290, '2020-10-07 02:56:23', '111.206.198.21');
INSERT INTO `visitors` VALUES (291, '2020-10-07 02:56:28', '111.206.221.40');
INSERT INTO `visitors` VALUES (292, '2020-10-07 02:56:28', '111.206.198.17');
INSERT INTO `visitors` VALUES (293, '2020-10-08 13:58:58', '203.208.60.113');
INSERT INTO `visitors` VALUES (294, '2020-10-08 22:14:06', '203.208.60.100');
INSERT INTO `visitors` VALUES (295, '2020-10-09 06:14:01', '203.208.60.106');
INSERT INTO `visitors` VALUES (296, '2020-10-10 11:02:22', '112.96.193.72');
INSERT INTO `visitors` VALUES (297, '2020-10-10 11:21:58', '112.96.193.72');
INSERT INTO `visitors` VALUES (298, '2020-10-10 14:34:11', '112.96.193.72');
INSERT INTO `visitors` VALUES (299, '2020-10-10 17:53:13', '112.96.193.72');
INSERT INTO `visitors` VALUES (300, '2020-10-10 17:55:58', '112.96.193.72');
INSERT INTO `visitors` VALUES (301, '2020-10-11 09:07:34', '111.206.198.31');
INSERT INTO `visitors` VALUES (302, '2020-10-11 09:07:34', '111.206.221.30');
INSERT INTO `visitors` VALUES (303, '2020-10-11 09:07:39', '111.206.198.55');
INSERT INTO `visitors` VALUES (304, '2020-10-11 09:07:39', '111.206.221.78');
INSERT INTO `visitors` VALUES (305, '2020-10-13 00:23:23', '113.65.231.111');
INSERT INTO `visitors` VALUES (306, '2020-10-13 20:41:51', '203.208.60.76');
INSERT INTO `visitors` VALUES (307, '2020-10-14 01:53:15', '203.208.60.83');
INSERT INTO `visitors` VALUES (308, '2020-10-14 19:18:09', '111.224.235.210');
INSERT INTO `visitors` VALUES (309, '2020-10-14 20:46:48', '203.208.60.58');
INSERT INTO `visitors` VALUES (310, '2020-10-15 19:38:41', '203.208.60.36');
INSERT INTO `visitors` VALUES (311, '2020-10-16 18:06:20', '52.26.74.135');
INSERT INTO `visitors` VALUES (312, '2020-10-17 10:36:38', '117.136.5.62');
INSERT INTO `visitors` VALUES (313, '2020-10-17 10:38:58', '117.136.5.62');
INSERT INTO `visitors` VALUES (314, '2020-10-18 16:35:14', '211.95.50.7');
INSERT INTO `visitors` VALUES (315, '2020-10-18 16:35:15', '211.95.50.8');
INSERT INTO `visitors` VALUES (316, '2020-10-18 16:44:16', '211.95.50.7');
INSERT INTO `visitors` VALUES (317, '2020-10-18 16:44:17', '211.95.50.7');
INSERT INTO `visitors` VALUES (318, '2020-10-18 16:44:20', '211.95.50.8');
INSERT INTO `visitors` VALUES (319, '2020-10-18 16:44:20', '211.95.50.8');
INSERT INTO `visitors` VALUES (320, '2020-10-19 20:30:52', '113.65.208.202');
INSERT INTO `visitors` VALUES (321, '2020-10-21 07:39:48', '69.160.160.55');
INSERT INTO `visitors` VALUES (322, '2020-10-23 07:42:03', '111.206.221.5');
INSERT INTO `visitors` VALUES (323, '2020-10-23 07:42:03', '111.206.198.5');
INSERT INTO `visitors` VALUES (324, '2020-10-23 07:42:09', '111.206.221.108');
INSERT INTO `visitors` VALUES (325, '2020-10-23 07:42:09', '111.206.198.50');
INSERT INTO `visitors` VALUES (326, '2020-10-24 21:02:01', '171.34.176.20');
INSERT INTO `visitors` VALUES (327, '2020-10-25 23:11:14', '211.95.50.7');
INSERT INTO `visitors` VALUES (328, '2020-10-25 23:11:15', '211.95.50.8');
INSERT INTO `visitors` VALUES (329, '2020-10-26 05:08:41', '113.65.208.147');
INSERT INTO `visitors` VALUES (330, '2020-10-26 10:18:41', '112.96.199.187');
INSERT INTO `visitors` VALUES (331, '2020-10-27 06:23:29', '111.206.198.50');
INSERT INTO `visitors` VALUES (332, '2020-10-27 06:23:35', '111.206.198.102');
INSERT INTO `visitors` VALUES (333, '2020-10-27 06:23:35', '111.206.221.76');
INSERT INTO `visitors` VALUES (334, '2020-10-27 06:23:41', '111.206.198.117');
INSERT INTO `visitors` VALUES (335, '2020-10-27 06:23:41', '111.206.198.91');
INSERT INTO `visitors` VALUES (336, '2020-10-30 15:02:29', '111.206.221.115');
INSERT INTO `visitors` VALUES (337, '2020-10-30 15:02:29', '111.206.221.45');
INSERT INTO `visitors` VALUES (338, '2020-10-31 02:48:17', '111.206.198.103');
INSERT INTO `visitors` VALUES (339, '2020-10-31 22:19:22', '116.30.6.112');
INSERT INTO `visitors` VALUES (340, '2020-10-31 22:19:53', '116.30.6.112');
INSERT INTO `visitors` VALUES (341, '2020-11-01 18:09:36', '183.42.11.202');
INSERT INTO `visitors` VALUES (342, '2020-11-02 10:07:59', '112.96.109.144');
INSERT INTO `visitors` VALUES (343, '2020-11-03 17:55:04', '111.206.198.34');
INSERT INTO `visitors` VALUES (344, '2020-11-03 17:55:16', '111.206.198.80');
INSERT INTO `visitors` VALUES (345, '2020-11-03 17:55:16', '111.206.198.99');
INSERT INTO `visitors` VALUES (346, '2020-11-03 17:55:25', '111.206.198.104');
INSERT INTO `visitors` VALUES (347, '2020-11-03 17:55:25', '111.206.221.26');
INSERT INTO `visitors` VALUES (348, '2020-11-04 04:11:12', '203.208.60.75');
INSERT INTO `visitors` VALUES (349, '2020-11-05 07:44:19', '203.208.60.54');
INSERT INTO `visitors` VALUES (350, '2020-11-06 09:37:04', '202.106.177.19');
INSERT INTO `visitors` VALUES (351, '2020-11-06 09:37:35', '202.106.177.19');
INSERT INTO `visitors` VALUES (352, '2020-11-07 09:14:17', '203.208.60.34');
INSERT INTO `visitors` VALUES (353, '2020-11-07 22:44:05', '113.65.209.115');
INSERT INTO `visitors` VALUES (354, '2020-11-08 05:20:01', '111.206.198.14');
INSERT INTO `visitors` VALUES (355, '2020-11-08 05:20:07', '111.206.221.31');
INSERT INTO `visitors` VALUES (356, '2020-11-08 07:22:22', '117.181.48.184');
INSERT INTO `visitors` VALUES (357, '2020-11-08 07:22:22', '117.181.48.184');
INSERT INTO `visitors` VALUES (358, '2020-11-08 07:31:33', '203.208.60.28');
INSERT INTO `visitors` VALUES (359, '2020-11-09 12:51:33', '203.208.60.32');
INSERT INTO `visitors` VALUES (360, '2020-11-09 17:05:49', '112.96.198.6');
INSERT INTO `visitors` VALUES (361, '2020-11-09 17:05:49', '112.96.198.6');
INSERT INTO `visitors` VALUES (362, '2020-11-09 17:06:18', '112.96.198.6');
INSERT INTO `visitors` VALUES (363, '2020-11-10 22:15:49', '113.65.210.58');
INSERT INTO `visitors` VALUES (364, '2020-11-11 10:02:40', '203.208.60.97');
INSERT INTO `visitors` VALUES (365, '2020-11-12 04:51:25', '111.206.222.175');
INSERT INTO `visitors` VALUES (366, '2020-11-12 04:51:29', '111.206.222.137');
INSERT INTO `visitors` VALUES (367, '2020-11-12 04:51:29', '111.206.198.89');
INSERT INTO `visitors` VALUES (368, '2020-11-12 04:51:35', '111.206.198.46');
INSERT INTO `visitors` VALUES (369, '2020-11-12 10:54:07', '112.96.198.6');
INSERT INTO `visitors` VALUES (370, '2020-11-12 10:54:07', '112.96.198.6');
INSERT INTO `visitors` VALUES (371, '2020-11-12 20:22:10', '69.160.160.50');
INSERT INTO `visitors` VALUES (372, '2020-11-15 15:27:34', '203.208.60.16');
INSERT INTO `visitors` VALUES (373, '2020-11-17 10:16:11', '111.206.221.36');
INSERT INTO `visitors` VALUES (374, '2020-11-17 15:58:57', '127.0.0.1');
INSERT INTO `visitors` VALUES (375, '2020-11-17 15:59:49', '127.0.0.1');
INSERT INTO `visitors` VALUES (376, '2020-11-17 16:00:50', '127.0.0.1');
INSERT INTO `visitors` VALUES (377, '2020-11-17 17:16:41', '127.0.0.1');

SET FOREIGN_KEY_CHECKS = 1;
