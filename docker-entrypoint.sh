#!/bin/bash
set -e

if [ "$1" = '/usr/bin/supervisord' ]; then

  ## apache2
  if [ ! -d /mnt/data/apache2 ]; then
    mkdir -p /mnt/data/apache2
    cp -r /etc/apache2.tpl/* /mnt/data/apache2
    chown -R www-data:www-data /mnt/data/apache2
  fi
  if [ ! -d /etc/apache2 ]; then
    ln -s /mnt/data/apache2 /etc/apache2
  fi

  ## SSL
  if [ ! -d /mnt/data/ssl ]; then
    mkdir -p /mnt/data/ssl
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out /mnt/data/ssl/moodle.key
    openssl req -new -key /mnt/data/ssl/moodle.key -out /mnt/data/ssl/moodle.csr -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
    openssl x509 -req -days 3650 -in /mnt/data/ssl/moodle.csr -signkey /mnt/data/ssl/moodle.key -out /mnt/data/ssl/moodle.crt
  fi
  if [ ! -f /etc/ssl/certs/moodle.crt ]; then
    ln -s /mnt/data/ssl/moodle.crt /etc/ssl/certs/moodle.crt
  fi
  if [ ! -f /etc/ssl/private/moodle.key ]; then
    ln -s /mnt/data/ssl/moodle.key /etc/ssl/private/moodle.key
  fi

  ## php
  if [ ! -d /mnt/data/php ]; then
    mkdir -p /mnt/data/php
    cp -r /etc/php.tpl/* /mnt/data/php
  fi
  if [ ! -d /etc/php ]; then
    ln -s /mnt/data/php /etc/php
  fi

  ## moodle
  if [ ! -d /mnt/data/moodle ]; then
    mkdir -p /mnt/data/moodle/{conf,data}
    cp /var/www/html/moodle/config.tpl.php /mnt/data/moodle/conf/config.php
    chown -R www-data:www-data /mnt/data/moodle
  fi
  if [ ! -f /var/www/html/moodle/config.php ]; then
    ln -s /mnt/data/moodle/conf/config.php /var/www/html/moodle/config.php
  fi

  ## solr
  if [ ! -d /mnt/data/solr ]; then
    mkdir -p /mnt/data/solr/{conf,data}
    cp -r /var/solr/data.tpl/* /mnt/data/solr/data/
    chown -R solr:solr /mnt/data/solr
  fi
  if [ ! -d /var/solr/data ]; then
    ln -s /mnt/data/solr/data /var/solr/data
  fi

  ## redis
  if [ ! -d /mnt/data/redis ]; then
    mkdir -p /mnt/data/redis/{conf,data}
    cp -r /etc/redis.tpl/* /mnt/data/redis/conf/
    cp -r /var/lib/redis.tpl/* /mnt/data/redis/data/ || /bin/true
    chown -R redis:redis /mnt/data/redis
  fi
  if [ ! -d /etc/redis ]; then
    ln -s /mnt/data/redis/conf /etc/redis
  fi
  if [ ! -d /var/lib/redis ]; then
    ln -s /mnt/data/redis/data /var/lib/redis
  fi

  ## mysql
  if [ ! -d /mnt/data/mysql ]; then
    mkdir -p /mnt/data/mysql/{conf,data}
    cp -r /etc/mysql/mariadb.conf.d.tpl/* /mnt/data/mysql/conf/
    cp -r /var/lib/mysql.tpl/* /mnt/data/mysql/data/
    chown -R mysql:mysql /mnt/data/mysql
  fi
  if [ ! -d /var/run/mysqld ]; then
    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld
  fi
  if [ ! -d /etc/mysql/mariadb.conf.d ]; then
    ln -s /mnt/data/mysql/conf /etc/mysql/mariadb.conf.d
  fi
  if [ ! -d /var/lib/mysql ]; then
    ln -s /mnt/data/mysql/data /var/lib/mysql
  fi

fi

exec "$@"
