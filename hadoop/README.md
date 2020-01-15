# dockerfiles
## hadoop

### Quick Start

- [Pseudo-Distributed](https://hadoop.apache.org/docs/stable2/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation)

```bash
## Pseudo-Distributed
#hadoop2.x
docker run --rm -it \
-p 8020:8020 -p 50070:50070 -p 50075:50075 -p 50090:50090 -p 8088:8088 -p 8042:8042 -p 19888:19888 -p 8188:8188 \
-v `pwd`/temp/conf:/etc/hadoop \
-v `pwd`/temp/data:/data/hadoop \
-e PS1_=hadoop2 \
--name hadoop-server -h hadoop-server \
longe/hadoop:2.7.7 namenode,secondarynamenode,datanode,resourcemanager,nodemanager,historyserver,timelineserver

#hadoop3.x
docker run --rm -it \
-p 8020:8020 -p 50070:9870 -p 50075:9864 -p 50090:9868 -p 8088:8088 -p 8042:8042 -p 19888:19888 -p 8188:8188 \
-e PS1_=hadoop3 \
--name hadoop-server -h hadoop-server \
longe/hadoop:3.1.3 namenode,secondarynamenode,datanode,resourcemanager,nodemanager,historyserver,timelineserver

```

- [Fully-Distributed](https://hadoop.apache.org/docs/stable2/hadoop-project-dist/hadoop-common/ClusterSetup.html)

```bash
## Fully-Distributed
# docker-compose.yml
docker network create --driver=bridge hadoop
docker-compose up -d

```


## build


- ubuntu

```bash
## 18.04 bionic
#java-8, hadoop:2.7.7
docker build -t longe/hadoop:2.7.7 ./ --build-arg HADOOP_VERSION=2.7.7
docker tag longe/hadoop:2.7.7 longe/hadoop:2.7.7-bionic
docker tag longe/hadoop:2.7.7 longe/hadoop:2.7.7-java-8-bionic

#java-8, hadoop:3.1.3
docker build -t longe/hadoop:3.1.3 ./ --build-arg HADOOP_VERSION=3.1.3
docker tag longe/hadoop:3.1.3 longe/hadoop:3.1.3-bionic
docker tag longe/hadoop:3.1.3 longe/hadoop:3.1.3-java-8-bionic


## 16.04 xenial
#java-8, hadoop:2.7.7
docker build -t longe/hadoop:2.7.7-xenial ./ --build-arg FROM_TAG=8-xenial --build-arg HADOOP_VERSION=2.7.7
docker tag longe/hadoop:2.7.7-xenial longe/hadoop:2.7.7-java-8-xenial

#java-8, hadoop:3.1.3
docker build -t longe/hadoop:3.1.3-xenial ./ --build-arg FROM_TAG=8-xenial --build-arg HADOOP_VERSION=3.1.3
docker tag longe/hadoop:3.1.3-xenial longe/hadoop:3.1.3-java-8-xenial
```


- debian

```bash
## 9 stretch
#openjdk-8, hadoop:2.7.7
docker build -t longe/hadoop:2.7.7-openjdk-8 ./ --build-arg FROM_IMG=openjdk --build-arg FROM_TAG=8-jdk --build-arg HADOOP_VERSION=2.7.7
docker tag longe/hadoop:2.7.7-openjdk-8 longe/hadoop:2.7.7-openjdk-8-stretch

#openjdk-8, hadoop:3.1.3
docker build -t longe/hadoop:3.1.3-openjdk-8 ./ --build-arg FROM_IMG=openjdk --build-arg FROM_TAG=8-jdk --build-arg HADOOP_VERSION=3.1.3
docker tag longe/hadoop:3.1.3-openjdk-8 longe/hadoop:2.7.7-openjdk-8-stretch

# 9 stretch, java-8, hadoop 2.7.7
docker build -t longe/hadoop:2.7.7-java-8-stretch ./ --build-arg FROM_TAG=8-stretch --build-arg HADOOP_VERSION=2.7.7
```


- alpine

```bash
# 3.10, java-8, hadoop 2.7.7
docker build -t longe/hadoop:2.7.7-alpine ./ -f ./Dockerfile.alpine --build-arg HADOOP_VERSION=2.7.7
docker tag longe/hadoop:2.7.7-alpine longe/hadoop:2.7.7-java-8-alpine
```
