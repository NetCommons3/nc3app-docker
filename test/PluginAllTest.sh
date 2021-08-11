#!/bin/bash -ex

SCRIPT_DIR=$(cd $(dirname $0); pwd)
source ${SCRIPT_DIR}/local.env

TODAY=$(date +%y%m%d)
export RESULT_LOGFILE=${NC3_DOCKER_DIR}/test/testResult_${TODAY}.log
echo "" > ${RESULT_LOGFILE}
echo "//////////////////////////////////" >> ${RESULT_LOGFILE}
echo "// All Test Results" >> ${RESULT_LOGFILE}
echo "//////////////////////////////////" >> ${RESULT_LOGFILE}
echo "" >> ${RESULT_LOGFILE}
echo "+----------------------------+" >> ${RESULT_LOGFILE}

export LOGFILE=${NC3_DOCKER_DIR}/test/PluginAllTest_${TODAY}.log

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
