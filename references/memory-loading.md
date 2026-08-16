# How agent-memory gets loaded into a session

Reference for the mechanics behind `scripts/sync-memory.sh` and the `claude`
provider setup.

## Claude Code: SessionStart hook

`~/.claude/settings.json` gets a `SessionStart` hook entry that runs
`scripts/sync-memory.sh` before each session begins. The script:

1. `git -C ~/agent-memory pull --ff-only` (best-effort — skip silently if
   offline or no remote configured yet, never block session start on
   network).
2. Prints `agent-memory/index.md`'s content to stdout, which Claude Code
   injects into the new session's context as hook output.

This means `index.md` — and only `index.md` — is in context automatically
every session. Everything else in the vault is reached by the agent
following a link or grepping, per `skills/memory-search/SKILL.md`. This is
why `index.md`'s size cap in `agent-memory/CONVENTIONS.md` is load-bearing:
it's not a style preference, it's the token cost paid on every single
session regardless of task.

## Other providers

OpenCode / Gemini CLI / Codex CLI don't have an equivalent hook yet — see
`docs/OTHER_AGENTS_SETUP.md` for the plan (most have *some* form of
session-start script or system-prompt injection; none are wired up here
yet). Until then, an agent on those harnesses has to be told explicitly to
read `~/agent-memory/index.md`, e.g. via `skills/memory-search` content
pasted into that harness's equivalent of a system prompt.
