#!/bin/bash -ex

PHP_VERSIONS="7.1 7.2 7.3 7.4"
#PHP_VERSIONS="7.2"
TAG="latest"
COMPOSER_TOKEN=(GitHub Access Token)

#docker ps -aq | xargs docker rm -f
#docker images -aq | xargs docker rmi -f

docker login

for phpVersion in ${PHP_VERSIONS}
do
	docker build --no-cache \
--build-arg COMPOSER_TOKEN=${COMPOSER_TOKEN} \
--build-arg PHP_VERSION=${phpVersion} \
-t netcommons3/nc3app-php${phpVersion}:${TAG} .

	docker push netcommons3/nc3app-php${phpVersion}:${TAG}
	docker rmi netcommons3/nc3app-php${phpVersion}
done
docker builder prune