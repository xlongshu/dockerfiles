# dockerfiles
## openjdk (https://github.com/docker-library/openjdk)


- debian

```bash
## 9 stretch
#openjdk:8-jdk
docker build -t longe/openjdk:8-jdk ./
docker tag longe/openjdk:8-jdk longe/openjdk:8
docker tag longe/openjdk:8-jdk longe/openjdk:8-stretch
docker tag longe/openjdk:8-jdk longe/openjdk:8-jdk-stretch

#openjdk:8-jre
docker build -t longe/openjdk:8-jre ./ --build-arg FROM_TAG=8-jre --build-arg MIRROR_DEBIAN=mirrors.aliyun.com
docker tag longe/openjdk:8-jre longe/openjdk:8-jre-stretch

#openjdk:11-jdk
docker build -t longe/openjdk:11-jdk ./ --build-arg FROM_TAG=11-jdk
docker tag longe/openjdk:11-jdk longe/openjdk:11
docker tag longe/openjdk:11-jdk longe/openjdk:11-stretch
docker tag longe/openjdk:11-jdk longe/openjdk:11-jdk-stretch

#openjdk:11-jre
docker build -t longe/openjdk:11-jre ./ --build-arg FROM_TAG=11-jre
docker tag longe/openjdk:11-jre longe/openjdk:11-jre-stretch


## 10 buster
#openjdk:13-jdk-buster
docker build -t longe/openjdk:13-jdk-buster ./ --build-arg FROM_TAG=13-jdk-buster
docker tag longe/openjdk:13-jdk-buster longe/openjdk:13-buster


## slim
docker build -t longe/openjdk:8-jdk-slim  -t longe/openjdk:8-slim  -t longe/openjdk:8-slim-buster  ./ --build-arg FROM_TAG=8-jdk-slim
docker build -t longe/openjdk:11-jdk-slim -t longe/openjdk:11-slim -t longe/openjdk:11-slim-buster ./ --build-arg FROM_TAG=11-jdk-slim
docker build -t longe/openjdk:13-jdk-slim -t longe/openjdk:13-slim -t longe/openjdk:13-slim-buster ./ --build-arg FROM_TAG=13-jdk-slim


## build-arg
default: --build-arg FROM_TAG=8-jdk
FROM_TAG: 8,8-jdk,8-jdk-stretch,8-stretch, 11,11-jdk,11-stretch,11-jdk-stretch, 13-jdk-buster,13-buster, 8-jre,11-jre, ...
MIRROR_DEBIAN: mirrors.aliyun.com,mirrors.163.com, ...
```
