# syntax=docker/dockerfile:1.4
FROM ubuntu:24.04

# パッケージ準備 (linux)
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends curl

# タイムゾーンのセット
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends tzdata

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ZIPのインストール
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends zip unzip

RUN which zip

# gitのインストール
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends git

RUN git --version
RUN which git

# ffmpegのインストール
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends ffmpeg

RUN ffmpeg -version
RUN which ffmpeg

# bowerのインストール
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends nodejs npm

RUN node -v
RUN npm -v
RUN npm install bower -g
RUN bower -v
RUN which bower

# phpのインストール
ARG PHP_VERSION
RUN echo ${PHP_VERSION}

RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends ca-certificates gnupg2 software-properties-common

RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
add-apt-repository -y ppa:ondrej/php; \
apt-get update; \
apt-get install -y --no-install-recommends \
php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-dev php${PHP_VERSION}-curl \
php${PHP_VERSION}-mbstring php${PHP_VERSION}-gd php-pear php${PHP_VERSION}-mysql \
php${PHP_VERSION}-xdebug php${PHP_VERSION}-intl php${PHP_VERSION}-zip php${PHP_VERSION}-xmlrpc \
php${PHP_VERSION}-xml php${PHP_VERSION}-imagick php${PHP_VERSION}-cli

RUN ls -l /etc/php/${PHP_VERSION}/cli/conf.d/
RUN php -v

# composerのインストール
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer self-update --2

## mysqlのインストール
#RUN apt-get -y install mysql-server-5.7 mysql-client-5.7
#RUN mysql --version

# gjslintのインストール
ARG PY2_VERSION=2.7.18
ARG PY2_PREFIX=/usr/local/python2
ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends \
build-essential ca-certificates wget xz-utils \
libssl-dev zlib1g-dev libncurses5-dev libffi-dev libsqlite3-dev \
libbz2-dev libreadline-dev tk-dev uuid-dev

RUN rm -rf /var/lib/apt/lists/*

RUN cd /tmp; \
wget -O Python-${PY2_VERSION}.tgz https://www.python.org/ftp/python/${PY2_VERSION}/Python-${PY2_VERSION}.tgz; \
tar xzf Python-${PY2_VERSION}.tgz

RUN cd /tmp/Python-${PY2_VERSION}; \
./configure --prefix=${PY2_PREFIX} --enable-optimizations; \
make -j"$(nproc)"; \
make altinstall

RUN ln -sf ${PY2_PREFIX}/bin/python2.7 /usr/local/bin/python2
RUN python2 -V
RUN cd /; rm -rf /tmp/Python-${PY2_VERSION} /tmp/Python-${PY2_VERSION}.tgz

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py

ENV PATH="/usr/local/python2/bin:${PATH}"

RUN python2 get-pip.py "pip==20.3.4"
RUN pip --version
RUN pip install six
RUN pip install https://github.com/NetCommons3/NetCommons3/raw/master/tools/build/plugins/cakephp/travis/v2.3.19.tar.gz
RUN which gjslint

# phpmdのセットアップ
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends wget

RUN mkdir /opt/phpmd
RUN wget https://raw.githubusercontent.com/NetCommons3/chef_boilerplate_php/master/files/default/build/cakephp/phpmd/rules.xml -O /opt/phpmd/rules.xml

# sendmailのインストール
RUN --mount=type=cache,target=/var/lib/apt/lists \
--mount=type=cache,target=/var/cache/apt \
set -e; \
apt-get update; \
apt-get install -y --no-install-recommends sendmail-base sendmail-bin sendmail-cf mailutils

# Test Scriptのコピー
#RUN mkdir /opt/scripts
#COPY ./scripts/* /opt/scripts/
#
#RUN mkdir /opt/scripts/test
#COPY ./scripts/test/* /opt/scripts/test/

# NetCommons3 setup
RUN echo '[url "https://github.com/"]' >> ~/.gitconfig
RUN echo '  insteadOf = "git://github.com/"' >> ~/.gitconfig

RUN git clone -b master git://github.com/NetCommons3/NetCommons3 /opt/nc3.dist
#RUN git clone -b master https://github.com/NetCommons3/NetCommons3 /opt/nc3.dist

#ARG COMPOSER_TOKEN
RUN --mount=type=secret,id=composer_token \
COMPOSER_TOKEN=$(cat /run/secrets/composer_token) && \
cd /opt/nc3.dist && \
COMPOSER_ALLOW_SUPERUSER=1 composer config --global -a github-oauth.github.com "$COMPOSER_TOKEN"

RUN cd /opt/nc3.dist && \
composer config minimum-stability dev && \
composer config preferred-install.netcommons/* source && \
composer config repositories.0 git https://github.com/NetCommons3/cakephp-upload.git && \
composer config repositories.1 git https://github.com/NetCommons3/php-code-coverage.git && \
composer config repositories.2 git https://github.com/NetCommons3/migrations.git

RUN cd /opt/nc3.dist && \
rm composer.lock && \
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-scripts --no-ansi --no-interaction && \
git checkout composer.lock

RUN cd /opt/nc3.dist && \
COMPOSER_ALLOW_SUPERUSER=1 composer config --global --unset github-oauth.github.com
