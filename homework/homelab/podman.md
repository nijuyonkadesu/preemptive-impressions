# Quadlet

[Container] - section is handled by podman, rest is passed down
[tldr](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) 

1. Check man page for systemd
2. https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html

- Rootless: ~/.config/containers/systemd/
- Root: /etc/containers/systemd/

## Steps 

1. do relevant parts from `./tdlib.md` 
2. rtfm
3. create a `.container` file 
4. configure env in a plain file with root:root (for now)
5. copy the `.container` file to Root dir
6. systemd daemon reload
7. start it

# TODO: 

1. [OK] GO look at sample systemd.unit files or smth and get idea of general structure
    a. `cd /etc/systemd/` - aight
2. [OK] Then my goal is to run telegram server as a service with podman secret
3. [OK] Expose a port and see if it's addressable over local network (over tailscale too)
4. [OK] continue reading podman-systemd.unit, container section 
5. [OK] copy the .container file to Root dir
6. [OK] Image pull error
7. automate image building and updating
8. security is a big question lmao, explore on `Network=` under `[Service]`
9. [ok] storage issue within the server (ughh, directories are not auto created)
    a. but it's not storage issue

# Secrets

1. gnome-keyring (not present)
2. systemd-creds (it's a file, so not really useful)
3. podman secret (podman) - looks like the only choice here

# Connecting The Dots 

- systemd generators creates unit files based on configuration files and load them at early stages of boot. 
- so that everything in at the end is present in the form of files that systemd can understand. 
- like `/etc/fstab` is converted to `usr/lib/systemd/system/local-fs.target` unit file, which mounts all the path
- podman has a generator of it's own, which based on the file, generates a systemd equivalent unit file. 

- /run has the most precedence
- /usr - vendor overrides over gnu/linux's default?

- the podman generator reads the search paths and reads files with the extensions .container .volume, .network, .pod and .kube
- WantedBy=default.target is applied by default to persist across system boot
- %i = instance -> instance variable -> name@instace.service

# Questions

- How do I even create a unit file for my dockerfiles? 
- what are the uses of .d drop-in folders?? To override configurations?
- for containers to run regarless of user login, they have to be placed in `/etc/containers/systemd/` ?


# Playground

```sh
man podman-systemd.unit
man systemd.service

systemctl --user list-unit-files
# podman storage is isolated for each user, so load your image with root 
# for make it available in root systemd
podman save localhost/telegram-bot-api:latest -o telegram-bot-api.tar
sudo podman load -i telegram-bot-api.tar

# for now instead of secrets
cd /etc/containers/homelab
sudo nvim telegram-bot-api.env
chmod 600 telegram-bot-api.env
chown root:root telegram-bot-api.env

sudo cp homework/homelab/deployment/telegram-bot-api.container /etc/containers/systemd/
# this is annoying, will remove later
sudo mkdir -p /var/lib/telegram-bot-api/temp /var/lib/telegram-bot-api/data
sudo chown -R root:root /var/lib/telegram-bot-api/temp /var/lib/telegram-bot-api/data

sudo systemctl daemon-reload
systemctl status telegram-bot-api.service
# you cannot enable service, because it is considered transcient
systemctl start telegram-bot-api.service
journalctl -xeu telegram-bot-api.service

# ping wuahhh, it works ~
curl -X GET localhost:8081/ping
```
