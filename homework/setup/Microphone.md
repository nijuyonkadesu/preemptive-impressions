# Windows Setup
1. Install voicemeter [link](https://vb-audio.com/Voicemeeter/potato.htm) 
2. Reaper 64bit VST plugins [link](https://www.reaper.fm/reaplugs/) 
3. reboot your system
4. your sound and input devices could be messed up now, so go to sound settings and choose your defaults manually
5. Watch [this](https://www.youtube.com/watch?v=6D5zd490NoU) for demo, and [this](https://www.youtube.com/watch?v=K62rUD8sCUs) tutorial


# Notes:

## 1.a. Noise Gate (reagate)

Adjust this based on your room's noise floor. This basically cuts off audio below a certain threshold you set. 

- Attack: how quickly the gate opens, allowing your voice to be passed through. (3ms)
- Release: how quick the gate closes, cutting off ambient noise. (100ms)
- Pre-open: to avoid cutting off frontend of your words. (6ms, 2x attack)
- High-pass filter: cutoff frequencies that muddy your voice (<=70Hz)

- Wet: Processed output %
- Dry: Unprocessed output %, recommended to set this up a little, to assist with pre-open, to avoid cutting off frontend of your voice. (-25dB)

## 1.b. Noise Subraction (reafir)

- Records the ambient noise, and subtracts it from the source
- Choose subtract from the dropdown

> [!CAUTION]
> Cure can be worse than the disease, if you overdo noise subtraction, by artificially making your chair creek or other common noises, you'll end up affecting the sound of your own voice. And that is not good.

## 2. EQ (reaeq)

- High-pass filter:
    - Roll off: @56Hz (try and finalize)
- Band: 
    - To cutoff boxy / echo / boomy sound - reduce <=4dB @1kHz or smth
    - For reducing sibilance - reduce a bit @5kHz
- Low-pass filter: 
    - To reduce high frequency sound - @10kHz to 12kHz

## 3 Compressor (reacomp)

Maintain the same level of volume, high to low, and low to high. Not killing your viewers.

- Ratio: 3:1, for every +3dB, you'll actually hear +1dB - when the set threshold is crossed.
- auto makeup: increase the loudness when falling behid a threshold

> [!WARNING]
> but findout your normal volume level when you're speaking, and adjust accordingly



## Gain Target

- Good gain such that signal to noise ratio is the highest, so that noise can be cleaned up.
- 10 o'clock: 
- target: -15dB

---

Linux's native format is VT2, so VST pluging do not work here. Install `Carla` for hosting plugins and audio routing - closest equivalent of `Cantabile Lite` from windows. Require pipewire to be installed and set as default.
Equivalent of Reaper's VST plugins: 

1. noise gate: x42-gate from x42 plugins
2. noise subtraction: noise-repellent, lsp-plugins. tonelib-noise-reducer. download `.deb` and install with debtap. [use this guide](https://www.baeldung.com/linux/arch-install-deb-package) 
2. EQ: x42-eq, LSP Parametric EQ, Calf EQ
3. Compressor: x42-dynamics, LSP compressor


> [!WARNING]
> Input souces and output can disappear after a disconnect - this is normal in pipewire. To solve the issue, create a virtual sink ([docs](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Virtual-Devices#create-a-sink)) and work with them in Carla. Also check out "Using LADSPA, LV2 and VST plugins" section in [arch wiki](https://wiki.archlinux.org/title/PipeWire). Oh, also read [this](https://forum.endeavouros.com/t/how-to-configure-pipewire-carla-so-that-it-remembers-the-configuration/36219/12) to know more about session issue.

```sh
# plugin host
yay -S carla 

# plugins
yay -S calf x42-plugins
sudo pacman -S noise-repellent lsp-plugins
mkdir -p ~/.config/pipewire/pipewire.conf.d/
nvim 10-default-null-sink.conf
```


TODO: add pics for both linux and windows
TODO: maybe add these sinks in dotfiles too

### sink confs

1. Create a virtual sink
2. Create a virtual source
3. link the virtual source to the real mic using `pw-link`
4. ahhhh sessions & links are not persisted by default?? need wireplumber now!?

```conf


```

```sh
systemctl --user restart pipewire
pw-link -i
pw-link -o

# find your real devices and link them - wait, don't do this - use wireplumber
pw-link alsa_input.usb-3142_fifine_Microphone-00.analog-stereo:capture_FL clean-mic-line-in:input_FL
pw-link alsa_input.usb-3142_fifine_Microphone-00.analog-stereo:capture_FR clean-mic-line-in:input_FR

```
