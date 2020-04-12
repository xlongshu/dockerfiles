ARG FROM_IMG=alpine
ARG FROM_TAG=3.10
FROM longe/${FROM_IMG}:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

EXPOSE 8080

VOLUME /etc/v2ray

# --build-arg V2RAY_VERSION=
ARG V2RAY_VERSION

ENV V2RAY_VERSION=${V2RAY_VERSION}

RUN set -xe \
    && mkdir -p /etc/v2ray \
    && mkdir -p /usr/bin/v2ray \
    && mkdir -p /var/log/v2ray \
    && V2RAY_URL="https://cdn.jsdelivr.net/gh/v2ray/dist/v2ray-linux-64.zip" \
    && if [[ ${V2RAY_VERSION} ]]; then V2RAY_URL="https://cdn.jsdelivr.net/gh/v2ray/dist@${V2RAY_VERSION}/v2ray-linux-64.zip"; fi \
    && curl -fsSL "$V2RAY_URL" -o /tmp/v2ray.zip \
    && unzip /tmp/v2ray.zip -d /usr/bin/v2ray \
    && rm -rf /tmp/v2ray.zip

RUN set -xe \
    && WEBPROC_URL="https://github.com/jpillora/webproc/releases/download/v0.3.3/webproc_0.3.3_linux_amd64.gz" \
    && curl -fsSL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc


ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV PATH /usr/bin/v2ray:$PATH
ENV _PS1="docker-v2ray"

COPY config_server.json /etc/v2ray/config.json

CMD ["webproc", "-c", "/etc/v2ray/config.json", "--", "/usr/bin/v2ray/v2ray", "-config=/etc/v2ray/config.json"]
