#!/bin/bash -ex

#-----------------------
# git clone NetCommons3
#-----------------------

#if [ -d $NC3_BUILD_DIR ]; then
#  rm -Rf $NC3_BUILD_DIR
#fi
if [ ! -d $NC3_BUILD_DIR ]; then
  git clone -b $NC3_GIT_BRANCH $NC3_GIT_URL $NC3_BUILD_DIR
  cd $NC3_BUILD_DIR
else
  cd $NC3_BUILD_DIR
  git checkout -b $NC3_GIT_BRANCH
fi

echo "PLUGIN_BUILD_DIR=${PLUGIN_BUILD_DIR}"


#-----------------------
# Exec composer install
#-----------------------

PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`
echo "PLUGIN_NAME=${PLUGIN_NAME}"

cd $NC3_BUILD_DIR

# NetCommons3 project install
rm composer.lock
#composer clear-cache
composer remove --no-update netcommons/install
composer config minimum-stability dev
composer config repositories.0 git https://github.com/NetCommons3/migrations.git
composer config repositories.1 git https://github.com/NetCommons3/cakephp-upload.git

# Plugin install
php -q << _EOF_ > packages.txt
<?php
\$composer = json_decode(file_get_contents('/opt/plugin/composer.json'), true);
\$ret = '';
if (isset(\$composer['require'])) {
  foreach (\$composer['require'] as \$package => \$version) {
    \$ret .= ' ' . \$package . ':' . \$version;
  }
}
echo \$ret;
_EOF_

composerRequire=`cat packages.txt | cut -c 2-`
if [ ! "$composerRequire" = "" ] ; then
  echo $composerRequire
  composer require --no-update $composerRequire
fi

php -q << _EOF_ > packages.txt
<?php
\$composer = json_decode(file_get_contents('/opt/plugin/composer.json'), true);
\$ret = '';
if (isset(\$composer['require-dev'])) {
  foreach (\$composer['require-dev'] as \$package => \$version) {
    \$ret .= ' ' . \$package . ':' . \$version;
  }
}
echo \$ret;
_EOF_

composerRequireDev=`cat packages.txt | cut -c 2-`
if [ ! "$composerRequireDev" = "" ] ; then
  echo $composerRequireDev
  composer require --dev --no-update $composerRequireDev
fi

composer install --no-scripts --no-ansi --no-interaction

#-----------------------
# Setup Plugin
#-----------------------

if [ -d "$NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME" ]; then
  rm -rf $NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME
fi
cp -rf /opt/plugin $NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME
