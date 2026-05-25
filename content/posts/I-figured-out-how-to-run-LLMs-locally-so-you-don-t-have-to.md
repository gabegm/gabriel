---
draft: false
unlisted: true
title: I figured out how to run LLMs locally so you don't have to
author: Gabriel Gauci Maistre
description: A journey through the local LLM rabbit hole from ollama to pi, and everything in between.
summary: I spent weeks chasing the perfect local LLM setup on my MacBook. Here is what I learned, what broke, and what actually works.
images:
- /images/the-power-of-the-sun.png
image: /images/the-power-of-the-sun.png
tags:
- local-llm
- machine-learning
- mlx
date: 2026-05-21 10:00:00 +0000
---

![alt text](/images/the-power-of-the-sun.png "The power of the sun sitting on my lap")

I wanted a coding model that worked on a flight without destroying my laptop battery.

What I got was a weeks-long rabbit hole through toolchains, benchmarks, broken processes, and one laptop shutdown that I eventually traced to a kernel panic under extreme memory pressure. Here is the full story, in case you want to save yourself some of the pain.

## The flight that started it all

After enough API outages, token limits, and one offline flight from Munich to London for Devoxx, I realised I could not work without a connection. The more we come to rely on cloud models, the less productive we are the moment they go dark. I wanted a coding assistant that would work offline, without turning my MacBook into a space heater.

What followed was a sequence of experiments through Ollama, MLX, oMLX, and pi, each revealing new trade-offs around memory, speed, and model behavior.

## Hardware and model tested

- **MacBook**: M4 Pro, 12-core CPU, 48GB unified memory
- **Model**: Qwen3.6-35B-A3B-TurboQuant-MLX-4bit (35B total parameters, 3B active per token, a Mixture-of-Experts model)[[0]](#f0)
- **macOS**: Tahoe 26.5 (updated during experiments)
- **Model format**: 4-bit quantized MLX, downloaded via `huggingface-cli`

## Benchmark results

These numbers are decode tokens per second[[3]](#f3), measured on a single continuous generation of roughly 2,000 tokens, with a short system prompt (~500 tokens). Benchmarks were taken on macOS Tahoe 26.5 with the laptop plugged in, on performance power mode. They are anecdotal. Your mileage will vary based on model quant, context length, prompt size, and what else is running on your machine.

### Baseline comparison (no speculative decoding)

| My setup | Memory (RAM + Swap) | Tokens/sec | Notes |
|---|---|---|---|
| Ollama (qwen3.6, default settings) | 48GB + 12GB swap[[2]](#f2) | ~25 | Fans at max, battery drains in ~2 hours |
| MLX (mlx_lm, default settings) | 48GB + 2GB swap[[2]](#f2) | ~35 | Cooler, but macOS killed the process under memory pressure |
| oMLX (default settings) | < 48GB (no swap)[[2]](#f2) | ~47 | The first setup I could imagine using regularly |

### Optimized experiment (pi + oMLX admin tweaks)

| My setup | Memory (RAM + Swap) | Tokens/sec | Notes |
|---|---|---|---|
| pi via oMLX (DFlash + 8-bit KV cache + custom template) | < 48GB (no swap)[[2]](#f2) | ~70 | Experimental; see caveats below |

**Important**: The optimized row is not apples-to-apples with the baseline. It includes speculative decoding (DFlash), 8-bit KV cache, a custom Jinja template, and several admin-level oMLX changes. The baseline rows used default configurations. I present them separately because combining them obscures what each contributed.

## How to replicate this

For anyone who wants to follow the same path on their own Apple Silicon Mac, here are the exact commands and configurations I used.

### Step 1: Ollama (my setup)

I started with [Ollama](https://ollama.com), the easiest on-ramp to local LLMs. Simplest possible setup:

```
$ ollama
```

This prompted me to pick a model (I chose qwen3.6) and then which agent (I chose opencode). It pulled the model, loaded it, and started serving. Expect 48GB+ RAM, 12GB swap, and roughly 25 tokens per second. Your laptop will get loud.

![alt text](/images/i-am-once-again-asking-for-more-ram.png "I am once again asking for more RAM")

Note: I cannot claim this is "Ollama vs MLX" in general. The Ollama model, the MLX model, the quantization, the context settings, and the cache behavior were all different. What I can say is that *my Ollama setup* used more swap and produced fewer tokens per second than *my MLX setup* on this specific machine and model.

### Step 2: MLX (mlx_lm)

After trying Ollama, I discovered MLX and wanted to try the same model in its native format. I used [mlx_lm](https://github.com/ml-explore/mlx-lm), the MLX-based inference library. I downloaded the 4-bit quantized MLX variant using `huggingface-cli`:

```
$ hf download majentik/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit --local-dir ~/models/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit
```

Then I started the server:

```
$ mlx_lm.server \
  --model /Users/gabegm/models/Qwen3.6-35B-A3B-TurboQuant-MLX-4bit \
  --chat-template-args '{"enable_thinking": false}'
```

Key flags:
- `--model`: path to the local 4-bit quantized MLX model
- `--chat-template-args`: disables the thinking/reasoning mode to avoid the looping problem

This served on `localhost:8080` by default. Roughly 35 tokens per second, 48GB RAM + 2GB swap. Cooler fans, but macOS still killed the process under memory pressure.

### Step 3: oMLX (baseline)

I then tried [oMLX](https://omlx.ai/), which handles model loading, memory management, and KV caching automatically:

```
$ omlx serve --host 0.0.0.0 --port 8080 --model-dir ~/models
```

No extra flags needed. oMLX handled the model loading, memory management, and KV caching automatically. I watched Activity Monitor and saw swap drop to zero, RAM settle around 42GB, and the fans finally stop screaming. 47 tokens per second.

### Step 4: pi via oMLX (optimized)

To connect the [pi agent](https://pi.dev/) to oMLX, I launched pi directly through oMLX:

```
$ omlx launch pi \
  --model 'Qwen3.6-35B-A3B-TurboQuant-MLX-4bit' \
  --api-key 'omlx-<your-key>'
```

### The oMLX admin tweaks

![alt text](/images/distracted-gabe.png "Distracted Gabe")

Since writing the original version of this post, I made several adjustments in the oMLX Web Admin that pushed pi past 70 tokens/sec. I do not know the exact technical reason each change helped, but here is what I changed and what I observed:

- **SpecPrefill: OFF.** I noticed the engine was cutting markdown files and codebases in half, which caused text-corruption in the output. Specifically, code blocks would end mid-function with unclosed braces, and the model would then enter a loop trying to "fix" the truncated code. Turning this off stopped the corruption.
- **TurboQuant KV Cache: 8-bit.** I forced 8-bit cache structures to maintain stability at the full 262K context window. The default 4-bit MoE cache had what looked like a slowdown bug in my setup[[14]](#f14).
- **DFlash speculative decoding.** I downloaded a companion model using `hf download mlx-community/Qwen3.5-0.8B-MLX-4bit --local-dir ~/models/Qwen3.5-0.8B-MLX-4bit`, and hooked it up as a lightweight companion model (4-bit quantized) to boost generation speed via speculative decoding[[13]](#f13). I observed roughly 2x speed on longer generations from short prompts without degrading accuracy.

  **Caveat**: oMLX's own DFlash integration docs note that DFlash has a default context threshold of 4096 tokens and falls back for longer prompts, does not use oMLX paged/SSD cache, and does full prefill from scratch for DFlash requests. I am not certain whether the ~70 tok/s result came from short-context DFlash acceleration, fallback engine behavior, or a combination. I have not profiled this carefully enough to say.

- **froggeric v19 Jinja template.** I replaced the official Qwen template with a Qwen fixed Jinja template variant ([froggeric v19 on GitHub](https://github.com/froggeric/qwen3-jinja/blob/main/qwen3.jinja))[[15]](#f15). I observed fewer empty thinking stalls and better KV cache hit rates.
- **tool_format: json.** I configured the chat template kwargs to return standard JSON data payloads, aligning the model's tool outputs with pi's CLI parser.

These are my observations from my setup. Your mileage may vary, and I have not profiled each change individually.

### Configuration

These are the parameters I used for the final pi/oMLX setup. The earlier mlx_lm config used `enable_thinking: false` and no `tool_format` setting.

| Parameter | Value | Purpose |
|---|---|---|
| ctx_window | 262144 | Context window size[[9]](#f9) |
| max_tokens | 32768 | Maximum output tokens |
| temp | 0.4 | Temperature (normal coding setting)[[10]](#f10) |
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

The key insight: OpenCode uses the `@ai-sdk/openai-compatible` npm package to talk to local MLX servers over HTTP, treating them like any OpenAI-compatible API. Just point `baseURL` to your oMLX server and you are good to go.

## Lessons learned

### Memory headroom matters more than you think

When MLX tried to allocate more memory than macOS would allow, the OS sent a SIGKILL to the process. Under enough pressure, the kernel panicked the whole system. It was a kernel panic, not a hardware-level crash. The macOS update was not what fixed it. What stopped the crashes was simply moving to lighter setups like oMLX, which reduced the memory pressure enough that the SIGKILL and kernel panic never happened again. Staying within memory headroom and keeping the model quantized at 4-bit[[5]](#f5) was critical in avoiding the situation.

![alt text](/images/this-is-fine.png "This is fine")

The answer lies in Apple Silicon's UMA[[1]](#f1). The CPU and GPU share exactly the same physical pool of RAM, which eliminates the need to copy tensors between separate memory banks. This is the single biggest performance advantage for running LLMs locally. But unified memory does not eliminate all overhead: memory bandwidth, cache movement, allocation behavior, and GPU scheduling still matter, and my workload was almost certainly GPU/Metal[[4]](#f4) rather than Neural Engine.

### Context size and the KV cache

At 262K context, the KV cache[[6]](#f6) dominates memory usage. Using 8-bit for the KV cache (not the model weights) avoided what looked like a slowdown bug in oMLX's 4-bit MoE cache handling at large context windows. Prefix caching[[8]](#f8) happens in the serving backend, not in pi itself. It chops your prompt into blocks, hashes them, and stores the resulting KV tensors in memory. On follow-up queries that reuse the same system prompt or project context, the model skips the heavy computation and reuses the cached blocks. The more context you feed the model, the more value you get from caching.

### Why Qwen 3.6 gets stuck in reasoning loops

![alt text](/images/opencode-throws-qwen.png "OpenCode throws Qwen")

From my own experience, I observed Qwen 3.6 getting stuck in reasoning loops under certain conditions. It endlessly second-guesses answers, repeats circular logic, or endlessly retries tool calls. This is not necessarily a bug in my setup. It seems to be a property of the model interacting with certain environments.

From what I could piece together, a few factors seem to contribute:

**Incompatible agent/tool frameworks.** Using agent environments (like OpenCode) with Qwen can cause instability. If a tool reports an error but fails to explain why, Qwen gets confused and attempts to trigger the same tool repeatedly without altering its inputs.

**Tool calling inside reasoning blocks.** Qwen models sometimes attempt to execute tool calls natively inside their hidden `<think>` blocks. Reasoning parsers may drop this section, causing the tool call to fail and prompting the model to re-initiate the entire thought process.

**Over-restricted sampling.** Setting temperatures too low (e.g., 0.1 to 0.5) limits the model's exploratory generation. Without a higher temperature, the model struggles to break out of its own logical ruts.

**Context window fatigue.** Exhausting or maximizing the context window[[9]](#f9) degrades the model's internal attention mechanism, making it much more likely to hallucinate the initial prompt and restart its reasoning cycles.

Note: 0.4 was my normal coding setting; 0.7 to 0.85 helped as a recovery tactic when the model looped.

### How I mitigated the looping

Several strategies helped in my testing:

- **Adjust temperature.** Increase to around 0.7 to 0.85 to encourage the model to explore new paths when it gets stuck.
- **Anti-looping prompts.** Add explicit rules to your system prompt telling the model to commit to its best guess after one pass instead of second-guessing itself.
- **Tweak penalties.** Use a light presence penalty (e.g., 0.1 to 0.2) to deter the repetition of previous tokens.
- **Hard inference caps.** If using local inference engines like [llama.cpp](https://github.com/ggerganov/llama.cpp), configure explicit reasoning budget cut-offs to force the model to output its answer if the loop continues past a safe limit.

I went with the simplest fix: disabling the "thinking" mode entirely (via `--chat-template-args`). It stopped the looping, but it also stripped away some of Qwen's depth, which felt like a trade-off I was not always comfortable making.

Later, after the pi optimizations, I re-enabled thinking mode by updating the pi config to use the froggeric v19 template and adjusting the tool format. The template changes stopped the looping in my test cases, so thinking mode could be safely turned back on.

## What I would recommend

- **Easiest: Ollama.** Works out of the box. 48GB RAM, 12GB swap, noisy fans, and 25 tokens per second. Great for getting started, not the setup I would use for long coding sessions on battery.
- **Best baseline on my machine: oMLX.** 47 tokens per second, under 48GB, no swap, and a laptop that actually stayed cool. This was the first setup I could imagine using regularly.
- **Fastest but experimental: pi + oMLX tweaks.** ~70 tokens per second, under 48GB, no swap, cool laptop. This required speculative decoding, 8-bit KV cache, a custom Jinja template, and several admin-level oMLX changes. Not apples-to-apples with the baseline, and I have not fully profiled why it works.

## Caveats and open problems

1. **RTK support for pi was initially missing, but has since been added via [PR #1741](https://github.com/rtk-ai/rtk/pull/1741).** I had written in the original draft that [RTK](https://www.rtk-ai.app/) was incompatible with pi, but coincidentally the GitHub issue was picked up and Pi support was added. I have not yet tested it end-to-end with oMLX, but the integration path now exists.

2. **little-coder does not play nice with oMLX.** I wanted to use [little-coder](https://github.com/itayinbarr/little-coder), which is built on top of pi, but I could not figure out how to get it to work with oMLX. So for now, I am sticking with bare pi.

3. **DFlash context behavior is unclear.** As noted above, oMLX's DFlash has a default context threshold of 4096 tokens and falls back for longer prompts. I am not certain whether the speed boost came from DFlash acceleration on short contexts, fallback behavior on long contexts, or both. If you are benchmarking with long prompts, the DFlash speedup may not apply.

4. **Quantization quality is subjective.** For my coding workflow, the quality trade-off of 4-bit quantization was acceptable. Whether that holds for your use case is another question.

## Is this for you?

Local LLMs are not for everyone. Before you follow along, ask yourself these questions:

**Do you have Apple Silicon?** This entire journey is Apple Silicon-specific. MLX, oMLX, and unified memory architecture (UMA)[[1]](#f1) are the reason this works. On an Intel Mac or a PC with a dedicated GPU, the story is different and this article is not your guide.

**Do you have 48GB of RAM?** The 48GB on my M4 Pro was where this became usable for me. At 262K context, the KV cache can dominate memory, so 32GB may load some 35B 4-bit variants at shorter context, but it leaves limited overhead for anything else. Browsing, terminal, or background processes will compete for memory. If you have less, you will need a smaller model and fewer tokens per second.

**Are you okay with "good enough"?** These models are not GPT-5 or Claude. They will make mistakes. They will hallucinate. My setup once triggered a kernel panic under memory pressure. But for smaller coding tasks, they are genuinely useful. If you need a coding buddy on a plane ride, go local.

**Do you value privacy?** Inference can happen without sending prompts to a cloud model. Your own model, your own rules. If any of that matters to you, local LLMs are worth exploring.

**Are you comfortable with a terminal?** You need to be comfortable running commands, managing files, and troubleshooting. If that scares you, start with Ollama and work your way up. It is the easiest on-ramp and you can always go deeper later.

---

* <a name="f0">[0]</a> MoE (Mixture-of-Experts): A model architecture where only a subset of parameters is active per token, enabling larger models to run on less memory.
* <a name="f1">[1]</a> UMA (Unified Memory Architecture): Apple Silicon's approach of giving the CPU and GPU access to the same pool of physical RAM.
* <a name="f2">[2]</a> Swap: macOS using SSD as scratch space when physical RAM is exhausted.
* <a name="f3">[3]</a> Tokens: Basic units of text an LLM processes. Roughly a word or fraction thereof.
* <a name="f4">[4]</a> Metal: Apple's low-level graphics API that lets MLX-based tools use the GPU for compute.
* <a name="f5">[5]</a> 4-bit quantization: Compression technique reducing weight precision from 16 bits to 4 bits, cutting model weight storage by roughly 4x before overhead.
* <a name="f6">[6]</a> KV (Key-Value) cache: Stores attention tensors from previous tokens to avoid recomputation.
* <a name="f7">[7]</a> Continuous batching: Processing multiple user requests together in a single forward pass.
* <a name="f8">[8]</a> Prefix caching: Hashing prompt blocks and storing resulting KV tensors for reuse on follow-up queries.
* <a name="f9">[9]</a> Context window: Maximum tokens the model can process at once, including input and output.
* <a name="f10">[10]</a> Temperature: Controls randomness in model output. 0.0 is deterministic; 1.0 is fully creative.
* <a name="f11">[11]</a> Nucleus sampling (top_p): Restricts the model to the smallest set of tokens whose combined probability exceeds the threshold.
* <a name="f12">[12]</a> Repetition penalty: Penalizes the model for repeating tokens. 1.0 means no penalty.
* <a name="f13">[13]</a> Speculative decoding: A smaller "companion" model generates draft tokens quickly, and a larger model verifies them in parallel. DFlash is oMLX's implementation.
* <a name="f14">[14]</a> 8-bit KV cache: Using 8-bit precision for cache structures as a middle ground between 16-bit and 4-bit.
* <a name="f15">[15]</a> Jinja template: Defines how a model formats its input, including system prompts, messages, tool definitions, and thinking blocks. The froggeric v19 variant addresses known issues with the official Qwen template.
