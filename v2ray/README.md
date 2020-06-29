# dockerfiles
## v2ray (https://github.com/v2ray/v2ray-core)



### Quick Start

```bash
# server_webproc http://127.0.0.1:18086/
docker run -d \
-p 10086:10086 \
-p 18086:8080 \
--name server_webproc -h server_webproc \
--log-opt "max-size=100m" \
--restart=always \
-v $(pwd)/config_server.json:/etc/v2ray/config.json \
-e 'HTTP_USER=v2ray' -e "HTTP_PASS=server_webproc" \
longe/v2ray 

# v2ray_server
docker run -d \
-p 10086:10086 \
--name v2ray_server -h v2ray_server \
--log-opt "max-size=100m" \
--restart=always \
-v $(pwd)/config_server.json:/etc/v2ray/config.json \
longe/v2ray noone

# docker exec v2ray_server noone restart v2ray -config=/etc/v2ray/config.json


# v2ray_client
docker run -d \
-p 1080:1080 \
-p 18080:8080 \
--name v2ray_client -h v2ray_client \
--log-opt "max-size=50m" \
-v $(pwd)/config_client.json:/etc/v2ray/config.json \
-e 'HTTP_USER=v2ray' -e "HTTP_PASS=v2ray_client" \
longe/v2ray 


# uuid
cat /proc/sys/kernel/random/uuid

```


## build

- alpine

```bash
# 3.12, v4.25.1
build.sh -i longe/v2ray -t v4.25.1,latest -p v2ray -A FROM_TAG=3.12 -A V2RAY_VERSION=v4.25.1 -U build

# 3.12, v4.23.4
#docker build -t longe/v2ray:v4.23.4 -t longe/v2ray ./ --build-arg FROM_TAG=3.12 --build-arg V2RAY_VERSION=v4.23.4 --pull
build.sh -i longe/v2ray -t v4.23.4 -p v2ray -A FROM_TAG=3.12 -A V2RAY_VERSION=v4.23.4 -U build

# 3.10, v4.23.1
docker build -t onge/v2ray:v4.23.1 ./ --build-arg FROM_TAG=3.10 --build-arg V2RAY_VERSION=v4.23.1

# 3.9, v4.23.1
docker build -t longe/v2ray:v4.23.1-alpine-3.9 ./ --build-arg FROM_TAG=3.9 --build-arg V2RAY_VERSION=v4.23.1
```


- ubuntu, debian

```bash
# 18.04 bionic
build.sh -i longe/v2ray -t latest -p v2ray -A FROM_IMG=ubuntu -A FROM_TAG=18.04 build

# 10 buster
build.sh -i longe/v2ray -t latest -p v2ray -A FROM_IMG=debian -A FROM_TAG=10 build

```


## Reverse Proxy

- nginx

```nginx
http {
    # ...

    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    server {
        listen  80;
        server_name  ws.domain.com;

        index  index.html index.htm;

        proxy_set_header  Cookie $http_cookie;
        proxy_set_header  X-Real-IP $remote_addr;
        #proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-For $remote_addr;

        location / {
            proxy_pass  https://help.github.com/;
            expires  12h;
        }

        # v2ray webproc (EventSource)
        location /v2ray/ {
            proxy_pass http://127.0.0.1:18086/;
            proxy_set_header  Host $http_host;
            proxy_set_header Connection '';
            proxy_http_version 1.1;
            chunked_transfer_encoding off;
            proxy_buffering off;
            proxy_cache off;
        }

        # v2ray websocket
        location /ws {
            proxy_pass http://127.0.0.1:10086;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }
    }

}
```


- caddy

```
ws.domain.com {
  reverse_proxy * https://help.github.com
  reverse_proxy /ws http://127.0.0.1:10086
}
```
