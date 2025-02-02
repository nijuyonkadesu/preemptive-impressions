# 01 - Network

Example netplan yaml with a default gateway. Without default route, ipv4 networks will not work.

```yaml
network:
  version: 2
  ethernets:
    eno1:
      addresses:
        - 192.168.29.200/24
      routes:
        - to: default
          via: 192.168.29.1
      dhcp4: false
      dhcp6: true
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
  wifis:
    wlxd8448903c476:
      optional: true
      addresses:
        - 192.168.29.200/24
      dhcp4: false
      dhcp6: true
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
      access-points:
        "put-your-wifi-ssid":
          auth:
            key-management: "psk"
            password: "pass"
```

Modify and paste the above yaml.

```sh
sudo vim etc/netplan/50-cloud-init.yaml
sudo netplan generate && sudo netplan try
```

# 02 - SSH Configs

Creates a keypair in present in ~/.ssh/

```sh
ssh-keygen -t ed25519 -C "cherio!"
```
You can either copy your .pub files from other machines into this machine's `authorized_keys` file 
or run: `ssh-copy-id user@<ip>` from your client machine
or, import public keys from github `ssh-import-id gh:nijuyonkadesu`

# 03 - Development Environment

```sh
# Install neovim from source
sudo apt-get install ninja-build gettext cmake curl build-essential 
mkdir ~/build
# Modify the tmuxs script tho
cd ~/build
git clone --depth 1 https://github.com/neovim/neovim -b stable
sudo make install
make CMAKE_BUILD_TYPE=RelWithDebInfo

# Final setup before launching neovim
sudo apt install ripgrep fd-find fzf
sudo apt install npm python3.12-venv
sudo apt install golang-go
cd ~/.config && git clone https://github.com/nijuyonkadesu/dotfiles nvim

# tmuxs
mkdir logs
mkdir test
mkdir redacted 
```

# 04 - SSH clipboard: 

[ref](https://mil.ad/blog/2024/remote-clipboard.html#:~:text=Configuring%20neovim%20to%20use%20OSC%2D52&text=This%20allows%20you%20to%20use,have%20them%20work%20across%20SSH.) 

```lua
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste '+',
    ['*'] = require('vim.ui.clipboard.osc52').paste '*',
  },
}
```
and in `~/.config/tmux/tmux.conf` add: `set -g set-clipboard on`

# 04 - tmuxs
1. work on https://github.com/nijuyonkadesu/dotfiles/issues/5
