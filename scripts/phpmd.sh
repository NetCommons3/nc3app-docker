#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " PHP Mess Detector(phpmd)"
echo "  ==> phpmd app/Plugin/$PLUGIN_NAME"
echo "------------------------------------------------------"

cd $NC3_BUILD_DIR

# phpmd
for p in `cat ./app/Config/vendors.txt`
do
  IGNORE_PLUGINS="$IGNORE_PLUGINS,$NC3_BUILD_DIR/app/Plugin/$p"
done
IGNORE_PLUGINS=`echo $IGNORE_PLUGINS | cut -c 2-`

phpmd app/Plugin/$PLUGIN_NAME text /opt/phpmd/rules.xml --exclude $NETCOMMONS_BUILD_DIR/vendors,$NETCOMMONS_BUILD_DIR/app/Config/Migration,$NETCOMMONS_BUILD_DIR/app/Plugin/$PLUGIN_NAME/Config/Migration,$NETCOMMONS_BUILD_DIR/app/Plugin/$PLUGIN_NAME/Config/Schema,$NETCOMMONS_BUILD_DIR/app/Plugin/$PLUGIN_NAME/Vendor,$IGNORE_PLUGINS

ret=$?
if [ $ret -eq 0 ]; then
    echo "Success phpmd."
else
    echo "Failure phpmd."
fi
echo ""

exit $ret
