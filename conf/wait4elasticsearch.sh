#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until elasticsearch -h "$host" -c '\l'; do
      >&2 echo "ElasticSearch is unavailable - sleeping"
        sleep 1
    done

    >&2 echo "ElasticSearch is up - executing command"
    exec $cmd
