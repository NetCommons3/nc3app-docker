#!/bin/bash

GITHUB_WORKSPACE=`pwd`

export NC3_BUILD_DIR="/opt/nc3"
export NC3_GIT_URL="git://github.com/NetCommons3/NetCommons3"
export NC3_GIT_BRANCH="master"
export PLUGIN_BUILD_DIR="/var/www/html/nc3/app/Plugin/AccessCounters"
export MYSQL_ROOT_PASSWORD=root
export MYSQL_DATABASE=cakephp_test
export PHP_VERSION=7.2
export COMPOSE_INTERACTIVE_NO_CLI=1

#------------------------------------------
# Step1
#------------------------------------------

cd ..
docker-compose rm -a -f
docker-compose up -d
docker-compose start
docker-compose ps
docker ps

docker-compose exec -T nc3app touch /opt/test
docker-compose exec -T nc3app ls -l /opt/
docker-compose exec -T nc3app bash /opt/scripts/start-on-docker.sh


#------------------------------------------
# Step2
#------------------------------------------

docker-compose exec -T nc3app bash /opt/scripts/app-build.sh

docker-compose exec -T nc3app bash /opt/scripts/phpcs.sh
docker-compose exec -T nc3app bash /opt/scripts/phpmd.sh
docker-compose exec -T nc3app ls -l /etc/php/${PHP_VERSION}/cli/conf.d/
docker-compose exec -T nc3app bash /opt/scripts/phpcpd.sh
docker-compose exec -T nc3app ls -l /etc/php/${PHP_VERSION}/cli/conf.d/
docker-compose exec -T nc3app bash /opt/scripts/gjslint.sh
docker-compose exec -T nc3app bash /opt/scripts/phpdoc.sh
docker-compose exec -T nc3app bash /opt/scripts/phpunit.sh


#------------------------------------------
# Step3
#------------------------------------------

docker-compose rm -a -f