ARG FROM_TAG=9
FROM debian:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# --build-arg MIRROR_DEBIAN=mirrors.ustc.edu.cn
ARG MIRROR_DEBIAN="mirrors.aliyun.com"

RUN set -xe \
    && cp -f /etc/apt/sources.list /etc/apt/sources.list.backup \
    && sed -i "s@http://.*debian.org/debian@http://$MIRROR_DEBIAN/debian@g" /etc/apt/sources.list \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    locales tzdata file psmisc iputils-ping net-tools ca-certificates curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -x \
    && localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && localedef -c -i zh_CN -f UTF-8 zh_CN.UTF-8

ENV LANG=en_US.UTF-8

ENV PATH $PATH:.

CMD ["/bin/bash"]