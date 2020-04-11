#!/bin/sh

echo "$(date +"%Y-%m-%d %H:%M:%S") $(readlink -f "$0")"

FILE_PATH=$3

if [ $2 -eq 0 ]; then
  exit 0
elif [ -e "${FILE_PATH}.aria2" ]; then
  echo "$(date +"%Y-%m-%d %h:%M:%s") Delete ${FILE_PATH}.aria2 ..."
  rm -vf "${FILE_PATH}.aria2"
fi
