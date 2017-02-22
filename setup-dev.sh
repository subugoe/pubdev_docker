#!/bin/bash

# Repositories
LIBRECAT_REMOTE=https://github.com/LibreCat/LibreCat.git
# Directories
LIBRECATHOME=${1-./src}
LIBDIR=$LIBRECATHOME/local

# Other Variables
PERL_VERSION_FILE=$LIBRECATHOME/.perl-version
WD=`pwd`
LIBRECAT_TAG=`grep LIBRECAT_VERSION Dockerfile_Base | head -1 | cut -d '=' -f 2`

# Check if there are arguments, this can change the directory where a copy of LibreCat
# will be placed.
echo "Using LibreCat installation at $LIBRECATHOME"

# Set call to the cpanm script here if guessing doesn't work
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

# Checkout LibreCat
mkdir -p $LIBRECATHOME
# Check if directory is empty
if [ "$(ls -A $LIBRECATHOME)" ]; then 
    echo "Pulling in Changes"
    cd $LIBRECATHOME && git pull
    echo "Reseting tree"
    git reset --hard $LIBRECAT_TAG
    cd $WD
else
    git clone $LIBRECAT_REMOTE $LIBRECATHOME
fi

if [ -n "$LIBRECAT_TAG" ]; then
    cd $LIBRECATHOME
    echo "Checking out tag $LIBRECAT_TAG"
    git checkout $LIBRECAT_TAG
    cd $WD
fi

# Create directory for Perl modules
mkdir -p $LIBDIR

if [ -f $PERL_VERSION_FILE ]; then
    if [ "$(perl -version | sed '2,2!d')" != "$(cat $PERL_VERSION_FILE)" ]; then
        echo "Perl version changed, rebuild of modules will be forced"
	    rm -rf $LIBDIR && mkdir $LIBDIR
    fi
fi

# Install dependencies to lib dir
echo "Using cpanm at $CPANM"
# This lets you skip the tests (-n), might be a bit faster
$CPANM -L $LIBDIR --installdeps -qn $LIBRECATHOME
$CPANM -L $LIBDIR -qn install Devel::Camelcadedb
$CPANM -L $LIBDIR -qn install Carton

echo "If something fails to install you might need some additional libraries, since some Perl modules aren't selfcontained! Look at the logs."

# Save Version of Perl, to recompile modules if needed
echo $(perl -version | sed '2,2!d') > $PERL_VERSION_FILE

# Build a fully patched version for development
cd $LIBRECATHOME
cp $WD/patches/*.patch .
cp $WD/patches/*.diff .
cp $WD/robonils.sh .
cp $WD/goettingenfy.py .
LOCAL_LAYER=$LIBRECATHOME
export LIBRECATHOME LOCAL_LAYER
echo "Using sources from $LIBRECATHOME to build layer in $LOCAL_LAYER"
bash ./robonils.sh
echo "Running goettingenfy"
python goettingenfy.py -s  .
rm *.patch *.diff robonils.sh goettingenfy.py