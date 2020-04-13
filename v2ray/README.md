# dockerfiles
## v2ray (https://github.com/v2ray/v2ray-core)



### Quick Start

```bash
# server_webproc http://127.0.0.1:18086/
docker run -d \
-p 10086:10086 \
-p 18086:8080 \
--name server_webproc -h server_webproc \
--log-opt "max-size=50m" \
--restart=always \
-v $(pwd)/config_server.json:/etc/v2ray/config.json \
-e 'HTTP_USER=v2ray' -e "HTTP_PASS=server_webproc" \
longe/v2ray 

# v2ray_server
docker run -d \
-p 10086:10086 \
--name v2ray_server -h v2ray_server \
--log-opt "max-size=50m" \
--restart=always \
-v $(pwd)/config_server.json:/etc/v2ray/config.json \
longe/v2ray v2ray -config=/etc/v2ray/config.json


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
# 3.10
docker build -t longe/v2ray ./
docker tag longe/v2ray:latest longe/v2ray:v4.23.1

# 3.9
docker build -t longe/v2ray:v4.23.1-alpine-3.9 ./ --build-arg FROM_TAG=3.9 --build-arg V2RAY_VERSION=v4.23.1
```


- ubuntu, debian

```bash
# 18.04 bionic
docker build -t longe/v2ray:v4.23.1-bionic ./ --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=18.04 --build-arg V2RAY_VERSION=v4.23.1

# 10 buster
docker build -t longe/v2ray:v4.23.1-buster ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=10 --build-arg V2RAY_VERSION=v4.23.1

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
            proxy_pass http://127.0.0.1:10088;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }
    }

}
```
