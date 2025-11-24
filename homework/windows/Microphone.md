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

# 1.b. Noise Subraction (reafir)

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
