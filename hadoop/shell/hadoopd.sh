#!/usr/bin/env bash
# hadoopd.sh

HADOOP_PREFIX=${HADOOP_PREFIX:-"/opt/hadoop"}
HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

# hdfs namenode -format
# hadoop-daemon.sh start <namenode|secondarynamenode|datanode|journalnode|dfs|dfsadmin|fsck|balancer|zkfc>
# yarn-daemon.sh start <resourcemanager|nodemanager|proxyserver|timelineserver>

hadoop_daemon() {
  local startStop=$1
  local name=$2
  [[ -z ${name} ]] && return 1

  echo "Exec $startStop $name"
  case ${name} in
    sshd)
      echo "Start sshd"
      /usr/sbin/sshd
    ;;
    historyserver)
      "$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh" "$startStop" historyserver
    ;;
    resourcemanager | nodemanager | proxyserver | timelineserver)
      "$HADOOP_PREFIX/sbin/yarn-daemon.sh" "$startStop" "$name"
    ;;
    namenode | secondarynamenode | datanode | journalnode | dfs | dfsadmin | fsck | balancer | zkfc)
      if [[ "namenode" == "$name" ]]; then
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
    hdfs namenode -format
  fi
}

start_hadoops() {
  local services=( ${1//,/ } )
  for name in "${services[@]}"; do
    [[ -n ${name} ]] && hadoop_daemon start "$name"
  done
}

stop_hadoops() {
  local services=( ${1//,/ } )
  for name in "${services[@]}"; do
    [[ -n ${name} ]] && hadoop_daemon stop "$name"
  done
}


# hadoopd.sh (start|stop) <hadoop-command>
# hadoopd.sh start namenode,datanode,resourcemanager,nodemanager
if [[ $# -gt 1 ]] && [[ "$1" == "start" || "$1" == "stop" ]]; then
  $1_hadoops $2
else
  echo "Usage: hadoopd.sh (start|stop) <hadoop-command>"
fi
