FROM ubuntu:18.04

#RUN echo $HOME

# パッケージ準備 (linux)
RUN apt-get update
RUN apt-get install -y curl
#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# タイムゾーンのセット
RUN apt-get install -y tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ZIPのインストール
RUN apt-get -y install zip unzip
RUN which zip

# gitのインストール
RUN apt-get -y install git
RUN git --version
RUN which git

# ffmpegのインストール
RUN apt-get -y install ffmpeg
RUN ffmpeg -version
RUN which ffmpeg

# bowerのインストール
RUN apt-get -y install nodejs npm
RUN node -v
RUN npm -v
RUN npm install bower -g
RUN bower -v
RUN which bower

# phpのインストール
ARG PHP_VERSION
RUN echo ${PHP_VERSION}

RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
#RUN apt-get update

RUN apt-get -y install php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-dev php${PHP_VERSION}-curl \
php${PHP_VERSION}-mbstring php${PHP_VERSION}-gd php-pear php${PHP_VERSION}-mysql \
php${PHP_VERSION}-xdebug php${PHP_VERSION}-intl php${PHP_VERSION}-zip php${PHP_VERSION}-xmlrpc \
php${PHP_VERSION}-xml php${PHP_VERSION}-imagick php${PHP_VERSION}-cli

RUN ls -l /etc/php/${PHP_VERSION}/cli/conf.d/
RUN php -v

# composerのインストール
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer self-update --1

## mysqlのインストール
#RUN apt-get -y install mysql-server-5.7 mysql-client-5.7
#RUN mysql --version

# gjslintのインストール
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py
RUN pip --version
RUN pip install six
RUN pip install https://github.com/NetCommons3/NetCommons3/raw/master/tools/build/plugins/cakephp/travis/v2.3.19.tar.gz
RUN which gjslint

# phpmdのセットアップ
RUN apt-get -y install wget
RUN mkdir /opt/phpmd
RUN wget https://raw.githubusercontent.com/NetCommons3/chef_boilerplate_php/master/files/default/build/cakephp/phpmd/rules.xml -O /opt/phpmd/rules.xml

# sendmailのインストール
RUN apt-get -y install sendmail sendmail-cf mailutils

# Test Scriptのコピー
#RUN mkdir /opt/scripts
#COPY ./scripts/* /opt/scripts/
#
#RUN mkdir /opt/scripts/test
#COPY ./scripts/test/* /opt/scripts/test/

# NetCommons3 setup
#RUN git clone -b master git://github.com/NetCommons3/NetCommons3 /opt/nc3.dist
RUN git clone -b master https://github.com/NetCommons3/NetCommons3 /opt/nc3.dist
RUN cd /opt/nc3.dist && \
composer config minimum-stability dev && \
composer config repositories.0 git https://github.com/NetCommons3/cakephp-upload.git && \
composer config repositories.1 git https://github.com/NetCommons3/php-code-coverage.git && \
composer config repositories.2 git https://github.com/NetCommons3/migrations.git
RUN cd /opt/nc3.dist && \
rm composer.lock && \
composer install --no-scripts --no-ansi --no-interaction && \
git checkout composer.lock
