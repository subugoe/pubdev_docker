#!/bin/bash
cd ${LIBRECATHOME}

# Wait a number of seconds for all dependencies to catch up
# Depend on your system you may want to reduce or enlarge this
sleep 15

# Starting gearman
./gearman-entrypoint.sh 2>&1 >> ${LIBRECATHOME}/logs/gearmand.log &

# For remote-instance, replace <REMOTE:PORT> with the ip/url:port and comment in the line.
#sed -i 's/localhost:5001/<REMOTE:PORT>/g' ${SETTINGS_LAYER}/config/catmandu.local.yml

# Databases and tables
if [ ${MYSQL_TYPE} != "local" ]
then
	sed -i 's/username:\ librecat/username:\ '${MYSQL_USERNAME}'/g' ${SETTINGS_LAYER}/config/store.yml
	sed -i 's/password:\ librecat/password:\ '${MYSQL_PASSWORD}'/g' ${SETTINGS_LAYER}/config/store.yml
	sed -i 's/mysqldb/'${MYSQL_HOST}'/g' ${SETTINGS_LAYER}/config/store.yml
	sed -i 's/3360/'${MYSQL_PORT}'/g' ${SETTINGS_LAYER}/config/store.yml
	sed -i 's/librecat_system/'${MYSQL_LIBRECAT_SYSTEM_DATABASE}'/g' ${SETTINGS_LAYER}/config/store.yml
	sed -i 's/librecat_metrics/'${MYSQL_LIBRECAT_METRICS_DATABASE}'/g' ${SETTINGS_LAYER}/config/store.yml
	sed -i 's/librecat_backup/'${MYSQL_LIBRECAT_BACKUP_DATABASE}'/g' ${SETTINGS_LAYER}/config/store.yml
fi

# If you wish to have permanent data, just comment out the next two sections, you just need `boot..`
if [ ${MYSQL_TYPE} == "local" ]
then
	mysql --user=${MYSQL_ROOT_USERNAME} --password=${MYSQL_ROOT_PASSWORD} --host=${MYSQL_HOST} --port=${MYSQL_PORT} < ${SETTINGS_LAYER}/config/mysql-${MYSQL_TYPE}.init
else
	mysql --user=${MYSQL_USERNAME} --password=${MYSQL_PASSWORD} --host=${MYSQL_HOST} --port=${MYSQL_PORT} < ${SETTINGS_LAYER}/config/mysql-${MYSQL_TYPE}.init
fi
# creating 1st scripts
./index.sh drop
./index.sh create

# Starting librecat
./boot.sh starman
