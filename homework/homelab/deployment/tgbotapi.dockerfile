# 2025-02-23 Bot API v8.3
FROM alpine:3.20 as builder
WORKDIR /server

RUN apk update && apk upgrade
RUN apk add alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git --depth 1
RUN rm -rf telegram-bot-api/build
RUN mkdir -p telegram-bot-api/build

RUN cd telegram-bot-api/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=.. ..
RUN cd telegram-bot-api/build && \
    cmake --build . --target install

FROM alpine:3.20
RUN apk add --update openssl libstdc++
COPY --from=builder /server/telegram-bot-api/bin/telegram-bot-api /telegram-bot-api
ENTRYPOINT ["/telegram-bot-api"]
