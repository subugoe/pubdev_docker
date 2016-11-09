#!/bin/bash
cd ${LIBRECATHOME}

# Wait a number of seconds for all dependencies to catch up
# Depend on your system you may want to reduce or enlarge this
sleep 15

# Starting gearman
./gearman-entrypoint.sh 2>&1 >> ${LIBRECATHOME}/logs/gearmand.log &

# New databases for LibreCat
sed -i 's/localhost:5001/141.5.101.219/g' ${LOCAL_LAYER}/config/catmandu.local.yml
mysql -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD --host=$MYSQL_HOST --port=$MYSQL_PORT < ${LOCAL_LAYER}/config/mysql-remote.sql
sed -i 's/mysqldb/'$MYSQL_HOST'/g' ${LOCAL_LAYER}/config/store.yml
sed -i 's/3306/'$MYSQL_PORT'/g' ${LOCAL_LAYER}/config/store.yml

# creating 1st scripts
./index.sh drop
./index.sh create

# Starting librecat
./boot.sh starman
