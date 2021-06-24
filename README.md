# netcommons3-docker

このDockerは、Github Actionのテストで使用するためのDocker

## Docker環境

| ライブラリ | バージョン | 備考
| ------------ | ------ | ------
| OS | Ubuntu 18.04 |
| mysql | 5.7 | user: root, password: root


## 備考

### Docker Build


````
git clone https://github.com/NetCommons3/nc3app-docker.git
cd nc3app-docker
docker build --build-arg PHP_VERSION=7.2 -t nc3app-7.2 .
````

## Docker Run

````
docker run -i -t -d --name=nc3app-7.2 nc3app-7.2

````

## Dockerコンテナにアクセス

````
docker exec -i -t nc3app-7.2 /bin/bash
````

## Docker Delete

````
docker rm -f nc3-docker
````
