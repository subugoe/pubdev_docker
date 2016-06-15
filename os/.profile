#!/bin/bash
export LIBRECATHOME=/srv/LibreCat
export PERLHOME=/usr/local/bin
export PATH=${LIBRECATHOME}/bin:${PERLHOME}:${PATH}
export PERL5LIB=${LIBRECATHOME}/local/lib/perl5:${LIBRECATHOME}/lib
