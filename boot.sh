#!/bin/bash
#
#	Settings variables & arguments
#

echo "Starting LibreCat"

CARTON=/usr/bin/carton
PID=./plackup.librecat.pid
SERVER_PORT=5001
SERVER_WORKERS=15
SERVER_USER="librecat"
SERVER_GROUP="librecat"
DANCER_DIR="/srv/LibreCat"
DANCER_APP="bin/app.pl"
PLACK_ENV="development"
ACCESS_LOG="logs/access.log"
ERROR_LOG="logs/error.log"
# If a config.yml is in a layers directory, use this line: 
# LAYER_DIR="/opt/local"

starman_args="--pid $PID --workers $SERVER_WORKERS --user $SERVER_USER --group $SERVER_GROUP --error-log $ERROR_LOG --max-requests 20"
plackup_args="-E $PLACK_ENV -R lib -p $SERVER_PORT --access-log $ACCESS_LOG -s Starman $starman_args"
simple_args="-E $PLACK_ENV -R lib -p $SERVER_PORT --access-log $ACCESS_LOG"

export DANCER_APP LAYER_DIR CARTON plackup_args simple_args

if [ -z ${PERL5_DEBUG_ROLE+x} ]; then
    if [ "$1" == "starman" ]; then
        LIBRECAT_LAYERS=${LAYER_DIR} $CARTON exec plackup $plackup_args -a $DANCER_APP -D
    else
        LIBRECAT_LAYERS==${LAYER_DIR} $CARTON exec plackup $simple_args -a $DANCER_APP -D
    fi
else
    echo "Debugger configuration detected - Role: $PERL5_DEBUG_ROLE, Host: $PERL5_DEBUG_HOST, Port: $PERL5_DEBUG_PORT"
    #This will result in debugging carton at first
    #PERL5OPT=-d:Camelcadedb LIBRECAT_LAYERS==${LAYER_DIR} $CARTON exec plackup $simple_args -a $DANCER_APP -D
    LIBRECAT_LAYERS==${LAYER_DIR} $CARTON exec perl -d:Camelcadedb local/bin/plackup $simple_args -a $DANCER_APP -D
fi


