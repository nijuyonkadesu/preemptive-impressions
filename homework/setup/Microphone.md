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

auto-link-usb-mic.conf

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


## Easier way and sanity friendly way to setup mic: 
- Pavucontrol
- easy effects

