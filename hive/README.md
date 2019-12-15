# dockerfiles
## hive

### Quick Start
```bash
# test
docker run --rm -it \
-p 10000:10000 -p 10002:10002 \
-v `pwd`/test:/etc/hive \
-v `pwd`/test:/data/hive \
-e PS1_=hive \
--network hadoop \
--env-file `pwd`/hive-test.env \
--name hive-test -h hive-test \
longe/hive:2.3.4 


# docker-compose.yml
docker-compose up -d

```


## build
- ubuntu
```bash
## 18.04 bionic, java-8
# hadoop-2.7.7, hive:1.2.2
docker build -t longe/hive:1.2.2 ./ --build-arg HIVE_VERSION=1.2.2
docker tag longe/hive:1.2.2 longe/hive:1.2.2-bionic
docker tag longe/hive:1.2.2 longe/hive:1.2.2-hadoop-2.7.7

# hadoop-2.7.7, hive:2.3.4
docker build -t longe/hive:2.3.4 ./ --build-arg HIVE_VERSION=2.3.4
docker tag longe/hive:2.3.4 longe/hive:2.3.4-bionic
docker tag longe/hive:2.3.4 longe/hive:2.3.4-hadoop-2.7.7


## 16.04 xenial, java-8
# hadoop-2.7.7, hive:1.2.2
docker build -t longe/hive:1.2.2-hadoop-2.7.7-xenial ./ --build-arg FROM_TAG=2.7.7-xenial --build-arg HIVE_VERSION=1.2.2

# hadoop-2.7.7, hive:2.3.4
docker build -t longe/hive:2.3.4-hadoop-2.7.7-xenial ./ --build-arg FROM_TAG=2.7.7-xenial --build-arg HIVE_VERSION=2.3.4

```

- debian
```bash
## 9 stretch, java-8
# hadoop-2.7.7, hive:1.2.2
docker build -t longe/hive:1.2.2-hadoop-2.7.7-stretch ./ --build-arg FROM_TAG=8-stretch --build-arg HIVE_VERSION=1.2.2
# hadoop-2.7.7, hive:2.3.4
docker build -t longe/hive:2.3.4-hadoop-2.7.7-stretch ./ --build-arg FROM_TAG=8-stretch --build-arg HIVE_VERSION=2.3.4


## 9 stretch, openjdk-8
# hadoop 2.7.7, hive 1.2.2
docker build -t longe/hive:1.2.2-hadoop-2.7.7-openjdk-8 ./ --build-arg FROM_TAG=2.7.7-openjdk-8 --build-arg HIVE_VERSION=1.2.2
# hadoop-2.7.7, hive:2.3.4
docker build -t longe/hive:2.3.4-hadoop-2.7.7-openjdk-8 ./ --build-arg FROM_TAG=2.7.7-openjdk-8 --build-arg HIVE_VERSION=2.3.4

```