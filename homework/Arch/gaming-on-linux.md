For the most easiest way to game on linux, try out EndeavourOS. Basically it's arch with a desktop environment backed in.

Steps that are working as of 2025-11-30:

### Driver installation

```sh
sudo pacman -Syu switcheroo-control
sudo systemctl enable --now switcheroo-control

yay -S nvidia-inst
nvidia-inst -h

# detects the compatible drivers for the available GPU
nvidia-inst --drivers

# --open installs the open linux nvidia driver
nvidia-inst --closed
```

### Steam & Game setup

Games from steam are straightforward, install and just use it. How local exes:

- Open steam -> library -> collections
- Bottom left, choose "Add a game" -> "add a non-Steam game"
- Choose the game `.exe`
- Right click -> go to properties -> compatibility -> check the force use -> Choose proton v9 or v10 or anything that the community suggests.

```sh
sudo pacman -S steam

# for the games that refuse to work with steam
yay -S lutris
lutris -i fate-stay-night-realta-nua-ultimate-edition.yml
```

I was quite surprised how well games run, good thing I nuked windows.
