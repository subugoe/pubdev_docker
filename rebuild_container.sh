#!/bin/bash
echo "Starting to (re)build the container"
docker build --no-cache --tag librecat --force-rm -f Dockerfile_Dev .
