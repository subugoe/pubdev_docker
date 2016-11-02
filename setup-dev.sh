#!/bin/bash

#Repositories
LIBRECAT_REMOTE=https://github.com/LibreCat/LibreCat.git
GOEFIS_REMOTE=https://github.com/subugoe/goefis.git
#Directories
LIBRECATHOME=./src
LIBDIR=$LIBRECATHOME/local

#Set call to the cpanm script here if guessing doesn't work
#CPANM=
if [ -z ${CPANM+x} ]; then
    #Linux
    if [ $(which cpanm) ]; then
        CPANM=$(which cpanm)
    #Mac with Mac ports (use sudo port install p5.24-app-cpanminus)
    elif [ $(which cpanm-5.24) ]; then
        CPANM=$(which cpanm-5.24)
    elif [ $(which cpanm-5.22) ]; then
        CPANM=$(which cpanm-5.22)
    elif [ $(which cpanm-5.20) ]; then
        CPANM=$(which cpanm-5.20)
    else
        echo "cpanm script not set, exiting"
        exit 1
    fi
fi

#Checkout LibreCat
mkdir -p ${LIBRECATHOME} 
git clone $LIBRECAT_REMOTE $LIBRECATHOME

#Create directory for Perl modules
mkdir -p $LIBDIR

#Install dependencies to lib dir
echo "Using cpanm at $CPANM"
$CPANM -L $LIBDIR --installdeps $LIBRECATHOME
$CPANM -L $LIBDIR install Devel::Camelcadedb
