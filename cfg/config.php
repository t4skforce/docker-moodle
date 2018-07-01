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

require_once('/var/www/html/moodle/lib/setup.php'); // Do not edit
