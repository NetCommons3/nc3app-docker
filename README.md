# netcommons3-docker

このDockerは、Github Actionのテストで使用するためのDocker

## Docker環境

| ライブラリ | バージョン | 備考
| ------------ | ------ | ------
| OS | Ubuntu 18.04 |


## 備考

### Docker Build


````
e.g.)
git clone https://github.com/NetCommons3/nc3app-docker.git
cd nc3app-docker
docker build --build-arg PHP_VERSION=7.2 -t nc3app-php7.2 .
````

## Docker Run

````
e.g.)
docker run -i -t -d --name=nc3app-php7.2 nc3app-php7.2
````

## Dockerコンテナにアクセス

````
e.g.)
docker exec -i -t nc3app-php7.2 /bin/bash
````

## Docker Delete

````
docker rm -f nc3-docker
````

## DockerHubにPush

DockerHubにPushするにはアカウントとPusuできるパーミッションが必要です。
※<tag>は、1.0のようなバージョンタグ

````
e.g.)
git clone https://github.com/NetCommons3/nc3app-docker.git
cd nc3app-docker
docker login
docker build --no-cache --build-arg PHP_VERSION=7.2 -t netcommons3/nc3app-php7.2:<tag> .
#docker tag netcommons3/nc3app-php7.2:<tag> netcommons3/nc3app-php7.2:<tag>
docker push netcommons3/nc3app-php7.2:<tag>
````
