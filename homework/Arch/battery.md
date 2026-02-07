[repo link for acer battery driver](https://github.com/frederik-h/acer-wmi-battery?tab=readme-ov-file) 

## Steps to install

```sh

git clone https://github.com/frederik-h/acer-wmi-battery.git
cd acer-wmi-battery
make

sudo insmod acer-wmi-battery.ko

# after makepkg -si, check if the module is loaded
lsmod | grep acer_wmi_battery
pacman -Ql acer-wmi-battery

# cap charging limit to 80%
echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/health_mode
cat /sys/bus/wmi/drivers/acer-wmi-battery/temperature



```

for persistence across reboots, install it using pacman.
paste this `PKGBUILD` file in the root of the acer-wmi-battery directory

PKGBUILD
```
pkgname=acer-wmi-battery
pkgver=0.1
pkgrel=1
pkgdesc="Acer WMI battery kernel module"
arch=('x86_64')
license=('GPL')
makedepends=('linux-headers')

build() {
  cd "$startdir"
  make
}

package() {
  cd "$startdir"
  install -Dm644 acer-wmi-battery.ko \
    "$pkgdir/usr/lib/modules/$(uname -r)/extra/acer-wmi-battery.ko"
}

```

run `makepkg -si` after all files are in place.
