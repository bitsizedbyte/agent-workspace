# Gemini CLI provider — design stub

Not implemented yet. This is the plan for when it is.

## What "wiring in" means for Gemini CLI
Gemini CLI supports custom "extensions" and a `GEMINI.md` context file
(analogous to Claude Code's `CLAUDE.md`) that's loaded automatically per
project/user — that's the natural home for a memory-loading instruction.
Whether it has a native subagent concept with per-agent model selection
should be confirmed against current docs before building this; if not,
`agents/*.md` become prompt templates invoked manually rather than
dispatchable subagents.

## Plan
1. `providers/gemini.sh` — installs a `~/.gemini/GEMINI.md` (or the
   confirmed equivalent) that points at `skills/memory-search/SKILL.md`'s
   content so memory gets checked at the start of a session, mirroring what
   the Claude Code `SessionStart` hook does automatically.
2. Translate `agents/*.md` using each file's `gemini_model` field — these
   are currently placeholders (`gemini-2.5-pro` / `gemini-2.5-flash`),
   written from general model-tiering logic in
   `references/model-tiering.md`, not verified against Gemini's current
   model roster. Confirm before wiring anything real to them.
3. Workflows (`workflows/*.md`) likely translate directly since they're
   provider-agnostic descriptions of stage order — the orchestration layer
   (something has to dispatch each stage to the right model) is the actual
   unknown here.

## Why this is a stub and not built yet
Same reasoning as `opencode.md` — build against Gemini CLI's actual current
capabilities when adopting it, not against assumptions made now.
