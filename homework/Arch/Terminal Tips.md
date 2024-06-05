`| lime  `
`| less  `
`| grep <keyword> ` 
`| sort`  
`| sed <pattern>`

  
`ctrl + r` (old command search)  
  
`yes | command` (gives auto yes that requires user interaction)  
`alias`  
  
`find /home/user -type f sensetive_data.txt  `
`find . -type f -size 100M (size > 100)  `
`find . -type d -name ".git"`
`df -h`  

`read var` 
  
Nvidia card status  
`cat /sys/class/drm/card*/device/power_state`  
DO is full power ([https://docs.kernel.org/power/pci.html#native-pci-power-management](https://docs.kernel.org/power/pci.html#native-pci-power-management))
see if the card is in D0: cat
`cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_statussuspended`

## Shortcuts
`<C w>` delete a word backwards
`<C k>` delete entire thing following the cursor
`<C e>` go to end
`<C a>` go to begining
## tmux
*with tmux.conf*
`Ctrl + b`
- d - detach
- v, h - split
- z full screen
- https://stackoverflow.com/questions/5609192/how-do-i-set-tmux-to-open-specified-windows-at-startup
- quick 4 pane launch `tmux new-session \; split-window -v -p 20 \; split-window -h \; select-layout tiled \; resize-pane -t 1 -y 40 \; split-window -h \;`

### conf file:
```bash
set -g mouse on
set -g renumber-windows on
set -g history-limit 1000000
set -sg escape-time 0 # No command delay
set -g status-keys vi
setw -g mode-keys vi
set -g default-terminal "screen-256color"

set-option -ga terminal-overrides ",xterm-256color:Tc"
set-option -g status-position top
set-option -g status-interval 1

#-------------------------------------------------------------------------------
# Keys binding
#-------------------------------------------------------------------------------
bind v split-window -h -c "#{pane_current_path}"
bind h split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

bind c new-window -c "$HOME"

# Switch panes using Alt + vim keys
bind -n M-h select-pane -L
bind -n M-l select-pane -R
bind -n M-j select-pane -U
bind -n M-k select-pane -D

# Switch windows
bind -n S-Left previous-window
bind -n S-Right next-window

# Copy
unbind [
bind Escape copy-mode
bind P paste-buffer
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
bind-key -T copy-mode-vi Escape send-keys -X copy-pipe-and-cancel 'wl-copy'
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'

# Double LMB Select & Copy (Word), then press Escape or Enter to exit copy mode
bind-key -n DoubleClick1Pane \
    select-pane \; \
    copy-mode -M \; \
    send-keys -X select-word \; \
    send-keys -X copy-pipe-no-clear 'wl-copy' \; \


# Reload config file while in tmux
bind r source-file ~/.config/tmux/tmux.conf \; display "Reload configurations..."

# Do not display the original window's name when renaming it
bind , command-prompt -p "(rename-window '#W')" "rename-window '%%'"

# Do not display the orignal pane's name when renaming it
bind '$' command-prompt -p "(rename-session '#S')" "rename-session '%%'"
```

### Commands
`tmux a -t 0` attach to the tmux window


### Node Version Manager
Need to activate nvm by running init script
nvm - Node version Manager  
nvm install (version)  
nvm use (verrsion)

## bash.rc
```bash
alias timef='/usr/bin/time -f "Memory used (kB): %M\nUser time (seconds): %U"'
alias less='nvim \+":setlocal buftype=nofile" -'
export VISUAL=nvim
```

## cron

```bash

```

```bash
eval "$(ssh-agent -s)"
sshpass -P passphrase -p '#####' ssh-add ~/.ssh/id_ed25519
ssh -T u0_a342@192.168.29.133 -p 8022 << EOF
    cd vpc_migrate
    pg_dumpall > watgbridge-$(date +"%d-%m-%Y").sql
EOF
scp -P 8022 u0_a342@192.168.29.133:~/vpc_migrate/watgbridge-$(date +"%d-%m-%Y").sql ~/Documents/watg_backup
scp -P 8022 u0_a342@192.168.29.133:~/watgbridge/wawebstore.db ~/Documents/watg_backup
scp -P 8022 u0_a342@192.168.29.133:~/watgbridge/config.yaml ~/Documents/watg_backup
```

*for some reason, this didn't work... neither did systemd.service*, perhaps need to consume STDOUT somewhere 
```bash
crontab -e
@reboot /home/guts/ssh_scripts/watgbridge_reboot_backup_cron.sh
```

