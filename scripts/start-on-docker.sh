#!/bin/bash

# MySQLの起動
service mysql start
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
#mysql -uroot -proot mysql -e "SELECT * FROM user;"

php -v
mysql --version
ffmpeg -version
bower --version
composer --version
