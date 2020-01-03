#!/usr/bin/env bash

echo "======== os ========"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
elif [[ -f /etc/redhat-release ]]; then
  cat /etc/redhat-release
else
  cat /etc/issue
fi

export HADOOP_VERSION=${HADOOP_VERSION:-"2.7.x"}
export HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}
export HADOOP_DATA_DIR=${HADOOP_DATA_DIR:-"/data/hadoop"}

echo "Init HADOOP_CONF_DIR=${HADOOP_CONF_DIR}"
mkdir -p "${HADOOP_CONF_DIR}"
cp -Ru ${HADOOP_HOME}/etc/hadoop/* ${HADOOP_CONF_DIR}/
echo "Init HADOOP_DATA_DIR=${HADOOP_DATA_DIR}"
mkdir -p ${HADOOP_DATA_DIR}/logs ${HADOOP_DATA_DIR}/dfs ${HADOOP_DATA_DIR}/yarn ${HADOOP_DATA_DIR}/mapred
ln -sf ${HADOOP_DATA_DIR}/logs ${HADOOP_HOME}/logs
chgrp -R hadoop ${HADOOP_DATA_DIR}
chmod g+rw -R ${HADOOP_DATA_DIR}

set -e
set -o pipefail

## Set some sensible defaults
# core-site.xml
export CORE_SITE_fs_defaultFS=${CORE_SITE_fs_defaultFS:-"hdfs://$(hostname -f):8020"}
export CORE_SITE_hadoop_tmp_dir=${CORE_SITE_hadoop_tmp_dir:-"/data/hadoop"}
export CORE_SITE_hadoop_proxyuser_root_hosts=${CORE_SITE_hadoop_proxyuser_root_hosts:-"*"}
export CORE_SITE_hadoop_proxyuser_root_groups=${CORE_SITE_hadoop_proxyuser_root_groups:-"*"}
# hdfs-site.xml
export HDFS_SITE_dfs_replication=${HDFS_SITE_dfs_replication:-"1"}
export HDFS_SITE_dfs_webhdfs_enabled=${HDFS_SITE_dfs_webhdfs_enabled:-"true"}
export HDFS_SITE_dfs_permissions_enabled=${HDFS_SITE_dfs_permissions_enabled:-"true"}
export HDFS_SITE_dfs_permissions_superusergroup=${HDFS_SITE_dfs_permissions_superusergroup:-"hadoop"}
export HDFS_SITE_dfs_namenode_rpc___bind___host=${HDFS_SITE_dfs_namenode_rpc___bind___host:-"0.0.0.0"}
export HDFS_SITE_dfs_namenode_servicerpc___bind___host=${HDFS_SITE_dfs_namenode_servicerpc___bind___host:-"0.0.0.0"}
export HDFS_SITE_dfs_namenode_http___bind___host=${HDFS_SITE_dfs_namenode_http___bind___host:-"0.0.0.0"}
export HDFS_SITE_dfs_namenode_https___bind___host=${HDFS_SITE_dfs_namenode_https___bind___host:-"0.0.0.0"}
# mapred-site.xml
export MAPRED_SITE_mapreduce_framework_name=${MAPRED_SITE_mapreduce_framework_name:-"yarn"}
# yarn-site.xml
export YARN_SITE_yarn_nodemanager_aux___services=${YARN_SITE_yarn_nodemanager_aux___services:-"mapreduce_shuffle"}
export YARN_SITE_yarn_nodemanager_bind___host=${YARN_SITE_yarn_nodemanager_bind___host:-"0.0.0.0"}
export YARN_SITE_yarn_resourcemanager_bind___host=${YARN_SITE_yarn_resourcemanager_bind___host:-"0.0.0.0"}
export YARN_SITE_yarn_timeline___service_bind___host=${YARN_SITE_yarn_timeline___service_bind___host:-"0.0.0.0"}

hadoop_confs=(
${HADOOP_CONF_DIR}/core-site.xml
${HADOOP_CONF_DIR}/hdfs-site.xml
${HADOOP_CONF_DIR}/httpfs-site.xml
${HADOOP_CONF_DIR}/kms-site.xml
${HADOOP_CONF_DIR}/mapred-site.xml
${HADOOP_CONF_DIR}/yarn-site.xml
${HADOOP_CONF_DIR}/hadoop-policy.xml
${HADOOP_CONF_DIR}/capacity-scheduler.xml
${HADOOP_CONF_DIR}/container-executor.cfg
${HADOOP_CONF_DIR}/hadoop-metrics2.properties
)

for conf in "${hadoop_confs[@]}"; do
  /opt/env2conf.sh ${conf}
done

if [[ ${HADOOP_VERSION} =~ ^3 ]]; then
  export HDFS_NAMENODE_USER=${HDFS_NAMENODE_USER:-"root"}
  export HDFS_DATANODE_USER=${HDFS_DATANODE_USER:-"root"}
  export HDFS_SECONDARYNAMENODE_USER=${HDFS_SECONDARYNAMENODE_USER:-"root"}
  #export HDFS_DATANODE_SECURE_USER=${HDFS_DATANODE_SECURE_USER:-"hdfs"}
  export YARN_RESOURCEMANAGER_USER=${YARN_RESOURCEMANAGER_USER:-"root"}
  export YARN_NODEMANAGER_USER=${YARN_NODEMANAGER_USER:-"root"}
  # hadoop log dir
  export HADOOP_LOG_DIR=${HADOOP_LOG_DIR:-${HADOOP_DATA_DIR}/logs}
  unset YARN_LOG_DIR
  unset HADOOP_MAPRED_LOG_DIR
  # 3.x HADOOP_SLAVE_NAMES has been replaced by HADOOP_WORKER_NAMES
  if [[ -n ${HADOOP_SLAVE_NAMES} ]]; then
    export HADOOP_WORKER_NAMES=${HADOOP_SLAVE_NAMES}
    unset HADOOP_SLAVE_NAMES
  fi
else
  # hadoop log dir
  export HADOOP_LOG_DIR=${HADOOP_LOG_DIR:-${HADOOP_DATA_DIR}/logs}
  export YARN_LOG_DIR=${YARN_LOG_DIR:-${HADOOP_DATA_DIR}/logs}
  export HADOOP_MAPRED_LOG_DIR=${HADOOP_MAPRED_LOG_DIR:-${HADOOP_DATA_DIR}/logs}
fi

env | grep -E '^(JAVA|HADOOP_|HDFS_|YARN_)'  \
 | grep -v 'HDFS_SITE_\|YARN_SITE_'  \
 | sed 's/^/export /g'  \
 > /etc/profile.d/export_hadoop.sh
echo "PATH=$PATH:\$PATH" >> /etc/profile.d/export_hadoop.sh


source /opt/hadoopd.sh "--"
source /opt/wait_until.sh

echo "Waiting services:[${WAIT_UNTIL_SERVER}] ..."
for ws in ${WAIT_UNTIL_SERVER[@]}; do
  wait_until_server ${ws}
  sleep 1
done

# run /docker-entrypoint.d/*.sh
if [[ -d /docker-entrypoint.d ]]; then
  for f in $(find /docker-entrypoint.d -type f -name "*.sh"); do
    echo "running $f";
    . "$f"
  done
  unset f
fi


set -e
export RUN_SERVICE="$1"
echo "services: $RUN_SERVICE"
start_hadoops "${RUN_SERVICE}"

sleep 2
echo "======== jps ========"
jps -l

shift 1
echo "Exec: [$*]"
if [[ -z $1 ]]; then
  /bin/bash
else
  exec "$@"
fi
