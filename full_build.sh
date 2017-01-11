#!/bin/bash
echo "* Creating one Dockerfile in order to ease up the build process."
echo "** start **"

echo "-- Dockerfile_Base > Dockerfile"
cat Dockerfile_Base > Dockerfile
echo "** Removing unnecessary lines"
sed -i '/ENTRYPOINT/ d' ./Dockerfile
echo "** Dockerfile_Dev +> Dockerfile"
tail -q -n +3 Dockerfile_Dev >> Dockerfile

echo "** end **"
