# Setting up non-Claude providers

Only the `claude` provider (`providers/claude.sh`) is actually implemented
right now. The other three — OpenCode, Gemini CLI, Codex CLI — have design
stubs only:

- [`providers/opencode.md`](../providers/opencode.md)
- [`providers/gemini.md`](../providers/gemini.md)
- [`providers/codex.md`](../providers/codex.md)

## Why stubs instead of scripts

Each of those harnesses has its own, evolving convention for context
loading, custom agents, and headless invocation. Writing `.sh` scripts
against assumed conventions now would either be wrong today or go stale
before they're used. The stub docs capture the plan and the specific things
to confirm (config file format, hook/session-start equivalent, actual
current model IDs) so that building the real integration later is a
translation exercise against `agents/`, `skills/`, and `workflows/`, not a
redesign.

## What's provider-agnostic already (no new work needed per provider)

- `agents/*.md` — the role definitions (what each agent should do) are
  written generically; only the `tools:`/`model:` mapping needs translating
  per harness. Each file already carries `gemini_model` / `codex_model` /
  `opencode_model` fields as placeholders for that translation — see
  `references/model-tiering.md` for the reasoning behind them, and confirm
  actual current model IDs before trusting them.
- `workflows/*.md` — stage order and checkpoints are harness-independent.
- `skills/*/SKILL.md` — content is portable; only the delivery mechanism
  (Claude Code's native skills vs. folding into another harness's system
  prompt) differs.
- `agent-memory/` itself — it's just a git repo of markdown; any harness
  that can read files and run git can use it.

## What needs real work per provider

1. Confirm that provider's session-start / context-injection mechanism (or
   confirm it doesn't have one, and plan for manual instruction instead).
2. Confirm that provider's subagent/custom-agent format, if any, and write
   the `providers/<name>.sh` translator.
3. Confirm current model IDs for that provider and update the placeholder
   fields in `agents/*.md`.
4. If it supports headless/non-interactive invocation, port
   `scripts/distill-session.sh`'s pattern for the daily distillation cron
   job.

## Adding a new provider later

Copy the shape of `providers/claude.sh` (the one real implementation) as a
reference for what a translator script does — install/translate agents,
wire up memory loading, done idempotently — rather than starting from the
design-stub docs alone.
