#!/bin/bash
cd ${LIBRECATHOME}

# Wait a number of seconds for all dependencies to catch up
# Depend on your system you may want to reduce or enlarge this
sleep 15

# Starting gearman
./gearman-entrypoint.sh 2>&1 >> ${LIBRECATHOME}/logs/gearmand.log &

# New databases for LibreCat
mysql -u $MYSQL_USERNAME --password=$MYSQL_ROOT_PASSWORD -h mysqldb < ${LOCAL_LAYER}/config/mysql-init.sql
#sed -i 's/localhost:5001/141.5.101.220/g' ${LOCAL_LAYER}/config/catmandu.local.yml

# creating 1st scripts
./index.sh drop
./index.sh create

# Starting librecat
./boot.sh starman
