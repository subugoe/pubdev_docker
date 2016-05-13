# pub_dev
PUB/LibreCat docker image

It is a merge from official docker HUB releases of:

Java JRE-8 @: https://github.com/docker-library/openjdk/blob/89851f0abc3a83cfad5248102f379d6a0bd3951a/8-jre/Dockerfile

mongoDB @: https://github.com/docker-library/mongo/tree/4bb17b336a05ad85c9bf83b103d21529e27e62f9/3.2

elasticsearch @: https://github.com/docker-library/elasticsearch/tree/master/1.7

LibreCat @: https://github.com/LibreCat/LibreCat

Following the 1-Process<->1-Container princiople these different parts come together an being managed via
'docker-compose' instruction.

I strongly recommend to install via docker-compose.yml. However, for all intents and purposes you may
choose to intall the standalone version and test the software all in one.

Regards,

A.
