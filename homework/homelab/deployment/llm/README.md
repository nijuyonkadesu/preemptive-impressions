# Ollama + OpenCode Setup

## 🔗 Resources

- **CPU Tierlist** (as of 2026-07-28) [→ insiderllm](https://insiderllm.com/guides/cpu-only-llms-what-actually-works/)
- **Model Recommendations for OpenCode** [→ modelfit](https://modelfit.io/tools/opencode/)

---

## 🔧 Installation & Configuration

### 1. Install Ollama (Mac / Linux / Windows)

```sh
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Configure System Service

Check the status:
```sh
systemctl status ollama
```

Edit the service to increase context length:
```sh
sudo systemctl edit ollama.service
```

Paste this override (without quotes):
```ini
[Service]
Environment="OLLAMA_CONTEXT_LENGTH=65536"
Environment="OLLAMA_KEEP_ALIVE=24h"
```

Restart Ollama server:
```sh
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

---

## 🚀 Running Models

### Qwen 2.5 (7B) - Better quality, needs 16GB+ RAM
```sh
ollama run qwen2.5:7b
>>> /show info
```

### Qwen 2.5 Coder (128K context) ⚠️ *opencode requires at least 64k*
```sh
ollama run hf.co/unsloth/Qwen2.5-Coder-7B-Instruct-128K-GGUF:Q4_K_M
>>> /show info
```

### Qwen 3.5 (27B)
```sh
ollama run qwen3.5:27b
```

Check configured context window:
```sh
ollama ps
```

---

## ⚙️ OpenCode Configuration File (~/.config/opencode/opencode.json):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "hf.co/unsloth/Qwen2.5-Coder-7B-Instruct-128K-GGUF:Q4_K_M": {},
        "qwen3-coder:30b": {},
        "qwen2.5:7b": {},
        "qwen3.5:27b": {},
        "qwen3.6:35b-a3b": {}
      }
    }
  }
}
```
