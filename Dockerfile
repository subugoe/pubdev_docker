FROM centos:7
MAINTAINER  Arash Samadi (samadi@sub.uni-goettingen.de)
# 
# creating a predecessor for the LibreCat Image
#

# Add extra Repository for ElasticSearch
RUN yum install -y wget
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm \
    && rpm -ivh epel-release-7-6.noarch.rpm

ENV LANG C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_COLLATE C
ENV LC_CTYPE en_US.UTF-8
ENV LIBRECATHOME /srv/LibreCat

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

RUN yum install -y tcp_wrappers-devel \
    expat-devel expat \
    openssl-devel openssl \
    libxml2 libxml2-devel \
    libxslt libxslt-devel \
    libgearman libgearman-devel gearmand \
    mariadb-devel \
    mongodb-devel \
    gdbm gdbm-devel \
    ImageMagick \
    sudo \
    && yum clean all

# git clone LibreCat
RUN cd /srv \
     && git clone --recursive https://github.com/subugoe/LibreCat.git \
     && cd LibreCat \
     && git fetch \
     && git checkout dev

WORKDIR /srv/LibreCat
COPY conf/catmandu.local.yml .
COPY conf/catmandu.store.yml .
COPY conf/cpanfile .

RUN cpanm -n -q --installdeps Test::More
RUN cpanm -n -q --installdeps Catmandu
RUN cpanm -n -q --installdeps Catmandu::MARC
RUN cpanm -n -q --installdeps .
RUN cpanm -n -q --installdeps Gearman::XS Net::Telnet::Gearman
RUN cpanm -n -q Carton

COPY gearman-entrypoint.sh ./gearboot.sh
COPY docker-entrypoint.sh ./entrypoint.sh
RUN sed -i "s/NEW_PASSWORD/$MYSQL_ROOT_PASSWORD/g" entrypoint.sh

#   Installing Perl-Modules and compiling everything
#   Finalizing setup and run Web-Interface under :5001
#
ENV PERLHOME /usr/bin
ENV PATH ${LIBRECATHOME}/local/bin:${PERLHOME}:${PATH}
ENV PERL5LIB ${LIBRECATHOME}/local/lib/perl5

RUN carton install

RUN chmod +x bin/generate_forms.pl \
    && perl bin/generate_forms.pl

EXPOSE 5001 4730

CMD ["./entrypoint.sh"]
