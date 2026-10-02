Make sure to update the bot-api to make use of new features

```sh
sudo podman build -f tgbotapi.dockerfile -t localhost/telegram-bot-api:latest
sudo systemctl restart telegram-bot-api.service
```
