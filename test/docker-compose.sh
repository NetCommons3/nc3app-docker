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

if [ "$RESULT_LOGFILE" = "" ]; then
	RESULT_LOGFILE=${NC3_DOCKER_DIR}/test/logs/testResult.log
	echo "" > ${RESULT_LOGFILE}
	echo "//////////////////////////////////" >> ${RESULT_LOGFILE}
	echo "// Test Results" >> ${RESULT_LOGFILE}
	echo "//   [${NC3_TEST_DIR}]" >> ${RESULT_LOGFILE}
	echo "//////////////////////////////////" >> ${RESULT_LOGFILE}
	echo "" >> ${RESULT_LOGFILE}
	echo "+----------------------------+" >> ${RESULT_LOGFILE}
fi
echo "  ${PLUGIN_NAME}" >> ${RESULT_LOGFILE}

echo ""
echo ""
echo "//////////////////////////////////"
echo "// Checked ${PLUGIN_NAME}"
echo "//   [${NC3_TEST_DIR}]"
echo "//////////////////////////////////"

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
docker-compose stop
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

if [ -f "$NC3_TEST_DIR/app/Config/application.yml" ]; then
  sudo -s rm -f $NC3_TEST_DIR/app/Config/application.yml
fi
if [ -d "$NC3_TEST_DIR/app/Plugin/$PLUGIN_NAME" ]; then
  sudo -s rm -Rf $NC3_TEST_DIR/app/Plugin/$PLUGIN_NAME
fi
sudo -s cp -Rpf $PLUGIN_BUILD_DIR $NC3_TEST_DIR/app/Plugin/$PLUGIN_NAME

docker-compose exec -T nc3app bash /opt/scripts/phpcs.sh
result=$?
if [ $result -eq 0 ]; then
	echo "     phpcs   : Success" >> ${RESULT_LOGFILE}
else
	echo "     phpcs   : Failure" >> ${RESULT_LOGFILE}
fi

docker-compose exec -T nc3app bash /opt/scripts/phpmd.sh
result=$?
if [ $result -eq 0 ]; then
	echo "     phpmd   : Success" >> ${RESULT_LOGFILE}
else
	echo "     phpmd   : Failure" >> ${RESULT_LOGFILE}
fi

docker-compose exec -T nc3app bash /opt/scripts/phpcpd.sh
result=$?
if [ $result -eq 0 ]; then
	echo "    phpcpd   : Success" >> ${RESULT_LOGFILE}
else
	echo "    phpcpd   : Failure" >> ${RESULT_LOGFILE}
fi

docker-compose exec -T nc3app bash /opt/scripts/gjslint.sh
result=$?
if [ $result -eq 0 ]; then
	echo "    gjslint  : Success" >> ${RESULT_LOGFILE}
else
	echo "    gjslint  : Failure" >> ${RESULT_LOGFILE}
fi

docker-compose exec -T nc3app bash /opt/scripts/phpdoc.sh
result=$?
if [ $result -eq 0 ]; then
	echo "    phpdoc   : Success" >> ${RESULT_LOGFILE}
else
	echo "    phpdoc   : Failure" >> ${RESULT_LOGFILE}
fi

docker-compose exec -T nc3app bash /opt/scripts/phpunit.sh
result=$?
if [ $result -eq 0 ]; then
	echo "    phpunit  : Success" >> ${RESULT_LOGFILE}
else
	echo "    phpunit  : Failure" >> ${RESULT_LOGFILE}
fi

echo "+----------------------------+" >> ${RESULT_LOGFILE}

#------------------------------------------
# Step3
#------------------------------------------

docker-compose stop
docker-compose rm -a -f

# 下記のエラーが出るようになったため
# UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
sudo -s systemctl restart docker