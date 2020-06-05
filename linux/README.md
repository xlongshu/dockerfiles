# dockerfiles
## linux

- ubuntu

```bash
## ubuntu build-arg
# default: --build-arg FROM_TAG=18.04
# FROM_TAG: latest, focal, 20.04, eoan, 19.10, bionic, 18.04, xenial, 16.04, ...
# MIRROR_UBUNTU: mirrors.aliyun.com,mirrors.163.com, ...

# 16.04 xenial
docker build -t longe/ubuntu:16.04 ./ubuntu --build-arg FROM_TAG=16.04
docker tag longe/ubuntu:16.04 longe/ubuntu:xenial

# 18.04 bionic, latest
docker build -t longe/ubuntu:18.04 ./ubuntu  --build-arg FROM_TAG=18.04
docker tag longe/ubuntu:18.04 longe/ubuntu:bionic
docker tag longe/ubuntu:18.04 longe/ubuntu:latest

# 19.10 eoan
docker build -t longe/ubuntu:19.10 ./ubuntu --build-arg FROM_TAG=19.10
docker tag longe/ubuntu:19.10 longe/ubuntu:eoan

# 20.04 focal
docker build -t longe/ubuntu:20.04 ./ubuntu --build-arg FROM_TAG=20.04
docker tag longe/ubuntu:20.04 longe/ubuntu:focal


## ubuntu-systemctl build-arg
# default: --build-arg FROM_TAG=18.04
# FROM_TAG: latest, bionic, 18.04, xenial, 16.04, ...
docker build -t longe/ubuntu:16.04-systemctl ./ubuntu/systemctl --build-arg FROM_TAG=16.04
docker tag longe/ubuntu:16.04-systemctl longe/ubuntu:xenial-systemctl

docker build -t longe/ubuntu:18.04-systemctl ./ubuntu/systemctl --build-arg FROM_TAG=18.04
docker tag longe/ubuntu:18.04-systemctl longe/ubuntu:bionic-systemctl
docker tag longe/ubuntu:18.04-systemctl longe/ubuntu:latest-systemctl

```


- debian

```bash
## debian build-arg
# default: --build-arg FROM_TAG=10
# FROM_TAG: latest, buster, 10, buster-slim, 10-slim, stretch, 9, stretch-slim, 9-slim, ...
# MIRROR_DEBIAN: mirrors.aliyun.com,mirrors.163.com, ...

# 9 stretch
docker build -t longe/debian:9 ./debian --build-arg FROM_TAG=9
docker tag longe/debian:9 longe/debian:stretch

# 10 buster, latest
docker build -t longe/debian:10 ./debian --build-arg FROM_TAG=10
docker tag longe/debian:10 longe/debian:buster
docker tag longe/debian:10 longe/debian:latest


## debian-systemctl build-arg
# default: --build-arg FROM_TAG=10
# FROM_TAG: latest, buster, 10, stretch, 9, ...
# systemctl
docker build -t longe/debian:9-systemctl ./debian/systemctl --build-arg FROM_TAG=9
docker tag longe/debian:9-systemctl longe/debian:stretch-systemctl

docker build -t longe/debian:10-systemctl ./debian/systemctl --build-arg FROM_TAG=10
docker tag longe/debian:10-systemctl longe/debian:buster-systemctl
docker tag longe/debian:10-systemctl longe/debian:latest-systemctl

```


- alpine

```bash
## alpine build-arg
# default: --build-arg FROM_TAG=3.12
# FROM_TAG: latest, 3, 3.12, 3.11, 3.10, 3.9 ...
# MIRROR_DEBIAN: mirrors.aliyun.com,mirrors.163.com, ...

# 3.9
docker build -t longe/alpine:3.9 ./alpine --build-arg FROM_TAG=3.9

# 3.10
docker build -t longe/alpine:3.10 ./alpine --build-arg FROM_TAG=3.10

# 3.11
docker build -t longe/alpine:3.11 ./alpine --build-arg FROM_TAG=3.11

# 3.12, latest
docker build -t longe/alpine:3.12 ./alpine --build-arg FROM_TAG=3.12
docker tag longe/alpine:3.12 longe/alpine:latest
docker tag longe/alpine:3.12 longe/alpine:3

```


- mirrors
```
mirrors.aliyun.com
mirrors.ustc.edu.cn
mirrors.163.com
mirrors.huaweicloud.com
```


## PS1

```bash
export _PS1=${_PS1:-"docker"}
export PS1_=${PS1_:-""}
export PS1PS1=${PS1PS1:-${PS1:-'[\u@\h:\w]\$ '}}
export PS1='\n${_PS1:+($_PS1)}'"$PS1PS1"'\n${PS1_:+$PS1_}\$ '

# add to $HOME/.bashrc
echo $'
export _PS1=${_PS1:-""}
export PS1_=${PS1_:-""}
export PS1PS1=${PS1PS1:-${PS1:-\'[\u@\h:\w]\$ \'}}
export PS1=\'\\n${_PS1:+($_PS1)}\'"$PS1PS1"\'\\n${PS1_:+$PS1_}\$ \'
' >> $HOME/.bashrc

source $HOME/.bashrc

```
