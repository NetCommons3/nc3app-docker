#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " Push Coveralls"
echo "  ==> coveralls $PLUGIN_NAME"
echo "------------------------------------------------------"

cd $NC3_BUILD_DIR

echo "COVERALLS_REPO_TOKEN"
cat $COVERALLS_REPO_TOKEN

if [ -f build/logs/clover.xml ]; then
	php vendors/bin/coveralls --coverage_clover=build/logs/clover.xml -vvv || exit $?
	echo "Success coveralls."
	echo ""
else
    echo "Not file build/logs/clover.xml."
	echo ""
	exit 1
fi
