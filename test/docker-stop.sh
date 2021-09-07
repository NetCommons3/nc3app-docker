#!/bin/bash

#------------------------------------------
# Environment
#------------------------------------------

GITHUB_WORKSPACE=`pwd`

export PLUGIN_NAME="${1}"

docker-compose stop
docker-compose rm -a -f

SCRIPT_DIR=$(cd $(dirname $0); pwd)
source ${SCRIPT_DIR}/remove.env