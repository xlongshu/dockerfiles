ARG FROM_TAG=2.7.7
FROM longe/hadoop:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

EXPOSE 10000 9083

VOLUME /data/hive

# --build-arg HIVE_VERSION=3.1.1 --build-arg MIRROR_APACHE=http://mirrors.aliyun.com/apache
ARG HIVE_VERSION="2.3.4"
ARG MIRROR_APACHE="http://archive.apache.org/dist"

WORKDIR /opt/

ENV HIVE_URL=$MIRROR_APACHE/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN set -x \
    && curl --silent --head $HIVE_URL | head -n 1 \
    && curl -fSL "$HIVE_URL" -o apache-hive-$HIVE_VERSION-bin.tar.gz \
    && tar -zxf apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ \
    && rm -f apache-hive-$HIVE_VERSION-bin.tar.gz

# add local file
#ADD "apache-hive-$HIVE_VERSION-bin.tar.gz" /opt/

ENV HIVE_PREFIX="/opt/apache-hive-$HIVE_VERSION-bin" \
    HIVE_HOME="/opt/hive" \
    HIVE_CONF_DIR="/etc/hive"

ENV PATH $HIVE_HOME/bin:$PATH
ENV _PS1="docker-hive-$HIVE_VERSION"

RUN set -xe \
    && ln -s $HIVE_PREFIX $HIVE_HOME \
    && mkdir -p $HIVE_CONF_DIR \
    && mkdir -p "/data/hive" \
    # download jdbc driver
    && curl -fSL "http://central.maven.org/maven2/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar" -o "${HIVE_HOME}/lib/postgresql-42.2.5.jar" \
    && curl -fSL "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.40/mysql-connector-java-5.1.40.jar" -o "${HIVE_HOME}/lib/mysql-connector-java-5.1.40.jar"

# test hadoop
RUN set -eux; $HADOOP_PREFIX/bin/hadoop version
# test hive
RUN set -eux; $HIVE_HOME/bin/hive --help

COPY docker_hive.sh /docker_hive.sh
RUN chmod +x /docker_hive.sh

COPY shell/*.sh /opt/
RUN chmod +x /opt/*.sh

ENTRYPOINT ["/docker_hive.sh"]
CMD ["daemon"]
