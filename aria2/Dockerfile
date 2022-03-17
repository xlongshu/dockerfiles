ARG FROM_TAG=3.14
FROM longe/alpine:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

EXPOSE 6800 6880 6888 6888/udp

VOLUME /data
VOLUME /download

# --build-arg ARIA2_VERSION=
ARG ARIA2_VERSION
ARG ARIANG_VERSION

ENV ARIA2_VERSION=${ARIA2_VERSION:-"1.36.0"}
ENV ARIANG_VERSION=${ARIANG_VERSION:-"1.2.3"}

# https://github.com/q3aql/aria2-static-builds/releases/download/v${ARIA2_VERSION}/aria2-${ARIA2_VERSION}-linux-gnu-64bit-build1.tar.bz2
# https://download.fastgit.org/q3aql/aria2-static-builds/releases/download/v${ARIA2_VERSION}/aria2-${ARIA2_VERSION}-linux-gnu-64bit-build1.tar.bz2
RUN set -xe \
    && mkdir -p /data /download \
    && curl -fsSL -o /tmp/aria2.tar.bz2 "https://github.com/q3aql/aria2-static-builds/releases/download/v${ARIA2_VERSION}/aria2-${ARIA2_VERSION}-linux-gnu-64bit-build1.tar.bz2" \
    && mkdir /tmp/aria2 \
    && tar -xf /tmp/aria2.tar.bz2 --strip-components=1 -C /tmp/aria2 \
    && mv /tmp/aria2/aria2c /usr/local/bin/ \
    && chmod +x /usr/local/bin/aria2c \
    && rm -rf /tmp/aria2*

# httpd -p 6880 -h /var/www
RUN set -xe \
    && mkdir -p /var/www && cd /var/www \
    && curl -fsSL -o /tmp/AriaNg.zip "https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip" \
    && unzip /tmp/AriaNg.zip \
    && rm -rf /tmp/AriaNg.zip

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV _PS1="docker-aria2"


COPY docker_aria2.sh /docker_aria2.sh
RUN chmod +x /docker_aria2.sh

COPY shell/*.sh /opt/aria2/
RUN chmod +x /opt/aria2/*.sh

WORKDIR /download

ENTRYPOINT ["/docker_aria2.sh"]
