Try out voxtype [link](https://github.com/peteonrails/voxtype). Supports push to talk, and transcribes text into any text field. How cool is that? All in local too!


## Setup: 

Run these, and follow the instrucitons printed on terminal post install.

1. Install
```sh
yay -S voxtype-bin

# uses vulkan
sudo voxtype setup gpu --enable
voxtype setup gpu
```

2. Postinstall setup (might be changed, check console output)

```sh
sudo usermod -aG input $USER
voxtype setup model
systemctl --user enable --now voxtype
```

3. Configure shortcuts: refer [docs](https://github.com/peteonrails/voxtype#compositor-keybindings) 

