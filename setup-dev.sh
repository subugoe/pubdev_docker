#!/bin/bash

#Repositories
LIBRECAT_REMOTE=https://github.com/LibreCat/LibreCat.git
GOEFIS_REMOTE=https://github.com/subugoe/goefis.git
#Directories
LIBRECATHOME=./src
LIBDIR=$LIBRECATHOME/local
LAYERDIR=$LIBRECATHOME/goefis

#Other Variables
PERL_VERSION_FILE=$LIBRECATHOME/.perl-version
WD=`pwd`

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
mkdir -p $LIBRECATHOME
#Check if directory is empty
if [ "$(ls -A $LIBRECATHOME)" ]; then 
    echo "Pulling in Changes"
    cd $LIBRECATHOME && git pull && cd $WD
else
    git clone $LIBRECAT_REMOTE $LIBRECATHOME
fi

#Checkout GoeFIS Layer
mkdir -p $LAYERDIR
#Check if directory is empty
if [ "$(ls -A $LAYERDIR)" ]; then 
    echo "Pulling in Changes"
    cd $LAYERDIR && git pull && cd $WD
else
    git clone $GOEFIS_REMOTE $LAYERDIR
fi

#Create directory for Perl modules
mkdir -p $LIBDIR

if [ -f $PERL_VERSION_FILE ]; then
    if [ "$(perl -version | sed '2,2!d')" != "$(cat $PERL_VERSION_FILE)" ]; then
        echo "Perl version changed, rebuild of modules will be forced"
	    rm -rf $LIBDIR && mkdir $LIBDIR
    fi
fi

#Install dependencies to lib dir
echo "Using cpanm at $CPANM"
#this can be done faster, if you skip the tests (-n)
$CPANM -L $LIBDIR --installdeps -qn $LIBRECATHOME
$CPANM -L $LIBDIR -qn install Devel::Camelcadedb
$CPANM -L $LIBDIR -qn install Carton

echo "If something fails to install you might need some additional libraries, since some Perl modules aren't selfcontained! Look at the logs."

#Save Version of Perl, to recompile modules if needed
echo $(perl -version | sed '2,2!d') > $PERL_VERSION_FILE


