#!/usr/bin/env sh


export RPC_SECRET=${RPC_SECRET:-"docker-aria2"}

export DOWNLOAD_DIR=${DOWNLOAD_DIR:-"/data/download"}
mkdir -p "${DOWNLOAD_DIR}"

export CONF_FILE=${CONF_FILE:-"/data/config/aria2.conf"}
mkdir -p "$(dirname "${CONF_FILE}")"
mkdir -p "/data/config"

set -e

init_aria2_conf() {
  echo "Init CONF_FILE=${CONF_FILE}"
  if [ -e "${CONF_FILE}" ]; then
    echo "Already exists [${CONF_FILE}] !"
    return 0;
  fi

  touch /data/config/session.txt
  touch /data/config/dht.dat
  touch /data/config/dht6.dat

  echo "Generate [${CONF_FILE}] ..."
  cat << EOF > "${CONF_FILE}"
# ${CONF_FILE}

## Basic Options
# 文件保存路径, 默认为当前启动位置
dir=${DOWNLOAD_DIR}
# 最大同时下载数(任务数), 路由建议值: 3
max-concurrent-downloads=5
# 同服务器连接数
max-connection-per-server=6
# 断点续传
continue=true
# 检查完整性
check-integrity=false


## RPC Options
# 允许rpc
enable-rpc=true
# 允许所有来源, web界面跨域权限需要
rpc-allow-origin-all=true
# 允许外部访问，false的话只监听本地端口
rpc-listen-all=true
# RPC端口, 仅当默认端口被占用时修改
rpc-listen-port=6800
# 设置加密的密钥
rpc-secret=${RPC_SECRET}
# 是否启用https加密，启用之后要设置公钥,私钥的文件路径
#rpc-secure=true
# 启用加密设置公钥
#rpc-certificate=${HOME}/.aria2/example.crt
# 启用加密设置私钥
#rpc-private-key=${HOME}/.aria2/example.key


## Advanced Options
disable-ipv6=true
force-save=true
# 日志文件保存路径，忽略或设置为空为不保存，默认不保存。
#log=
# 日志级别，可选 debug, info, notice, warn, error 。默认 debug
#log-level=warn
# Aria2 一键安装管理脚本 与 Aria2 Pro 使用以下选项设置日志。
# 控制台日志级别，可选 debug, info, notice, warn, error 。默认 notice
# 建议设置为 warn ，此项仅输出警告和错误，可大幅减少日志产生并有利于排错。
console-log-level=warn
# 安静模式，禁止在控制台输出日志，默认：false
quiet=false
# 从会话文件中读取下载任务
input-file=/data/config/session.txt
# 在Aria2退出时保存 错误/未完成 的下载任务到会话文件
save-session=/data/config/session.txt
# 定时保存会话, 0为退出时才保存, 需1.16.1以上版本, 默认:0
save-session-interval=120
#always-resume=true
max-resume-failure-tries=6
connect-timeout=45
timeout=60
http-accept-gzip=true
content-disposition-default-utf8=true
# 最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
min-split-size=16M
# 单文件最大线程数, 路由建议值: 5
split=4
# 下载速度限制
max-overall-download-limit=0
# 单文件速度限制
max-download-limit=0
# 上传速度限制
max-overall-upload-limit=1024K
# 单文件速度限制
max-upload-limit=0
# 断开速度过慢的连接
#lowest-speed-limit=0
# 验证用，需要1.16.1之后的release版本
#referer=*
#user-agent=*
# 文件缓存, 使用内置的文件缓存, 如果你不相信Linux内核文件缓存和磁盘内置缓存时使用, 需要1.16及以上版本
#disk-cache=0
# 另一种Linux文件缓存方式, 使用前确保您使用的内核支持此选项, 需要1.15及以上版本(?)
#enable-mmap=true
# 文件预分配, 能有效降低文件碎片, 提高磁盘性能. 缺点是预分配时间较长
# 所需时间 none < falloc ? trunc << prealloc, falloc和trunc需要文件系统和内核支持
# 若无法下载，提示 fallocate failed.cause：Operation not supported 说明不支持，请设置为 none 或 prealloc
file-allocation=falloc
# 不进行证书校验
check-certificate=false


# 下载停止后执行的命令
on-download-stop=/opt/aria2/on_stop.sh
# 下载完成后执行的命令
# 此项未定义则执行下载停止后执行的命令（on-download-stop）
on-download-complete=/opt/aria2/on_complete.sh
# 下载错误后执行的命令
# 此项未定义则执行下载停止后执行的命令（on-download-stop）
#on-download-error=
# 下载暂停后执行的命令
#on-download-pause=
# 下载开始后执行的命令
#on-download-start=


## BitTorrent/Metalink Options
bt-enable-lpd=true
bt-max-open-files=128
bt-max-peers=80
#dht-listen-port=6881-6999
dht-file-path=/data/config/dht.dat
dht-file-path6=/data/config/dht6.dat
max-overall-upload-limit=2048K

bt-tracker=

EOF

}

server_AriaNg() {
    httpd -p 80 -h /var/www
}


echo "########"

init_aria2_conf

server_AriaNg

aria2c --conf-path="${CONF_FILE}" --enable-rpc --rpc-listen-all
