# Quadlet

[Container] - section is handled by podman, rest is passed down
[tldr](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) 

1. Check man page for systemd
2. https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html

1. Rootless: ~/.config/containers/systemd/
2. Root: /etc/containers/systemd/

# TODO: 

1. GO look at sample systemd.unit files or smth and get idea of general structure
    a. `cd /etc/systemd/` - aight
2. Then my goal is to run telegram server as a service with podman secret
3. Expose a port and see if it's addressable over local network (over tailscale too)
4. continue reading podman-systemd.unit, container section 
5. Move this readme one level up

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
systemctl --user list-unit-files
```
