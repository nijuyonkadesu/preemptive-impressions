`paccache -rk1  `
  
`yay -Scc ` 
[https://forum.endeavouros.com/t/removing-old-packages-from-yay-cache-in-home-directory/1428/5](https://forum.endeavouros.com/t/removing-old-packages-from-yay-cache-in-home-directory/1428/5)  
  
`yay -Sua` - upgrade all packages in aur  
`sudo pacman -Rsu $(pacman -Qdtq)` - remove orphan packages
`yay -Sc` - clean up build / cache files (be cautious while choosing options)
  
## Keyring, Screenkey  
pacman -Sy archlinux-keyring  
screenkey  - ctrl right and left to disable screen key
asd.service

## Mirror List
sudo nano /etc/pacman.d/mirrorlist  
[https://archlinux.org/mirrorlist/](https://archlinux.org/mirrorlist/)
