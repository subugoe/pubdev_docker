# Dockerizing LibreCat

FROM librecat_os:1.0
MAINTAINER Arash Samadi (asamadi@sub.uni-goettingen.de)

RUN cd /srv \
    && git clone --recursive https://github.com/LibreCat/LibreCat.git

WORKDIR /srv/LibreCat
RUN cpanm --notest --installdeps .

RUN perl bin/generate_forms.pl
# Correct the Database Issue
#COPY catmandu.store.yml .

ENTRYPOINT ["starman","bin/app.pl"]
