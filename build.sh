#!/usr/bin/env bash

## build only
# build.sh -i longe/ubuntu -t 18.04,bionic,latest -p linux/ubuntu -A FROM_TAG=18.04 build
## push only
# build.sh -i longe/ubuntu -t 18.04,bionic,latest push

## build & push
# build.sh -i longe/ubuntu -t 18.04,bionic,latest -p linux/ubuntu -A FROM_TAG=18.04 build push

: "${DO_ACTION:=true}"
: "${DO_DEBUG}"

[ "${DO_DEBUG}" ] && set -xe

echo ">>Pwd: [$PWD]"

docker_build() {
  echo ">>Build path: [${B_PATH} -> ${B_PATH_REAL}]"
  #cd "${B_PATH_REAL}" || exit 2

  # tags for build
  local TAG_LIST=""
  IFS=', ' read -r -a TAG_ARR <<<"${B_TAGS}"
  for TAG_B in "${TAG_ARR[@]}"; do
    TAG_LIST="${TAG_LIST} -t ${B_IMAGE}:${TAG_B} "
  done
  echo ">>Build tags: [${TAG_LIST}]"

  local BUILD_CMD="docker build ${TAG_LIST} ${B_PATH_REAL}"
  [ -n "${B_FILE}" ] && BUILD_CMD="${BUILD_CMD} -f ${B_FILE}"
  [ -n "${BUILD_ARGS}" ] && BUILD_CMD="${BUILD_CMD} ${BUILD_ARGS}"
  echo ">>Build cmd: [${BUILD_CMD}]"
  sleep 2
  [ "true" = "${DO_ACTION}" ] && eval "${BUILD_CMD}"
}

docker_push() {
  IFS=', ' read -r -a TAG_ARR <<<"${B_TAGS}"
  for TAG_P in "${TAG_ARR[@]}"; do
    echo ">>Push: [${B_IMAGE}:${TAG_P}]"
    sleep 1
    [ "true" = "${DO_ACTION}" ] && docker push "${B_IMAGE}:${TAG_P}"
  done
}

OPTIND=1
while getopts ":i:t:p:f:A:" opt; do
  case $opt in
  i)
    # image name
    B_IMAGE=${OPTARG}
    ;;
  t)
    # -t, --tag list    Name and optionally a tag in the 'name:tag' format
    B_TAGS=${OPTARG}
    ;;
  p)
    # PATH (Build Context)
    B_PATH=${OPTARG:-"."}
    B_PATH_REAL=$(realpath "${B_PATH}")
    ;;
  f)
    # -f, --file string    Name of the Dockerfile (Default is 'PATH/Dockerfile')
    B_FILE=${OPTARG}
    ;;
  A)
    # --build-arg list    Set build-time variables
    BUILD_ARGS="${BUILD_ARGS} --build-arg ${OPTARG} "
    ;;
  ?)
    echo "Invalid option: -$OPTARG" >&2
    exit 2
    ;;
  esac
done
shift $((OPTIND - 1))

echo ">>Vars: B_IMAGE=[$B_IMAGE], B_TAGS=[$B_TAGS], B_PATH=[$B_PATH], B_FILE=[$B_FILE], BUILD_ARGS=[$BUILD_ARGS]"
echo ">>Args: [$*]"

# build | push
ACTION="$1"
[ "${ACTION}" ] && docker_"${ACTION}"
ACTION="$2"
[ "${ACTION}" ] && docker_"${ACTION}"
