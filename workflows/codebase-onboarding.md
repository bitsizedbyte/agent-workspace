---
name: codebase-onboarding-workflow
description: Bring a new project into agent-memory for the first time, producing a projects/<name>/ folder with codemap.md and decisions.md.
---

# Codebase onboarding workflow

1. **Scope check.** Confirm the project's root path and, briefly, what it is
   (from the user or from a quick look at README/package manifest) — don't
   let the mapper guess at purpose from file names alone.
2. **Map** (`agents/codebase-mapper.md`, opus). Follow
   `agent-memory/projects/_template/codemap.md`'s shape. Pointers only, no
   pasted code. Cap root `codemap.md` at ~150 lines; split overflow into
   `agent-memory/code-deepdives/<project>/<name>.md`, generated lazily
   rather than all at once.
3. **Seed decisions.** Create `decisions.md` from the template even if
   empty at first — it's the landing spot for future architectural calls,
   not something to backfill from git history speculatively.
4. **Index.** Add a one-line entry for the new project to
   `agent-memory/index.md` under "Projects" (respecting its ~100-line cap —
   trim something else first if needed).
5. **Commit.** Commit the new `agent-memory/projects/<name>/` folder and the
   `index.md` update together with a message naming the project.
