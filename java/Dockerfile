#escape=\

ARG FROM_TAG=18.04
FROM ubuntu:$FROM_TAG

#ARG FROM_TAG=stretch
#FROM debian:$FROM_TAG

LABEL version="1.0"
LABEL maintainer="xlongshu@163.com"

RUN set -xe \
    && sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    locales tzdata psmisc iputils-ping net-tools curl openjdk-8-jre openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -x \
    && localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && localedef -c -i zh_CN -f UTF-8 zh_CN.UTF-8

ENV LANG=en_US.UTF-8

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH:.

#RUN { echo '#!/bin/sh'; echo 'set -e'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home
RUN { echo '#!/bin/sh'; echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home \
    && ln -s $JAVA_HOME /usr/lib/jvm/default-jvm


CMD ["/bin/bash"]
