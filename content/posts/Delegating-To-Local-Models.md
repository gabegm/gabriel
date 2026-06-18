---
draft: true
title: Delegating To Local Models
author: Gabriel Gauci Maistre
description: I am experimenting with a small CLI that lets a strong cloud agent delegate bounded leaf tasks to a local OpenAI-compatible model.
summary: Local models are not ready to replace the strongest cloud coding agents for planning and judgment, but they may already be useful as cheap, private, local workers for small tasks.
tags:
- local-llm
- agents
- machine-learning
- developer-tools
date: 2026-05-26 10:00:00 +0000
---

I have been experimenting with a small idea: what if a strong cloud agent could delegate the boring parts of its work to a local model?

Not the important parts. Not the planning. Not the judgment. Not the part where the agent decides whether a change is safe, whether a test failure matters, or whether a user request is underspecified.

I mean the leaf tasks.

Summarise this one large file. Classify these five search results. Draft a commit message from this diff. Answer this narrow repository question using only the context I have already supplied.

That is the idea behind `local-agent-delegate`, or `lad`, a small experimental CLI I have been building for connecting a supervising agent like Codex, GPT, or Claude to a local OpenAI-compatible model.

The cloud agent remains the adult in the room. The local model gets handed a small job, returns a small answer, and the cloud agent checks whether that answer is useful.

## Why bother?

After getting local LLMs running properly on my MacBook, I kept running into the same awkward question:

What are these models actually good for in my day-to-day workflow?

It is tempting to imagine the local model replacing everything. Fully offline coding. No API calls. No cloud dependency. No cost. No latency. The laptop becomes the whole development environment.

That sounds lovely, but it is not where I am today.

The strongest cloud models are still much better at the parts of software work that require broad context, careful planning, and taste. They are better at noticing when a request is not actually the right request. They are better at holding a complicated refactor in their head. They are better at deciding when not to touch code.

Local models, especially the smaller ones that run comfortably on consumer hardware, are more uneven. They can be useful, but they can also be confidently wrong in ways that are annoying to detect if you give them too much responsibility.

So I started thinking about the problem differently.

Maybe the right question is not, "Can a local model replace the cloud agent?"

Maybe it is, "What work can a local model do where mistakes are cheap to catch?"

That leads to a very different design.

## The local model should not be the planner

The core rule of `lad` is conservative delegation.

The supervising agent decides what needs to happen. It finds the files. It chooses the context. It decides whether a local delegation is appropriate. It checks the answer. If the local answer is vague, wrong, or suspicious, the supervisor ignores it and inspects the source material itself.

The local model should not be asked to:

- design the architecture;
- make security-sensitive decisions;
- perform cross-file refactors;
- change public APIs;
- decide whether a test failure is acceptable;
- plan the main task.

Those are not leaf tasks. Those are judgment tasks.

For version one, I am interested in tasks that are bounded, easy to verify, and useful even when the answer is imperfect.

For example:

```sh
lad summarize --file src/example.py --max-tokens 600
```

The supervisor can ask the local model to summarise one large file. If the summary says something surprising, the supervisor can open the file and check. The answer does not need to be trusted blindly.

Another example:

```sh
lad classify \
  --prompt "Which service owns checkout?" \
  --candidate booking \
  --candidate payments
```

This is intentionally narrow. The local model is not inventing a plan. It is choosing from a short list.

Or:

```sh
lad draft commit --diff-file changes.diff
```

Commit messages are a good target because the cost of a mediocre first draft is low. The supervising agent, or the human, can edit it immediately.

## This is not "multi-agent" magic

I am slightly allergic to agent diagrams where every box is another tiny employee with a grand title.

`lad` is not trying to create a team of autonomous local agents. I do not want a local "architect agent", "reviewer agent", "security agent", and "product manager agent" arguing with each other on my laptop while I wait for my battery to disappear.

The model behind `lad` is much more boring.

There is one supervisor. There is one local worker. The worker receives a bounded prompt and returns text. The supervisor remains responsible.

This distinction matters because it changes the failure mode. If the local model is treated as an independent agent, then its mistakes can become part of the plan. If it is treated as a disposable helper, then its mistakes are just another signal to verify.

That is the level of trust I am comfortable with.

## The OpenAI-compatible layer is the trick

The CLI talks to a local OpenAI-compatible server. In my current setup, that is served locally on `localhost:8080`, backed by an MLX/oMLX model.

The configuration is deliberately plain:

```sh
export LAD_BASE_URL=http://localhost:8080/v1
export LAD_MODEL=qwen-local
export LAD_API_KEY=optional-token
```

That means the CLI does not need to care too much about the backend. It could be oMLX, LM Studio, Ollama if exposed through a compatible endpoint, or some other local server.

This is important because the local inference ecosystem is moving quickly. I do not want the agent-facing interface to be coupled to one runtime. The supervisor should only need a small set of task commands. The local backend can change underneath.

The current commands are intentionally limited:

```sh
lad summarize --file src/example.py --max-tokens 600
lad summarize --prompt "Long text to summarize"
lad classify --prompt "Which service owns checkout?" --candidate booking --candidate payments
lad draft commit --diff-file changes.diff
lad inspect repo --question "Where is cancellation handled?" --context-file search-results.txt
lad stats
```

There is also a kill switch:

```sh
export LAD_DISABLED=1
```

If that is set, delegation refuses to call the backend. I want local delegation to be explicitly opt-in, not something an agent starts doing because it found a tool lying around.

## What I used it for while drafting this

I used `lad` while writing this post, but only in the way I would want a cloud agent to use it: as a bounded helper.

I asked the local model to summarise the project README and suggest angles. It returned a useful high-level shape, but it also hallucinated a few details. That was actually a good reminder of why the design is conservative.

The local model was helpful enough to accelerate a small part of the work, but not reliable enough to be the source of truth.

That is the point.

The correct workflow is not:

1. ask local model;
2. believe local model;
3. ship answer.

The workflow is:

1. supervisor chooses a bounded task;
2. local model returns a draft or summary;
3. supervisor verifies against the source;
4. supervisor uses, edits, or discards the result.

This sounds less exciting than "autonomous local agents", but it is much closer to something I would actually trust.

## The economics of attention

The obvious benefits of local delegation are cost, privacy, and offline access.

Those matter, but I think the more interesting benefit is context management.

Cloud agents are powerful, but their attention is still finite. The more irrelevant text you stuff into the context window, the more you dilute the parts that matter. A large file might need to be read, but not every line of that file needs to sit in the supervisor's working memory forever.

A local model can act as a lossy compression step.

That sounds dangerous, because it is. Summaries lose information. Summaries can hide edge cases. Summaries can lie.

But used carefully, this can still be useful. The supervisor can ask for a first-pass summary of a file, use it to decide where to inspect next, and then open the exact sections that matter. The local model does not replace source inspection. It helps route attention.

That is the part I want to measure.

Does delegation reduce the amount of context a cloud agent needs to consume? Does it make the agent faster? Does it make it cheaper? Does it preserve quality when the supervisor verifies the answer?

If the answer is no, then the experiment is not worth much. If the answer is yes, even for a narrow class of tasks, then there is something here.

## The guardrails are the product

The most important part of this project is not the CLI command syntax. It is the delegation policy.

The agent instructions are strict:

- use `lad` only when explicitly asked;
- delegate only one bounded task at a time;
- do not delegate planning or judgment;
- do not treat local output as final truth;
- prefer dry runs when inspecting what would be sent;
- keep write operations out of scope unless there is a verification and rollback path.

This is why the current version does not attempt code edits. A future version might support verified mechanical edits, but only if the loop is extremely constrained: make the edit, run the verification command, and roll back if it fails.

Until then, read-only and draft-only tasks are enough.

I would rather have a boring tool that is safe to use often than an impressive demo that I do not trust.

## What comes next

The next step is not to make `lad` smarter. It is to make it more measurable.

I want to track which delegated tasks are actually useful. Summaries may help. Classifications may help. Commit-message drafts probably help. Repository inspection might help if the context is bounded tightly enough.

I also want better stats:

```sh
lad stats
```

Right now, usage logging is mostly there to prove that calls happened. Eventually I want it to answer better questions:

- Which tasks save the most cloud-agent context?
- Which tasks get discarded most often?
- Which local models are good enough for which task types?
- When does delegation slow the workflow down instead of speeding it up?

That last question matters. Local inference is not free just because the API bill is zero. It uses battery, memory, and time. A local model that produces a weak answer after thirty seconds may be worse than no delegation at all.

## Small models, small jobs

The mistake I keep seeing around local LLMs is expecting them to behave like the best frontier models, just smaller and cheaper.

That framing makes them disappointing.

I think they become more interesting when they are treated as small models for small jobs. Not worse versions of the cloud agent, but local utilities with a narrow contract.

`lad` is my attempt to explore that contract.

A strong cloud agent should stay responsible for the work. The local model should help with bounded, auditable tasks. The human should still be able to understand what happened.

That is less glamorous than a fully autonomous local coding team.

It is also much more likely to survive contact with real work.
