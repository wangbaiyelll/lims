-- =====================================================
-- 图书信息管理系统数据库【最终修复版】
-- 12张表 | 满测试数据 | 符合任务书要求
-- =====================================================

CREATE DATABASE IF NOT EXISTS library_system
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_system;

-- =====================================================
-- 1. 角色表（权限必备）
-- =====================================================
CREATE TABLE role (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      role_name VARCHAR(50) NOT NULL,
                      permission_json TEXT COMMENT 'JSON权限'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO role (role_name, permission_json) VALUES
                                                  ('超级管理员','["*"]'),
                                                  ('图书管理员','["teacher:list","book:list","borrow:add","return:handle"]');

-- =====================================================
-- 2. 管理员表
-- =====================================================
CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       real_name VARCHAR(50) NOT NULL,
                       role_id INT NOT NULL,
                       status TINYINT DEFAULT 1,
                       last_login_time DATETIME,
                       create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (role_id) REFERENCES role(id) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO admin (username,password,real_name,role_id,status) VALUES
                                                                   ('admin','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','系统管理员',1,1),
                                                                   ('lib001','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','李丽',2,1),
                                                                   ('lib002','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','王芳',2,1),
                                                                   ('lib003','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','张敏',2,1),
                                                                   ('lib004','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','赵静',2,1),
                                                                   ('lib005','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','刘洋',2,1),
                                                                   ('lib006','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','陈晨',2,0),
                                                                   ('lib007','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','周华',2,1),
                                                                   ('lib008','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','吴迪',2,1),
                                                                   ('lib009','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','郑爽',2,1),
                                                                   ('lib010','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','孙梅',2,0);

-- =====================================================
-- 3. 操作日志表
-- =====================================================
CREATE TABLE admin_log (
                           id BIGINT PRIMARY KEY AUTO_INCREMENT,
                           admin_id INT,
                           admin_name VARCHAR(50),
                           operation VARCHAR(100) NOT NULL,
                           target_type VARCHAR(50),
                           target_id INT,
                           target_name VARCHAR(100),
                           create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO admin_log (admin_id,admin_name,operation,target_type,target_id,target_name) VALUES
                                                                                            (1,'系统管理员','新增教师','教师',1,'张明'),
                                                                                            (1,'系统管理员','新增教师','教师',2,'李华'),
                                                                                            (2,'李丽','启用教师','教师',1,'张明'),
                                                                                            (2,'李丽','禁用教师','教师',4,'赵敏'),
                                                                                            (1,'系统管理员','新增图书','图书',1,'Java编程思想'),
                                                                                            (1,'系统管理员','新增图书','图书',2,'Spring Boot实战'),
                                                                                            (2,'李丽','修改图书','图书',1,'Java编程思想'),
                                                                                            (3,'张敏','删除教师','教师',5,'孙丽'),
                                                                                            (4,'赵静','批量导入','图书',NULL,'批量导入15本'),
                                                                                            (5,'刘洋','审核续借','续借',1,'续借申请1号');

-- =====================================================
-- 4. 教师表
-- =====================================================
CREATE TABLE teacher (
                         id INT PRIMARY KEY AUTO_INCREMENT,
                         username VARCHAR(50) NOT NULL UNIQUE,
                         password VARCHAR(255) NOT NULL,
                         emp_no VARCHAR(20) NOT NULL UNIQUE,
                         name VARCHAR(50) NOT NULL,
                         college VARCHAR(100),
                         phone VARCHAR(20),
                         email VARCHAR(100),
                         hire_date DATE,
                         status TINYINT DEFAULT 1,
                         create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO teacher (username,password,emp_no,name,college,phone,email,hire_date,status) VALUES
                                                                                             ('teacher01','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023001','张明','计算机学院','13800138001','zhangming@univ.edu','2023-09-01',1),
                                                                                             ('teacher02','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023002','李华','软件学院','13800138002','lihua@univ.edu','2023-09-01',1),
                                                                                             ('teacher03','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023003','王磊','计算机学院','13800138003','wanglei@univ.edu','2022-09-01',1),
                                                                                             ('teacher04','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023004','赵敏','信息学院','13800138004','zhaomin@univ.edu','2023-09-01',0),
                                                                                             ('teacher05','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023005','孙丽','软件学院','13800138005','sunli@univ.edu','2021-09-01',1),
                                                                                             ('teacher06','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023006','周强','计算机学院','13800138006','zhouqiang@univ.edu','2023-09-01',1),
                                                                                             ('teacher07','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023007','吴静','信息学院','13800138007','wujing@univ.edu','2022-09-01',1),
                                                                                             ('teacher08','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023008','郑伟','软件学院','13800138008','zhengwei@univ.edu','2023-09-01',1),
                                                                                             ('teacher09','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023009','王芳','计算机学院','13800138009','wangfang@univ.edu','2021-09-01',1),
                                                                                             ('teacher10','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023010','陈磊','信息学院','13800138010','chenlei@univ.edu','2022-09-01',1),
                                                                                             ('teacher11','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023011','刘敏','软件学院','13800138011','liumin@univ.edu','2023-09-01',1),
                                                                                             ('teacher12','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAtKv1Wi','T2023012','杨华','计算机学院','13800138012','yanghua@univ.edu','2022-09-01',0);

-- =====================================================
-- 5. 图书分类表
-- =====================================================
CREATE TABLE category (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          parent_id INT DEFAULT 0,
                          name VARCHAR(50) NOT NULL,
                          level TINYINT DEFAULT 1,
                          sort_order INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO category (parent_id,name,level,sort_order) VALUES
                                                           (0,'计算机',1,1),
                                                           (0,'文学',1,2),
                                                           (0,'历史',1,3),
                                                           (0,'经济',1,4),
                                                           (1,'编程语言',2,1),
                                                           (1,'数据库',2,2),
                                                           (1,'人工智能',2,3),
                                                           (2,'小说',2,1),
                                                           (2,'散文',2,2),
                                                           (3,'中国史',2,1);

-- =====================================================
-- 6. 图书表
-- =====================================================
CREATE TABLE book (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      isbn VARCHAR(20) NOT NULL UNIQUE,
                      title VARCHAR(200) NOT NULL,
                      author VARCHAR(100) NOT NULL,
                      publisher VARCHAR(100),
                      publish_date DATE,
                      price DECIMAL(10,2),
                      summary TEXT,
                      category_id INT,
                      status TINYINT DEFAULT 1,
                      create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO book (isbn,title,author,publisher,publish_date,price,summary,category_id) VALUES
                                                                                          ('9787111636896','Java编程思想','Bruce Eckel','机械工业出版社','2020-06-01',108,'Java经典',5),
                                                                                          ('9787115542678','Spring Boot实战','Craig Walls','人民邮电出版社','2023-01-01',79,'微服务',5),
                                                                                          ('9787302527891','三体','刘慈欣','重庆出版社','2020-12-01',68,'科幻',8),
                                                                                          ('9787121365432','Python从入门到实践','Eric','人民邮电出版社','2021-05-01',89,'入门',5),
                                                                                          ('9787111682565','MySQL必知必会','Ben','人民邮电出版社','2022-03-01',59,'数据库',6),
                                                                                          ('9787302567890','深入理解计算机系统','Bryant','机械工业出版社','2021-07-01',139,'系统',5),
                                                                                          ('9787115548762','设计模式','Gamma','机械工业出版社','2022-01-01',99,'开发',5),
                                                                                          ('9787302543210','活着','余华','作家出版社','2020-08-01',45,'文学',8),
                                                                                          ('9787530212345','百年孤独','马尔克斯','南海出版公司','2019-10-01',55,'小说',8),
                                                                                          ('9787020123456','红楼梦','曹雪芹','人民文学出版社','2018-01-01',88,'古典',8),
                                                                                          ('9787544256789','平凡的世界','路遥','北京十月文艺','2021-03-01',108,'文学',8);

-- =====================================================
-- 7. 馆藏位置表
-- =====================================================
CREATE TABLE location (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          library_name VARCHAR(100) NOT NULL,
                          shelf_no VARCHAR(50) NOT NULL,
                          position_code VARCHAR(50) NOT NULL UNIQUE,
                          description VARCHAR(255),
                          status TINYINT DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO location (library_name,shelf_no,position_code,description,status) VALUES
                                                                                  ('主馆','A-01','A-01-01','计算机区',1),
                                                                                  ('主馆','A-01','A-01-02','数据库区',1),
                                                                                  ('主馆','B-01','B-01-01','文学区',1),
                                                                                  ('主馆','C-01','C-01-01','历史区',1),
                                                                                  ('分馆','A-01','F-A-01-01','综合区',1);

-- =====================================================
-- 8. 库存表
-- =====================================================
CREATE TABLE stock (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       book_id INT NOT NULL,
                       location_id INT NOT NULL,
                       total_qty INT DEFAULT 0,
                       available_qty INT DEFAULT 0,
                       status TINYINT DEFAULT 1,
                       last_in_date DATE,
                       FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE,
                       FOREIGN KEY (location_id) REFERENCES location(id),
                       UNIQUE KEY uk_book_loc (book_id,location_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO stock (book_id,location_id,total_qty,available_qty,last_in_date) VALUES
                                                                                 (1,1,5,3,'2024-01-15'),
                                                                                 (1,5,3,3,'2024-01-15'),
                                                                                 (2,1,4,2,'2024-02-10'),
                                                                                 (3,3,6,4,'2024-01-20'),
                                                                                 (4,1,5,5,'2024-03-01'),
                                                                                 (5,2,4,3,'2024-02-15'),
                                                                                 (6,1,3,2,'2024-01-10'),
                                                                                 (7,1,3,3,'2024-03-05'),
                                                                                 (8,3,5,4,'2024-01-25'),
                                                                                 (9,3,4,3,'2024-02-20');

-- =====================================================
-- 9. 借阅记录表（已修复ID错误）
-- =====================================================
CREATE TABLE borrow_record (
                               id BIGINT PRIMARY KEY AUTO_INCREMENT,
                               teacher_id INT NOT NULL,
                               book_id INT NOT NULL,
                               stock_id INT NOT NULL,
                               borrow_date DATE NOT NULL,
                               due_date DATE NOT NULL,
                               return_date DATE NULL,
                               status TINYINT DEFAULT 1,
                               renew_count INT DEFAULT 0,
                               FOREIGN KEY (teacher_id) REFERENCES teacher(id),
                               FOREIGN KEY (book_id) REFERENCES book(id),
                               FOREIGN KEY (stock_id) REFERENCES stock(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO borrow_record (teacher_id,book_id,stock_id,borrow_date,due_date,return_date,status,renew_count) VALUES
                                                                                                                (1,1,1,DATE_SUB(CURDATE(),INTERVAL 25 DAY),DATE_SUB(CURDATE(),INTERVAL 10 DAY),NULL,3,0),
                                                                                                                (1,2,3,DATE_SUB(CURDATE(),INTERVAL 5 DAY),DATE_ADD(CURDATE(),INTERVAL 25 DAY),NULL,1,0),
                                                                                                                (2,3,4,DATE_SUB(CURDATE(),INTERVAL 15 DAY),DATE_ADD(CURDATE(),INTERVAL 15 DAY),NULL,1,0),
                                                                                                                (2,8,9,DATE_SUB(CURDATE(),INTERVAL 20 DAY),DATE_SUB(CURDATE(),INTERVAL 5 DAY),DATE_SUB(CURDATE(),INTERVAL 2 DAY),2,0),
                                                                                                                (3,4,5,DATE_SUB(CURDATE(),INTERVAL 10 DAY),DATE_ADD(CURDATE(),INTERVAL 20 DAY),NULL,1,1);

-- =====================================================
-- 10. 续借申请表
-- =====================================================
CREATE TABLE renew_application (
                                   id BIGINT PRIMARY KEY AUTO_INCREMENT,
                                   teacher_id INT NOT NULL,
                                   borrow_id BIGINT NOT NULL,
                                   apply_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                                   status TINYINT DEFAULT 0,
                                   audit_date DATETIME NULL,
                                   audit_admin_id INT NULL,
                                   audit_remark VARCHAR(255),
                                   FOREIGN KEY (teacher_id) REFERENCES teacher(id),
                                   FOREIGN KEY (borrow_id) REFERENCES borrow_record(id),
                                   FOREIGN KEY (audit_admin_id) REFERENCES admin(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO renew_application (teacher_id,borrow_id,status,audit_date,audit_admin_id,audit_remark) VALUES
                                                                                                       (3,5,1,DATE_SUB(NOW(),INTERVAL 2 DAY),1,'续借通过'),
                                                                                                       (1,1,2,DATE_SUB(NOW(),INTERVAL 5 DAY),2,'已预约');

-- =====================================================
-- 11. 罚款记录表
-- =====================================================
CREATE TABLE fine (
                      id BIGINT PRIMARY KEY AUTO_INCREMENT,
                      teacher_id INT NOT NULL,
                      borrow_id BIGINT NULL,
                      amount DECIMAL(10,2) NOT NULL,
                      fine_date DATE NOT NULL,
                      due_days INT,
                      status TINYINT DEFAULT 0,
                      pay_date DATE NULL,
                      remark VARCHAR(255),
                      FOREIGN KEY (teacher_id) REFERENCES teacher(id),
                      FOREIGN KEY (borrow_id) REFERENCES borrow_record(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO fine (teacher_id,borrow_id,amount,fine_date,due_days,status,pay_date,remark) VALUES
    (1,1,5.00,DATE_SUB(CURDATE(),INTERVAL 10 DAY),10,0,NULL,'逾期10天');

-- =====================================================
-- 12. 消息通知表
-- =====================================================
CREATE TABLE message (
                         id BIGINT PRIMARY KEY AUTO_INCREMENT,
                         teacher_id INT NOT NULL,
                         type VARCHAR(20) NOT NULL,
                         title VARCHAR(200) NOT NULL,
                         content TEXT NOT NULL,
                         status TINYINT DEFAULT 0,
                         create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (teacher_id) REFERENCES teacher(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO message (teacher_id,type,title,content,status) VALUES
                                                               (1,'overdue','图书逾期','《Java编程思想》已逾期',0),
                                                               (2,'fine','罚款通知','您有未缴罚款',0);

-- 更新图书管理员的权限配置
UPDATE role
SET permission_json = '[
  "teacher:list",
  "book:list",
  "borrow:list",
  "borrow:add",
  "borrow:return",
  "stock:list",
  "fine:list"
]'
WHERE role_name = '图书管理员';

-- 请执行这个 SQL 创建 overdue_reminder 表
CREATE TABLE IF NOT EXISTS `overdue_reminder` (
                                                  `id` bigint NOT NULL AUTO_INCREMENT,
                                                  `teacher_id` int NOT NULL COMMENT '教师 ID',
                                                  `borrow_id` bigint NOT NULL COMMENT '借阅 ID',
                                                  `overdue_days` int NOT NULL COMMENT '逾期天数',
                                                  `reminder_date` datetime NOT NULL COMMENT '提醒日期',
                                                  `send_status` tinyint DEFAULT '1' COMMENT '发送状态：0-未发送 1-已发送',
                                                  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
                                                  PRIMARY KEY (`id`),
                                                  KEY `idx_teacher_id` (`teacher_id`),
                                                  KEY `idx_borrow_id` (`borrow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='逾期提醒记录表';

