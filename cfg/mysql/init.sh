#!/usr/bin/env bash
while !(mysqladmin ping)
do
   sleep 1
   echo "waiting for mysql ..."
done
mysql -u root < /etc/mysql/init.sql
echo "mysql init done ..."
