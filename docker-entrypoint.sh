#!/bin/bash
cd /srv/LibreCat

# Wait a number of seconds for all dependencies to catch up
# Depend on your system you may want to reduce or enlarge this
sleep 15

# Starting gearman
./gearboot.sh 2>&1 >> /srv/LibreCat/logs/gearmand.log &

# New databases for LibreCat
mysql -u $MYSQL_USERNAME --password=$MYSQL_ROOT_PASSWORD -h mysqldb < gofis/config/mysql-init.sql

# Starting SSH-Service
export TERM=screen

# creating 1st scripts
./index.sh drop
./index.sh create

# Starting librecat
./boot.sh starman
