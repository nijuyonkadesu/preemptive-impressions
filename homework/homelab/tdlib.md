# Local build step for alpine - Telegram bot API

## Dockerfile 

```sh 
export TG_API_ID=""
export TG_API_HASH=""

docker build -f homework/homelab/deployment/tgbotapi.dockerfile --tag=telegram-bot-api
docker run -p 8081:8081 \ 
    --env TELEGRAM_API_ID=TG_API_ID \
    --env TELEGRAM_API_HASH=TG_API_HASH \ 
    -it telegram-bot-api --local
```

```dockerfile
FROM alpine:3.20 as builder
WORKDIR /server

RUN apk update && apk upgrade
RUN apk add alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git --depth 1
RUN cd telegram-bot-api
RUN rm -rf build
RUN mkdir build
RUN cd build

RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=.. ..
RUN cmake --build . --target install

FROM alpine:3.20
RUN apk add --update openssl libstdc++
COPY --from=builder /server/telegram-bot-api/bin/telegram-bot-api /telegram-bot-api
ENTRYPOINT ["/telegram-bot-api"]
```

## Export the image for canonical k8s

1. Get the template and put it in deployment if you want
```sh 
podman create -p 8081:8081 \
    --name telegram-bot-api \
    --env TELEGRAM_API_ID=TG_API_ID \
    --env TELEGRAM_API_HASH=TG_API_HASH \
    localhost/telegram-bot-api --local

podman generate kube telegram-bot-api > telegram-bot-api.yaml
podman rm telegram-bot-api

# TODO: need to find an elegant way to integrate local register & canonical k8s
# podman run -d -p 5000:5000 --restart=always --name registry registry:2
podman save -o telegram-bot-api.tar localhost/telegram-bot-api:latest

sudo /snap/k8s/current/bin/ctr --address /run/containerd/containerd.sock --namespace k8s.io images import telegram-bot-api.tar
sudo /snap/k8s/current/bin/ctr --address /run/containerd/containerd.sock --namespace k8s.io images list -q | grep tele
# and don't forget to set `imagePullPolicy: IfNotPresent` in deployment
```

## Available Flags

```
Telegram Bot API server. Options:
  -h, --help                          display this help text and exit
      --version                       display version number and exit
      --local                         allow the Bot API server to serve local requests
      --api-id=<arg>                  application identifier for Telegram API access, which can be obtained at https://my.telegram.org (defaults to the value of the TELEGRAM_API_ID environment variable)
      --api-hash=<arg>                application identifier hash for Telegram API access, which can be obtained at https://my.telegram.org (defaults to the value of the TELEGRAM_API_HASH environment variable)
  -p, --http-port=<arg>               HTTP listening port (default is 8081)
  -s, --http-stat-port=<arg>          HTTP statistics port
  -d, --dir=<arg>                     server working directory
  -t, --temp-dir=<arg>                directory for storing HTTP server temporary files
      --filter=<arg>                  "<remainder>/<modulo>". Allow only bots with 'bot_user_id % modulo == remainder'
      --max-webhook-connections=<arg> default value of the maximum webhook connections per bot
      --http-ip-address=<arg>         local IP address, HTTP connections to which will be accepted. By default, connections to any local IPv4 address are accepted
      --http-stat-ip-address=<arg>    local IP address, HTTP statistics connections to which will be accepted. By default, statistics connections to any local IPv4 address are accepted
  -l, --log=<arg>                     path to the file where the log will be written
  -v, --verbosity=<arg>               log verbosity level
      --memory-verbosity=<arg>        memory log verbosity level; defaults to 3
      --log-max-file-size=<arg>       maximum size of the log file in bytes before it will be auto-rotated (default is 2000000000)
  -u, --username=<arg>                effective user name to switch to
  -g, --groupname=<arg>               effective group name to switch to
  -c, --max-connections=<arg>         maximum number of open file descriptors
      --cpu-affinity=<arg>            CPU affinity as 64-bit mask (defaults to all available CPUs)
      --main-thread-affinity=<arg>    CPU affinity of the main thread as 64-bit mask (defaults to the value of the option --cpu-affinity)
      --proxy=<arg>                   HTTP proxy server for outgoing webhook requests in the format http://host:port
```
