ARG FROM_IMG=ubuntu
ARG FROM_TAG=18.04
FROM longe/${FROM_IMG}:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# --build-arg JAVA_VER=11
ARG JAVA_VER
ENV JAVA_VER=${JAVA_VER:-"8"}

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y -f --no-install-recommends \
    ca-certificates p11-kit fontconfig libfreetype6 \
    openjdk-${JAVA_VER}-jre openjdk-${JAVA_VER}-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME="/usr/lib/jvm/java-${JAVA_VER}-openjdk-amd64"
ENV PATH $JAVA_HOME/bin:$PATH
ENV _PS1="docker-java-${JAVA_VER}"

RUN ln -s $JAVA_HOME /usr/lib/jvm/default-jvm
RUN { echo '#!/bin/sh'; echo 'set -e'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home
RUN { echo '#!/bin/sh'; echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; } > /usr/local/bin/java-home \
    && chmod +x /usr/local/bin/java-home

# test
RUN set -eux; $JAVA_HOME/bin/java -version; $JAVA_HOME/bin/javac -version;

CMD ["/bin/bash"]
