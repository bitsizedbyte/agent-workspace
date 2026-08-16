# Model tiering rationale

Why each agent in `agents/` is assigned the model it is — kept separate from
the agent files themselves so the reasoning doesn't have to be repeated in
each one, and so it's easy to revisit as models change.

| Tier | Used for | Agents |
|---|---|---|
| Opus (highest reasoning) | Open-ended judgment: architecture trade-offs, mapping unfamiliar code, anything where a wrong call is expensive to unwind | `researcher`, `codebase-mapper` |
| Sonnet (balanced) | Bounded execution against an already-decided plan: writing code, writing/running tests | `feature-implementer`, `tester` |
| Haiku (cheap, fast) | High-volume or narrow-scope work where speed/cost matters more than depth: quick sanity checks, unattended daily runs | `qa-bot`, `distiller` |

General rule for adding a new agent: tier by **how expensive a wrong
decision is to unwind**, not by how "important" the task sounds. A daily
cron job that's easy to re-run and cheap to be slightly wrong (`distiller`)
stays on Haiku even though memory quality matters a lot in aggregate, because
each individual run is low-stakes and reversible. A one-shot architecture
call (`codebase-mapper`) gets Opus because a bad codemap misleads every
future session that reads it.

The `gemini_model` / `codex_model` / `opencode_model` fields in each agent
file are placeholders using the tiering logic above, not verified current
model IDs — confirm the actual IDs when that provider's module gets built
(see `docs/OTHER_AGENTS_SETUP.md`); external model lineups change often
enough that hardcoding them now would likely go stale before they're used.
