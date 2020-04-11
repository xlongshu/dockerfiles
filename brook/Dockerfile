ARG FROM_IMG=alpine
ARG FROM_TAG=3.10
FROM longe/${FROM_IMG}:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# --build-arg BROOK_VERSION=v20200201
ARG BROOK_VERSION
ENV BROOK_VERSION=${BROOK_VERSION}

RUN set -xe \
    && BROOK_URL="https://github.com/txthinking/brook/releases/latest/download/brook" \
    && if [[ ${BROOK_VERSION} ]]; then BROOK_URL="https://github.com/txthinking/brook/releases/download/${BROOK_VERSION}/brook"; fi \
    && curl -fsSL "$BROOK_URL" -o /usr/local/bin/brook \
    && chmod +x /usr/local/bin/brook

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV _PS1="docker-brook"

ENV ARGS="wsserver -l :6080 -p brook123456"

#EXPOSE 6060
EXPOSE 6080

CMD brook ${ARGS}
