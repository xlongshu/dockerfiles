ARG FROM_TAG=3.10
FROM longe/alpine:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

RUN set -xe \
    && apk update && apk upgrade \
    && apk add bash bash-completion openjdk8-jre openjdk8 \
    && rm -rf /var/cache/apk/*

ENV JAVA_HOME="/usr/lib/jvm/default-jvm"
ENV PATH $JAVA_HOME/bin:$PATH
ENV _PS1="docker-java-alpine"

RUN { echo '#!/bin/sh'; echo 'set -e'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home
RUN { echo '#!/bin/sh'; echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; } > /usr/local/bin/java-home \
    && chmod +x /usr/local/bin/java-home

# test
RUN set -eux; $JAVA_HOME/bin/java -version; $JAVA_HOME/bin/javac -version;

CMD ["/bin/bash"]
