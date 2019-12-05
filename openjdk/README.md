# dockerfiles
## openjdk (https://github.com/docker-library/openjdk)


- debian
```bash
# 9 stretch
docker build -t longe/openjdk:8-jdk ./
docker tag longe/openjdk:8-jdk longe/openjdk:8-jdk-stretch

docker build -t longe/openjdk:8-jre ./ --build-arg FROM_TAG=8-jre --build-arg MIRROR_DEBIAN=mirrors.aliyun.com
docker tag longe/openjdk:8-jre longe/openjdk:8-jre-stretch

docker build -t longe/openjdk:11-jdk ./ --build-arg FROM_TAG=11-jdk
docker tag longe/openjdk:11-jdk longe/openjdk:11-jdk-stretch

docker build -t longe/openjdk:11-jre ./ --build-arg FROM_TAG=11-jre
docker tag longe/openjdk:11-jre longe/openjdk:11-jre-stretch


# 10 buster
docker build -t longe/openjdk:13-jdk-buster ./ --build-arg FROM_TAG=13-jdk-buster
docker tag longe/openjdk:13-jdk-buster longe/openjdk:13-jdk
```
