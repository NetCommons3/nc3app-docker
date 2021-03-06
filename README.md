# nc3テストのためのdocker

このDockerは、各プラグインのGithub Actionのテストで使用するためのDockerです。

## Dockerイメージ

Dockerhubに最新のイメージがあります。

- php7.1
https://hub.docker.com/r/netcommons3/nc3app-php7.1

- php7.2
https://hub.docker.com/r/netcommons3/nc3app-php7.1

- php7.3
https://hub.docker.com/r/netcommons3/nc3app-php7.1

- php7.4
https://hub.docker.com/r/netcommons3/nc3app-php7.1


## 最新のDokerhubのイメージの作成方法

当リポジトリのreleaseタグを付けることで最新のDokerイメージをDockerhubにPushします。

https://github.com/NetCommons3/nc3app-docker/actions/workflows/build_docker_images.yml

※dockerhub-build-push.shを実行しても可

## テスト用のdocker-composeを直接実行する方法

````
cd nc3app-docker/test

#----
# docker起動
#    第一引数にプラグインを指定してください。
#----
export PLUGIN_NAME="NetCommons"; source local.env && bash docker-start.sh

#----
# dockerコンテナーの中に入る
#----
docker-compose exec nc3app bash

#----
# docker破棄
#----
bash docker-stop.sh && source remove.env
````


## ローカルの開発環境でテストを実行する

### 1. 事前準備

#### 1-1. dockerのインストール

https://docs.docker.com/engine/install/


#### 1-2. docker-composeのインストール

https://docs.docker.jp/compose/install.html#compose


#### 1-3. 当リポジトリをgit cloneする。

※`/var/www/html/nc3app-docker` に`git clone`する例

````
cd /var/www/html/
git clone https://github.com/NetCommons3/nc3app-docker.git
````

### 2. local.envを各自修正する

`test/local.env` の下記のパスをローカルの環境に各自修正する

https://github.com/NetCommons3/nc3app-docker/blob/main/test/local.env#L5-L6

````
 5  export TARGET_NC3_DIR="/var/www/NetCommons3/app"
 6  export NC3_DOCKER_DIR="/var/www/NetCommons3/nc3app-docker"
 7
 8  export PHP_VERSION=7.3
 9  export MYSQL_VERSION=5.7
````

※phpのバージョンは、デフォルト7.3を使用しています。
phpのバージョンを変える場合は、PHP_VERSIONを変更してください。
使用できるバージョンは、`7.1` , `7.2` , `7.3` , `7.4` です。
※MySQLのバージョンは、デフォルト5.7を使用しています。
MySQLのバージョンを変える場合は、MYSQL_VERSIONを変更してください。
使用できるバージョンは、https://hub.docker.com/_/mysql です。


### 3. テストシェルを実行する

````
bash test/docker-compose.sh (プラグイン名)
e.g) bash test/docker-compose.sh Announcements
````

## ローカルで全プラグインのテストを実行する

事前準備として、dockerおよびdocker-composeはインストールしてください。
また、local.envも各自設定を変更してください。

### テストシェルを実行する

````
bash test/PluginAllTest.sh
````

### 別ターミナルで実行ログを監視

````
tail -f test/logs/testResult.log
````
````
tail -f test/logs/PluginAllTest.log
````

### NetCommons3リポジトリ―に上がっている全プラグインのテスト結果

- [![Tests Status](https://github.com/NetCommons3/AccessCounters/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/AccessCounters/actions/workflows/tests.yml) : AccessCounters
- [![Tests Status](https://github.com/NetCommons3/Announcements/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Announcements/actions/workflows/tests.yml) : Announcements
- [![Tests Status](https://github.com/NetCommons3/Auth/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Auth/actions/workflows/tests.yml) : Auth
- [![Tests Status](https://github.com/NetCommons3/AuthGeneral/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/AuthGeneral/actions/workflows/tests.yml) : AuthGeneral
- [![Tests Status](https://github.com/NetCommons3/AuthorizationKeys/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/AuthorizationKeys/actions/workflows/tests.yml) : AuthorizationKeys
- [![Tests Status](https://github.com/NetCommons3/Bbses/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Bbses/actions/workflows/tests.yml) : Bbses
- [![Tests Status](https://github.com/NetCommons3/Blocks/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Blocks/actions/workflows/tests.yml) : Blocks
- [![Tests Status](https://github.com/NetCommons3/Blogs/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Blogs/actions/workflows/tests.yml) : Blogs
- [![Tests Status](https://github.com/NetCommons3/Boxes/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Boxes/actions/workflows/tests.yml) : Boxes
- [![Tests Status](https://github.com/NetCommons3/Cabinets/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Cabinets/actions/workflows/tests.yml) : Cabinets
- [![Tests Status](https://github.com/NetCommons3/Calendars/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Calendars/actions/workflows/tests.yml) : Calendars
- [![Tests Status](https://github.com/NetCommons3/Categories/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Categories/actions/workflows/tests.yml) : Categories
- [![Tests Status](https://github.com/NetCommons3/CircularNotices/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/CircularNotices/actions/workflows/tests.yml) : CircularNotices
- [![Tests Status](https://github.com/NetCommons3/CleanUp/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/CleanUp/actions/workflows/tests.yml) : CleanUp
- [![Tests Status](https://github.com/NetCommons3/CommunitySpace/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/CommunitySpace/actions/workflows/tests.yml) : CommunitySpace
- [![Tests Status](https://github.com/NetCommons3/Containers/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Containers/actions/workflows/tests.yml) : Containers
- [![Tests Status](https://github.com/NetCommons3/ContentComments/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/ContentComments/actions/workflows/tests.yml) : ContentComments
- [![Tests Status](https://github.com/NetCommons3/ControlPanel/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/ControlPanel/actions/workflows/tests.yml) : ControlPanel
- [![Tests Status](https://github.com/NetCommons3/DataTypes/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/DataTypes/actions/workflows/tests.yml) : DataTypes
- [![Tests Status](https://github.com/NetCommons3/Faqs/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Faqs/actions/workflows/tests.yml) : Faqs
- [![Tests Status](https://github.com/NetCommons3/Files/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Files/actions/workflows/tests.yml) : Files
- [![Tests Status](https://github.com/NetCommons3/Frames/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Frames/actions/workflows/tests.yml) : Frames
- [![Tests Status](https://github.com/NetCommons3/Groups/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Groups/actions/workflows/tests.yml) : Groups
- [![Tests Status](https://github.com/NetCommons3/Holidays/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Holidays/actions/workflows/tests.yml) : Holidays
- [![Tests Status](https://github.com/NetCommons3/Iframes/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Iframes/actions/workflows/tests.yml) : Iframes
- [![Tests Status](https://github.com/NetCommons3/Install/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Install/actions/workflows/tests.yml) : Install
- [![Tests Status](https://github.com/NetCommons3/Likes/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Likes/actions/workflows/tests.yml) : Likes
- [![Tests Status](https://github.com/NetCommons3/Links/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Links/actions/workflows/tests.yml) : Links
- [![Tests Status](https://github.com/NetCommons3/M17n/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/M17n/actions/workflows/tests.yml) : M17n
- [![Tests Status](https://github.com/NetCommons3/Mails/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Mails/actions/workflows/tests.yml) : Mails
- [![Tests Status](https://github.com/NetCommons3/Menus/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Menus/actions/workflows/tests.yml) : Menus
- [![Tests Status](https://github.com/NetCommons3/Multidatabases/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Multidatabases/actions/workflows/tests.yml) : Multidatabases
- [![Tests Status](https://github.com/NetCommons3/Nc2ToNc3/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Nc2ToNc3/actions/workflows/tests.yml) : Nc2ToNc3
- [![Tests Status](https://github.com/NetCommons3/NetCommons/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/NetCommons/actions/workflows/tests.yml) : NetCommons
- [![Tests Status](https://github.com/NetCommons3/Notifications/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Notifications/actions/workflows/tests.yml) : Notifications
- [![Tests Status](https://github.com/NetCommons3/Pages/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Pages/actions/workflows/tests.yml) : Pages
- [![Tests Status](https://github.com/NetCommons3/PhotoAlbums/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/PhotoAlbums/actions/workflows/tests.yml) : PhotoAlbums
- [![Tests Status](https://github.com/NetCommons3/PluginManager/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/PluginManager/actions/workflows/tests.yml) : PluginManager
- [![Tests Status](https://github.com/NetCommons3/PrivateSpace/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/PrivateSpace/actions/workflows/tests.yml) : PrivateSpace
- [![Tests Status](https://github.com/NetCommons3/PublicSpace/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/PublicSpace/actions/workflows/tests.yml) : PublicSpace
- [![Tests Status](https://github.com/NetCommons3/Questionnaires/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Questionnaires/actions/workflows/tests.yml) : Questionnaires
- [![Tests Status](https://github.com/NetCommons3/Quizzes/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Quizzes/actions/workflows/tests.yml) : Quizzes
- [![Tests Status](https://github.com/NetCommons3/Registrations/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Registrations/actions/workflows/tests.yml) : Registrations
- [![Tests Status](https://github.com/NetCommons3/Reservations/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Reservations/actions/workflows/tests.yml) : Reservations
- [![Tests Status](https://github.com/NetCommons3/Roles/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Roles/actions/workflows/tests.yml) : Roles
- [![Tests Status](https://github.com/NetCommons3/Rooms/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Rooms/actions/workflows/tests.yml) : Rooms
- [![Tests Status](https://github.com/NetCommons3/RssReaders/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/RssReaders/actions/workflows/tests.yml) : RssReaders
- [![Tests Status](https://github.com/NetCommons3/Searches/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Searches/actions/workflows/tests.yml) : Searches
- [![Tests Status](https://github.com/NetCommons3/SiteManager/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/SiteManager/actions/workflows/tests.yml) : SiteManager
- [![Tests Status](https://github.com/NetCommons3/SystemManager/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/SystemManager/actions/workflows/tests.yml) : SystemManager
- [![Tests Status](https://github.com/NetCommons3/Tags/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Tags/actions/workflows/tests.yml) : Tags
- [![Tests Status](https://github.com/NetCommons3/Tasks/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Tasks/actions/workflows/tests.yml) : Tasks
- [![Tests Status](https://github.com/NetCommons3/ThemeSettings/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/ThemeSettings/actions/workflows/tests.yml) : ThemeSettings
- [![Tests Status](https://github.com/NetCommons3/Topics/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Topics/actions/workflows/tests.yml) : Topics
- [![Tests Status](https://github.com/NetCommons3/UserAttributes/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/UserAttributes/actions/workflows/tests.yml) : UserAttributes
- [![Tests Status](https://github.com/NetCommons3/UserManager/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/UserManager/actions/workflows/tests.yml) : UserManager
- [![Tests Status](https://github.com/NetCommons3/UserRoles/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/UserRoles/actions/workflows/tests.yml) : UserRoles
- [![Tests Status](https://github.com/NetCommons3/Users/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Users/actions/workflows/tests.yml) : Users
- [![Tests Status](https://github.com/NetCommons3/Videos/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Videos/actions/workflows/tests.yml) : Videos
- [![Tests Status](https://github.com/NetCommons3/VisualCaptcha/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/VisualCaptcha/actions/workflows/tests.yml) : VisualCaptcha
- [![Tests Status](https://github.com/NetCommons3/Workflow/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Workflow/actions/workflows/tests.yml) : Workflow
- [![Tests Status](https://github.com/NetCommons3/Wysiwyg/actions/workflows/tests.yml/badge.svg)](https://github.com/NetCommons3/Wysiwyg/actions/workflows/tests.yml) : Wysiwyg
