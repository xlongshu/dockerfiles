ARG FROM_TAG=18.04
FROM longe/ubuntu:${FROM_TAG}

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends sysvinit-utils systemd systemd-sysv runit python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# docker-systemctl-replacement
RUN set -xe \
    && if [[ -f /bin/systemctl ]]; then mv /bin/systemctl /bin/systemctl.bin; fi \
    && curl -fSL -o /bin/systemctl "https://rawcdn.githack.com/gdraheim/docker-systemctl-replacement/v1.4.3424/files/docker/systemctl.py" \
    && chmod +x /bin/systemctl

RUN (cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup.service | xargs rm -f $1); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN systemctl set-default multi-user.target || true


CMD ["/bin/systemctl"]
