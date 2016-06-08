#!/bin/bash
cd /srv/LibreCat

# Initilizing and starting mysql
/usr/bin/mysql_install_db --user=mysql -ldata=/var/lib/mysql 2>&1 &
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --user=mysql 2>&1 &
sleep 30

# New databases for LibreCat
/usr/bin/mysql -u root --password='' < devel/mysql.sql
/usr/bin/mysql -u root --password='' librecat_system < devel/librecat_system.sql
/usr/bin/mysql -u root --password='' librecat_backup < devel/librecat_backup.sql
/usr/bin/mysql -u root --password='' librecat_metrics < devel/librecat_metrics.sql

# Starting elasticsearch
/usr/share/elasticsearch/bin/elasticsearch -Des.config=/etc/elasticsearch/elasticsearch.yml -Des.logging=/etc/elasticsearch/logging.yml -d
#/usr/share/elasticsearch/bin/elasticsearch -Des.config=/etc/elasticsearch/elasticsearch.yml -d
sleep 30

# Starting gearman
./gearboot.sh 2>&1 > /var/log/gearmand.log &

# creating 1st scripts
./index.sh drop
./index.sh create

# Starting librecat
./boot.sh 
