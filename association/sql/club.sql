-- 1. 关闭外键约束，避免创建顺序冲突
SET FOREIGN_KEY_CHECKS=0;

-- 2. 强制创建utf8mb4编码数据库（核心！）
CREATE DATABASE club
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;
USE club;

-- 3. 所有表统一指定utf8mb4，字段长度按需扩大
-- 活动类型表
CREATE TABLE `activity_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动类型ID',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 社团类型表
CREATE TABLE `club_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '社团类型ID',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '社团类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 文件类型表
CREATE TABLE `file_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文件类型ID',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '文件类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 文章类型表
CREATE TABLE `passage_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文章类型ID',
  `type` varchar(255) DEFAULT '' COMMENT '文章类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 用户角色表
CREATE TABLE `user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(45) NOT NULL DEFAULT '' COMMENT '角色名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 单栏配置表（club_summary扩大到200字符）
CREATE TABLE `one_column` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `club_name` varchar(80) NOT NULL DEFAULT '' COMMENT '社团名称',
  `club_summary` varchar(200) NOT NULL DEFAULT '' COMMENT '社团概况',
  `introduce` varchar(50) NOT NULL DEFAULT '' COMMENT '社团简介',
  `notice` varchar(50) NOT NULL DEFAULT '' COMMENT '社团快讯',
  `show` varchar(55) NOT NULL DEFAULT '' COMMENT '社团活动风采',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 社团表
CREATE TABLE `club` (
  `num` int(11) NOT NULL AUTO_INCREMENT COMMENT '社团编号',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '社团名称',
  `introduce` varchar(255) NOT NULL DEFAULT '' COMMENT '社团简介',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `club_type_id` tinyint(2) NOT NULL DEFAULT '0' COMMENT '社团类型id',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '社团状态',
  PRIMARY KEY (`num`),
  KEY `idx_club_type` (`club_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=79685 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 用户表
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `call_name` varchar(60) DEFAULT '' COMMENT '用户职称',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别（0保密，1男，2女）',
  `institute` varchar(50) NOT NULL DEFAULT '' COMMENT '学院',
  `account` varchar(50) NOT NULL COMMENT '登录账号',
  `password` varchar(60) NOT NULL COMMENT '登录密码',
  `role_id` int(11) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '用户创建时间',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '用户是否激活（0未激活，1激活）',
  `last_login_time` varchar(80) DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_account` (`account`),
  KEY `idx_role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 文章表（title扩大到150字符，彻底解决长度问题）
CREATE TABLE `passage` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` text NOT NULL COMMENT '文章内容',
  `publisher` varchar(50) NOT NULL DEFAULT '' COMMENT '文章发布者',
  `source` varchar(255) DEFAULT '' COMMENT '文章来源',
  `passage_type_id` tinyint(2) NOT NULL DEFAULT '1' COMMENT '文章类型ID',
  `club_id` int(11) DEFAULT '0' COMMENT '发布文章的社团id',
  `publish_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '发布时间',
  `click_num` int(11) NOT NULL DEFAULT '0' COMMENT '点击次数',
  PRIMARY KEY (`id`),
  KEY `idx_passage_type` (`passage_type_id`),
  KEY `idx_club_passage` (`club_id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 活动表
CREATE TABLE `activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `activity_name` varchar(55) NOT NULL DEFAULT '' COMMENT '活动名称',
  `site` varchar(60) NOT NULL DEFAULT '' COMMENT '活动地点',
  `hold_time` varchar(80) NOT NULL DEFAULT '' COMMENT '活动举行时间',
  `introduce` text COMMENT '活动介绍',
  `apply_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `permission` int(1) NOT NULL DEFAULT '0' COMMENT '社团联是否批准（0未批准，1已批准）',
  `activity_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动类型ID',
  `club_id` int(11) NOT NULL DEFAULT '0' COMMENT '举办社团ID',
  PRIMARY KEY (`id`),
  KEY `idx_activity_type` (`activity_type_id`),
  KEY `idx_club_activity` (`club_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 学生表
CREATE TABLE `student` (
  `num` varchar(30) NOT NULL DEFAULT '1' COMMENT '学生编号',
  `name` varchar(50) NOT NULL COMMENT '学生姓名',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别（0保密，1男，2女）',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `email` varchar(80) NOT NULL DEFAULT '' COMMENT '电子邮箱',
  `phone` varchar(50) NOT NULL COMMENT '联系电话',
  `club_num` int(11) NOT NULL DEFAULT '0' COMMENT '所属社团编号',
  PRIMARY KEY (`num`),
  KEY `idx_student_club` (`club_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 文件表（修正关联字段长度）
CREATE TABLE `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `file_name` varchar(60) NOT NULL DEFAULT '' COMMENT '文件名称',
  `file_path` varchar(120) NOT NULL DEFAULT '' COMMENT '文件路径',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `file_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '文件类型ID',
  `passage_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联文章id',
  `activity_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联活动id',
  PRIMARY KEY (`id`),
  KEY `idx_file_type` (`file_type_id`),
  KEY `idx_file_passage` (`passage_id`),
  KEY `idx_file_activity` (`activity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 用户-社团关联表
CREATE TABLE `user_club` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `club_id` int(11) DEFAULT NULL COMMENT '社团ID',
  PRIMARY KEY (`id`),
  KEY `idx_user_club` (`user_id`),
  KEY `idx_club_user` (`club_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. 插入数据（清理所有特殊字符，确保纯UTF-8中文）
INSERT INTO `activity_type` VALUES (1, '活动预告'), (2, '精彩活动回顾');

INSERT INTO `club_type` VALUES
(1, '理论学习类社团'),
(2, '艺术类型'),
(3, '公益服务类社团'),
(4, '职业发展类社团'),
(5, '体育锻炼类社团'),
(6, '兴趣爱好');

INSERT INTO `file_type` VALUES
(1, '普通图片'),
(2, '常用文档'),
(3, '社团文件'),
(4, '首页轮播图'),
(5, '文章内部图片'),
(6, '活动内部图片');

INSERT INTO `one_column` VALUES (1, '社员名称', '社团摘要', '社团简介', '社团快讯', '活动风采');

INSERT INTO `passage_type` VALUES
(1, '重要通知'),
(2, '社团要闻'),
(3, '社团联简介'),
(4, '社团简介');

INSERT INTO `user_role` VALUES (1, '部长'), (2, '副会长'), (3, '社长');

-- 文章数据（简化+去重，确保title无超长）
INSERT INTO `passage` VALUES
(1, '社团联简介', '<p>这是一个社团系统，下面有许多社团，欢迎访问</p>', '社团联管理员', '社团联', 3, 0, '2019-05-03 14:35:20', 0),
(2, '社团简介', '<p>社团集合54543</p>', '社团管理员', '某某社团', 4, 0, '2019-05-03 14:35:37', 0),
(11, '社团招新通知', '<p>欢迎报名参加</p>', '社团管理员', '22', 1, 0, '2019-03-22 16:00:00', 0),
(13, '社团比赛', '欢迎报名参加', '社团管理员', '22', 2, 0, '2019-03-14 10:48:29', 0),
(14, '计算机协会成绩公布赛', '仔细观看各个学生成绩', '社团管理员', '', 1, 0, '2019-04-10 10:47:15', 0),
(15, '社团换届下周举行', '<p>各位社团尽快完成换届</p>', '社团管理员', '', 2, 0, '2019-04-02 16:00:00', 0),
(16, '极客俱乐部下周讲座', '欢迎各位参加', '', '', 1, 0, '2019-04-03 10:50:18', 0),
(17, '社团简介-补充', '社团集合', '社团管理员', '某某社团', 4, 0, '2019-04-10 16:00:00', 0),
(92, '测试文章4252', '<p>52353</p>', '社团管理员', '社团管理员', 1, 0, '2019-05-09 14:20:26', 0),
(93, '测试文章53535', '<p>345345</p>', '社团管理员', '社团管理员', 2, 0, '2019-05-09 14:58:38', 0);

-- 5. 创建管理员账号（用于后台登录）
INSERT INTO `user` (
  `name`, `call_name`, `sex`, `institute`,
  `account`, `password`, `role_id`, `is_active`
) VALUES (
  '系统管理员', '超级管理员', 0, '社团联',
  'admin', '123456', 3, 1
);

-- 6. 开启外键约束
SET FOREIGN_KEY_CHECKS=1;

-- 7. 验证编码和数据（执行后查看结果）
SELECT
  '初始化成功' AS result,
  DATABASE() AS db_name,
  @@character_set_database AS charset,
  @@collation_database AS collation,
  (SELECT COUNT(*) FROM user WHERE account='admin') AS admin_account_count;