FROM longe/java:8

LABEL version="1.0"
LABEL maintainer="xlongshu@163.com"

EXPOSE 22
# NameNode (hdfs)
EXPOSE 8020 50070
# DataNode (hdfs)
EXPOSE 50010 50020 50075
# ResourceManager (yarn)
EXPOSE 8030 8031 8032 8033 8088
# NodeManager (yarn)
EXPOSE 8040 8042
# JobHistoryServer (mapred)
EXPOSE 10020 19888

# --build-arg HADOOP_VERSION=3.1.2 DL_SERVER=http://mirrors.aliyun.com/apache
ARG HADOOP_VERSION="2.7.7"
#ARG DL_SERVER="http://archive.apache.org/dist"

# add local file
ADD "hadoop-$HADOOP_VERSION.tar.gz" /opt/

#ENV HADOOP_URL=$DL_SERVER/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
#RUN set -x \
#    && curl --silent --head $HADOOP_URL | head -n 1
#    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
#    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
#    && rm /tmp/hadoop.tar.gz*

#RUN echo \
#deb http://mirrors.aliyun.com/debian/ stretch main contrib non-free\
#deb http://mirrors.aliyun.com/debian/ stretch-updates main contrib non-free\
#deb http://mirrors.aliyun.com/debian/ stretch-backports main contrib non-free\
#deb http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free\
#> /etc/apt/sources.list

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-server xmlstarlet \
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

ENV USER=root
ENV HADOOP_PREFIX="/opt/hadoop-$HADOOP_VERSION" \
    YARN_CONF_DIR="${HADOOP_CONF_DIR}" \
    HADOOP_CONF_DIR="/etc/hadoop" \
    HADOOP_HOME="/opt/hadoop" \
    HADOOP_DATA_PREFIX="/data/hadoop"

ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

RUN set -xe \
    && ln -s $HADOOP_PREFIX $HADOOP_HOME \
    && rm -rf $HADOOP_PREFIX/share/doc \
    && mkdir -p $HADOOP_CONF_DIR $HADOOP_HOME/logs $HADOOP_DATA_PREFIX
RUN cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml
RUN sed -i 's@${JAVA_HOME}@'/usr/lib/jvm/default-jvm'@g' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
#RUN sed -i "/^export JAVA_HOME/ s:.*:export JAVA_HOME=${JAVA_HOME}:" ${HADOOP_CONF_DIR}/hadoop-env.sh

COPY hadoopd.sh /opt/hadoopd.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /opt/hadoopd.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sshd"]
