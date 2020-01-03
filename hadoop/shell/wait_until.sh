#!/usr/bin/env bash

check_port() {
  set +o pipefail
  local hostname=${1?}
  local port=${2?}
  local wait_sec=${3:-2}

  if command -v nc > /dev/null; then
    #nc -z -w ${wait_sec} ${hostname} ${port} && echo 0 || echo 1
    nc -z -w ${wait_sec} ${hostname} ${port}
  elif command -v telnet > /dev/null; then
    #echo quit | timeout ${wait_sec} telnet ${hostname} ${port} 2>&1 | grep -q Connected && echo 0 || echo 1
    echo quit | timeout ${wait_sec} telnet ${hostname} ${port} 2>&1 | grep -q Connected
  else
    echo "telnet or nc not found ! [apt install netcat] or [yum install nmap-ncat]"
    exit 126
  fi

  local result=$?
  echo ${result}
  return ${result}
}


wait_until() {
  set +e
  local hostname=${1?}
  local port=${2?}
  local quit=${3:-0}
  local max_try=${4:-45}
  local retry_sec=${5:-4}

  local count=1
  local result=$(check_port ${hostname} ${port})

  until [[ ${result} -eq 0 ]]; do
    echo "[$count/$max_try] Waiting until ${hostname} ${port} up ..."
    if [[ ${max_try} -eq ${count} ]]; then
      echo "Giving up after ${max_try} tries, ${hostname} ${port} is still not available!"
      [[ 1 -eq ${quit} ]] && exit 1
      break
    fi

    echo "[$count/$max_try] try in ${retry_sec}s once again ..."
    let count++
    sleep ${retry_sec}
    result=$(check_port ${hostname} ${port})
  done

  [[ ${result} -eq 0 ]] && echo "[$count/$max_try] ${hostname}:${port} is available."
  sleep 1
}


wait_until_server() {
  local serviceport=$1
  local service=${serviceport%%:*}
  local port=${serviceport#*:}
  local quit=${2:-1}
  local max_try=${3:-45}
  local retry_sec=${4:-4}

  wait_until ${service} ${port} ${quit} ${max_try} ${retry_sec}
}
