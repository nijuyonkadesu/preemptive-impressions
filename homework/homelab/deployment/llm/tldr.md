# TL;DR

This repository contains setup instructions for running local LLMs with OpenCode using Ollama. It includes installation steps, system service configuration to increase context length, and examples for running different Qwen models (7B, 128K context, 27B). The setup supports local development and testing of large language models using OpenCode's framework.

## Quick Start

1. Install Ollama: `curl -fsSL https://ollama.com/install.sh | sh`
2. Configure Ollama service to increase context length to 65536
3. Run a model: `ollama run qwen2.5:7b`
4. Configure OpenCode to use Ollama at `http://localhost:11434/v1`

## Models

- Qwen 2.5 (7B) - Better quality, needs 16GB+ RAM
- Qwen 2.5 Coder (128K context) - Required for OpenCode
- Qwen 3.5 (27B)