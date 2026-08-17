# agent-workspace

Provider-agnostic agent roles, skills, and workflows, wired into Claude Code
(and eventually other harnesses) against a persistent memory vault at
[`agent-memory`](https://github.com/bitsizedbyte/agent-memory) (sibling repo,
expected at `~/agent-memory`).

## Layout

```
agents/       Role definitions (researcher, feature-implementer, tester,
              qa-bot, distiller, codebase-mapper) — see references/model-tiering.md
              for why each is tiered the way it is.
skills/       Claude Code skills: memory-search, run-workflow, token-estimate.
workflows/    Multi-stage processes that chain agents together, with
              explicit checkpoints where a human should confirm before
              continuing.
providers/    Per-harness setup. Only claude.sh is implemented; opencode.md,
              gemini.md, codex.md are design stubs — see docs/OTHER_AGENTS_SETUP.md.
scripts/      sync-memory.sh (SessionStart hook) and distill-session.sh
              (daily cron entrypoint).
references/   Background docs for whoever's extending this repo — subagent
              file format, model tiering rationale, how memory loading works.
docs/         Longer-form docs that don't fit in a top-level file.
```

## Quickstart

```bash
bash setup.sh
```

See [setup.md](setup.md) for prerequisites, what it does, and how to
register the daily distillation job. See
[docs/OTHER_AGENTS_SETUP.md](docs/OTHER_AGENTS_SETUP.md) if you're extending
this to a harness other than Claude Code.

## The idea

Two repos, two jobs:
- **agent-memory** — what's known: user facts, feedback on how to work,
  per-project pointer-maps, decisions. Small, cheap to load, grows by
  disciplined pruning not accumulation.
- **agent-workspace** (this repo) — how work gets done: which agent handles
  which kind of task, at what model tier, in what order, checking memory
  before acting and updating it after.

`index.md` in agent-memory is the only thing loaded automatically every
session (via the `SessionStart` hook `scripts/sync-memory.sh` installs).
Everything else — in both repos — is reached deliberately, by an agent
following a link or a workflow step, not by being dumped into context
upfront. See [references/memory-loading.md](references/memory-loading.md)
for the mechanics.
