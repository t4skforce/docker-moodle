SET GLOBAL innodb_file_format = barracuda;
SET GLOBAL innodb_file_per_table = 1;
SET GLOBAL innodb_large_prefix = 'on';
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'moodle'@'localhost' IDENTIFIED BY 'moodle';
GRANT ALL PRIVILEGES ON * . * TO 'moodle'@'localhost';
FLUSH PRIVILEGES;
