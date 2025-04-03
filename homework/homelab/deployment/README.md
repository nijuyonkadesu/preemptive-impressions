# Quadlet

[Container] - section is handled by podman, rest is passed down
[tldr](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) 

1. Check man page for systemd
2. https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html

1. Unit File Directory: ~/.config/containers/systemd/

# TODO: 

1. GO look at sample systemd.unit files or smth and get idea of general structure
2. Then my goal is to run telegram server as a service with podman secret
3. Expose a port and see if it's addressable over local

# Secrets

1. gnome-keyring (not present)
2. systemd-creds (it's a file, so not really useful)
3. podman secret (podman) - looks like the only choice here
