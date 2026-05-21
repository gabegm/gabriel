---
draft: true
title: I figured out how to run LLMs locally so you don't have to
author: Gabriel Gauci Maistre
description: A journey through the local LLM rabbit hole from ollama to pi, and everything in between.
summary: I spent weeks chasing the perfect local LLM setup on my MacBook. Here is what I learned, what broke, and what actually works.
images:
- /images/i-am-once-again-asking-for-more-ram.png
image: /images/i-am-once-again-asking-for-more-ram.png
tags:
- local-llm
- machine-learning
- mac
- ollama
- llama.cpp
- mlx
- pi
date: 2026-05-21 10:00:00 +0000
---

![alt text](/images/i-am-once-again-asking-for-more-ram.png "I am once again asking for more RAM")

I started a simple experiment: run a 32-parameter large language model locally on my MacBook M4 Pro (12-core CPU, 48GB unified memory). What started as a curiosity quickly turned into an obsessive rabbit hole of toolchains, benchmarks, broken processes, and one laptop shutdown that I am still not sure was a hardware fault or just macOS being macOS.

Here is the full story, in case you want to save yourself some of the pain.

## The beginning: ollama, qwen3.6, and opencode

My first stop was [ollama](https://ollama.com), because it is the easiest on-ramp to local LLMs. I paired it with [opencode](https://github.com/opencode-ai/opencode) and ran qwen3.6 (32B parameters). It worked, really well, honestly. The model was responsive, the code suggestions were solid, and for a moment I felt like I had cracked the code.

Then the laptop started screaming.

The fans kicked in at full speed. The battery drained in about two hours. And memory? A staggering 48GB of RAM plus 12GB of swap was being consumed, and I was getting roughly 25 tokens per second. It was cool that it worked, but it was also an incredibly inefficient way to use a laptop.

### Why was ollama so inefficient?

Under the hood, ollama acts as a Go wrapper that uses llama.cpp as its backend. On Mac machines, llama.cpp compiles down to Metal via a portable framework. But this framework traditionally treated the Mac's unified memory like a standard PC, copying data between system RAM and GPU memory banks.

This created two problems:

**Data transfer latency.** Every tensor had to be copied from system RAM into GPU memory and back. On a traditional PC with dedicated VRAM, this is the expected workflow. On Apple Silicon, where the CPU, GPU, and Neural Engine all share the same physical pool of RAM, it is a massive waste.

**Wrapper overhead.** The Go wrapper and cross-platform abstraction layer consumed up to 50% of your processing power. You were paying a tax just to talk to the model.

The result: phantom memory copies, latency, and a laptop that sounded like a jet engine for no good reason.

## Token-saving tools: rtk-ai

I discovered [rtk-ai](https://github.com/rtk-ai), a tool designed to reduce token usage by being smarter about what gets sent to the model. It was genuinely helpful, with fewer tokens meaning fewer resources. But I ran into another problem: qwen was *overthinking*. It would get stuck in reasoning loops, spinning its wheels instead of producing useful output. Disabling the "thinking" mode helped, but it felt like I was fighting the model rather than working with it.

### Why does Qwen 3.6 get stuck in reasoning loops?

Qwen 3.6 has a well-documented tendency to get stuck in reasoning loops. It endlessly second-guesses answers, repeats circular logic, or endlessly retries tool calls. This is not a bug in my setup, it is a property of the model interacting with certain environments.

Four primary drivers were identified:

**Incompatible agent/tool frameworks.** Using agent environments (like OpenCode) with Qwen can cause instability. If a tool reports an error but fails to explain why, Qwen gets confused and attempts to trigger the same tool repeatedly without altering its inputs.

**Tool calling inside reasoning blocks.** Qwen models sometimes attempt to execute tool calls natively inside their hidden `<think>` blocks. Reasoning parsers may drop this section, causing the tool call to fail and prompting the model to re-initiate the entire thought process.

**Over-restricted sampling.** Setting temperatures too low (e.g., 0.1 to 0.5) limits the model's exploratory generation. Without a higher temperature, the model struggles to break out of its own logical ruts.

**Context window fatigue.** Exhausting or maximizing the context window degrades the model's internal attention mechanism, making it much more likely to hallucinate the initial prompt and restart its reasoning cycles.

### How to mitigate the looping

Several strategies can help:

- **Adjust temperature.** Increase to around 0.7 to 0.85 to encourage the model to explore new paths when it gets stuck.
- **Anti-looping prompts.** Add explicit rules to your system prompt telling the model to commit to its best guess after one pass instead of second-guessing itself.
- **Tweak penalties.** Use a light presence penalty (e.g., 0.1 to 0.2) to deter the repetition of previous tokens.
- **Hard inference caps.** If using local inference engines like llama.cpp, configure explicit reasoning budget cut-offs to force the model to output its answer if the loop continues past a safe limit.

I went with the simplest fix: disabling the "thinking" mode entirely. It solved the looping, but it also stripped away some of Qwen's depth, which felt like a trade-off I was not always comfortable making.

## The efficiency leap: llama.cpp and MLX

I kept digging. Someone mentioned that ollama is not the most efficient backend, and that you could get better performance by going straight to [llama.cpp](https://github.com/ggerganov/llama.cpp). Fair enough. But then I heard about something even more promising: MLX versions of models that leverage Apple's Metal API, which means they actually use your GPU instead of just your CPU.

I tried [mlx_lm](https://github.com/ml-explore/mlx-lm) and the difference was noticeable. The laptop was cooler and the battery lasted longer. I was getting around 35 tokens per second with 48GB RAM plus 2GB swap. But memory was still a problem. macOS kept aggressively ejecting the process when it tried to allocate too much memory. At one point, my laptop actually shut off completely. Not a graceful exit.

### Why does MLX use the GPU instead of the CPU?

The answer lies in Apple Silicon's Unified Memory Architecture (UMA). The CPU, GPU, and Neural Engine all share exactly the same physical pool of RAM.

Traditional GPU programming involves copying tensors from system RAM into dedicated VRAM. MLX eliminates this step entirely. The GPU handles compute-heavy matrix multiplications without moving memory around, because there is no memory to move. Zero physical data transfers, zero copy penalty.

The result: drastically faster tokens per second, cooler fans, and a laptop that does not sound like it is about to take off.

### Why is omlx more memory-efficient than mlx_lm?

The technical difference is in how they manage memory:

**mlx_lm** frequently fails to deduplicate arrays, often duplicating entire transformer weights in memory when instantiating new models. This causes memory to swell during large generation tasks.

**omlx** uses advanced caching mechanisms, including a two-tier Key-Value cache, and continuous batching. It avoids loading redundant tensors and actively offloads cold cache blocks to your SSD when memory constraints are tight.

The result: mlx_lm sees memory swell and crash. omlx keeps things tight.

## The breakthrough: omlx

Then I found [omlx](https://github.com/omlx/omlx). I gave it a shot, and suddenly I was not even using the full 48GB anymore.

The laptop was cooler, battery life improved, and I was achieving roughly **47 tokens per second**. This was the sweet spot I had been searching for.

## Going deeper: the pi agent

![alt text](/images/we-need-to-go-deeper.png "We need to go deeper")

But I had already come this far. Why stop?

I discovered the [pi agent](https://github.com/pi-agent/pi), a barebones way of interacting with LLMs that saves a massive amount of tokens by cutting out all the bloat. The speed difference was incredible.

### Why does Pi save tokens?

The mechanism is called **Prefix Caching**.

Here is how it works: the LLM serving framework chops your prompt into blocks and hashes them. If you send long system instructions or extensive project references, the Key-Value (KV) tensors for those initial prompt blocks are stored and locked in memory.

On subsequent turns or follow-up queries, the model reuses the cached KV blocks instead of recalculating them. This saves both input tokens and computation costs. The more context you feed into the model, the more value you get from caching, because the heavy lifting (the system prompt, the project context) stays the same across turns.

### The unresolved issues

But here is where I hit a wall, two walls actually:

1. **No rtk-ai hook for pi.** There is an open issue on GitHub, but it is not being prioritized. So I am stuck between token-saving and not having that integration.

2. **little-coder does not play nice with omlx.** I wanted to use [little-coder](https://github.com/little-coder/little-coder), which is built on top of pi, but I could not figure out how to get it to work with omlx. So for now, I am sticking with bare pi.

If anyone has cracked either of these, I would love to hear how.

## A comparison

For anyone following along, here is a quick summary of how each toolstack performed on my M4 Pro (32B model):

| Toolstack | Memory (RAM + Swap) | Tokens/sec | Notes |
|---|---|---|---|
| ollama | 48GB + 12GB | ~25 | Fans at max, battery dies fast |
| mlx_lm | 48GB + 2GB | ~35 | Cooler, but macOS killed the process |
| omlx | < 48GB (no swap) | ~47 | Sweet spot |
| pi | even less | even faster | No rtk-ai hook, no little-coder support |

## How to replicate this

For anyone who wants to follow the same path on their own Apple Silicon Mac, here are the exact commands and configurations I used.

### Step 1: ollama

Simplest possible setup:

```
ollama run qwen3.6
```

This pulled the model, loaded it, and started serving. Expect 48GB+ RAM, 12GB swap, and roughly 25 tokens per second. Your laptop will get loud.

### Step 2: mlx_lm

I downloaded the 4-bit quantized version of the model to `~/models` and started the server:

```
mlx_lm.server \
  --model /Users/gabegm/models/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit \
  --chat-template-args '{"enable_thinking": false}'
```

Key flags:
- `--model`: path to the local 4-bit quantized MLX model
- `--chat-template-args`: disables the thinking/reasoning mode to avoid the looping problem

This served on `localhost:8080` by default. Roughly 35 tokens per second, 48GB RAM + 2GB swap. Cooler fans, but macOS still killed the process under memory pressure.

### Step 3: omlx

```
omlx serve --host 0.0.0.0 --port 8080 --model-dir ~/models
```

No extra flags needed. omlx handled the model loading, memory management, and KV caching automatically. This is where things got interesting: under 48GB RAM, no swap, and 47 tokens per second.

### Step 4: pi via omlx

To connect pi to omlx, I launched pi directly through omlx:

```
omlx launch pi \
  --model 'Qwen3.6-35B-A3B-TurboQuant-MLX-4bit' \
  --api-key 'omlx-<your-key>'
```

### Configuration

For both mlx_lm and omlx, these are the parameters I settled on:

| Parameter | Value | Purpose |
|---|---|---|
| ctx_window | 262144 | Context window size |
| max_tokens | 32768 | Maximum output tokens |
| temp | 0.7 | Temperature (balances creativity vs. focus) |
| top_p | 0.85 | Nucleus sampling threshold |
| top_k | 0 | No top-k filtering |
| min_p | 0.05 | Minimum probability threshold |
| rep_penalty | 1 | Repetition penalty |
| presence_penalty | -0.85 | Penalizes repeating previous tokens |
| enable_thinking | false | Disables reasoning loops |

### OpenCode configuration

To use the MLX-powered model inside OpenCode, I added this to my config:

```json
{
  "$schema": "https://opencode.ai",
  "provider": {
    "mlx": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "MLX (Local)",
      "options": {
        "baseURL": "http://localhost:8080/v1",
        "apiKey": "omlx-<your-key>"
      },
      "models": {
        "Qwen3.6-35B-A3B-TurboQuant-MLX-4bit": {
          "name": "Qwen3.6 35B TurboQuant (4-bit)"
        },
        "supergemma4-26b-uncensored-mlx-4bit-v2": {
          "name": "Super Gemma4 26B Uncensored Fast v2 (4-bit)"
        }
      }
    }
  }
}
```

The key insight: OpenCode uses the `@ai-sdk/openai-compatible` npm package to talk to local MLX servers over HTTP, treating them like any OpenAI-compatible API. Just point `baseURL` to your omlx server and you are good to go.

## Why this matters

I am genuinely excited about the local LLM scene. The idea that you can run these models locally, without being tied to an API, is powerful. Especially when you are on spotty internet, or when the Anthropic API goes down again, as it so often seems to.

I am not saying these local models are *better* than what Anthropic, OpenAI, or others offer. They are not. But for smaller coding tasks, they are genuinely useful. They are free as in beer. And they are getting better every day.

I definitely see a future where these models become both more efficient and more intelligent at the same time. The trajectory is there.

The future is exciting.
