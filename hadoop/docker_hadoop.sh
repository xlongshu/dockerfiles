#!/usr/bin/env bash

echo "======== os ========"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
elif [[ -f /etc/redhat-release ]]; then
  cat /etc/redhat-release
else
  cat /etc/issue
fi


export HADOOP_PREFIX=${HADOOP_PREFIX:-"/opt/hadoop"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native
export LD_LIBRARY_PATH=${HADOOP_COMMON_LIB_NATIVE_DIR}:${LD_LIBRARY_PATH}

set -e
set -o pipefail

echo "Init ${HADOOP_CONF_DIR}"
awk 'BEGIN { copy="cp -Ri ${HADOOP_PREFIX}/etc/hadoop/* ${HADOOP_CONF_DIR}/"; print "n" |copy; }'

## Set some sensible defaults
# core-site.xml
export CORE_SITE_fs_defaultFS=${CORE_SITE_fs_defaultFS:-"hdfs://`hostname -f`:8020/"}
export CORE_SITE_hadoop_tmp_dir=${CORE_SITE_hadoop_tmp_dir:-"/data/hadoop"}
export CORE_SITE_hadoop_proxyuser_root_hosts=${CORE_SITE_hadoop_proxyuser_root_hosts:-"*"}
export CORE_SITE_hadoop_proxyuser_root_groups=${CORE_SITE_hadoop_proxyuser_root_groups:-"*"}
# hdfs-site.xml
export HDFS_SITE_dfs_webhdfs_enabled=${HDFS_SITE_dfs_webhdfs_enabled:-"true"}
export HDFS_SITE_dfs_permissions_enabled=${HDFS_SITE_dfs_permissions_enabled:-"false"}
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
)

for conf in "${hadoop_confs[@]}"; do
  /opt/env2conf.sh ${conf}
done


source /opt/hadoopd.sh "--"

export RUN_SERVICE="$1"
echo "services: $RUN_SERVICE"
start_hadoops ${RUN_SERVICE}

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
