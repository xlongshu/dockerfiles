ARG FROM_IMG=java
ARG FROM_TAG=8
FROM longe/${FROM_IMG}:${FROM_TAG}

LABEL maintainer="xlongshu@163.com"

# NameNode (hdfs) 8020 50070
# DataNode (hdfs) 50010 50020 50075
# ResourceManager (yarn) 8030 8031 8032 8033 8088
# NodeManager (yarn) 8040 8042
# JobHistoryServer (mapred) 8188 10020 19888
#EXPOSE 50070 50075 8042 8088

VOLUME /data/hadoop

# --build-arg HADOOP_VERSION=3.1.3 --build-arg MIRROR_APACHE=http://mirrors.aliyun.com/apache
ARG HADOOP_VERSION
ARG MIRROR_APACHE="http://archive.apache.org/dist"

ENV HADOOP_VERSION=${HADOOP_VERSION:-"2.7.7"}
ENV HADOOP_INSTALL="/opt/hadoop-$HADOOP_VERSION"

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-client openssh-server telnet netcat tree libsnappy1v5 openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# configure SSH
RUN set -xe \
    && update-rc.d ssh defaults \
    && service ssh start && service ssh stop \
    && mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh \
    && ssh-keygen -q -N "" -t rsa -f $HOME/.ssh/id_rsa \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys \
    && chmod 600 $HOME/.ssh/authorized_keys
ADD ssh_config /root/.ssh/config

# add users
RUN set -xe \
    && useradd hadoop -m -s /bin/bash \
    && usermod root -aG hadoop \
    && for user in hdfs yarn mapred; do \
         #useradd ${user} -s /usr/sbin/nologin -G hadoop; \
         useradd ${user} -m -s /bin/bash -G hadoop; \
       done \
    && for user in hadoop hdfs yarn mapred; do \
         cp -R /root/.ssh /home/${user}; \
         chown ${user}:hadoop -R /home/${user}; \
       done


WORKDIR /opt/

#http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
#http://www.apache.org/dyn/closer.cgi?action=download&filename=hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_URL=$MIRROR_APACHE/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN set -x \
    && curl --silent --head $HADOOP_URL | head -n 1 | grep "200 OK" \
    && curl -fSL "$HADOOP_URL" -o hadoop-$HADOOP_VERSION.tar.gz \
    && tar -zxf hadoop-$HADOOP_VERSION.tar.gz -C /opt/ \
    && rm -f hadoop-$HADOOP_VERSION.tar.gz \
    && rm -rf $HADOOP_INSTALL/share/doc \
    && find $HADOOP_INSTALL -name "*.cmd" | xargs rm -rf \
    && find $HADOOP_INSTALL/share/hadoop -path "*/sources" | xargs rm -rf \
    && find $HADOOP_INSTALL/share/hadoop -name "*tests*.jar" | xargs rm -rf

# add local file
#ADD "hadoop-$HADOOP_VERSION.tar.gz" /opt/

# test hadoop
RUN set -eux; $HADOOP_INSTALL/bin/hadoop version; $HADOOP_INSTALL/bin/hadoop checknative

ENV USER=root
ENV HADOOP_HOME="/opt/hadoop" \
    HADOOP_CONF_DIR="/etc/hadoop" \
    HADOOP_DATA_DIR="/data/hadoop" \
    HADOOP_LOG_DIR="/data/hadoop/logs"

ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
ENV _PS1="docker-hadoop-$HADOOP_VERSION"

RUN set -xe \
    && ln -s $HADOOP_INSTALL $HADOOP_HOME \
    && rm -rf $HADOOP_HOME/share/doc \
    && mkdir /docker-entrypoint.d \
    && mkdir -p ${HADOOP_CONF_DIR} ${HADOOP_DATA_DIR}

#RUN sed -i "s:.*export JAVA_HOME=.*:JAVA_HOME=${JAVA_HOME}:g" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
RUN sed -i "/export JAVA_HOME/a\export JAVA_HOME=${JAVA_HOME}" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

COPY docker_hadoop.sh /docker_hadoop.sh
RUN chmod +x /docker_hadoop.sh

COPY shell/*.sh /opt/
RUN chmod +x /opt/*.sh

ENTRYPOINT ["/docker_hadoop.sh"]
CMD ["sshd"]
