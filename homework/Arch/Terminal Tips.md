`| lime  `
`| less  `
`| grep <keyword> ` 
`| sort`  
`| sed <pattern>`

  
`ctrl + r` (old command search)  
  
`yes | command` (gives auto yes that requires user interaction)  
`alias`  
  
`find /home/user -type f sensetive_data.txt  `
`find. -type f -size 100M (size > 100)  `
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
ssh -T u0_a342@192.168.29.133 -p 8022 << EOF
    cd vpc_migrate
    pg_dumpall > watgbridge-$(date +"%d-%m-%Y").sql
EOF
scp -P 8022 u0_a342@192.168.29.133:~/vpc_migrate/watgbridge-$(date +"%d-%m-%Y").sql ~/Documents/watg_backup
scp -P 8022 u0_a342@192.168.29.133:~/watgbridge/wawebstore.db ~/Documents/watg_backup
scp -P 8022 u0_a342@192.168.29.133:~/watgbridge/config.yaml ~/Documents/watg_backup
```

```bash
crontab -e
@reboot /home/guts/ssh_scripts/watgbridge_reboot_backup_cron.sh
```
