1. Learn how to complie.
2. Several concepts will click in your mind along the way.
3. It is better to learn kernel development (most core of all)
4. check [alaska linux user](https://www.youtube.com/watch?v=XWDDdHC0sY8&list=PLRJ9-cX1yE1nTL6cuJszmdJOAS2918mrh&index=1)

[basic custom rom guide](https://github.com/shantanu-sarkar/CustomROM).

## Overview

1. device tree

   - respective rom has a copy of device tree?
   - eg: [android/device/xiaomi/miatoll](https://github.com/LineageOS/android_device_xiaomi_miatoll)

2. kernel tree

   - eg: [android/kernel/xiaomi/sm6250](https://github.com/Demon000/kernel_xiaomi_sm6250)
   - eg: [android/kernel/xiaomi/sm6250](https://github.com/LineageOS/android_kernel_xiaomi_sm6250)

3. vendor tree

   - eg: [android/vendor/xiaomi/miatoll](https://github.com/TheMuppets/proprietary_vendor_xiaomi_miatoll)
   - [ref: youtube](https://www.youtube.com/watch?v=PMLIzUXee84)
   - Vendor tree is pulled from the device. It's proprietary binary files that are included with the device.

4. optional hardware
   - eg: [android/hardware/xiaomi](https://github.com/LineageOS/android_hardware_xiaomi)

check final build zip in `out/target/product/<codename>`.

## Only works for Official ROMs

Do not download device specific repos manually. For LOS, use lunch cli tool. Don't forget to add TheMuppets for vendor proprietary files.

Setup:

- `lunch lineage-<codename>-hinge`
- `lunch lineage-<codename>-userdebug`

Build:

- `brunch lineage-<codename>-userdebug`

## TODO

- what about OSS vendor?
- what about unsupported / new device?

# Resources to Build your own kernel

1. http://goo.gl/b3A2EX
2. https://www.geeksforgeeks.org/compile-our-own-android-kernel-in-5-simple-steps/
3. https://forum.xda-developers.com/t/reference-how-to-compile-an-android-kernel.3627297/
4. https://forum.xda-developers.com/t/guide-noobs-familiar-how-to-build-android-kernel-with-features.3654336/
5. https://forum.xda-developers.com/t/guide-working-with-android-kernel-from-scratch.3909887/
6. https://appuals.com/how-to-update-your-android-kernel-to-latest-linux-stable/
7. https://youtu.be/b8-eOfWviU0
8. https://youtu.be/ZDqJvOj3-aE
9. https://baalajimaestro.me/posts/2020/07/kernel-for-newbies/
10. https://youtu.be/598Xe7OsPuU
11. https://youtu.be/cueEGjQES9o
12. https://cyberknight777.dev/posts/2021/09/how-to-rebase-a-kernel/

## Overview

## Caution

1. Do not use unknown driver modules or blobs.
2. Do not mindlessly swap proprietary parts with OSS parts.

It can very well destroy your device.

## TODO
