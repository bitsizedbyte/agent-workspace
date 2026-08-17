---
name: token-estimate
description: Estimate the total tokens a task will consume before running it — sizes the files/context it would read and the agents it would dispatch, and reports a rough budget with a breakdown. Use when the user asks "how many tokens will this take," wants a cost/budget estimate before a large task, or before kicking off a multi-agent workflow. For usage *after* a task ran, use the explain-usage skill instead — this is a pre-task estimate, not a report on what already happened.
---

# Token estimate

This produces a **rough budget**, not a measurement — the only way to know
exact token counts is to run the task and check actual usage. Say that up
front in the output; don't present the number as more precise than it is.

## 1. Scope the task

Before estimating, pin down what's actually being counted. Ask if it's
unclear:
- A single prompt/response, or a multi-step task?
- Does it involve dispatching subagents (Agent tool)? Each subagent call
  starts cold and re-derives context from scratch — that's a real
  multiplier, not just a detail. Count each dispatch's context separately,
  don't assume it shares the parent's budget.
- Roughly how many turns/tool round-trips is this likely to take? A
  one-file edit is very different from an open-ended investigation.

## 2. Measure the inputs

For anything concrete (files, a directory, a set of URLs to fetch), get
real byte counts rather than guessing:

```bash
wc -c path/to/file                    # single file
find path/to/dir -type f -name '*.ext' -exec wc -c {} + | tail -1   # directory total
```

Convert: **~4 characters ≈ 1 token** for English text and most code (a
rough industry-standard heuristic — dense code with lots of symbols/short
identifiers can run closer to 3 chars/token, prose closer to 4–5). State
which ratio you used.

For content not yet on disk (a web page to fetch, an API response), estimate
by analogy to similar known content, and flag it as a rougher guess than the
file-based numbers.

## 3. Account for the fixed overhead

These are easy to forget and often dominate for small tasks:
- **System prompt + tool definitions**: a few thousand tokens, roughly
  constant per turn, larger when many tools/skills are loaded.
- **Conversation history so far**: if mid-conversation, the existing
  transcript is already "spent" context that carries forward each turn
  (mitigated by prompt caching on repeat sends — cached tokens are far
  cheaper, so a long stable history costs much less than its raw size
  after the first turn).
- **Expected output**: a bug fix might produce hundreds of tokens of diff
  and explanation; a written report or generated document can run into the
  thousands. Estimate output separately from input — they're billed and
  budgeted differently.
- **Each subagent dispatch**: its own system prompt + tool defs + whatever
  context you hand it in the prompt, independent of the parent's budget.

## 4. Present a breakdown, not just a total

```
Component                          Est. tokens
----------------------------------------------
Files read (n files, x KB)         ~N
Fixed overhead (system + tools)    ~N
Subagent dispatch A (role)         ~N
Subagent dispatch B (role)         ~N
Expected output                    ~N
----------------------------------------------
Total (rough)                      ~N  (±30%)
```

Give a range, not a false-precision single number — actual usage commonly
lands 20–40% off a heuristic estimate depending on tool-call overhead and
how much back-and-forth the task actually needs.

## 5. After the task runs

If the user wants to know what it actually cost, that's a different
question — point them at the `explain-usage` skill, which reports real
session usage rather than a prediction. Comparing the two (estimate vs.
actual) is useful for calibrating future estimates but isn't done
automatically — call it out only if the user asks.
