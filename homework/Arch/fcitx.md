# Environments: 
.pam_environment -> environment.d/xxx.conf : https://kisaragi-hiu.com/migrating-away-from-pam-environment/
doc: https://wiki.archlinux.org/title/Environment_variables#Per_Xorg_session (look wayland)

```~/.config/environment.d/imejp.conf 
XMODIFIERS=@im=fcitx
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
```
# Installation: 
1. Install fcitx 
2. set the above env variables 
3. add fcitx to autostart
4. logout and signin 

```sh
sudo pacman -S fcitx-configuration
sudo pacman -S fcitx-mozc
sudo pacman -S fcitx-configtool
```

# New method for KDE

[doc](https://wiki.archlinux.org/title/Mozc) 
[doc](https://wiki.archlinux.org/title/Fcitx5)
[ughhhh ime jp](https://wiki.archlinux.org/title/Localization/Japanese) 
1. No need to install any AUR packages. 
2. system settings -> keyboard -> virtual keyboard -> fcitx5 wayland launcher
3. add those envs
4. frick reddit, and any other sources, they do not work for you, because it's highly likely they are all deprecated and arch wiki might have way easier installations 

```sh 
sudp pacman -S fcitx5-im fcitx5-mozc
# or
sudo pacman -S fcitx5 fcitx5-configtool 

fcitx5-diagnose
# For GTK applications like firefox single line mode
sudo pacman -S fcitx5-gtk
```
- No need to set any envs anywhere. 

