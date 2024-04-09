```bash
alsamixer  
inxi --full  
aplay -l  
lsmod | grep snd  
dmesg|grep -i -E "snd|audio|hd|sound|alsa"  
```

[https://bbs.archlinux.org/viewtopic.php?id=268397](https://bbs.archlinux.org/viewtopic.php?id=268397)  

```bash
pw-top  
  
cat /proc/asound/card1/pcm0p/sub0/hw_params  
nvim /usr/share/alsa/alsa.conf  
nvim .asoundrc  
  
aplay -D hw:1,0 -f S24_LE fine.wav
```

```bash
# I hear my own voice, ie: Transparency mode kek
pw-loopback -d node-id=95
```

```bash
[guts@sus ~]$ aplay --dump-hw-params -D hw:2,0 -f cd /dev/zero
aplay: main:850: audio open error: Device or resource busy
[guts@sus ~]$ aplay --dump-hw-params -D hw:2,0 -f cd /dev/zero
Playing raw data '/dev/zero' : Signed 16 bit Little Endian, Rate 44100 Hz, Stereo
HW Params of device "hw:2,0":
--------------------
ACCESS:  MMAP_INTERLEAVED RW_INTERLEAVED
FORMAT:  S16_LE S32_LE SPECIAL S24_3LE DSD_U32_BE
SUBFORMAT:  STD
SAMPLE_BITS: [16 32]
FRAME_BITS: [32 64]
CHANNELS: 2
RATE: [32000 768000]
PERIOD_TIME: [125 1000000]
PERIOD_SIZE: [8 768000]
PERIOD_BYTES: [64 6144000]
PERIODS: [2 1024]
BUFFER_TIME: (20 2000000]
BUFFER_SIZE: [16 1536000]
BUFFER_BYTES: [64 12288000]
TICK_TIME: ALL
--------------------
```

## Make a script to play songs
using awk / find / or smth

I came across the same problem. With ALSA it is possible to use the name of the device instead of the HW: address. If you run `aplay -L` (that is a capital L), you should see the name of your DAC. Mine is called “PRO”, so instead of HW:0,0 in which you use the ID of the device, you can use: `device=hw:CARD=Pro,DEV=0`. That way, it doesn’t matter what ID your card gets after a system reboot!
```bash
aplay -D hw:CARD=3,DEV=0 -v -f DSD_U32_BE -c 2 -r 88200 [file]
```
