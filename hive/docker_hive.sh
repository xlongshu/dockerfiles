#!/usr/bin/env bash

echo "======== os ========"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
elif [[ -f /etc/redhat-release ]]; then
  cat /etc/redhat-release
else
  cat /etc/issue
fi


export HIVE_DBTYPE=${HIVE_DBTYPE:-""}
export HIVE_HOME=${HIVE_HOME:-"/opt/hive"}
export HIVE_CONF_DIR=${HIVE_CONF_DIR:-"/etc/hive"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

set -e
set -o pipefail

echo "Init ${HIVE_CONF_DIR}"
cp -u ${HIVE_HOME}/conf/beeline-log4j2.properties.template ${HIVE_CONF_DIR}/beeline-log4j2.properties
cp -u ${HIVE_HOME}/conf/hive-exec-log4j2.properties.template ${HIVE_CONF_DIR}/hive-exec-log4j2.properties
cp -u ${HIVE_HOME}/conf/hive-log4j2.properties.template ${HIVE_CONF_DIR}/hive-log4j2.properties
cp -u ${HIVE_HOME}/conf/llap-daemon-log4j2.properties.template ${HIVE_CONF_DIR}/llap-daemon-log4j2.properties
cp -u ${HIVE_HOME}/conf/hive-env.sh.template ${HIVE_CONF_DIR}/hive-env.sh
cp -u ${HIVE_HOME}/conf/ivysettings.xml ${HIVE_CONF_DIR}/ivysettings.xml

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
# hive-site.xml
export HIVE_SITE_hive_metastore_uris=${HIVE_SITE_hive_metastore_uris:-"thrift://`hostname -f`:9083"}

hive_confs=(
${HIVE_CONF_DIR}/hive-site.xml
${HADOOP_CONF_DIR}/core-site.xml
${HADOOP_CONF_DIR}/hdfs-site.xml
${HADOOP_CONF_DIR}/httpfs-site.xml
${HADOOP_CONF_DIR}/kms-site.xml
${HADOOP_CONF_DIR}/mapred-site.xml
${HADOOP_CONF_DIR}/yarn-site.xml
)

for conf in "${hive_confs[@]}"; do
  /opt/env2conf.sh ${conf}
done

# init
/opt/init-hive-dfs.sh

mkdir -p /data/hive && cd /data/hive
# test
#if [[ ! -d /data/hive/metastore_db ]]; then
#  "$HIVE_HOME/bin/schematool" -initSchema -dbType derby
#fi
if [[ -n "${HIVE_DBTYPE}" ]]; then
  echo "initSchema: ${HIVE_DBTYPE}"
  "$HIVE_HOME/bin/schematool" -dbType ${HIVE_DBTYPE} -initSchema
fi

echo "Exec: [$*]"
case ${1} in
  daemon | runserver | startserver)
    nohup "$HIVE_HOME/bin/hive" --service metastore 1> /data/hive/hive_metastore.log 2>&1 &
    sleep 3
    nohup "$HIVE_HOME/bin/hive" --service hiveserver2 1> /data/hive/hiveserver.log 2>&1 &
    if [[ -n "$2" ]]; then
      shift 1
      exec "$@"
    else
      tail -n 200 -f /data/hive/hive_metastore.log /data/hive/hiveserver.log
    fi
  ;;
  beeline | cli | hiveserver2 | hiveserver | metastore | metatool | schemaTool)
    "$HIVE_HOME/bin/hive" --service $@
  ;;
  *)
    exec "$@"
  ;;
esac

