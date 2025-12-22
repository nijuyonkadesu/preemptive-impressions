After installing tailscale, follow [arch wiki](https://wiki.archlinux.org/title/Tailscale#Using_with_NetworkManager) to unmanage tailscale0 interface from NetworkManager (if you're using it). 

Now, if your MagicDNS do not work after a system sleep: 
reason: `etc/resolv.conf` gets overwritten by NetworkManager. To fix this follow [tailscale docs](https://tailscale.com/kb/1188/linux-dns#networkmanager--systemd-resolved), and configure NetworkManager to use systemd-resolved for DNS configurations ([arch wiki](https://wiki.archlinux.org/title/NetworkManager#DNS_management))

```sh
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo cat << EOF > /etc/NetworkManager/conf.d/dns.conf
[main]
dns=systemd-resolved
EOF

sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager
sudo systemctl restart tailscaled
```

