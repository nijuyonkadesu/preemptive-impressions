FROM localhost/telegram-bot-api:latest
RUN apk add --no-cache proxychains-ng
COPY proxychains4.conf /etc/proxychains/proxychains.conf
ENTRYPOINT ["proxychains4", "/telegram-bot-api"]
