<?php

$CFG = new stdClass();

$CFG->dbtype    = 'mariadb';    // 'pgsql', 'mariadb', 'mysqli', 'sqlsrv' or 'oci'
$CFG->dblibrary = 'native';     // 'native' only at the moment
$CFG->dbhost    = 'localhost';  // eg 'localhost' or 'db.isp.com' or IP
$CFG->dbname    = 'moodle';     // database name, eg moodle
$CFG->dbuser    = 'moodle';     // your database username
$CFG->dbpass    = 'moodle';     // your database password
$CFG->prefix    = 'mdl_';       // prefix to use for all table names
$CFG->wwwroot   = 'https://172.17.0.2';
$CFG->dataroot  = '/mnt/data/moodle/data';
$CFG->directorypermissions = 02777;
$CFG->admin = 'admin';

$CFG->session_handler_class = '\core\session\redis';
$CFG->session_redis_host = '127.0.0.1';
$CFG->session_redis_port = 6379;  // Optional.
$CFG->session_redis_database = 0;  // Optional, default is db 0.
$CFG->session_redis_prefix = 'moodle_'; // Optional, default is don't set one.
$CFG->session_redis_acquire_lock_timeout = 120;
$CFG->session_redis_lock_expire = 7200;

require_once('/var/www/html/moodle/lib/setup.php'); // Do not edit
