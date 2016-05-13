u!/bin/bash

# 
# You can uncomment and recomment-out one line after another to create the images on after another or
# just copy and paster each line seperately to the command prompt and execute.
# !!! NOTE: !!!
# Different images are related to each other, do not mess with the order of creating them!

# Step 1: Base
# docker build -t librecat_base:devel -f Dockerfile_Step1 --force-rm

# Step 2: GoSu
# docker build -t librecat_gosu:devel -f Dockerfile_Step2 --force-rm

# Step 3: Java JRE-8
# docker build -t librecat_jre:devel -f Dockerfile_Step3 --force-rm

# Step 4: ElasticSearch
# docker build -t librecat_elastic:devel -f Dockerfile_Step4 --force-rm

# Step 5: MongoDB
# docker build -t librecat_mongo:devel -f Dockerfile_Step5 --force-rm

# Step 6: Git Clone
# docker build -t librecat_github:devel -f Dockerfile_Step6 --force-rm

# Step 7: Finally, LibreCat
# docker build -t librecat_standalone:devel -f Dockerfile_Step7 --force-rm

exit 0
