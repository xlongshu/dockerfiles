#!/usr/bin/env bash

# hadoopd.sh

HADOOP_VERSION=${HADOOP_VERSION:-"2.7.x"}
HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}
HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}
HADOOP_HDFS_INIT=${HADOOP_HDFS_INIT:-"hdfs dfs -ls /"}

if [[ ${HADOOP_VERSION} =~ ^3 ]]; then
  HDFS_DAEMON_CMD="hdfs --daemon"
  YARN_DAEMON_CMD="yarn --daemon"
else
  HDFS_DAEMON_CMD="$HADOOP_HOME/sbin/hadoop-daemon.sh"
  YARN_DAEMON_CMD="$HADOOP_HOME/sbin/yarn-daemon.sh"
fi

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
      "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh" "$startStop" historyserver
    ;;
    resourcemanager | nodemanager | proxyserver | timelineserver)
      ${YARN_DAEMON_CMD} "$startStop" "$name"
    ;;
    namenode | secondarynamenode | datanode | journalnode | dfs | dfsadmin | fsck | balancer | zkfc)
      if [[ "namenode" == "$name" ]]; then
        hadoop_format_namenode
      fi
      ${HDFS_DAEMON_CMD} "$startStop" "$name"
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

hadoop_dfs_init() {
  set +o pipefail
  echo "Init dfs ..."
  local address=$(hdfs getconf -confKey fs.defaultFS)
  local hostname=$(echo "${address}" | awk -F'[/:]' '{print $4}')
  local port=$(echo "${address}" | awk -F'[/:]' '{print $5}')
  local result=1
  for i in $(seq 30); do
    echo "Waiting namenode ${address} up ... with retry count: ${i}"
    if command -v nc > /dev/null; then
      echo "Checking nc ${hostname} ${port} ..."
      result=$(nc -z -w 2 ${hostname} ${port} && echo 0 || echo 1)
    elif command -v telnet > /dev/null; then
      echo "Checking telnet ${hostname} ${port} ..."
      result=$(echo quit | timeout 2 telnet ${hostname} ${port} 2>&1 | grep -q Connected && echo 0 || echo 1)
    fi
    if [[ ${result} -eq 0 ]]; then
      echo "namenode ${address} is available."
      break
    fi
    sleep 2
  done
  echo "Creating directory /tmp ..."
  hadoop fs -test -d /tmp/init || hadoop fs -mkdir -p /tmp/init
  hadoop fs -test -e /tmp && hadoop fs -chmod 777 /tmp
  if [[ -n ${HADOOP_HDFS_INIT} ]]; then
    echo "exec HADOOP_HDFS_INIT:[${HADOOP_HDFS_INIT}]"
    eval "${HADOOP_HDFS_INIT}"
  fi
}

start_hadoops() {
  local services=( ${1//,/ } )
  for name in "${services[@]}"; do
    [[ -n ${name} ]] && hadoop_daemon start "$name"
    if [[ "namenode" == "$name" ]]; then
      hadoop_dfs_init &
    fi
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
if [[ $# -gt 1 && "$1" != "--" ]]; then
  if [[ "$1" == "start" || "$1" == "stop" ]]; then
    $1_hadoops "$2"
  else
    echo "Usage: hadoopd.sh (start|stop) <hadoop-command>"
  fi
fi
