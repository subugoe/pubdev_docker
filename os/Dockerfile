FROM centos:7
MAINTAINER  Arash Samadi (samadi@sub.uni-goettingen.de)
# 
# creating a predecessor for the LibreCat Image
#

RUN sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/CentOS-Base.repo

ENV LANG C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_COLLATE C
ENV LC_CTYPE en_US.UTF-8

# Prepare to install
RUN yum update -y \
    && yum groupinstall -y "Development Tools"

RUN yum install -y perl-devel \
    perl-CPAN \
    perl-YAML \
    perl-App-cpanminus \
    perl-Module-Install \
    perl-DBD-MySQL \
    perl-Env

RUN yum install -y wget tcp_wrappers-devel \
    expat-devel expat \
    openssl-devel openssl \
    libxml2 libxml2-devel \
    libxslt libxslt-devel \
    libgearman libgearman-devel gearmand \
    gdbm gdbm-devel \
    ImageMagick \
    mariadb-libs \
    mongodb-devel -y \
    && yum clean all

# git clone LibreCat
RUN cd /srv \
     && git clone --recursive https://github.com/LibreCat/LibreCat.git \
     && cd LibreCat \
     && git fetch \
     && git checkout dev

WORKDIR /srv/LibreCat
COPY catmandu.local.yml .
COPY catmandu.store.yml .
COPY cpanfile .

RUN cpanm -n -q --installdeps Test::More
RUN cpanm -n -q --installdeps Catmandu
RUN cpanm -n -q --installdeps Catmandu::MARC
RUN cpanm -n -f -q --installdeps .
RUN cpanm -n -f -q --installdeps Gearman::XS Net::Telnet::Gearman
