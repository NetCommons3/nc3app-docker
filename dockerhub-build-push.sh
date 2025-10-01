#!/bin/bash -ex

PHP_VERSIONS="7.1 7.2 7.3 7.4"
#PHP_VERSIONS="7.4"
TAG="latest"

if [ "${MODE}" = "" ]; then
	#MODE="prod"
	MODE="$1"
fi

export COMPOSER_TOKEN="(Github Token)"

#docker ps -aq | xargs docker rm -f
#docker images -aq | xargs docker rmi -f

if [ ! "${DOCKER_USER}" = "" -a ! "${DOCKER_PASS}" = "" ]; then
  docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
else
  docker login
fi

for phpVersion in ${PHP_VERSIONS}
do
  DOCKER_BUILDKIT=1 docker build --no-cache \
--progress=plain \
--secret id=composer_token,env=COMPOSER_TOKEN \
--build-arg PHP_VERSION=${phpVersion} \
-t netcommons3/nc3app-php${phpVersion}:${TAG} .

  if [ "${MODE}" = "prod" ]; then
    docker push netcommons3/nc3app-php${phpVersion}:${TAG}
  fi
	docker rmi netcommons3/nc3app-php${phpVersion}

	yes | docker system prune --volumes
	yes | docker builder prune
done

yes | docker system prune --volumes
yes | docker builder prune
