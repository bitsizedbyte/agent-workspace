---
name: memory-search
description: Search agent-memory for relevant prior context before starting research or a new project. Use at the start of any non-trivial task, and whenever you're about to re-derive something (architecture, a past decision, a user preference) that might already be recorded.
---

# Memory search

`agent-memory` lives at `~/agent-memory` (synced from the git repo by
`scripts/sync-memory.sh`, and loaded automatically at session start on the
`claude` provider). Don't assume you already have its content in context —
check explicitly:

1. Read `agent-memory/index.md` first — it's small by design and links to
   everything else.
2. If the task touches a specific project, check whether
   `agent-memory/projects/<name>/codemap.md` and `decisions.md` exist before
   re-exploring the codebase from scratch. If the codemap links to a deep-dive
   in `agent-memory/code-deepdives/<name>/`, read that before re-investigating
   the module yourself.
3. If the task touches how to approach the work (not what to build), check
   `agent-memory/feedback/` for a relevant theme file.
4. If the task involves external documentation (an API, a library, a vendor
   doc), check `agent-memory/docs/` before re-reading and re-summarizing it
   from scratch.
5. If the task involves team process, a past work item, or something that
   may have come up in a meeting, check `agent-memory/team/`.
6. Grep across the whole vault for a keyword if index.md's links don't
   obviously cover it — the index is a map, not a search index:
   `grep -ril "<keyword>" ~/agent-memory`

Treat what you find as context, not gospel — a memory naming a specific file,
function, or flag is a claim about the state of things *when it was written*.
If you're about to act on it (not just informing background understanding),
verify it's still true first.
