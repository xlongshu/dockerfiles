# dockerfiles
## brook (https://github.com/txthinking/brook)



### Quick Start

```bash
docker run -it -d \
-p 6060:6060 -p 6080:6080 \
--name brook -h brook \
--restart=always \
longe/brook 

```


## build

- alpine

```bash
# 3.10
docker build -t longe/brook:v20200201 ./
docker tag longe/brook:v20200201 longe/brook:latest

# 3.9
docker build -t longe/brook:v20200201-alpine-3.9 ./ --build-arg FROM_TAG=3.9 --build-arg BROOK_VERSION=v20200201
```


- ubuntu, debian

```bash
# 18.04 bionic
docker build -t longe/brook:v20200201-bionic ./ --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=18.04 --build-arg BROOK_VERSION=v20200201

# 16.04 xenial
docker build -t longe/brook:v20200201-xenial ./ --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=16.04 --build-arg BROOK_VERSION=v20200201

# 9 stretch
docker build -t longe/brook:v20200201-stretch ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=9 --build-arg BROOK_VERSION=v20200201

# 10 buster
docker build -t longe/brook:v20200201-buster ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=10 --build-arg BROOK_VERSION=v20200201

```
