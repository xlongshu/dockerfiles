ARG FROM_TAG=2.7.7
FROM longe/hadoop:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

EXPOSE 10000 9083

VOLUME /data/hive

# --build-arg HIVE_VERSION=3.1.1 --build-arg MIRROR_APACHE=http://mirrors.aliyun.com/apache
ARG HIVE_VERSION
ARG MIRROR_APACHE="http://archive.apache.org/dist"

ENV HIVE_VERSION=${HIVE_VERSION:-"2.3.4"}
ENV HIVE_INSTALL="/opt/apache-hive-$HIVE_VERSION-bin"

WORKDIR /opt/

#http://www.apache.org/dyn/closer.cgi/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
#http://www.apache.org/dyn/closer.cgi?action=download&filename=hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN set -x \
    && HIVE_URL="$MIRROR_APACHE/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" \
    && curl --silent --head $HIVE_URL | head -n 1 | grep "200 OK" \
    && curl -fSL "$HIVE_URL" -o apache-hive-$HIVE_VERSION-bin.tar.gz \
    && tar -zxf apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ \
    && rm -f apache-hive-$HIVE_VERSION-bin.tar.gz

# add local file
#ADD "apache-hive-$HIVE_VERSION-bin.tar.gz" /opt/

# test hadoop
RUN set -eux; $HADOOP_INSTALL/bin/hadoop version
# test hive
RUN set -eux; $HIVE_INSTALL/bin/hive --help

ENV HIVE_HOME="/opt/hive" \
    HIVE_CONF_DIR="/etc/hive"

ENV PATH $HIVE_HOME/bin:$PATH
ENV _PS1="docker-hive-$HIVE_VERSION"

RUN set -xe \
    && ln -s $HIVE_INSTALL $HIVE_HOME \
    && mkdir -p $HIVE_CONF_DIR \
    # download jdbc driver
    && curl -fSL "http://central.maven.org/maven2/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar" -o "${HIVE_HOME}/lib/postgresql-42.2.5.jar" \
    && curl -fSL "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.40/mysql-connector-java-5.1.40.jar" -o "${HIVE_HOME}/lib/mysql-connector-java-5.1.40.jar" \
    && curl -fSL "http://central.maven.org/maven2/org/apache/derby/derbyclient/10.12.1.1/derbyclient-10.12.1.1.jar" -o "${HIVE_HOME}/lib/derbyclient-10.12.1.1.jar"


COPY docker_hive.sh /docker_hive.sh
RUN chmod +x /docker_hive.sh

COPY shell/*.sh /opt/
RUN chmod +x /opt/*.sh

ENTRYPOINT ["/docker_hive.sh"]
CMD ["daemon"]
