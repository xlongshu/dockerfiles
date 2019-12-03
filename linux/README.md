# dockerfiles
## linux

- ubuntu
```bash
# 18.04 bionic
docker build -t longe/ubuntu:18.04 ./ubuntu
docker tag longe/ubuntu:18.04 longe/ubuntu:bionic
docker tag longe/ubuntu:18.04 longe/ubuntu:latest

# 16.04 xenial
docker build -t longe/ubuntu:16.04 ./ubuntu --build-arg FROM_TAG=16.04 --build-arg MIRROR_UBUNTU=mirrors.ustc.edu.cn
docker tag longe/ubuntu:16.04 longe/ubuntu:xenial
```

- debian
```bash
# 10 buster
docker build -t longe/debian:10 ./debian
docker tag longe/debian:10 longe/debian:buster
docker tag longe/debian:10 longe/debian:latest

# 9 stretch
docker build -t longe/debian:9 ./debian --build-arg FROM_TAG=9 --build-arg MIRROR_DEBIAN=mirrors.ustc.edu.cn
docker tag longe/debian:9 longe/debian:stretch
```

- alpine
```bash
# 3.10
docker build -t longe/alpine:3.10 ./alpine
docker tag longe/alpine:3.10 longe/alpine:latest

# 3.9
docker build -t longe/alpine:3.9 ./alpine --build-arg FROM_TAG=3.9 --build-arg MIRROR_ALPINE=mirrors.ustc.edu.cn
```
