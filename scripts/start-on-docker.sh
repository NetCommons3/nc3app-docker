#!/bin/bash

touch /opt/dummy

echo "ls -la /opt/"
ls -la /opt/
echo ""
if [ ! -f /opt/dummy ]; then
	echo "/opt/dummy file does not exists."
	exit 1
fi

echo "ls -la /opt/plugin"
ls -la /opt/plugin
echo ""
if [ ! -f /opt/plugin/composer.json ]; then
	echo "/opt/plugin/composer.json file does not exists."
	exit 1
fi


## MySQLの起動
#service mysql start
#mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
#mysql -uroot -proot mysql -e "SELECT * FROM user;"
#echo ""

echo "php -v"
php -v
echo ""

echo "php -i"
php -i
echo ""

#mysql --version
#echo ""

echo "ffmpeg -version"
ffmpeg -version
echo ""

echo "bower --version"
bower --version
echo ""

echo "composer --version"
composer --version
echo ""

#php /opt/scripts/test/phpinfo.php
php /opt/scripts/test/imagick.php
php /opt/scripts/test/xdebug.php
php /opt/scripts/test/mysql.php
echo ""
