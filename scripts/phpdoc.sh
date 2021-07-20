#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " PHP Documentor(phpdoc)"
echo "  ==> phpdoc app/Plugin/$PLUGIN_NAME"
echo "------------------------------------------------------"

cd $NC3_BUILD_DIR

# phpdoc
LOG=./app/tmp/logs/phpdoc.log
touch $LOG
chmod a+w $LOG

phpdoc parse -d app/Plugin/$PLUGIN_NAME -i app/Plugin/$PLUGIN_NAME/Vendor -t $TRAVIS_BUILD_DIR/phpdoc --force --ansi | tee $LOG

#[ `grep -c '\[37;41m' $LOG` -ne 0 ] && cat $LOG && exit 1
if [ `grep -c '\[37;41m' $LOG` -ne 0 ] && cat $LOG; then
    export result=1
    echo "Failure phpdoc."
else
    echo "Success phpdoc."
fi
echo ""

exit $ret
