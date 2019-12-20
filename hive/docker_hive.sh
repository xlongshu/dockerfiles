#!/usr/bin/env bash

echo "======== os ========"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
elif [[ -f /etc/redhat-release ]]; then
  cat /etc/redhat-release
else
  cat /etc/issue
fi

# hive metastore derby|mysql|postgres
export HIVE_DBTYPE=${HIVE_DBTYPE:-"derby"}
export HIVE_HOME=${HIVE_HOME:-"/opt/hive"}
export HIVE_CONF_DIR=${HIVE_CONF_DIR:-"/etc/hive"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

set -e
set -o pipefail

echo "Init ${HIVE_CONF_DIR}"
mkdir -p "${HIVE_CONF_DIR}" "${HADOOP_CONF_DIR}"
for conf in $(ls -1 ${HIVE_HOME}/conf/*.properties.template); do
  cp -u ${conf} ${conf%.*}
done
cp -u ${HIVE_HOME}/conf/*.properties ${HIVE_CONF_DIR}/
cp -u ${HIVE_HOME}/conf/hive-env.sh.template ${HIVE_CONF_DIR}/hive-env.sh
cp -u ${HIVE_HOME}/conf/ivysettings.xml ${HIVE_CONF_DIR}/ivysettings.xml

## Set some sensible defaults
# core-site.xml
export CORE_SITE_fs_defaultFS=${CORE_SITE_fs_defaultFS:-"hdfs://$(hostname -f):8020/"}
export CORE_SITE_hadoop_proxyuser_root_hosts=${CORE_SITE_hadoop_proxyuser_root_hosts:-"*"}
export CORE_SITE_hadoop_proxyuser_root_groups=${CORE_SITE_hadoop_proxyuser_root_groups:-"*"}
# hdfs-site.xml
#export HDFS_SITE_dfs_webhdfs_enabled=${HDFS_SITE_dfs_webhdfs_enabled:-"true"}
#export HDFS_SITE_dfs_permissions_enabled=${HDFS_SITE_dfs_permissions_enabled:-"false"}
#export HDFS_SITE_dfs_namenode_rpc___bind___host=${HDFS_SITE_dfs_namenode_rpc___bind___host:-"0.0.0.0"}
#export HDFS_SITE_dfs_namenode_servicerpc___bind___host=${HDFS_SITE_dfs_namenode_servicerpc___bind___host:-"0.0.0.0"}
#export HDFS_SITE_dfs_namenode_http___bind___host=${HDFS_SITE_dfs_namenode_http___bind___host:-"0.0.0.0"}
#export HDFS_SITE_dfs_namenode_https___bind___host=${HDFS_SITE_dfs_namenode_https___bind___host:-"0.0.0.0"}
# mapred-site.xml
#export MAPRED_SITE_mapreduce_framework_name=${MAPRED_SITE_mapreduce_framework_name:-"yarn"}
# yarn-site.xml
#export YARN_SITE_yarn_nodemanager_aux___services=${YARN_SITE_yarn_nodemanager_aux___services:-"mapreduce_shuffle"}
#export YARN_SITE_yarn_nodemanager_bind___host=${YARN_SITE_yarn_nodemanager_bind___host:-"0.0.0.0"}
#export YARN_SITE_yarn_resourcemanager_bind___host=${YARN_SITE_yarn_resourcemanager_bind___host:-"0.0.0.0"}
#export YARN_SITE_yarn_timeline___service_bind___host=${YARN_SITE_yarn_timeline___service_bind___host:-"0.0.0.0"}
# hive-site.xml
export HIVE_SITE_hive_metastore_uris=${HIVE_SITE_hive_metastore_uris:-"thrift://$(hostname -f):9083"}
export HIVE_SITE_hive_metastore_warehouse_dir=${HIVE_SITE_hive_metastore_warehouse_dir:-"/user/hive/warehouse"}
export HIVE_SITE_hive_exec_scratchdir=${HIVE_SITE_hive_exec_scratchdir:-"/tmp/hive"}

hive_confs=(
${HIVE_CONF_DIR}/hive-site.xml
${HIVE_CONF_DIR}/beeline-site.xml
${HIVE_CONF_DIR}/beeline-hs2-connection.xml
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


source /opt/wait_until.sh

echo "Waiting services:[${WAIT_UNTIL_SERVER}] ..."
for ws in ${WAIT_UNTIL_SERVER[@]}; do
  wait_until_server ${ws}
done


# init
WAREHOUSE_DIR=${HIVE_SITE_hive_metastore_warehouse_dir}
TMP_DIR=${HIVE_SITE_hive_exec_scratchdir}
#init-hive-dfs.sh --warehouse-dir ${WAREHOUSE_DIR} --tmp-dir ${TMP_DIR}
#hadoop fs -mkdir -p   ${WAREHOUSE_DIR} ${TMP_DIR}
#hadoop fs -chmod g+w  ${WAREHOUSE_DIR} ${TMP_DIR}
echo "Creating directory warehouse-dir=[${WAREHOUSE_DIR}], tmp-dir=[${TMP_DIR}] ..."
hadoop fs -test -d ${WAREHOUSE_DIR} || hadoop fs -mkdir -p ${WAREHOUSE_DIR}
hadoop fs -test -e ${WAREHOUSE_DIR} && hadoop fs -chmod g+w ${WAREHOUSE_DIR}
hadoop fs -test -d ${TMP_DIR} || hadoop fs -mkdir -p ${TMP_DIR}
hadoop fs -test -e ${TMP_DIR} && hadoop fs -chmod +w ${TMP_DIR}


function test_metastore_db() {
  local dbType=${1:-"derby"}
  "$HIVE_HOME/bin/schematool" -dbType "${dbType}" -info > /dev/null 2>&1
  echo $?
}

function init_metastore() {
  if [[ 0 -ne $(test_metastore_db "${HIVE_DBTYPE}") ]]; then
    echo "initSchema: ${HIVE_DBTYPE} ..."
    "$HIVE_HOME/bin/schematool" -dbType "${HIVE_DBTYPE}" -initSchema
  fi
}


mkdir -p /data/hive && cd /data/hive
mkdir -p "/tmp/$(id -un)" && touch "/tmp/$(id -un)/hive.log"

echo "Exec: [$*]"
case ${1} in
  daemon | runserver | startserver)
    init_metastore
    nohup "$HIVE_HOME/bin/hive" --service metastore 1>> hive_metastore.log 2>&1 &
    sleep 2
    wait_until 0.0.0.0 9083
    nohup "$HIVE_HOME/bin/hive" --service hiveserver2 1>> hiveserver.log 2>&1 &
    if [[ -n "$2" ]]; then
      shift 1
      exec "$@"
    else
      tail -n 600 -f hive_metastore.log hiveserver.log "/tmp/$(id -un)/hive.log"
    fi
  ;;
  hiveserver2)
    nohup "$HIVE_HOME/bin/hive" --service hiveserver2 1>> hiveserver.log 2>&1 &
    tail -n 400 -f hiveserver.log "/tmp/$(id -un)/hive.log"
  ;;
  metastore)
    init_metastore
    nohup "$HIVE_HOME/bin/hive" --service metastore 1>> hive_metastore.log 2>&1 &
    tail -n 400 -f hive_metastore.log "/tmp/$(id -un)/hive.log"
  ;;
  beeline | cli | metatool | schemaTool)
    "$HIVE_HOME/bin/hive" --service "$@"
  ;;
  *)
    exec "$@"
  ;;
esac

