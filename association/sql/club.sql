-- 3. 按依赖顺序创建表（修正外键+强制字符集）

-- ----------------------------
-- 表1：活动类型表（无外键，优先创建）
-- ----------------------------
DROP TABLE IF EXISTS `activity_type`;
CREATE TABLE `activity_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动类型ID',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='活动类型字典表';

-- ----------------------------
-- 表2：社团类型表
-- ----------------------------
DROP TABLE IF EXISTS `club_type`;
CREATE TABLE `club_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '社团类型ID',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '社团类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='社团类型字典表';

-- ----------------------------
-- 表3：文件类型表
-- ----------------------------
DROP TABLE IF EXISTS `file_type`;
CREATE TABLE `file_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文件类型ID',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '文件类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='文件类型字典表';

-- ----------------------------
-- 表4：文章类型表
-- ----------------------------
DROP TABLE IF EXISTS `passage_type`;
CREATE TABLE `passage_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文章类型ID',
  `type` varchar(255) DEFAULT '' COMMENT '文章类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='文章类型字典表';

-- ----------------------------
-- 表5：用户角色表
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(45) NOT NULL DEFAULT '' COMMENT '角色名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='用户角色字典表';

-- ----------------------------
-- ----------------------------
-- 表6：社团表（修正：club_type_id 改为 int(11)，与 club_type.id 匹配）
-- ----------------------------
DROP TABLE IF EXISTS `club`;
CREATE TABLE `club` (
  `num` int(11) NOT NULL AUTO_INCREMENT COMMENT '社团编号（主键）',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '社团名称（唯一）',
  `introduce` varchar(255) NOT NULL DEFAULT '' COMMENT '社团简介',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建/更新时间',
  `club_type_id` int(11) DEFAULT NULL COMMENT '关联社团类型ID（允许为NULL，与 club_type.id 类型一致）',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '社团状态（0：未激活，1：正常，2：注销）',
  PRIMARY KEY (`num`),
  UNIQUE KEY `idx_club_name` (`name`),
  KEY `fk_club_club_type` (`club_type_id`),
  CONSTRAINT `fk_club_club_type` FOREIGN KEY (`club_type_id`)
    REFERENCES `club_type` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79685 DEFAULT CHARSET=utf8mb4 COMMENT='社团信息表';

-- ----------------------------
-- 表7：用户表（修正：role_id 允许为 NULL）
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `call_name` varchar(60) DEFAULT '' COMMENT '用户职称',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别（0：保密，1：男，2：女）',
  `institute` varchar(50) NOT NULL DEFAULT '' COMMENT '所属学院',
  `account` varchar(50) NOT NULL COMMENT '登录账号（唯一）',
  `password` varchar(60) NOT NULL COMMENT '登录密码',
  `role_id` int(11) DEFAULT NULL COMMENT '关联角色ID（允许为NULL）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建/更新时间',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否激活',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_account` (`account`),
  KEY `fk_user_role` (`role_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`)
    REFERENCES `user_role` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- ----------------------------
-- 表8：用户-社团关联表（多对多）
-- ----------------------------
DROP TABLE IF EXISTS `user_club`;
CREATE TABLE `user_club` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` int(11) DEFAULT NULL COMMENT '关联用户ID',
  `club_id` int(11) DEFAULT NULL COMMENT '关联社团ID',
  PRIMARY KEY (`id`),
  KEY `fk_user_club_user` (`user_id`),
  KEY `fk_user_club_club` (`club_id`),
  CONSTRAINT `fk_user_club_user` FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_club_club` FOREIGN KEY (`club_id`)
    REFERENCES `club` (`num`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户与社团关联表';

-- ----------------------------
-- 表9：活动表（修正：activity_type_id、club_id 允许为 NULL）
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `activity_name` varchar(55) NOT NULL DEFAULT '' COMMENT '活动名称',
  `site` varchar(60) NOT NULL DEFAULT '' COMMENT '活动地点',
  `hold_time` varchar(80) NOT NULL DEFAULT '' COMMENT '活动时间',
  `introduce` text COMMENT '活动介绍',
  `apply_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `permission` int(1) NOT NULL DEFAULT '0' COMMENT '审批状态',
  `activity_type_id` int(11) DEFAULT NULL COMMENT '关联活动类型ID（允许为NULL）',
  `club_id` int(11) DEFAULT NULL COMMENT '关联社团ID（允许为NULL）',
  PRIMARY KEY (`id`),
  KEY `fk_activity_type` (`activity_type_id`),
  KEY `fk_activity_club` (`club_id`),
  CONSTRAINT `fk_activity_type` FOREIGN KEY (`activity_type_id`)
    REFERENCES `activity_type` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_club` FOREIGN KEY (`club_id`)
    REFERENCES `club` (`num`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COMMENT='活动信息表';

-- ----------------------------
-- 表10：文章表（修正：passage_type_id 改为 int(11)，与 passage_type.id 匹配）
-- ----------------------------
DROP TABLE IF EXISTS `passage`;
CREATE TABLE `passage` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` text NOT NULL COMMENT '文章内容',
  `publisher` varchar(50) NOT NULL DEFAULT '' COMMENT '发布者',
  `source` varchar(255) DEFAULT '' COMMENT '来源',
  `passage_type_id` int(11) DEFAULT NULL COMMENT '关联文章类型ID（允许为NULL，与 passage_type.id 类型一致）',
  `club_id` int(11) DEFAULT NULL COMMENT '关联社团ID（允许为NULL）',
  `publish_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '发布时间',
  `click_num` int(11) NOT NULL DEFAULT '0' COMMENT '点击次数',
  PRIMARY KEY (`id`),
  KEY `fk_passage_type` (`passage_type_id`),
  KEY `fk_passage_club` (`club_id`),
  CONSTRAINT `fk_passage_type` FOREIGN KEY (`passage_type_id`)
    REFERENCES `passage_type` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_passage_club` FOREIGN KEY (`club_id`)
    REFERENCES `club` (`num`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COMMENT='文章信息表';

-- ----------------------------
-- 表11：文件表（修正：file_type_id 允许为 NULL）
-- ----------------------------
DROP TABLE IF EXISTS `file`;
CREATE TABLE `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `file_name` varchar(60) NOT NULL DEFAULT '' COMMENT '文件名称',
  `file_path` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '上传时间',
  `file_type_id` int(11) DEFAULT NULL COMMENT '关联文件类型ID（允许为NULL）',
  `passage_id` int(11) DEFAULT NULL COMMENT '关联文章ID（允许为NULL，二选一）',
  `activity_id` int(11) DEFAULT NULL COMMENT '关联活动ID（允许为NULL，二选一）',
  PRIMARY KEY (`id`),
  KEY `fk_file_type` (`file_type_id`),
  KEY `fk_file_passage` (`passage_id`),
  KEY `fk_file_activity` (`activity_id`),
  CONSTRAINT `fk_file_type` FOREIGN KEY (`file_type_id`)
    REFERENCES `file_type` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_file_passage` FOREIGN KEY (`passage_id`)
    REFERENCES `passage` (`id`)
    ON DELETE SET NULL  -- 改为SET NULL，删除文章时文件不删除，仅解除关联
    ON UPDATE CASCADE,
  CONSTRAINT `fk_file_activity` FOREIGN KEY (`activity_id`)
    REFERENCES `activity` (`id`)
    ON DELETE SET NULL  -- 同上，删除活动时保留文件
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COMMENT='文件存储表';

-- ----------------------------
-- 表12：学生表（修正：club_num 允许为 NULL）
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `num` varchar(30) NOT NULL DEFAULT '1' COMMENT '学生编号（主键）',
  `name` varchar(50) NOT NULL COMMENT '学生姓名',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `email` varchar(80) NOT NULL DEFAULT '' COMMENT '邮箱',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `club_num` int(11) DEFAULT NULL COMMENT '关联社团编号（允许为NULL）',
  PRIMARY KEY (`num`),
  KEY `fk_student_club` (`club_num`),
  CONSTRAINT `fk_student_club` FOREIGN KEY (`club_num`)
    REFERENCES `club` (`num`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

-- ----------------------------
-- 表13：单栏配置表
-- ----------------------------
DROP TABLE IF EXISTS `one_column`;
CREATE TABLE `one_column` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `club_name` varchar(80) NOT NULL DEFAULT '' COMMENT '社团名称字段配置',
  `club_summary` varchar(50) NOT NULL DEFAULT '' COMMENT '社团概况字段配置',
  `introduce` varchar(50) NOT NULL DEFAULT '' COMMENT '社团简介字段配置',
  `notice` varchar(50) NOT NULL DEFAULT '' COMMENT '社团快讯字段配置',
  `show` varchar(55) NOT NULL DEFAULT '' COMMENT '活动风采字段配置',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='页面单栏配置表';

-- ----------------------------
-- 插入初始数据（确保中文正常）
-- ----------------------------
INSERT INTO `activity_type` VALUES (1, '活动预告'), (2, '精彩活动回顾');
INSERT INTO `club_type` VALUES (1, '学术科技类'), (2, '文化艺术类'), (3, '志愿公益类'), (4, '创新创业类');
INSERT INTO `file_type` VALUES
  (1, '普通图片'), (2, '常用文档'), (3, '社团文件'),
  (4, '首页轮播图'), (5, '文章内部图片'), (6, '活动内部图片');
INSERT INTO `passage_type` VALUES (1, '重要通知'), (2, '社团要闻');
INSERT INTO `user_role` VALUES (1, '会长'), (2, '部长'), (3, '成员');
INSERT INTO `one_column` VALUES (1, '社团名称', '社团摘要', '社团简介', '社团快讯', '活动风采');
INSERT INTO `user` VALUES (2, 'user', '', 1, 'a', 'user', '123456', NULL, '2025-10-23 21:25:39', 0, NULL);

-- 验证结果
SELECT '数据库 club 重建成功！' AS result;