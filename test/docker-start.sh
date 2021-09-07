#!/bin/bash

#------------------------------------------
# Environment
#------------------------------------------

GITHUB_WORKSPACE=`pwd`

if [ "${1}" = "" ]; then
	echo "プラグインを指定してください。"
	echo "e.g) bash ${0} Accouncements"
	exit
fi

export PLUGIN_NAME="${1}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
source ${SCRIPT_DIR}/local.env

cd ${NC3_DOCKER_DIR}/test

if [ ! -d ${NC3_TEST_DIR} ]; then
	git clone -b ${NC3_GIT_BRANCH} ${NC3_GIT_URL} ${NC3_TEST_DIR}
	APP_BUILD="true"
else
	APP_BUILD="false"
fi

docker-compose stop
docker-compose rm -a -f
docker-compose up -d
docker-compose start
docker-compose ps
docker ps

docker-compose exec -T nc3app bash /opt/scripts/start-on-docker.sh

if [ $APP_BUILD = "true" ]; then
	docker-compose exec -T nc3app bash /opt/scripts/app-build.sh
fi
