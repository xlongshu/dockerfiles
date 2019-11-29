#!/usr/bin/env bash
# hadoopd.sh

HADOOP_PREFIX=${HADOOP_PREFIX:-"/opt/hadoop"}

set -e
#set -o pipefail

# hdfs namenode -format
# hadoop-daemon.sh start <namenode|secondarynamenode|datanode|journalnode|dfs|dfsadmin|fsck|balancer|zkfc>
# yarn-daemon.sh start <resourcemanager|nodemanager>

hadoop_daemon() {
  local startStop=$1
  local name=$2
  [[ -z ${name} ]] && return 1

  echo "Exec $startStop $name"
  case ${name} in
  sshd)
    echo "Start ssh"
    /usr/sbin/sshd
    ;;
  resourcemanager | nodemanager)
    "$HADOOP_PREFIX/sbin/yarn-daemon.sh" "$startStop" "$name"
    ;;
  historyserver)
    "$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh" "$startStop" historyserver
    ;;
  *)
    if [[ "namenode" == "$name" ]]; then
      echo "format_namenode..."
      hadoop_format_namenode
    fi
    "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" "$startStop" "$name"
    ;;
  esac
}

hadoop_format_namenode() {
  namenode_dir=$(hdfs getconf -confKey dfs.namenode.name.dir)
  namenode_dir=${namenode_dir#file://*}
  if [[ ! -e "${namenode_dir}/current/VERSION" ]]; then
    echo "Formatting namenode name directory: $namenode_dir"
    # -format -force
    #hdfs namenode -format
  fi
}

start_hadoops() {
  local services=("${1//,/ }")
  for name in "${services[@]}"; do
    [[ -n ${name} ]] && hadoop_daemon start "$name"
  done
}

stop_hadoops() {
  local services=("${1//,/ }")
  for name in "${services[@]}"; do
    [[ -n ${name} ]] && hadoop_daemon stop "$name"
  done
}

#export RUN_SERVICE="$1"
#echo "services: $RUN_SERVICE"
#start_hadoops "$RUN_SERVICE"

# sleep 1

# shift 1
# echo "Exec: [$*]"
# if [[ "$1" == "" ]]; then
#   /bin/bash
# else
#   exec "$@"
# fi

# start_hadoops namenode,datanode,resourcemanager,nodemanager
