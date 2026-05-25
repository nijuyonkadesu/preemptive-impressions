Go read [arch wiki](https://wiki.archlinux.org/title/Bluetooth) first.

```sh

# if bluetoothctl gets stuck: check if services are enabled
systemctl status bluetooth.service
systemctl enable bluetooth.service
systemctl start bluetooth.service

bluetoothctl power on
bluetoothctl scan on
bluetoothctl devices # copy the device you want to pair with
bluetoothctl pair XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
```
