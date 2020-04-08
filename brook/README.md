# dockerfiles
## brook (https://github.com/txthinking/brook)



### Quick Start

```bash
docker run -it -d \
-p 6080:6080 \
--name brook -h brook \
--restart=always \
longe/brook 

```


## build

- alpine

```bash
# 3.10
docker build -t longe/brook:v20200201 ./
docker tag longe/brook:v20200201 longe/brook:latest

# 3.9
docker build -t longe/brook:v20200201-alpine-3.9 ./ --build-arg FROM_TAG=3.9 --build-arg BROOK_VERSION=v20200201
```


- ubuntu, debian

```bash
# 18.04 bionic
docker build -t longe/brook:v20200201-bionic ./ --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=18.04 --build-arg BROOK_VERSION=v20200201

# 16.04 xenial
docker build -t longe/brook:v20200201-xenial ./ --build-arg FROM_IMG=ubuntu --build-arg FROM_TAG=16.04 --build-arg BROOK_VERSION=v20200201

# 9 stretch
docker build -t longe/brook:v20200201-stretch ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=9 --build-arg BROOK_VERSION=v20200201

# 10 buster
docker build -t longe/brook:v20200201-buster ./ --build-arg FROM_IMG=debian --build-arg FROM_TAG=10 --build-arg BROOK_VERSION=v20200201

```


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
            proxy_pass  https://docs.gitbook.com/;
            expires  12h;
        }

        location /ws {
            proxy_pass http://127.0.0.1:6080;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }
    }

}
```