#!/usr/bin/env bash

# env2conf.sh

# env2conf <filePath> [envPrefix]
function env2conf() {
  local filePath=$1
  local fileName=${filePath##*/}
  local fileExt=${fileName##*.}
  # default: a-b-c.xyz ==> A_B_C
  local defaultPrefix=$(echo "${fileName%.*}" | awk '{gsub(/-/,"_");print toupper($1)}')
  local envPrefix=${2:-$defaultPrefix}

  local envs=$(env | grep "${envPrefix}_")
  for e in ${envs}; do
    #eval $(echo ${e} | awk -F "=" '{ printf("key=%s;val=%s",$1,$2)}')
    local keyname=$(echo "${e}" | awk -F "=" '{print $1}') # get key
    # revert: - <== ___; _ <== __; . <== _;
    local key=$(echo "${keyname}" | sed -e "s/^${envPrefix}_//" -e 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;')
    local val="${!keyname}" # get from env
    #unset "${keyname}"
    if [[ "$fileExt" == "xml" ]]; then
      add2xml "${filePath}" "${key}" "${val}"
    else
      add2conf "${filePath}" "${key}" "${val}"
    fi
  done
}

function add2xml() {
  local filePath=$1
  local name=$2
  local value=$3

  if [[ ! -f ${filePath} ]]; then
    # hadoop configuration file
    echo '<?xml version="1.0" encoding="UTF-8"?>' > ${filePath}
    echo '<configuration>' >> ${filePath}
    echo '</configuration>' >> ${filePath}
  fi

  if grep -q "${name}" ${filePath}; then
    return 0
  fi

  local property="<property><name>$name</name><value>$value</value></property>"
  sed -i "s#</configuration>#${property}\n&#" ${filePath}
  #local escapedEntry=$(echo ${property} | sed 's/\//\\\//g')
  #sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" ${filePath}
  #sed -i "/<\/configuration/i\${escapedEntry}" ${filePath}
}

function add2conf() {
  local filePath=$1
  local name=$2
  local value=$3

  echo "$name=$value" >> ${filePath}
}

# env2conf.sh <filePath> [envPrefix]
if [[ $# -gt 0 && "$1" != "--" ]]; then
  echo "env2conf: $*"
  env2conf "$@"
fi
