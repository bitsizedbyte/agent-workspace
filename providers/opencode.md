# OpenCode provider — design stub

Not implemented yet. This is the plan for when it is.

## What "wiring in" means for OpenCode
OpenCode is provider-agnostic (BYO model), and reads agent/prompt config from
its own config file (`opencode.json` or similar, project- or user-scoped —
confirm current format against OpenCode's docs when building this, it moves
fast). The equivalent of Claude Code's subagents are OpenCode's custom agent
definitions; the equivalent of a `SessionStart` hook is likely a
system-prompt file or an init command, but OpenCode's hook model should be
checked directly rather than assumed to match Claude Code's.

## Plan
1. `providers/opencode.sh` — translates `agents/*.md` into whatever shape
   OpenCode's agent config wants, using `opencode_model` from each agent
   file's frontmatter (currently `inherit` for all agents — OpenCode has no
   fixed model roster, so per-agent model pinning may not even be the right
   default there; revisit once the config format is confirmed).
2. Memory loading: since there's no confirmed session-start hook, start by
   just instructing the OpenCode agent (via its system prompt / initial
   context file) to read `skills/memory-search/SKILL.md` and follow it
   manually at the start of a task, same as any harness without native hook
   support.
3. Skills: OpenCode may not have a first-class skills concept — if not, fold
   `skills/*/SKILL.md` content directly into the system prompt instead.

## Why this is a stub and not built yet
Building it blind risks locking in assumptions about OpenCode's config
format that are wrong or already stale. Build this when actually adopting
OpenCode, reading its current docs at that time rather than trusting this
file's specifics beyond the shape of the plan.
