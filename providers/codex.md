# Codex CLI provider — design stub

Not implemented yet. This is the plan for when it is.

## What "wiring in" means for Codex CLI
Codex CLI reads project/user instruction files (an `AGENTS.md` convention in
much of the ecosystem, which Codex CLI supports) and has its own config for
default model and sandboxing. Whether it has native subagent dispatch with
per-agent model overrides should be confirmed against current docs — if not,
`agents/*.md` translate to distinct prompt/instruction files invoked by name
rather than a dispatchable subagent registry.

## Plan
1. `providers/codex.sh` — installs an `AGENTS.md` (or confirmed equivalent)
   at the appropriate scope that includes memory-loading instructions from
   `skills/memory-search/SKILL.md`, since there's no confirmed session-start
   hook equivalent to translate directly.
2. Translate `agents/*.md` using each file's `codex_model` field — currently
   placeholders (`gpt-5.1-codex` / `gpt-5.1` / `gpt-5.1-mini`) from
   `references/model-tiering.md`'s general logic, not verified against
   Codex's current model roster. Confirm before relying on them.
3. `scripts/distill-session.sh`'s headless-cron pattern likely ports
   directly if Codex CLI has an equivalent non-interactive/exec mode —
   confirm the actual flag name at build time.

## Why this is a stub and not built yet
Same reasoning as the other provider stubs — build against Codex CLI's
actual current capabilities when adopting it.
