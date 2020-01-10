# dockerfiles
## linux

- ubuntu

```bash
# 18.04 bionic
docker build -t longe/ubuntu:18.04 ./ubuntu
docker tag longe/ubuntu:18.04 longe/ubuntu:bionic
docker tag longe/ubuntu:18.04 longe/ubuntu:latest

# 16.04 xenial
docker build -t longe/ubuntu:16.04 ./ubuntu --build-arg FROM_TAG=16.04 --build-arg MIRROR_UBUNTU=mirrors.aliyun.com
docker tag longe/ubuntu:16.04 longe/ubuntu:xenial

# systemctl
docker build -t longe/ubuntu:18.04-systemctl ./ubuntu/systemctl
docker tag longe/ubuntu:18.04-systemctl longe/ubuntu:bionic-systemctl
docker build -t longe/ubuntu:16.04-systemctl ./ubuntu/systemctl --build-arg FROM_TAG=16.04
docker tag longe/ubuntu:16.04-systemctl longe/ubuntu:xenial-systemctl
```


- debian

```bash
# 9 stretch
docker build -t longe/debian:9 ./debian
docker tag longe/debian:9 longe/debian:stretch
docker tag longe/debian:9 longe/debian:latest

# 10 buster
docker build -t longe/debian:10 ./debian --build-arg FROM_TAG=10 --build-arg MIRROR_DEBIAN=mirrors.aliyun.com
docker tag longe/debian:10 longe/debian:buster

# systemctl
docker build -t longe/debian:9-systemctl ./debian/systemctl
docker tag longe/debian:9-systemctl longe/debian:stretch-systemctl
docker build -t longe/debian:10-systemctl ./debian/systemctl --build-arg FROM_TAG=10
docker tag longe/debian:10-systemctl longe/debian:buster-systemctl
```


- alpine

```bash
# 3.10
docker build -t longe/alpine:3.10 ./alpine
docker tag longe/alpine:3.10 longe/alpine:latest

# 3.9
docker build -t longe/alpine:3.9 ./alpine --build-arg FROM_TAG=3.9 --build-arg MIRROR_ALPINE=mirrors.aliyun.com
```


- mirrors
```
mirrors.aliyun.com
mirrors.ustc.edu.cn
mirrors.163.com
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
