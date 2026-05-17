- download your keyboard json from [official site](https://womierkeyboard.com/pages/softwares) 
- Configuring womier keyboard using [usevia.app](usevia.app) -> settings -> enable design mode -> import the json file.
- check for errors in first tab.

**use viaapp is not working!!:** 
- go read [arch wiki discussion](https://bbs.archlinux.org/viewtopic.php?id=285709), claude gave a shitty complicated answer., the discussion gives a very neat solution.

**to find your hidraw number:** 
- go to [chrome device log](chrome://device-log), clear the logs, refresh useviaapp, authorize device
- search for hidraw: you'll see smth like: `[13:57:19] Failed to open '/dev/hidraw6': FILE_ERROR_ACCESS_DENIED`

```sh
ls -l /dev/hidraw6
sudo chmod a+rw /dev/hidraw6
# after doing all the configurations, reset the permissions:
sudo chmod 600 /dev/hidraw6
```

MO(2) is found under LAYERS, just click the keys and swap.
RALT is found under BASIC.

**Alternate solutions:** from the same wiki:
> This is a bit late, but in the qmk repo, (qmk/qmk_firmware), you can find a udev rule at qmk_firmware/util/udev/50-qmk.rules which you can move to /etc/udev/rules.d to allow user access to the keyboards.
