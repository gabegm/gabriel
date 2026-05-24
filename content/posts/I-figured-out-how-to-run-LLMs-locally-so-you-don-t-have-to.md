---
draft: false
unlisted: true
title: I figured out how to run LLMs locally so you don't have to
author: Gabriel Gauci Maistre
description: A journey through the local LLM rabbit hole from ollama to pi, and everything in between.
summary: I spent weeks chasing the perfect local LLM setup on my MacBook. Here is what I learned, what broke, and what actually works.
images:
- /images/ai-ai-ai.jpg
image: /images/ai-ai-ai.jpg
tags:
- local-llm
- machine-learning
- mlx
date: 2026-05-21 10:00:00 +0000
---

I wanted a coding model that worked on a flight without destroying my laptop battery.

What I got was a weeks-long rabbit hole through toolchains, benchmarks, broken processes, and one laptop shutdown that I eventually traced to a kernel panic under extreme memory pressure. Here is the full story, in case you want to save yourself some of the pain.

## TL;DR

On my M4 Pro (12-core CPU, 48GB unified memory), running a Qwen3.6-35B-A3B model (35B total parameters, 3B active per token) locally:

- **Ollama** was the easiest but least efficient: ~25 tokens/sec, 48GB RAM + 12GB swap, fans at max.
- **MLX (mlx_lm)** was a step up: ~35 tokens/sec, 48GB RAM + 2GB swap, but macOS killed the process under memory pressure.
- **omlx** was the first setup I could imagine using regularly: ~47 tokens/sec, under 48GB RAM, no swap, cool laptop.
- **pi** via omlx (with recent optimizations): ~70 tokens/sec, under 48GB RAM, no swap, cool laptop (see below for what I changed).

## Hardware and model tested

- **MacBook**: M4 Pro, 12-core CPU, 48GB unified memory
- **Model**: Qwen3.6-35B-A3B-TurboQuant-MLX-4bit (35B total parameters, 3B active per token, a Mixture-of-Experts model)
- **macOS**: Tahoe 26.5 (updated during experiments)
- **Model format**: 4-bit quantized MLX, downloaded via `huggingface-cli`
- **Companion model** (for speculative decoding): Qwen3.5-0.8B, 4-bit quantized (mlx-community variant)

## Benchmark table

| Toolstack | Memory (RAM + Swap) | Tokens/sec | Notes |
|---|---|---|---|
| ollama | 48GB + 12GB | ~25 | Fans at max, battery dies fast |
| mlx_lm | 48GB + 2GB | ~35 | Cooler, but macOS killed the process |
| omlx | < 48GB (no swap) | ~47 | Sweet spot (initial config) |
| pi (optimized) | < 48GB (no swap) | ~70 | Recent optimizations (see below) |

**Methodology notes**: These numbers are decode tokens per second, measured on a single continuous generation of roughly 2,000 tokens, with a short system prompt (~500 tokens). Benchmarks were taken on macOS Tahoe 26.5 with the laptop plugged in, on performance power mode. They are anecdotal. Your mileage will vary based on model quant, context length, prompt size, and what else is running on your machine.

## What worked and what failed

### What worked

- Running a 35B-parameter MoE model locally on 48GB RAM
- omlx delivering ~47 tokens/sec with no swap usage (initial config)
- pi reaching ~70 tokens/sec after recent oMLX admin optimizations
- Prefix caching in pi saving recomputation on follow-up turns

### What failed

- Ollama was the easiest but least efficient path. I do not want to overstate the root cause: Ollama, llama.cpp, MLX, quantization format, cache behavior, and context length all affect performance. What I can say confidently is that, on this MacBook and this model, the MLX/oMLX path used less swap and produced more tokens per second.
- mlx_lm crashed under memory pressure. macOS sent a SIGKILL to the process, and under enough pressure, the kernel panicked the whole system. I suspect memory pressure contributed, but I did not prove the root cause. Updating to the latest macOS and MLX seemed to fix it.
- No rtk-ai integration with pi (open GitHub issue, not prioritized)
- little-coder does not work with omlx

## How to replicate this

For anyone who wants to follow the same path on their own Apple Silicon Mac, here are the exact commands and configurations I used.

### Step 0: Downloading the model

Before any of the above, I needed the model on disk. I used `huggingface-cli` to download the 4-bit quantized MLX version:

```
hf download majentik/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit --local-dir ~/models/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit
```

### Step 1: ollama

Simplest possible setup:

```
ollama run qwen3.6
```

This pulled the model, loaded it, and started serving. Expect 48GB+ RAM, 12GB swap, and roughly 25 tokens per second. Your laptop will get loud.

### Step 2: mlx_lm

With the model already downloaded, I started the server:

```
mlx_lm.server \
  --model /Users/gabegm/models/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit \
  --chat-template-args '{"enable_thinking": false}'
```

Key flags:
- `--model`: path to the local 4-bit quantized MLX model
- `--chat-template-args`: disables the thinking/reasoning mode to avoid the looping problem

This served on `localhost:8080` by default. Roughly 35 tokens per second, 48GB RAM + 2GB swap. Cooler fans, but macOS still killed the process under memory pressure. At this stage, thinking mode was disabled via `--chat-template-args`.

### Step 3: omlx

```
omlx serve --host 0.0.0.0 --port 8080 --model-dir ~/models
```

No extra flags needed. Omlx handled the model loading, memory management, and KV caching automatically. I watched Activity Monitor and saw swap drop to zero, RAM settle around 42GB, and the fans finally stop screaming. 47 tokens per second.

### Step 4: pi via omlx

To connect pi to omlx, I launched pi directly through omlx:

```
omlx launch pi \
  --model 'Qwen3.6-35B-A3B-TurboQuant-MLX-4bit' \
  --api-key 'omlx-<your-key>'
```

### Later oMLX optimizations

Since writing the original version of this post, I made several adjustments in the oMLX Web Admin that pushed pi past 70 tokens/sec. I do not know the exact technical reason each change helped, but here is what I changed and what I observed:

- **SpecPrefill: OFF.** I noticed the engine was cutting markdown files and codebases in half, which caused text-corruption looping errors. Turning this off stopped the corruption.
- **TurboQuant KV Cache: 8-bit.** I forced 8-bit cache structures to maintain stability at the full 262K context window. The default 4-bit MoE cache had what looked like a slowdown bug in my setup[[14]](#f14).
- **DFlash speculative decoding.** I downloaded a companion model using `hf download mlx-community/Qwen3.5-0.8B-MLX-4bit --local-dir ~/models/Qwen3.5-0.8B-MLX-4bit`, and hooked it up as a lightweight Qwen3.5-0.8B companion model (4-bit quantized) to boost generation speed via speculative decoding[[13]](#f13). I observed roughly 2x speed on longer outputs without degrading accuracy.
- **froggeric v19 Jinja template.** I replaced the official Qwen template with a C++ native .jinja variant ([froggeric v19 on GitHub](https://github.com/froggeric/qwen3-jinja/blob/main/qwen3.jinja))[[15]](#f15). I observed fewer empty thinking stalls and better KV cache hit rates.
- **tool_format: json.** I configured the chat template kwargs to return standard JSON data payloads, aligning the model's tool outputs with pi's CLI parser.

These are my observations from my setup. Your mileage may vary, and I have not profiled each change individually. Note: the pi (optimized) row in the benchmark table is not apples-to-apples with the earlier rows because it includes speculative decoding and several admin-level oMLX changes. The earlier rows used a baseline configuration without those optimizations.

### Configuration

For both mlx_lm and omlx, these are the parameters I settled on:

| Parameter | Value | Purpose |
|---|---|---|
| ctx_window | 262144 | Context window size[[9]](#f9) |
| max_tokens | 32768 | Maximum output tokens |
| temp | 0.4 | Temperature (lower for coding precision)[[10]](#f10) |
| top_p | 0.9 | Nucleus sampling threshold[[11]](#f11) |
| top_k | 0 | No top-k filtering |
| min_p | 0.05 | Minimum probability threshold |
| rep_penalty | 1 | Repetition penalty[[12]](#f12) |
| presence_penalty | 0.1 | Light penalty on repeating tokens |
| enable_thinking | true | Re-activated CoT tracking (after the pi optimizations) |
| tool_format | json | Forces JSON tool output payloads |

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

## Technical notes and caveats

### Why I went local

The cloud alternatives kept letting me down. APIs went down. I ran out of tokens mid-project. I was on a flight from Munich to London for Devoxx with no internet and realised I could not work without a connection. The more we come to rely on these services, the less productive we are the moment they go dark. Local models remove that single point of failure.

### Is this for you?

Local LLMs are not for everyone. Before you follow along, ask yourself these questions:

**Do you have Apple Silicon?** This entire journey is Apple Silicon-specific. MLX, omlx, and unified memory architecture[[1]](#f1) are the reason this works. On an Intel Mac or a PC with a dedicated GPU, the story is different and this article is not your guide.

**Do you have 32GB of RAM or more?** You are not going to run a 35B model on 16GB. The 48GB on my M4 Pro was the floor, not the ceiling. 32GB can run a 35B 4-bit model, but it leaves limited overhead for anything else. Browsing, terminal, or background processes will compete for memory, so 48GB is the practical sweet spot. If you have less, you will need a smaller model and fewer tokens per second.

**Are you okay with "good enough"?** These models are not GPT-5 or Claude. They will make mistakes. They will hallucinate. My setup once triggered a kernel panic under memory pressure. But for smaller coding tasks, they are genuinely useful. If you need a coding buddy on a plane ride, go local.

**Do you value privacy?** No data leaves your machine. Your own model, your own rules. If any of that matters to you, local LLMs are worth exploring.

**Are you comfortable with a terminal?** You need to be comfortable running commands, managing files, and troubleshooting. If that scares you, start with ollama and work your way up. It is the easiest on-ramp and you can always go deeper later.

### My journey through the toolchains

My first stop was [ollama](https://ollama.com), because it is the easiest on-ramp to local LLMs. I paired it with [opencode](https://opencode.ai/) and ran qwen3.6 (35B parameters, 3B active per token). It worked, really well, honestly. The model was responsive, the code suggestions were solid, and for a moment I felt like I had cracked the code.

Then the laptop started screaming. The fans kicked in at full speed. The battery drained in about two hours. And memory? A staggering 48GB of RAM plus 12GB of swap[[2]](#f2) was being consumed, and I was getting roughly 25 tokens per second[[3]](#f3). It was cool that it worked, but it was also an incredibly inefficient way to use a laptop.

I do not know the exact cause of the inefficiency, but on this MacBook and this model, the Ollama setup used more swap and produced fewer tokens per second than the MLX/oMLX path. Ollama, llama.cpp, MLX, quantization format, cache behavior, and context length all affect performance. I can only report what I observed.

I discovered [rtk-ai](https://www.rtk-ai.app/), a tool designed to reduce token usage by being smarter about what gets sent to the model. It was genuinely helpful, with fewer tokens meaning fewer resources. But I ran into another problem. Qwen was *overthinking*. It would get stuck in reasoning loops, spinning its wheels instead of producing useful output.

### Why does Qwen 3.6 get stuck in reasoning loops?

From my own experience, I observed Qwen 3.6 getting stuck in reasoning loops under certain conditions. It endlessly second-guesses answers, repeats circular logic, or endlessly retries tool calls. This is not necessarily a bug in my setup. It seems to be a property of the model interacting with certain environments.

From what I could piece together, a few factors seem to contribute:

**Incompatible agent/tool frameworks.** Using agent environments (like OpenCode) with Qwen can cause instability. If a tool reports an error but fails to explain why, Qwen gets confused and attempts to trigger the same tool repeatedly without altering its inputs.

**Tool calling inside reasoning blocks.** Qwen models sometimes attempt to execute tool calls natively inside their hidden `<think>` blocks. Reasoning parsers may drop this section, causing the tool call to fail and prompting the model to re-initiate the entire thought process.

**Over-restricted sampling.** Setting temperatures too low (e.g., 0.1 to 0.5) limits the model's exploratory generation. Without a higher temperature, the model struggles to break out of its own logical ruts.

**Context window fatigue.** Exhausting or maximizing the context window[[9]](#f9) degrades the model's internal attention mechanism, making it much more likely to hallucinate the initial prompt and restart its reasoning cycles.

### How to mitigate the looping

Several strategies helped in my testing:

- **Adjust temperature.** Increase to around 0.7 to 0.85 to encourage the model to explore new paths when it gets stuck.
- **Anti-looping prompts.** Add explicit rules to your system prompt telling the model to commit to its best guess after one pass instead of second-guessing itself.
- **Tweak penalties.** Use a light presence penalty (e.g., 0.1 to 0.2) to deter the repetition of previous tokens.
- **Hard inference caps.** If using local inference engines like llama.cpp, configure explicit reasoning budget cut-offs to force the model to output its answer if the loop continues past a safe limit.

I went with the simplest fix: disabling the "thinking" mode entirely (via `--chat-template-args`). It solved the looping, but it also stripped away some of Qwen's depth, which felt like a trade-off I was not always comfortable making.

Later, after the pi optimizations, I re-enabled thinking mode by updating the pi config to use the froggeric v19 template and adjusting the tool format. The template changes resolved the looping issues, so thinking mode could be safely turned back on.

### The efficiency leap: MLX and omlx

I kept digging. Someone mentioned that ollama is not the most efficient backend, and that you could get better performance by going straight to [llama.cpp](https://github.com/ggerganov/llama.cpp). Fair enough. But then I heard about MLX versions of models that leverage Apple's Metal API.

I tried [mlx_lm](https://github.com/ml-explore/mlx-lm) and the difference was noticeable. The laptop was cooler and the battery lasted longer. I was getting around 35 tokens per second with 48GB RAM plus 2GB swap. But memory was still a problem. macOS kept aggressively ejecting the process when it tried to allocate too much memory. At one point, my laptop actually shut off completely. Not a graceful exit.

In my case, when MLX tried to allocate more memory than macOS would allow, the OS sent a SIGKILL to the process. Under enough pressure, the kernel panicked the whole system. It was a kernel panic, not a hardware-level crash. I later updated to the latest macOS and MLX, and the crash never happened again. The fix was simply staying within memory headroom and keeping the model quantized at 4-bit[[5]](#f5).

The answer lies in Apple Silicon's Unified Memory Architecture (UMA)[[1]](#f1). The CPU, GPU, and Neural Engine all share exactly the same physical pool of RAM.

Traditional GPU programming involves copying tensors from system RAM into dedicated VRAM. MLX eliminates this step entirely. The GPU handles compute-heavy matrix multiplications without moving memory around, because there is no memory to move. Zero physical data transfers, zero copy penalty.

### Why omlx behaved better than mlx_lm

Then I found [omlx](https://omlx.ai/). I gave it a shot, and suddenly I was not even using the full 48GB anymore.

I watched Activity Monitor: RAM settled around 42GB, swap hit zero, and the fans stopped their constant high-RPM whine. I was achieving roughly **47 tokens per second** (initial config). This was the first setup I could imagine using regularly.

### Why pi is efficient

I discovered the [pi agent](https://pi.dev/), which sends leaner prompts than OpenCode because it does not wrap every interaction in tool-calling boilerplate. The speed difference was noticeable right away.

It also benefits from **Prefix Caching** in the underlying MLX serving framework: the framework chops your prompt into blocks, hashes them, and stores the resulting Key-Value (KV) tensors in memory. On subsequent turns that reuse the same system prompt or project context, the model skips the heavy computation and reuses the cached blocks. This saves recomputation, reduces time-to-first-token, and lowers latency.

With the recent oMLX optimizations (speculative decoding, 8-bit KV cache, froggeric template), pi pushed past 70 tokens/sec, roughly double the initial omlx number. I did not expect that jump.

## Open problems

But here is where I hit a wall, two walls actually:

1. **No rtk-ai hook for pi.** There is an open issue on GitHub, but it is not being prioritized. So I am stuck between token-saving and not having that integration.

2. **little-coder does not play nice with omlx.** I wanted to use [little-coder](https://github.com/itayinbarr/little-coder), which is built on top of pi, but I could not figure out how to get it to work with omlx. So for now, I am sticking with bare pi.

If anyone has cracked either of these, I would love to hear how.

## Conclusion

I started this because I wanted a coding assistant on a plane. I ended up with one, but it took more yak-shaving than I expected.

Here is where each toolstack landed:

- **Ollama** works out of the box. 48GB RAM, 12GB swap, noisy fans, and 25 tokens per second. Great for getting started, not for serious work.
- **MLX (via mlx_lm)** was a step up. Cooler fans, 35 tokens per second, less swap. But memory management was rough, and macOS would kill the process (or in one extreme case, the kernel would panic and shut the laptop down) under pressure.
- **omlx** got me to 47 tokens per second (initial config), under 48GB, no swap, and a laptop that actually stayed cool.
- **pi (optimized)** got me to ~70 tokens per second, under 48GB, no swap, cool laptop. This required several oMLX admin tweaks: speculative decoding, 8-bit KV cache, a custom Jinja template. Note: this row is not apples-to-apples with the earlier rows because it includes speculative decoding and admin-level changes.

The laptop crash that haunted my MLX experiments was a kernel panic under extreme memory pressure. I was never able to pin down the exact cause, but I was able to solve it by finding efficiency gains where possible. The lesson: stay within memory headroom, keep your model quantized, and do not be afraid to tweak the oMLX admin settings.

---

* <a name="f0">[0]</a> Parameters are the adjustable weights inside a neural network that determine how it processes input. A 35B model (like Qwen3.6-35B-A3B) has 35 billion total parameters, but because it is a Mixture-of-Experts model, only about 3 billion are active per token. This is what makes it possible to run on 48GB of RAM.
* <a name="f1">[1]</a> Unified memory (or unified memory architecture, UMA) is Apple Silicon's approach of giving the CPU, GPU, and Neural Engine access to the same pool of physical RAM, instead of separate memory banks. This eliminates the need to copy data between CPU and GPU memory, which is the single biggest performance advantage for running LLMs locally.
* <a name="f2">[2]</a> Swap is when macOS runs out of physical RAM and starts using your SSD as scratch space. It is orders of magnitude slower than RAM, which is why your tokens-per-second drops through the floor when swap kicks in.
* <a name="f3">[3]</a> Tokens are the basic units of text that an LLM processes. Roughly a word, or a fraction of a word. A 1,000-word article is roughly 1,300 to 1,500 tokens. When you see "32,768 tokens" in a config, that is the maximum output the model will generate in a single response.
* <a name="f4">[4]</a> Metal is Apple's low-level graphics API, similar to OpenGL or Vulkan, that gives programs direct access to the GPU. On Apple Silicon, Metal is the bridge that lets MLX-based tools actually use your GPU for compute instead of just your CPU.
* <a name="f5">[5]</a> 4-bit quantization is a compression technique that reduces the precision of a model's weights from 16 bits (standard) down to 4 bits. A 35B 4-bit model takes roughly 18GB of RAM instead of 64GB. The quality loss is small enough that most people cannot tell the difference.
* <a name="f6">[6]</a> Key-Value (KV) cache stores the attention tensors from previous tokens so the model does not need to recompute them on every new token. Without a KV cache, every new token requires re-reading the entire conversation history. With one, the model only computes the new token.
* <a name="f7">[7]</a> Continuous batching is a serving technique where multiple user requests are processed together in a single forward pass, rather than one at a time. This dramatically improves throughput when multiple people are using the same model server.
* <a name="f8">[8]</a> Prefix caching works by chopping your prompt into blocks, hashing them, and storing the resulting KV tensors in memory. On follow-up queries that reuse the same system prompt or project context, the model skips the heavy computation and reuses the cached blocks. The more context you feed the model, the more value you get from caching.
* <a name="f9">[9]</a> Context window is the maximum amount of text (in tokens) the model can "remember" at once. That includes both the input you send and the output it generates. A 262,144 context window is roughly 200,000 words, which is larger than most novels.
* <a name="f10">[10]</a> Temperature controls how random the model's output is. A temperature of 0.0 always picks the most likely next token (deterministic). A temperature of 1.0 samples from the full probability distribution (creative). 0.7 is a common middle ground.
* <a name="f11">[11]</a> Nucleus sampling (top_p) is another randomness control. Instead of fixing temperature, it restricts the model to the smallest set of tokens whose combined probability exceeds the threshold. top_p of 0.85 means the model picks from the smallest group of tokens that together cover 85% of the probability mass.
* <a name="f12">[12]</a> Repetition penalty discourages the model from repeating the same tokens or phrases. A penalty of 1.0 means no penalty. Values above 1.0 actively discourage repetition. Values below 1.0 encourage it.
* <a name="f13">[13]</a> Speculative decoding is a technique where a smaller "companion" model generates draft tokens quickly, and a larger model verifies them in parallel. The idea is that the small model is fast enough to produce plausible next tokens, and the large model checks them all at once, saving the large model from doing one token at a time. DFlash is oMLX's implementation of this idea.
* <a name="f14">[14]</a> 8-bit quantization reduces weight precision from 16 bits down to 8 bits. It is a middle ground between standard 16-bit and aggressive 4-bit compression. In my case, using 8-bit for the KV cache (not the model weights) avoided what looked like a slowdown bug in oMLX's 4-bit MoE cache handling at large context windows.
* <a name="f15">[15]</a> Jinja templates define how a model formats its input, including system prompts, messages, tool definitions, and thinking blocks. The official Qwen template has known issues with empty thinking stalls. The froggeric v19 template is a C++ native variant that avoids those stalls and improves KV cache hit rates.
