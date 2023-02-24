#!/bin/bash -ex

#-----------------------
# git clone NetCommons3
#-----------------------

cd $NC3_BUILD_DIR
cp -rpf /opt/nc3.dist/app ./
cp -rpf /opt/nc3.dist/vendors ./

echo "PLUGIN_BUILD_DIR=${PLUGIN_BUILD_DIR}"

#-----------------------
# Exec composer install
#-----------------------

if [ ! "${COMPOSER_TOKEN}" = "" ]; then
  composer config github-oauth.github.com ${COMPOSER_TOKEN}
fi


PLUGIN_NAME=`basename ${PLUGIN_BUILD_DIR}`
echo "PLUGIN_NAME=${PLUGIN_NAME}"

cd $NC3_BUILD_DIR

composer global require hirak/prestissimo

# NetCommons3 project install
rm composer.lock
composer clear-cache
composer remove --no-update netcommons/install
composer config minimum-stability dev
composer config repositories.0 git https://github.com/NetCommons3/cakephp-upload.git
composer config repositories.1 git https://github.com/NetCommons3/php-code-coverage.git
composer config repositories.2 git https://github.com/NetCommons3/migrations.git

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

#-----------------------
# Setup Plugin
#-----------------------

if [ -d "$NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME" ]; then
  rm -rf $NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME
fi
cp -rf /opt/plugin $NC3_BUILD_DIR/app/Plugin/$PLUGIN_NAME