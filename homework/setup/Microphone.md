# Windows Setup
1. Install voicemeter [link](https://vb-audio.com/Voicemeeter/potato.htm) 
2. Reaper 64bit VST plugins [link](https://www.reaper.fm/reaplugs/) 
3. reboot your system
4. your sound and input devices could be messed up now, so go to sound settings and choose your defaults manually
5. Watch [this](https://www.youtube.com/watch?v=6D5zd490NoU) for demo, and [this](https://www.youtube.com/watch?v=K62rUD8sCUs) tutorial


# Notes:

## 1.a. Noise Subraction (reafir)

- Records the ambient noise, and subtracts it from the source
- Choose subtract from the dropdown

> [!CAUTION]
> Cure can be worse than the disease, if you overdo noise subtraction, by artificially making your chair creek or other common noises, you'll end up affecting the sound of your own voice. And that is not good.

## 1.b. Noise Gate (reagate)

Adjust this based on your room's noise floor. This basically cuts off audio below a certain threshold you set. 

- Attack: how quickly the gate opens, allowing your voice to be passed through. (3ms)
- Release: how quick the gate closes, cutting off ambient noise. (100ms)
- Pre-open: to avoid cutting off frontend of your words. (6ms, 2x attack)
- High-pass filter: cutoff frequencies that muddy your voice (<=70Hz)

- Wet: Processed output %
- Dry: Unprocessed output %, recommended to set this up a little, to assist with pre-open, to avoid cutting off frontend of your voice. (-25dB)

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

# Linux Setup

> [!WARNING]
> ALSA by applieds a huge gain (+21db) when I increased input volume from system settings, so run `alsamixer` and press `F6`, find your microphone, use tab, go to capture, and reduce the gain to +0. Set the microphone knob to 100%, and adjust your carla plugin gains accordingly

Linux's native format is VT2, so VST pluging do not work here. Install `Carla` for hosting plugins and audio routing - closest equivalent of `Cantabile Lite` from windows. Require pipewire to be installed and set as default., or try out [Ardour](https://www.youtube.com/watch?v=bfTAKv4htDE). 
Equivalent of Reaper's VST plugins: 

1. noise subtraction: noise-repellent ([usage guide with Ardour](https://www.youtube.com/watch?v=LeKyGoAmbFE)), lsp-plugins. (or) tonelib-noise-reducer: download `.deb` and install with debtap. [use this guide](https://www.baeldung.com/linux/arch-install-deb-package) 
2. noise gate: LSP gate
3. EQ: x42-eq, LSP Parametric EQ (x8, stereo), Calf EQ (or skip it if noise gate already supports adding low and high pass filter, if that's the only thing you're going to set)
4. Compressor: LSP compressor, x42-dynamics (reaction time should not be greater than lookahead time)


**noise-repellent mode & type of reduction explaination (opencode generated) as of 2026-03-11** 


| Index | Parameter           | Symbol          | What it does                                |
| ----- | ------------------- | --------------- | ------------------------------------------- |
| 0     | Learn noise profile | noise_learn     | Captures noise profile (0=off, 1=learn)     |
| 1     | Mode                | aggressiveness  | -100 to +100: Bias for Intelligent Steering |
| 2     | Reset noise profile | reset           | Clears captured profile                     |
| 3     | Mode                | adaptive_noise  | 0=Manual, 1=Adaptive                        |
| 4     | Type of reduction   | adaptive_method | 0=SPP-MMSE, 1=Brandt, 2=Martin              |


Looking at the enum, index 1 is AGGRESSIVENESS and index 3 is ADAPTIVE_NOISE.

File: subprojects/libspecbleach/src/shared/denoiser_logic/estimators/spp_mmse_noise_estimator.c

1.  adaptive_noise = 0 (Manual mode - original SPP-MMSE):
    - You capture a noise profile by setting noise_learn = 1
    - The plugin subtracts that captured profile from input

2.  adaptive_noise = 1 (Adaptive mode):
    - Uses one of 3 estimation algorithms selected by adaptive_method:
      - 0 = SPP-MMSE: Fast, speech-optimized
      - 1 = Brandt: Music with broadband noise (vinyl/tape)
      - 2 = Martin: General purpose, most reliable

The aggressiveness parameter (-100% to +100%) biases between Mean/Max/Min profiles in the intelligent steering.

From `lv2ttl/nrepellent-2d.ttl.in`:
lv2:default 0 ;  (for adaptive_noise)

From plugins/nrepellent-2d.c:505:
`.adaptive_noise = self->adaptive_noise ? (int)*self->adaptive_noise : 0,`

> [!NOTE]
> TODO: clean this section with findings from https://claude.ai/chat/0760cde5-4955-484e-b71d-51b7731c73b7


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

10-default-null-sink.conf
```conf
context.objects = [
    {   factory = adapter
        args = {
            factory.name     = support.null-audio-sink
            node.name        = "clean-mic-line-in"
            media.class      = Audio/Source/Virtual
            audio.position   = [ FL FR ]
            monitor.channel-volumes = true
            monitor.passthrough = true
            adapter.auto-port-config = {
                mode = dsp
                monitor = true
                position = preserve
            }
        }
    }
    {   factory = adapter
        args = {
            factory.name     = support.null-audio-sink
            node.name        = "clean-mic-line-out"
            media.class      = Audio/Sink
            audio.position   = [ FL FR ]
            monitor.channel-volumes = true
            monitor.passthrough = true
            adapter.auto-port-config = {
                mode = dsp
                monitor = true
                position = preserve
            }
        }
    }
]
```

TODO: add pics for both linux and windows
TODO: maybe add these sinks in dotfiles too

### Overall steps

1. Create a virtual sink
2. Create a virtual source
3. link the virtual source to the real mic using `pw-link`
4. ahhhh sessions & links are not persisted by default?? need wireplumber now!?


```sh
systemctl --user restart pipewire
pw-link -i
pw-link -o

# find your real devices and link them - wait, don't do this - use wireplumber
pw-link alsa_input.usb-3142_fifine_Microphone-00.analog-stereo:capture_FL clean-mic-line-in:input_FL
pw-link alsa_input.usb-3142_fifine_Microphone-00.analog-stereo:capture_FR clean-mic-line-in:input_FR

# wiki: https://wiki.archlinux.org/title/WirePlumber
# list all pipewire managed objects - sources, sinks, etc, find the ID, and use it in inspect command
wpctl status
wpctl inspect 98
# note down `node.nick = "fifine Microphone"` or some other property for wireplumber matching

# check default wireplumber .lua files under /usr/share/wireplumber/scripts/linking/
mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
nvim ~/.config/wireplumber/wireplumber.conf.d/auto-link-usb-mic.conf

# paste the conf contents & restart wireplumber or, run wpexec manually
wpexec ~/.config/wireplumber/scripts/auto-link-usb-mic.lua

systemctl --user restart wireplumber.service 

# try qpwgraph on the side to visualize the links, and see if lua script actually works
sudo pacman -S qpwgraph
```

auto-link-usb-mic.lua
```lua
-- Make links GLOBAL (remove 'local') so they persist!
r_link = nil
l_link = nil
mic_node = nil
target_node = nil

-- Simplified: Match by media class and check node name in the callback
mic_om = ObjectManager {
    Interest {
        type = "node",
        Constraint { "media.class", "equals", "Audio/Source" },
    }
}

target_om = ObjectManager {
    Interest {
        type = "node",
        Constraint { "node.name", "matches", "clean-mic-line-in" },
    }
}

-- ObjectManager to monitor existing links
link_om = ObjectManager {
    Interest {
        type = "link"
    }
}

function checkAndLink()
    -- Check if links already exist and are valid
    if l_link and l_link["bound-id"] and l_link["bound-id"] ~= -1 and
       r_link and r_link["bound-id"] and r_link["bound-id"] ~= -1 then
        print("Fifine Script: Links already exist (created by us), skipping...")
        return
    end

    if mic_node and target_node then
        local mic_id = mic_node["bound-id"]
        local target_id = target_node["bound-id"]
        
        if not mic_id or not target_id then
            print("Fifine Script: Nodes not bound yet...")
            return
        end
        
        -- CHECK IF LINKS ALREADY EXIST between these nodes!
        local existing_link_count = 0
        for link in link_om:iterate() do
            local out_node = tonumber(link.properties["link.output.node"])
            local in_node = tonumber(link.properties["link.input.node"])
            if out_node == mic_id and in_node == target_id then
                existing_link_count = existing_link_count + 1
                print("Fifine Script: Found existing link between nodes!")
            end
        end
        
        if existing_link_count >= 2 then
            print("Fifine Script: Both stereo links already exist (created elsewhere), nothing to do!")
            return
        end
        
        print("Fifine Script: Nodes confirmed.")
        print("   > Source: " .. (mic_node.properties["node.nick"] or mic_node.properties["node.name"]))
        print("   > Target: " .. target_node.properties["node.name"])
        print("   > Existing links: " .. existing_link_count .. "/2")
        print("   > Action: Creating " .. (2 - existing_link_count) .. " link(s)...")

        -- Only create links we need
        if existing_link_count < 1 then
            l_link = Link("link-factory", {
                ["link.output.node"] = mic_id,
                ["link.input.node"] = target_id,
                ["object.linger"] = 1
            })
            
            -- Use simple activation without callback!
            l_link:activate(1)
            print("Link #1 created and activated")
        end
        
        if existing_link_count < 2 then
            r_link = Link("link-factory", {
                ["link.output.node"] = mic_id,
                ["link.input.node"] = target_id,
                ["object.linger"] = 1
            })
            
            -- Use simple activation without callback!
            r_link:activate(1)
            print("Link #2 created and activated")
        end
    else
        local mic_status = mic_node and "Found" or "MISSING"
        local target_status = target_node and "Found" or "MISSING"
        print("Fifine Script: Waiting... Mic: [" .. mic_status .. "] | Target: [" .. target_status .. "]")
    end
end

target_om:connect("object-added", function(_, node)
    print("Target added: " .. node.properties["node.name"])
    target_node = node
    checkAndLink()
end)

target_om:connect("object-removed", function(_, node)
    if target_node == node then
        print("Target removed: " .. node.properties["node.name"])
        target_node = nil
        l_link = nil
        r_link = nil
    end
end)

mic_om:connect("object-added", function(_, node)
    local node_name = node.properties["node.name"] or "UNNAMED"
    print("Mic OM caught: " .. node_name)
    
    -- Only set mic_node if it matches our Fifine mic
    if node_name:match("3142_fifine_Microphone") then
        print("Mic added: " .. (node.properties["node.nick"] or node.properties["node.name"]))
        mic_node = node
        checkAndLink()
    end
end)

mic_om:connect("object-removed", function(_, node)
    if mic_node == node then
        print("Mic removed: " .. (node.properties["node.nick"] or node.properties["node.name"]))
        mic_node = nil
        l_link = nil
        r_link = nil
    end
end)

-- Add debug logging to see ALL nodes
debug_om = ObjectManager {
    Interest {
        type = "node",
        Constraint { "media.class", "equals", "Audio/Source" }
    }
}

debug_om:connect("object-added", function(_, node)
    print("DEBUG: Audio source node added: " .. (node.properties["node.name"] or "UNNAMED"))
end)

debug_om:activate()
link_om:activate()
target_om:activate()
mic_om:activate()

-- CRITICAL: Check for nodes that ALREADY EXIST before the script loaded!
Core.sync(function()
    print("Fifine Script: Checking for existing nodes after activation...")
    
    -- Check if target already exists
    for target in target_om:iterate() do
        if not target_node then
            print("Found existing target: " .. target.properties["node.name"])
            target_node = target
        end
    end
    
    -- Check if mic already exists
    for node in mic_om:iterate() do
        local node_name = node.properties["node.name"] or "UNNAMED"
        if node_name:match("3142_fifine_Microphone") and not mic_node then
            print("Found existing mic: " .. node_name)
            mic_node = node
        end
    end
    
    -- Try to link if both exist
    checkAndLink()
end)

print("Fifine Script: Loaded and monitoring for nodes...")
```

logs, proof of working:
```log
Dec 05 01:49:45 sus wireplumber[140293]: wp-device: SPA handle 'api.libcamera.enum.manager' could not be loaded; is it installed?
Dec 05 01:49:45 sus wireplumber[140293]: s-monitors-libcamera: PipeWire's libcamera SPA plugin is missing or broken. Some camera types may not be supported.
Dec 05 01:49:45 sus wireplumber[140293]: Fifine Script: Loaded and monitoring for nodes...
Dec 05 01:49:45 sus wireplumber[140293]: Target added: clean-mic-line-in
Dec 05 01:49:45 sus wireplumber[140293]: Fifine Script: Waiting... Mic: [MISSING] | Target: [Found]
Dec 05 01:49:45 sus wireplumber[140293]: Fifine Script: Checking for existing nodes after activation...
Dec 05 01:49:45 sus wireplumber[140293]: Fifine Script: Waiting... Mic: [MISSING] | Target: [Found]
Dec 05 01:49:45 sus wireplumber[140293]: DEBUG: Audio source node added: alsa_input.pci-0000_05_00.6.analog-stereo
Dec 05 01:49:45 sus wireplumber[140293]: Mic OM caught: alsa_input.pci-0000_05_00.6.analog-stereo
Dec 05 01:49:50 sus wireplumber[140293]: DEBUG: Audio source node added: alsa_input.usb-3142_fifine_Microphone-00.analog-stereo
Dec 05 01:49:50 sus wireplumber[140293]: Mic OM caught: alsa_input.usb-3142_fifine_Microphone-00.analog-stereo
Dec 05 01:49:50 sus wireplumber[140293]: Mic added: fifine Microphone
Dec 05 01:49:50 sus wireplumber[140293]: Fifine Script: Nodes confirmed.
Dec 05 01:49:50 sus wireplumber[140293]:    > Source: fifine Microphone
Dec 05 01:49:50 sus wireplumber[140293]:    > Target: clean-mic-line-in
Dec 05 01:49:50 sus wireplumber[140293]:    > Existing links: 0/2
Dec 05 01:49:50 sus wireplumber[140293]:    > Action: Creating 2 link(s)...
Dec 05 01:49:50 sus wireplumber[140293]: Link #1 created and activated
Dec 05 01:49:50 sus wireplumber[140293]: Link #2 created and activated
```

51-usb-mic-autoconnect.conf
```conf
-- auto link USB mic to virtual source automatically, and wireplumber remembers it
-- hindsight, not remember, it reconnects everytime 🤓
wireplumber.components = [
  {
    name = /home/guts/.config/wireplumber/scripts/auto-link-usb-mic.lua 
    type = script/lua
    provides = custom.auto-link-usb-mic
  }
]

wireplumber.profiles = {
  main = {
    custom.auto-link-usb-mic = required
  }
}
```

> [!WARNING]
> wireplumber docs: [link](https://lira.epac.to/DOCS/wireplumber/html/scripting/lua_api/lua_object_interest_api.html), [another-link](https://pipewire.pages.freedesktop.org/wireplumber/policies/linking.html)  


## Easier way and sanity friendly way to setup mic: 
- Pavucontrol
- easy effects


---

# Q: how to make your voice sound fuller, rich in texture?

## [TODO] Iteration 1
The technique you're looking for is called **harmonic excitation / presence enhancement**. Your voice sounds "fuller" because they're adding saturation (subtle harmonic distortion) and EQ shaping that emphasizes the presence band (~2-5 kHz) and rounds out the low-mids (~100-300 Hz).
Add these two plugins to your chain (after compressor, before output):

1. LSP Parametric EQ Stereo — boost ~100-150 Hz by 2-4 dB (warmth), cut 300-500 Hz by 1-2 dB (mud), boost 2-4 kHz by 2-3 dB (presence/definition), gentle shelf at 8-10 kHz (air)
2. LSP Exciter Stereo — adds even-order harmonics that make the voice feel "rich" without being louder. Low mix, high-frequency band only.

Your current chain has no EQ or saturation, so it sounds flat/clinical. Those two plugins will give you that "fuller" texture you're hearing.

## [TODO] Iteration 2

It's both talent AND heavy processing. Anime VA recordings go through much more than a simple mic chain — they're mixed like an instrument.
What they do (studio-grade):

- Multiband compression — not just a single compressor. Different frequency bands compressed independently (e.g., LSP Multiband Compressor). This gives that tight, controlled sound.
- De-esser — tames harsh sibilance so they can boost highs without it sounding painful.
- EQ shaping — huge low-mid scoop around 300-500 Hz (anime voices are intentionally "thin" in some ranges to cut through), then big boosts at presence bands.
- Parallel compression — blend a slammed copy of the voice underneath the clean signal (New York compression). Adds body without making every word pump.
- Subtle reverb — short room/hall, mixed very low. You don't hear it as reverb, just a sense of space/depth.
- Pitch correction/formant shifting — some intentionally brighten the formants slightly (makes voice sound younger/more "anime").

**Search terms to learn:**

- "anime voice acting mixing techniques"
- "voice over parallel compression"
- "presence and air EQ for voice"
- "vocal multiband compression"
- "formant shifting voice"
- "broadcast voice chain (de-esser -> compressor -> limiter -> exciter)"
- "seiyuu recording setup / 声優 録音 機材"
- "LPF and HPF for voice clarity"

**Start with multiband compressor + de-esser + exciter in Carla, and you'll get 80% of the way there.**

---

Same but for english: No, the techniques stay the same. The only difference is frequency targets shift slightly:

- English sibilance lives higher (~6-8 kHz) than Japanese (~4-6 kHz), so your de-esser frequency changes.
- English voices benefit more from a presence boost at 3-5 kHz (consonant clarity) rather than the upper-mid push anime uses.
- Low-end warmth (100-200 Hz) matters more for English deep/authoritative tone.
Everything else — multiband comp, parallel comp, exciter/saturation, short reverb, formant shifting — is identical. Just tweak the EQ points by ear for your voice.

## [TODO] Iteration 3 - to conditionally enable / disable chain of effects

Carla supports MIDI CC mapping on plugin parameters. You can assign a keyboard key or MIDI button to toggle plugin wet/dry without touching the patchbay.
For #2 (toggle parallel excitation):
Put the parallel chain (exciter + saturator) in series after the compressor, but crank up its dry/wet mix. Map a MIDI CC to that mix parameter: 0% = dry (off), 100% = full effect. Carla remembers the CC mapping. One button press, done.

For #3 (voice-activated loop):
This is a bit trickier. You can:
- Use the LSP Gate Stereo you already have — its sidechain/envelope follower can trigger a gate on the loop track. Route your voice as sidechain to a gate on the loop. When you speak, gate opens → loop plays. Not perfect but works in pure Carla.
- Or run a small external script that watches for voice activity and sends MIDI CC to Carla. Tools: jack-midi-clock, csound, or a simple Python script with python-rtmidi.
Simplest approach: Use Carla's parameter automation lanes. Record a button press as automation to toggle the parallel chain. No routing headaches

### keybind: MIDI setup workaround
Most seamless options for your Wayland setup:
1. Carla's built-in keyboard (easiest, no extra software) — click the keyboard icon in Carla toolbar. Click any key → it sends MIDI. Map that to your plugin's wet/dry parameter via MIDI learn. Just click a key on screen whenever you want the effect.
2. vmpk (Virtual MIDI Piano Keyboard) — runs alongside Carla, can be minimized. It maps PC keyboard keys to MIDI notes (Z-M, Q-U etc.). Set it to output on the same MIDI bus, assign a note to toggle your effect.
3. Best for your use case: Carla LADSPA "midi through" trick — Add a MIDI CC controller plugin (like MIDI CC to Audio or similar). You can route a simple button in Carla's own patchbay without needing external MIDI at all — just automate the parameter directly in the Carla sequence.

Practical recommendation: Open Carla → go to the plugin's parameter → right-click → "MIDI Learn" → then open Carla's built-in keyboard (View → Keyboard). Tap any key on that virtual keyboard. Done. No external tools, no Wayland issues, no routing nightmares.

[TODO] clean up once all is setup and finalized


## Software female voice: [TODO] LMFAO, it would be hilarious, but fun

Yes, but not with simple EQ/compression — those only make it sound like a man with a thin voice. The key is formant shifting, not pitch shifting.
What you need:
- Pitch shift (~+4 to +7 semitones) — raises fundamental frequency
- Formant shift — shifts the resonant peaks of your vocal tract independently. This is what actually changes perceived gender. Without it, you just sound like Alvin and the Chipmunks.
- Vocal tract length normalization — shortens the perceived vocal tract length.
Linux plugins that can do this:
- ZynAddSubFX or Calf Monosynth (formant filter) — partial
- Rubber Band (LV2 version: rubberband-lv2) — can do pitch+formant separately
- Autotalent or Zita-at1 (autotune with formant)
- Sox (command-line) — pitch + bend but not real-time
- Real-time solution: Rakarrack (LV2) — has a robust pitch shifter with formant preservation/alteration
- LSP Pitch Shifter Stereo — shift pitch but it doesn't independently control formants well
The hard truth: Free Linux LV2 plugins for realistic gender transformation are limited. People doing realistic real-time voice feminization either use:
- Windows VSTs via yabridge (e.g., Little AlterBoy, Pitchproof, Melda MAutoPitch)
- Dedicated voice changers like Clownfish (Windows, yabridge) or Voicemod
- AI-based: RVC (Retrieval-based Voice Conversion) — real-time now possible on Linux, highest quality but needs GPU
Search terms:
- "formant shifting Linux LV2"
- "voice gender transformation EQ formant"
- "RVC voice changer Linux real-time"
- "yabridge Little AlterBoy"
- "vocal tract length normalization"
- "spectral envelope shifting"
With just LV2 plugins under Carla, you can get an androgynous sound but not a fully convincing female voice. For that, you need yabridge+VSTs or AI-based conversion.

