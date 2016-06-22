FROM ubuntu:14.04
MAINTAINER  Arash Samadi (samadi@sub.uni-goettingen.de)
# 
# creating a predecessor for the LibreCat Image
#

# Add extra Repository for ElasticSearch
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 \
    && echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" > /etc/apt/sources.list.d/elasticsearch-1.7.list
RUN sed -i '/multiverse/s/#[\ ]*deb/deb/g' /etc/apt/sources.list

ENV LIBRECATHOME /srv/LibreCat
ENV MYSQL_USER root
ENV MYSQL_PASSWORD alaki

# Prepare to install
RUN apt-get clean \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y

RUN apt install -y build-essential
RUN apt install -y ca-certificates \
    wget \
    g++ \
    numactl \
    xz-utils \
    bsdmainutils \
    git \
    man-db \
    ImageMagick \
    libexpat1-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libgdbm-dev \
    libyaz-dev \
    libwrap0-dev \
    zlib1g \
    zlib1g-dev \
    binutils \
    pwgen \
    libaio1
RUN apt install -y perl-doc \
    cpanminus \
    libcapture-tiny-perl \
    libdbd-mysql-perl \
    libmodule-install-perl \
    libyaml-perl \
    libb-utils-perl \
    carton
RUN apt install -y gearman \
    gearman-server \
    gearman-tools
RUN apt install -y mysql-client \
    libmysqlclient-dev

RUN sed -i '/socket/ d' /etc/mysql/my.cnf \
    && sed -i '/\[mysqld\]/a bind-address\ =\ 0.0.0.0' /etc/mysql/my.cnf

# git clone LibreCat
RUN cd /srv \
     && git clone --recursive https://github.com/subugoe/LibreCat.git \
     && cd LibreCat \
     && git fetch \
     && git checkout dev

WORKDIR $LIBRECATHOME
#   Installing Perl-Modules and compiling everything
#   Finalizing setup and run Web-Interface under :5001
#
ENV LANG en_US.UTF-8
ENV LANGUAGE en.UTF-8
ENV LC_COLLATE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_PAPER en_US.UTF-8
ENV LC_ADDRESS en_US.UTF-8
ENV LC_MONETARY en_US.UTF-8
ENV LC_NUMERIC en_US.UTF-8
ENV LC_TELEPHONE en_US.UTF-8
ENV LC_IDENTIFICATION en_US.UTF-8
ENV LC_MEASUREMENT en_US.UTF-8
ENV LC_TIME en_US.UTF-8
ENV LC_NAME en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Building LibreCat
RUN sed -i 's/==/\>=/g' cpanfile
RUN sed -i '/Gearman::XS/ d' cpanfile
RUN cpanm -nq --installdeps Catmandu
RUN cpanm -nq --installdeps Catmandu::MARC
RUN cpanm -nq --installdeps .
RUN cpanm -nq --installdeps Gearman::XS Net::Telnet::Gearman
RUN carton install
RUN chmod +x bin/generate_forms.pl \
    && perl bin/generate_forms.pl

# Clean up
RUN apt-get clean \
    && apt-get purge -y binutils \
    wget \
    git \
    pwgen \
    binutils \
    && apt-get --purge autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY conf/catmandu.local.yml .
COPY conf/catmandu.store.yml .
COPY conf/mysql-init.sql .
COPY gearman-entrypoint.sh ./gearboot.sh
COPY docker-entrypoint.sh ./entrypoint.sh

VOLUME ["/usr/share/elasticsearch/data","/var/lib/mysql"]

EXPOSE 5001 3306 9200 9300 4730

CMD ["./entrypoint.sh"]
