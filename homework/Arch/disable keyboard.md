# Disable inbuilt laptop keyboard

```sh
sudo evtest
# you'd see smth like: (inbuilt keyboard)
# /dev/input/event4:      AT Translated Set 2 keyboard

# redirects all input to null
sudo evtest --grab /dev/input/event4 > /dev/null
```
