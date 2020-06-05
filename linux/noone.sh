#!/bin/sh

: "${NO1_LOG_PATH:="/var/log/noone"}"
: "${NO1_RUN_PATH:="/var/run/noone"}"
: "${NO1_COMMAND:=""}"

mkdir -p ${NO1_LOG_PATH} ${NO1_RUN_PATH}

do_start() {
  RUN_BIN=$1
  BIN_NAME=$(basename "$RUN_BIN")
  shift 1
  touch "${NO1_LOG_PATH}/${BIN_NAME}.out" "${NO1_LOG_PATH}/${BIN_NAME}.err"
  #nohup ${RUN_BIN} 1>>"${BIN_NAME}.log" 2>&1 &
  nohup "${RUN_BIN}" "$@" 1>>"${NO1_LOG_PATH}/${BIN_NAME}.out" 2>>"${NO1_LOG_PATH}/${BIN_NAME}.err" &
  #setsid "${RUN_BIN}" "$@" 1>>"${NO1_LOG_PATH}/${BIN_NAME}.out" 2>>"${NO1_LOG_PATH}/${BIN_NAME}.err"
  echo $! >"${NO1_RUN_PATH}/${BIN_NAME}.pid"
  echo "Log: ${NO1_LOG_PATH}/${BIN_NAME}.out ${NO1_LOG_PATH}/${BIN_NAME}.err"
}

do_run() {
  do_start "$@"
  RUN_BIN=$1
  BIN_NAME=$(basename "$RUN_BIN")
  tail -n 500 -f "${NO1_LOG_PATH}/${BIN_NAME}.err" "${NO1_LOG_PATH}/${BIN_NAME}.out"
}

do_stop() {
  RUN_BIN=$1
  BIN_NAME=$(basename "$RUN_BIN")
  RUN_PID=$(cat "${NO1_RUN_PATH}/${BIN_NAME}.pid")
  if [ -n "${RUN_PID}" ]; then
    kill -15 "${RUN_PID}" || kill -9 "${RUN_PID}"
  fi
}

do_restart() {
  do_stop "$@"
  do_start "$@"
}

do_help() {
  echo "Usage: noone (start|stop|restart|run) <command...>"
}

keep_run() {
  if [ ! -f /dev/noone ]; then
    echo "Keep runing..."
    touch /dev/noone
    # tail -f /dev/null
    while true; do sleep 86400; done
  fi
}

main() {
  echo "Exec: [$*]"
  [ "$1" = "noone" ] && shift
  action=$1
  shift
  case ${action} in
  run | start | stop | restart | help)
    echo "do_$action $*"
    do_"$action" "$@"
    ;;
  --)
    exec "$@"
    ;;
  *)
    do_help
    exit 0
    ;;
  esac

  sleep 1
  keep_run
}

if [ $# -gt 1 ]; then
  main "$@"
elif [ -n "${NO1_COMMAND}" ]; then
  echo "Cmd: ${NO1_COMMAND}"
  set -- ${NO1_COMMAND}
  main "$@"
else
  do_help
fi
