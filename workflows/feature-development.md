---
name: feature-development-workflow
description: End-to-end flow for building a feature or fix of non-trivial size — research, plan checkpoint, implement, test, verify.
---

# Feature development workflow

1. **Memory check.** Run `memory-search` (see `skills/memory-search/`) —
   check for an existing `codemap.md`/`decisions.md` for the target project
   before researching from scratch.
2. **Research** (`agents/researcher.md`, opus). Investigate the current
   state of the relevant code and any open questions about approach. Output:
   a short report with options and trade-offs if more than one approach is
   viable.
3. **Checkpoint.** Present the research and proposed approach to the user.
   Do not proceed to implementation until the user has confirmed the
   approach — this is the one stage `run-workflow` must not skip.
4. **Implement** (`agents/feature-implementer.md`, sonnet). Build the
   confirmed approach. Output: the diff and a summary of what changed.
5. **Test** (`agents/tester.md`, sonnet). Write/run tests covering the
   change. Output: pass/fail, and any new test files.
6. **Verify** (`agents/qa-bot.md`, haiku). Quick sanity pass — does the
   change actually do what was asked, does it break anything obvious nearby.
7. **Memory update.** If this surfaced a durable architectural fact or a
   decision worth remembering, update the project's `codemap.md` or
   `decisions.md` directly (small update — don't wait for the nightly
   distiller for something this concrete and already in hand).
