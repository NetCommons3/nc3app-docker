#!/bin/bash -ex

export TARGET_NC3_DIR="/var/www/html/nc3"
export NC3_DOCKER_DIR="/var/www/html/nc3app-docker2"

export RESULT_LOGFILE=${NC3_DOCKER_DIR}/test/testResult.log
echo "" > ${RESULT_LOGFILE}
echo "//////////////////////////////////" >> ${RESULT_LOGFILE}
echo "// All Test Results" >> ${RESULT_LOGFILE}
echo "//////////////////////////////////" >> ${RESULT_LOGFILE}
echo "" >> ${RESULT_LOGFILE}
echo "+----------------------------+" >> ${RESULT_LOGFILE}

NOW=$(date +%y%m%d%H%M%S)
export LOGFILE=${NC3_DOCKER_DIR}/test/PluginAllTest.log

echo "" > ${LOGFILE}

PLUGIN_NAME=`ls $TARGET_NC3_DIR/app/Plugin`

echo "" > ${LOGFILE}
for plugin in ${PLUGIN_NAME}
do
	case "${plugin}" in
		"empty" ) continue ;;
		"BoostCake" ) continue ;;
		"DebugKit" ) continue ;;
		"HtmlPurifier" ) continue ;;
		#"M17n" ) continue ;;
		"Migrations" ) continue ;;
		"MobileDetect" ) continue ;;
		"Sandbox" ) continue ;;
		#"Install" ) continue ;;
		"TinyMCE" ) continue ;;
		"Upload" ) continue ;;
		* )

		echo "" >> ${LOGFILE}
		echo "" >> ${LOGFILE}
		date 1>> ${LOGFILE} 2>&1

		COMMAND="bash ${NC3_DOCKER_DIR}/test/docker-compose.sh \"$plugin\""
		echo ${COMMAND}
		bash ${NC3_DOCKER_DIR}/test/docker-compose.sh "$plugin" 1>> ${LOGFILE} 2>&1

		date 1>> ${LOGFILE} 2>&1
	esac
done

#
#-- end of file --
