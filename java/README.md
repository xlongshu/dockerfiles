# dockerfiles
## java (install openjdk)

- ubuntu, debian

```bash
# 18.04 bionic, java:8
docker build -t longe/java:8 ./
docker tag longe/java:8 longe/java:8-bionic

# 18.04 bionic, java:11
docker build -t longe/java:11 ./ --build-arg JAVA_VER=11
docker tag longe/java:11 longe/java:11-bionic

# 16.04 xenial, java:8
docker build -t longe/java:8-xenial . --build-arg FROM_TAG=16.04

# 9 stretch, java:8
docker build -t longe/java:8-stretch ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=9

# 10 buster, java:11
docker build -t longe/java:11-buster ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=10 --build-arg JAVA_VER=11

## build-arg
default: --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=18.04 --build-arg JAVA_VER=8
FROM_IMG: ubuntu; FROM_TAG: 16.04,xenial, 18.04,bionic, 16.04-systemctl,xenial-systemctl, 18.04-systemctl,bionic-systemctl
FROM_IMG: debian; FROM_TAG: 9,stretch, 10,buster, 9-systemctl,stretch-systemctl, 10-systemctl,buster-systemctl
```


- alpine

```bash
# 3.10, java:8
docker build -t longe/java:8-alpine ./ -f ./Dockerfile.alpine
docker tag longe/java:8-alpine longe/java:8-alpine-3.10

# 3.9, java:8
docker build -t longe/java:8-alpine-3.9 ./ -f ./Dockerfile.alpine --build-arg FROM_TAG=3.9
```
