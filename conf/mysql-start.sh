#!/bin/bash
#/usr/bin/mysql_install_db --user=mysql -ldata=/var/lib/mysql 2>&1 &
#mysqld --user=mysql
mysql --user=root --password=$MYSQL_ROOT_PASSWORD < /tmp/mysql-init.sql
