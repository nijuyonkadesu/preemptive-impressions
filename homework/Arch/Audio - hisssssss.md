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
