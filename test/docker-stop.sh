#!/bin/bash

#------------------------------------------
# Environment
#------------------------------------------

GITHUB_WORKSPACE=`pwd`

export PLUGIN_NAME="${1}"

docker-compose stop
docker-compose rm -a -f
