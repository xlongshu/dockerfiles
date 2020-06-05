# dockerfiles
## linux

- ubuntu

```bash
## ubuntu build-arg
# default: --build-arg FROM_TAG=18.04 --build-arg MIRROR_UBUNTU=
# FROM_TAG: latest, focal, 20.04, eoan, 19.10, bionic, 18.04, xenial, 16.04, ...
# MIRROR_UBUNTU: mirrors.aliyun.com,mirrors.163.com, ...

# 16.04 xenial
#docker build -t longe/ubuntu:16.04 -t longe/ubuntu:xenial ./ubuntu --build-arg FROM_TAG=16.04
build.sh -i longe/ubuntu -t 16.04,xenial -p linux/ubuntu -A FROM_TAG=16.04 -A MIRROR_UBUNTU=mirrors.aliyun.com build

# 18.04 bionic, latest
#docker build -t longe/ubuntu:18.04 -t longe/ubuntu:bionic -t longe/ubuntu:latest ./ubuntu  --build-arg FROM_TAG=18.04
build.sh -i longe/ubuntu -t 18.04,bionic,latest -p linux/ubuntu -A FROM_TAG=18.04 -A MIRROR_UBUNTU=mirrors.aliyun.com build

# 19.10 eoan
#docker build -t longe/ubuntu:19.10 -t longe/ubuntu:eoan ./ubuntu --build-arg FROM_TAG=19.10
build.sh -i longe/ubuntu -t 19.10,eoan -p linux/ubuntu -A FROM_TAG=19.10 -A MIRROR_UBUNTU=mirrors.aliyun.com build

# 20.04 focal
#docker build -t longe/ubuntu:20.04 -t longe/ubuntu:focal ./ubuntu --build-arg FROM_TAG=20.04
build.sh -i longe/ubuntu -t 20.04,focal -p linux/ubuntu -A FROM_TAG=20.04 -A MIRROR_UBUNTU=mirrors.aliyun.com build


## ubuntu-systemctl build-arg
# default: --build-arg FROM_TAG=18.04
# FROM_TAG: latest, bionic, 18.04, xenial, 16.04, ...
docker build -t longe/ubuntu:16.04-systemctl -t longe/ubuntu:xenial-systemctl ./ubuntu/systemctl --build-arg FROM_TAG=16.04
build.sh -i longe/ubuntu -t 16.04-systemctl,xenial-systemctl -p linux/ubuntu/systemctl -A FROM_TAG=16.04 build

#docker build -t longe/ubuntu:18.04-systemctl -t longe/ubuntu:bionic-systemctl -t longe/ubuntu:latest-systemctl ./ubuntu/systemctl
build.sh -i longe/ubuntu -t 18.04-systemctl,bionic-systemctl,latest-systemctl -p linux/ubuntu/systemctl build

```


- debian

```bash
## debian build-arg
# default: --build-arg FROM_TAG=10 --build-arg MIRROR_DEBIAN=
# FROM_TAG: latest, buster, 10, buster-slim, 10-slim, stretch, 9, stretch-slim, 9-slim, ...
# MIRROR_DEBIAN: mirrors.aliyun.com,mirrors.163.com, ...

# 9 stretch
#docker build -t longe/debian:9 -t longe/debian:stretch ./debian --build-arg FROM_TAG=9
build.sh -i longe/debian -t 9,stretch -p linux/debian -A FROM_TAG=9 -A MIRROR_DEBIAN=mirrors.aliyun.com build

# 10 buster, latest
#docker build -t longe/debian:10 -t longe/debian:buster -t longe/debian:latest ./debian --build-arg FROM_TAG=10
build.sh -i longe/debian -t 10,buster,latest -p linux/debian -A FROM_TAG=10 -A MIRROR_DEBIAN=mirrors.aliyun.com build


## debian-systemctl build-arg
# default: --build-arg FROM_TAG=10
# FROM_TAG: latest, buster, 10, stretch, 9, ...
# systemctl
docker build -t longe/debian:9-systemctl -t longe/debian:stretch-systemctl ./debian/systemctl --build-arg FROM_TAG=9
build.sh -i longe/debian -t 9-systemctl,stretch-systemctl -p linux/debian/systemctl -A FROM_TAG=9 build

#docker build -t longe/debian:10-systemctl -t longe/debian:buster-systemctl -t longe/debian:latest-systemctl ./debian/systemctl
build.sh -i longe/debian -t 10-systemctl,buster-systemctl,latest-systemctl -p linux/debian/systemctl build

```


- alpine

```bash
## alpine build-arg
# default: --build-arg FROM_TAG=3.12 --build-arg MIRROR_ALPINE=
# FROM_TAG: latest, 3, 3.12, 3.11, 3.10, 3.9 ...
# MIRROR_DEBIAN: mirrors.aliyun.com,mirrors.163.com, ...

# 3.9
#docker build -t longe/alpine:3.9 ./alpine --build-arg FROM_TAG=3.9 --build-arg MIRROR_ALPINE=mirrors.aliyun.com
build.sh -i longe/alpine -t 3.9 -p linux/alpine -A FROM_TAG=3.9 -A MIRROR_ALPINE=mirrors.aliyun.com build

# 3.10
#docker build -t longe/alpine:3.10 ./alpine --build-arg FROM_TAG=3.10 --build-arg MIRROR_ALPINE=mirrors.aliyun.com
build.sh -i longe/alpine -t 3.10 -p linux/alpine -A FROM_TAG=3.10 -A MIRROR_ALPINE=mirrors.aliyun.com build

# 3.11
#docker build -t longe/alpine:3.11 ./alpine --build-arg FROM_TAG=3.11 --build-arg MIRROR_ALPINE=mirrors.aliyun.com
build.sh -i longe/alpine -t 3.11 -p linux/alpine -A FROM_TAG=3.11 -A MIRROR_ALPINE=mirrors.aliyun.com build

# 3.12, latest
#docker build -t longe/alpine:3.12 -t longe/alpine:3 -t longe/alpine:latest ./alpine --build-arg FROM_TAG=3.12 --build-arg MIRROR_ALPINE=mirrors.aliyun.com
build.sh -i longe/alpine -t 3.12,3,latest -p linux/alpine -A FROM_TAG=3.12 -A MIRROR_ALPINE=mirrors.aliyun.com build

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
