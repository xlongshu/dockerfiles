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
--restart=always \
-v ~/downloads:/data/download \
-e "RPC_SECRET=aria2c123" \
longe/aria2

```


## build

- alpine

```bash
# 3.10
docker build -t longe/aria2:latest ./ --build-arg ARIA2_VERSION=1.35.0
docker tag longe/aria2:latest longe/aria2:1.35.0

# 3.9
docker build -t longe/aria2:1.35.0-alpine-3.9 ./ --build-arg FROM_TAG=3.9 --build-arg ARIA2_VERSION=1.35.0
```


```
# https://github.com/aria2/aria2
# https://github.com/q3aql/aria2-static-builds/releases

# https://github.com/P3TERX/aria2.conf
# https://github.com/P3TERX/docker-aria2-pro

# https://github.com/wahyd4/aria2-ariang-docker
# https://github.com/wahyd4/aria2-ariang-x-docker-compose

```
