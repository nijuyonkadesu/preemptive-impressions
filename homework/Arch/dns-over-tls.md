
The reason we use opportunistic is to allow tailscale magic dns to work, along side with DNS over TLS whenever possible. Minimal overhead for setup, for the moment, I don't want to dive deep. 

Applies for ubunut server 
```sh

sudo nvim /etc/systemd/resolved.conf 
DNS=8.8.8.8#dns.google 8.8.4.4#dns.google
DNSOverTLS=opportunistic


sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager

resolvectl status
```
