#!/bin/bash


function finish {
  kill -9 `pidof gearmand`
}

trap finish SIGTERM SIGKILL


DEFAULT_PORT=4730

PARAMS="--backlog=32 \
  --job-retries=0 \
  --listen=0.0.0.0 \
  --threads=4 \
  --worker-wakeup=0 \
  --log-file=none \
  --file-descriptors=65536 \
  --port=${GEARMAN_PORT:-$DEFAULT_PORT} \
  "

if [ ! -z $MEMCACHE_HOST ]; then
  PARAMS="$PARAMS --queue-type=libmemcached --libmemcached-servers=$MEMCACHE_HOST"
fi

if [ ! -z $MYSQL_HOST ]; then
  PARAMS="$PARAMS --queue-type=mysql --mysql-host=$MYSQL_HOST --mysql-user=$MYSQL_USER --mysql-password=$MYSQL_PASSWORD --mysql-db=$MYSQL_DB"
fi

echo "Starting gearman job server with params: $PARAMS"

exec gearmand $PARAMS
