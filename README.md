# pub_dev
**PUB/LibreCat docker image**

I used different official and unofficial docker-images as template and built my own:

* Java JRE-8 (https://github.com/docker-library/openjdk/tree/89851f0abc3a83cfad5248102f379d6a0bd3951a/8-jre)

* mongoDB (https://github.com/docker-library/mongo/tree/4bb17b336a05ad85c9bf83b103d21529e27e62f9/3.2)

* elasticsearch (https://github.com/docker-library/elasticsearch/tree/master/1.7)

* LibreCat (https://github.com/LibreCat/LibreCat)

* MySQL 5.5 (https://github.com/docker-library/mysql/tree/f7a67d7634a68d319988ad6f99729bfeaa84ceb2/5.5)


** 2016.06.15 **

The 1st `docker-compose` version is ready:

```
$ docker-compose up -d
```

after a while you can access the LibreCat as usual under:

http://localhost:5001/

** 2016.06.08 **

As of right now only the centOS version is functional. Though it will take a while, one Dockerfile suffices
building the functional Image:

```
$ docker build -t librecat --force-rm .
```

Regards,

A.
