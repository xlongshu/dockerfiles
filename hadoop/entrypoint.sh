#!/usr/bin/env bash

export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native
export LD_LIBRARY_PATH=${HADOOP_COMMON_LIB_NATIVE_DIR}:${LD_LIBRARY_PATH}

echo "Init ${HADOOP_CONF_DIR}"
awk 'BEGIN { copy="cp -Ri ${HADOOP_PREFIX}/etc/hadoop/* ${HADOOP_CONF_DIR}/"; print "n" |copy; }'

set -eo pipefail

source /opt/hadoopd.sh

export RUN_SERVICE="$1"
echo "services: $RUN_SERVICE"
start_hadoops "$RUN_SERVICE"

sleep 2
netstat -lntup
/bin/bash

#shift 1
#echo "Exec: [$*]"
#if [[ -n $1 ]]; then
#  /bin/bash
#else
#  exec "$@"
#fi
