# dockerfiles
## v2ray (https://github.com/v2ray/v2ray-core)



### Quick Start

```bash
# server
docker run -it -d \
-p 10086:10086 \
-p 18086:8080 \
--name v2ray -h v2ray \
--log-opt "max-size=100m" \
--restart=always \
-v $(pwd)/config_server.json:/etc/v2ray/config.json \
longe/v2ray 

# client
docker run -it -d \
-p 1080:1080 \
-p 18080:8080 \
--name v2ray_client -h v2ray_client \
--log-opt "max-size=100m" \
-v $(pwd)//config_client.json:/etc/v2ray/config.json \
longe/v2ray 


# uuid
cat /proc/sys/kernel/random/uuid

```


## build

- alpine

```bash
# 3.10
docker build -t longe/v2ray ./
docker tag longe/v2ray:latest longe/v2ray:v4.23.1

# 3.9
docker build -t longe/v2ray:v4.23.1-alpine-3.9 ./ --build-arg FROM_TAG=3.9 --build-arg V2RAY_VERSION=v4.23.1
```


- ubuntu, debian

```bash
# 18.04 bionic
docker build -t longe/v2ray:v4.23.1-bionic ./ --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=18.04 --build-arg V2RAY_VERSION=v4.23.1

# 10 buster
docker build -t longe/v2ray:v4.23.1-buster ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=10 --build-arg V2RAY_VERSION=v4.23.1

```
