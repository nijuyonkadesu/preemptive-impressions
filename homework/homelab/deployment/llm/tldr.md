# Download guff model weights

- Download models of your choice and run them with llama.cpp

```sh
mkdir ~/models

uvx --from "huggingface_hub[cli]" hf download unsloth/Qwen3.8-27B-GGUF \
  --include "Qwen3.8-27B-UD-Q4_K_M.gguf" "mmproj-F16.gguf" "MTP/mtp-Qwen3.8-27B-Q4_0.gguf" \
  --local-dir ~/models/qwen3.8-27b

llama serve \
  --models-dir ~/models/ \
  --models-preset ~/models/presets.ini \
  --host 0.0.0.0 \
  --port 11434 \
  --models-max 2 \
  -t 8 \
  -tb 8 \
  -ngl 0 \
  -c $((64*1024)) \
  --sleep-idle-seconds $((5*60*60)) \
  -fa on

# Maybe add them if really needed. Sending a hi-res image blocked GPU?, while with mmproj-offload disabled, CPUs were revving for very long time.
# --no-mmproj-offload \
# --image-max-tokens 16384
```

## Sample preset.ini

```ini
# Per-model overrides for the llama.cpp router.
# Only needed here to enable the MTP draft head for Qwen3.8-27B.
[qwen3.8-27b]
model = /home/shichika/models/qwen3.8-27b/Qwen3.8-27B-UD-Q4_K_M.gguf
mmproj = /home/shichika/models/qwen3.8-27b/mmproj-F16.gguf
ctx-size = 65536
flash-attn = on
spec-type = draft-mtp
spec-draft-model = /home/shichika/models/qwen3.8-27b/MTP/mtp-Qwen3.8-27B-Q4_0.gguf

# Qwen3-TTS 0.6B - mmproj name is not "mmproj-*", so it must be set explicitly.
# Smaller ctx than the global 64k: TTS prompts are short and 64k KV is wasted RAM.
[qwen3-tts-0.6b]
model = /home/shichika/models/qwen3-tts-0.6b/Qwen3-TTS-12Hz-0.6B-Base.Q8_0.gguf
mmproj = /home/shichika/models/qwen3-tts-0.6b/Qwen3-TTS-12Hz-0.6B-Base.mmproj-Q8_0.gguf
ctx-size = 8192
flash-attn = on

# PocketTTS (Kyutai) - English, no voice cloning. 25 built-in voices live in
# the mmproj: alba anna azelma bill_boerst ... giovanni ... vera
[pocket-tts]
model = /home/shichika/models/pocket-tts/pocket-tts-english.gguf
mmproj = /home/shichika/models/pocket-tts/mmproj-pocket-tts-english.gguf
ctx-size = 4096
flash-attn = on
```

