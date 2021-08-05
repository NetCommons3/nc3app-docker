#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " PHP Copy/Paste Detector (phpcpd)"
echo "  ==> phpcpd app/Plugin/$PLUGIN_NAME"
echo "------------------------------------------------------"

cd /etc/php/${PHP_VERSION}/cli/conf.d/
rm 20-xdebug.ini
#ls -l /etc/php/${PHP_VERSION}/cli/conf.d/

cd $NC3_BUILD_DIR

# phpcpd
for p in `cat ./app/Config/vendors.txt`
do
	IGNORE_PLUGINS_OPTS="$IGNORE_PLUGINS_OPTS --exclude app/Plugin/$p"
done
if [ -f app/Plugin/$PLUGIN_NAME/.phpcpdignore ]; then
	for file in `cat app/Plugin/$PLUGIN_NAME/.phpcpdignore`
	do
		IGNORE_FILES="$IGNORE_FILES,$file"
	done
fi
if [ ! "${IGNORE_FILES}" = "" ]; then
	IGNORE_FILES=`echo $IGNORE_FILES | cut -c 2-`
	IGNORE_PLUGINS_OPTS="$IGNORE_PLUGINS_OPTS --names-exclude ${IGNORE_FILES}"
fi

phpcpd --exclude Test --exclude Config --exclude Vendor $IGNORE_PLUGINS_OPTS app/Plugin/$PLUGIN_NAME

ret=$?
if [ $ret -eq 0 ]; then
    echo "Success phpcpd."
else
    echo "Failure phpcpd."
fi
echo ""

cd /etc/php/${PHP_VERSION}/cli/conf.d/
ln -s /etc/php/${PHP_VERSION}/mods-available/xdebug.ini 20-xdebug.ini

#ls -l /etc/php/${PHP_VERSION}/cli/conf.d/

exit $ret
