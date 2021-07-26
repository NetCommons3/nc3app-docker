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
  export IGNORE_PLUGINS="$IGNORE_PLUGINS,$NC3_BUILD_DIR/app/Plugin/$p"
done

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