ARG FROM_TAG=10
FROM debian:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# --build-arg MIRROR_DEBIAN=mirrors.aliyun.com
ARG MIRROR_DEBIAN
ENV MIRROR_DEBIAN=$MIRROR_DEBIAN

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -xe; \
    if [ ${MIRROR_DEBIAN} ]; then \
        cp -f /etc/apt/sources.list /etc/apt/sources.list.backup; \
        sed -i "s@http://.*debian.org/debian@http://${MIRROR_DEBIAN}/debian@g" /etc/apt/sources.list; \
    fi \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && if ! command -v gpg > /dev/null; then apt-get install -y --no-install-recommends gnupg dirmngr; fi \
    && apt-get install -y --no-install-recommends \
    locales tzdata file tree procps psmisc iputils-ping net-tools ca-certificates curl netbase telnet unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && localedef -c -i zh_CN -f UTF-8 zh_CN.UTF-8

ENV LANG=en_US.UTF-8

ENV PATH $PATH:.
ENV _PS1="docker-debian"

# configure
RUN set -xe \
    && echo 'set completion-ignore-case on' >> $HOME/.inputrc \
    && echo 'set show-all-if-ambiguous on' >> $HOME/.inputrc \
    && echo '[ -f $HOME/.shell_env ] && source $HOME/.shell_env' >> $HOME/.bashrc

RUN set -xe \
    && curl -fsSL -o /root/.shell_env "https://raw.fastgit.org/xlongshu/dockerfiles/master/linux/shell_env.sh" \
    && curl -fsSL -o /usr/sbin/noone "https://raw.fastgit.org/xlongshu/dockerfiles/master/linux/noone.sh" \
    && chmod +x /usr/sbin/noone
