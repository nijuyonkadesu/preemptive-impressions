
The reason we use opportunistic is to allow tailscale magic dns to work, along side with DNS over TLS whenever possible. Minimal overhead for setup, for the moment, I don't want to dive deep. 
```sh

sudo nvim /etc/systemd/resolved.conf 
DNS=8.8.8.8 8.8.4.4
DNSOverTLS=opportunistic


sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager

resolvectl status
```
