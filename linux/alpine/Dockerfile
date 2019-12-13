ARG FROM_TAG=3.10
FROM alpine:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# --build-arg MIRROR_ALPINE=mirrors.aliyun.com
ARG MIRROR_ALPINE=""

RUN set -xe \
    && if [[ ${MIRROR_ALPINE} ]]; then sed -i "s@dl-cdn.alpinelinux.org@${MIRROR_ALPINE}@g" /etc/apk/repositories; fi \
    && apk update && apk upgrade \
    && apk add tzdata file tree procps ca-certificates curl busybox-extras \
    && rm -rf /var/cache/apk/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG=en_US.UTF-8

ENV PATH $PATH:.
ENV _PS1="docker-alpine"
ENV PS1='[\u@\h:\w]\$ '

# configure
RUN set -xe \
    && echo "root:`date -R|sha256sum|base64|head -c 12`" | chpasswd \
    && echo 'set completion-ignore-case on' >> $HOME/.inputrc \
    && echo 'set show-all-if-ambiguous on' >> $HOME/.inputrc \
    && echo '[ -f $HOME/shell_env.sh ] && source $HOME/shell_env.sh' >> $HOME/.bashrc

ADD shell_env.sh /root/

CMD ["/bin/sh"]
