# dockerfiles
## [aria2](https://github.com/aria2/aria2) + [AriaNg](https://github.com/mayswind/AriaNg)



### Quick Start

```bash
docker run -it -d \
-p 6800:6800 \
-p 6888:6888 \
-p 6888:6888/udp \
-p 6088:80 \
--name aria2 -h aria2 \
--log-opt "max-size=100m" \
--restart=unless-stopped \
-v ~/downloads:/download \
-e "RPC_SECRET=aria2c123" \
longe/aria2

```


## build

- alpine

```bash
# 3.12
# docker build -t longe/aria2:latest -t longe/aria2:1.35.0 ./ --build-arg ARIA2_VERSION=1.35.0
build.sh -i longe/aria2 -t 1.35.0,latest -p aria2 -A FROM_TAG=3.12 -A ARIA2_VERSION=1.35.0 -U build

build.sh -i longe/aria2 -t 1.35.0,latest -p aria2 -A ARIA2_VERSION=1.36.0 -A ARIANG_VERSION=1.2.3 -U build

```


```
# https://github.com/aria2/aria2
# https://github.com/q3aql/aria2-static-builds/releases

# https://github.com/P3TERX/aria2.conf
# https://github.com/P3TERX/docker-aria2-pro

# https://github.com/wahyd4/aria2-ariang-docker
# https://github.com/wahyd4/aria2-ariang-x-docker-compose

```
