#!/bin/bash
cd /srv/LibreCat

# Initilizing and starting mysql
./mysqlboot.sh &
mysql_install_db --defaults-file=/etc/mysql/my.cnf --user=mysql --basedir=/usr/local/mysql &
mysqld --user=mysql &
sleep 5
mysqladmin -u root password $MYSQL_PASSWORD
sed -i "/DATABASE\ librecat_metrics/a CREATE\ USER\ \'librecat\'\@\'localhost\'\ IDENTIFIED\ BY\ \'librecat\';" devel/mysql.sql

# New databases for LibreCat
mysql --user=root --password=$MYSQL_PASSWORD < devel/mysql.sql
mysql --user=librecat --password=librecat librecat_system < devel/librecat_system.sql
mysql --user=librecat --password=librecat librecat_backup < devel/librecat_backup.sql
mysql --user=librecat --password=librecat librecat_metrics < devel/librecat_metrics.sql

# Starting elasticsearch
/usr/share/elasticsearch/bin/elasticsearch -Des.config=/etc/elasticsearch/elasticsearch.yml -d
sleep 15

# Starting gearman
./gearboot.sh 2>&1 > /var/log/gearmand.log &

# creating 1st scripts
./index.sh drop
./index.sh create

# Starting librecat
./boot.sh 
