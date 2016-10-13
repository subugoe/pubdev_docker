#!/bin/bash
#
#	Settings variables & arguments
#

CARTON=/usr/bin/carton
SERVER_PORT=5001
SERVER_WORKERS=15
SERVER_USER="librecat"
SERVER_GROUP="librecat"
DANCER_DIR="/srv/LibreCat"
DANCER_APP="bin/app.pl"
PLACK_ENV="development"
ACCESS_LOG="logs/access.log"
ERROR_LOG="logs/error.log"
LAYER_DIR="goefis"
PID="./plackup.librecat.pid"

starman_args="--pid $PID --workers $SERVER_WORKERS --user $SERVER_USER --group $SERVER_GROUP --error-log $ERROR_LOG --max-requests 20"
plackup_args="-E $PLACK_ENV -R lib -p $SERVER_PORT --access-log $ACCESS_LOG -s Starman $starman_args"
simple_args="-E $PLACK_ENV -R lib -p $SERVER_PORT --access-log $ACCESS_LOG"

export DANCER_APP LAYER_DIR CARTON plackup_args simple_args

if [ "$1" == "starman" ]; then
    LIBRECAT_LAYERS=${LAYER_DIR} $CARTON exec plackup $plackup_args -a $DANCER_APP -D
else
    LIBRECAT_LAYERS==${LAYER_DIR} $CARTON exec plackup $simple_args -a $DANCER_APP -D
fi
