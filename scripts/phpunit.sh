#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " PHP UnitTest(phpunit)"
echo "  ==> phpunit $PLUGIN_NAME All$PLUGIN_NAME"
echo "------------------------------------------------------"

cd $NC3_BUILD_DIR

# php
cp /opt/scripts/database.php.act ./app/Config/database.php
cp /opt/plugin/phpunit.xml.dist .

echo "Configure::write('Security.salt', 'ForTravis');" >> ./app/Config/core.php
echo "Configure::write('Security.cipherSeed', '999');" >> ./app/Config/core.php
echo "Configure::write('NetCommons.installed', true);" >> ./app/Config/core.php

app/Console/cake test $PLUGIN_NAME All$PLUGIN_NAME --coverage-clover --configuration phpunit.xml.dist --stderr

ret=$?
if [ $ret -eq 0 ]; then
    echo "Success phpunit."
else
    echo "Failure phpunit."
fi
echo ""

exit $ret
