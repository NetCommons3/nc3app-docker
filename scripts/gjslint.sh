#!/bin/bash -ex

export PATH=$NC3_BUILD_DIR/vendors/bin:$PATH

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`

echo "------------------------------------------------------"
echo " JavaScript Style Check(gjslint)"
echo "  ==> gjslint app/Plugin/$PLUGIN_NAME"
echo "------------------------------------------------------"

cd $NC3_BUILD_DIR

# gjslint
gjslint --strict --max_line_length 100 -x jquery.js,jquery.cookie.js,js_debug_toolbar.js,travis.karma.conf.js,my.karma.conf.js -e jasmine_examples,HtmlPurifier,webroot/components,webroot/js/langs -r app/Plugin/$PLUGIN_NAME

ret=$?
if [ $ret -eq 0 ]; then
    echo "Success gjslint."
else
    echo "Failure gjslint."
fi
echo ""

exit $ret
