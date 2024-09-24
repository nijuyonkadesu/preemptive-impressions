`| lime  `
`| less  `
`| grep <keyword> ` 
`| sort`  
`| sed <pattern>`

**ripgrep** (often shortened to `rg`) and **fd** are modern alternatives to the traditional `grep` and `find` commands

`tree -d -L 2` list only directories with depth level 2
```zsh
for d (parent-dir/*/*(N/)) (cd -- $d && tree) | less
```
https://unix.stackexchange.com/questions/737234/using-tree-for-sub-subdirectories
  
`ctrl + r` (old command search)  
  
`yes | command` (gives auto yes that requires user interaction)  
`alias`  
  
`find /home/user -type f sensetive_data.txt  `
`find . -type f -size 100M (size > 100)  `
`find . -type d -name ".git"`
`df -h`  
`base64 -d <<< bWluaW8=`
`echo -n "" | base64 -d`
`head -2 trains-big.csv`
`tar cCf / - usr | cpipe -vt > /dev/null` - modify to measure current activity in STDIN / STDOUT
`read var` 
`fc` / `ctrl + x + e` - edit long commands in preffered editor
`jq '[.[] | select(.config_type | startswith("platform"))]' input.json`
`jq '[.[] | select(.config_type | startswith("platform"))]' input.json`
`7z t file.zip` check zip for corruption
`ab -k -c 350 -n 5000 http://<rpi ip>:3000/` command sends 5k requests in total with a concurrency of 350 requests. One could tweak these numbers as per requirements.
ref: [mock http request](https://gochronicles.com/benchmark-restful-apis/) 
 
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

- tmux-sessioner + fuzzy find (avoid cd hell): https://www.reddit.com/r/tmux/comments/1ch9tqp/primeagen_tmux_session_management/
- [primeagen](https://github.com/ThePrimeagen/.dotfiles/blob/master/tmux/.tmux.conf) 
- [fixed](https://github.com/brunobmello25/dotfiles/blob/main/bin%2F.local%2Fscripts%2Ftmux-sessionizer) 

### conf file:
```bash
set -g mouse on
set -g renumber-windows on
set -g history-limit 1000000
set -sg escape-time 0 # No command delay
set -g status-keys vi
setw -g mode-keys vi
set -g default-terminal "xterm-kitty"                                                                    
set -as terminal-overrides ",xterm-kitty:RGB"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

set-option -g status-position top 
set-option -g status-interval 1

# colors 
set -g status-style 'bg=#333333 fg=#5eacd3'

#-------------------------------------------------------------------------------
# Keys binding
#-------------------------------------------------------------------------------
unbind C-b
set-option -g prefix C-b
bind-key C-b send-prefix
set -g base-index 1
bind V split-window -h -c "#{pane_current_path}"
bind H split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

bind c new-window -c "$HOME"

# Switch panes using like vim keys
bind -r ^ last-window
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R

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
bind , command-prompt -p "(rename-window '#W') " "rename-window '%%'"

# Do not display the orignal pane's name when renaming it
bind '$' command-prompt -p "(rename-session '#S')" "rename-session '%%'"

# tmux-sessionizer
bind-key -r S run-shell "~/.local/bin/tmux-sessionizer ~/redacted/services-core/services"
bind-key -r P run-shell "~/.local/bin/tmux-sessionizer ~/redacted/platform-core"
bind-key -r f run-shell "tmux neww ~/.local/bin/tmux-sessionizer"
```

### Commands
`tmux a -t 0` attach to the tmux window
`tmux ls`


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

# kitty
Has TrueColors by default, gpu acceleated, less memory intensive, it's great. One small caviat -
TODO: have to find a solution to search keywords in terminal. 

kittens have useful tools for to copy items to clipboard even through ssh.
and view images through terminal wahhh. 
```sh
kitty +kittens icat ./file.png
kitty +kittens diff ./fileone ./filetwo
```
`->` [read me](https://wiki.archlinux.org/title/kitty)
`->` [diff docs](https://sw.kovidgoyal.net/kitty/kittens/diff/) can work on images too!

`ctrl + shift + h` to search on screen buffer
[alternative to live search](https://sw.kovidgoyal.net/kitty/marks/)

# Who are these people!!
https://stackoverflow.com/questions/43573081/fast-i-o-in-c-stdin-out
umm, pipes eh

## Postgres
When to use which index [docs](https://www.postgresql.org/docs/current/indexes-types.html).
[GIN indexes](https://pganalyze.com/blog/gin-index) 

```sh 
# List tables from another schema other than public 
/dt schema.* 
/dt+ 
/l 
/c database

# List all schemas
SELECT schema_name
FROM information_schema.schemata;

TRUNCATE TABLE "load-test.relational_database_large_test_16gb";
# ERROR:  relation "load-test.relational_database_large_test_16gb" does not exist

SHOW search_path;
SET search_path TO "load-test";

#    search_path
# -----------------
#  "$user", public
# (1 row)
# ref: https://stackoverflow.com/questions/34098326/how-to-select-a-schema-in-postgres-when-using-psql

# Index
# ref: https://gitlab.com/gitlab-org/gitlab/-/issues/336930 (GIN pending-list overhead)
\di+ index_merge_requests_on_description_trigram
exec REINDEX INDEX index_merge_requests_on_description_trigram

```
