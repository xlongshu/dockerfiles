ARG FROM_TAG=3.10
FROM alpine:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# --build-arg MIRROR_ALPINE=mirrors.ustc.edu.cn
ARG MIRROR_ALPINE="mirrors.aliyun.com"

RUN set -xe \
    && sed -i "s@dl-cdn.alpinelinux.org@$MIRROR_ALPINE@g" /etc/apk/repositories \
    && apk update && apk upgrade \
    && apk add tzdata procps file ca-certificates curl \
    && rm -rf /var/cache/apk/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG=en_US.UTF-8

ENV PATH $PATH:.

# configure
RUN set -xe \
    && echo "root:`date -R|sha256sum|base64|head -c 12`" | chpasswd \
    && echo $'\
export PS1=\'[\u@\h \w]\\$ \'\n\
alias ll="ls -alF"\n\
alias la="ls -A"\n\
alias l="ls -CF"\n'\
>> $HOME/.bashrc


CMD ["/bin/sh"]
