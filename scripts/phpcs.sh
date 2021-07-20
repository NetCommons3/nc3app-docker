#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " PHP CodeSniffer(phpcs)"
echo "  ==> phpcs app/Plugin/$PLUGIN_NAME"
echo "------------------------------------------------------"

cd $NC3_BUILD_DIR

# phpcs
for p in `cat ./app/Config/vendors.txt`
do
  IGNORE_PLUGINS="$IGNORE_PLUGINS,$NC3_BUILD_DIR/app/Plugin/$p"
done
IGNORE_PLUGINS=`echo $IGNORE_PLUGINS | cut -c 2-`

phpcs -p --extensions=php,ctp --standard=./vendors/cakephp/cakephp-codesniffer/CakePHP,tools/build/app/phpcs/NetCommons \
  --ignore=app/Config/Migration/,app/Config/database.php,app/Plugin/$PLUGIN_NAME/Config/Migration,app/Plugin/$PLUGIN_NAME/Config/Schema,app/Plugin/$PLUGIN_NAME/Vendor,$IGNORE_PLUGINS app/Plugin/$PLUGIN_NAME

ret=$?
if [ $ret -eq 0 ]; then
    echo "Success phpcs."
else
    echo "Failure phpcs."
fi
echo ""

exit $ret
