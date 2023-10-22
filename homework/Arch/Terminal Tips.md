`| lime  `
`| less  `
`| grep <keyword> ` 
`| sort`  
  
`ctrl + r` (old command search)  
  
`yes | command` (gives auto yes that requires user interaction)  
`alias`  
  
`find /home/user -type f sensetive_data.txt  `
`find. -type f -size 100M (size > 100)  `
`df -h`  
  
Nvidia card status  
`cat /sys/class/drm/card*/device/power_state`  
DO is full power ([https://docs.kernel.org/power/pci.html#native-pci-power-management](https://docs.kernel.org/power/pci.html#native-pci-power-management))
see if the card is in D0: cat
`cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_statussuspended`

### Node Version Manager
Need to activate nvm by running init script
nvm - Node version Manager  
nvm install (version)  
nvm use (verrsion)