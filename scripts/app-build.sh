#!/bin/bash -ex

#-----------------------
# git clone NetCommons3
#-----------------------

cd $NC3_BUILD_DIR
git config --global --add safe.directory $NC3_BUILD_DIR

cp -rpf /opt/nc3.dist/app ./
cp -rpf /opt/nc3.dist/vendors ./

echo "PLUGIN_BUILD_DIR=${PLUGIN_BUILD_DIR}"

#-----------------------
# Exec composer install
#-----------------------
export COMPOSER_ALLOW_SUPERUSER=1

if [ ! "${COMPOSER_TOKEN}" = "" ]; then
  composer config github-oauth.github.com ${COMPOSER_TOKEN}
fi


PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`
echo "PLUGIN_NAME=${PLUGIN_NAME}"

cd $NC3_BUILD_DIR

# NetCommons3 project install
rm composer.lock
composer clear-cache
if [ "${PLUGIN_NAME}" = "Install" ]; then
  composer require --no-update netcommons/install:@dev
else
  composer remove --no-update netcommons/install
fi

composer config minimum-stability dev
composer config preferred-install.netcommons/* source
composer config repositories.cakephp-upload git https://github.com/NetCommons3/cakephp-upload.git
composer config repositories.php-code-coverage git https://github.com/NetCommons3/php-code-coverage.git
composer config repositories.migrations git https://github.com/NetCommons3/migrations.git

# Plugin install
php -q << _EOF_ > packages.txt
<?php
\$composer = json_decode(file_get_contents('/opt/plugin/composer.json'), true);
\$ret = '';
if (isset(\$composer['require'])) {
  foreach (\$composer['require'] as \$package => \$version) {
    if ('$NC3_GIT_BRANCH' === 'availability' && \$package === 'netcommons/net-commons') {
      \$version = 'dev-availability';
    }
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
composer config --global --unset github-oauth.github.com

#-----------------------
# Setup Plugin
#-----------------------

if [ -d "$NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME" ]; then
  rm -rf $NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME
fi
cp -rf /opt/plugin $NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME