#!/bin/bash

GITHUB_WORKSPACE=`pwd`

export NC3_BUILD_DIR="/opt/nc3"
export NC3_GIT_URL="git://github.com/NetCommons3/NetCommons3"
export NC3_GIT_BRANCH="master"
export MYSQL_ROOT_PASSWORD=root
export MYSQL_DATABASE=cakephp_test
export PHP_VERSION=7.4
export COMPOSE_INTERACTIVE_NO_CLI=1
export PLUGIN_BUILD_DIR="/var/www/html/nc3/app/Plugin/Cabinets"
export NC3_DOCKER_DIR="/var/www/html/nc3app-docker"
export NC3_TEST_DIR="${NC3_DOCKER_DIR}/test/nc3"

#------------------------------------------
# Step1
#------------------------------------------

if [ ! -d ${NC3_TEST_DIR} ]; then
	git clone -b ${NC3_GIT_BRANCH} ${NC3_GIT_URL} ${NC3_TEST_DIR}
	APP_BUILD="true"
else
	APP_BUILD="false"
fi

cd ${NC3_DOCKER_DIR}/test
docker-compose rm -a -f
docker-compose up -d
docker-compose start
docker-compose ps
docker ps

docker-compose exec -T nc3app bash /opt/scripts/start-on-docker.sh


#------------------------------------------
# Step2
#------------------------------------------

if [ $APP_BUILD = "true" ]; then
	docker-compose exec -T nc3app bash /opt/scripts/app-build.sh
fi

#docker-compose exec -T nc3app bash /opt/scripts/phpcs.sh
#docker-compose exec -T nc3app bash /opt/scripts/phpmd.sh
#docker-compose exec -T nc3app bash /opt/scripts/phpcpd.sh
#docker-compose exec -T nc3app bash /opt/scripts/gjslint.sh
#docker-compose exec -T nc3app bash /opt/scripts/phpdoc.sh
docker-compose exec -T nc3app bash /opt/scripts/phpunit.sh


#------------------------------------------
# Step3
#------------------------------------------

docker-compose stop
docker-compose rm -a -f