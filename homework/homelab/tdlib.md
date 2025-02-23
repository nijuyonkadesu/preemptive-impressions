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
