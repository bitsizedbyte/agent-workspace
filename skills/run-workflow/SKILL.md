---
name: run-workflow
description: Execute one of the named workflows in agent-workspace/workflows/ (e.g. feature-development, codebase-onboarding, daily-distillation) by orchestrating the agents it calls for, in order. Use when the user names a workflow, or asks for something that clearly matches one end to end (e.g. "onboard this repo into memory", "build feature X start to finish").
---

# Run workflow

1. Identify which file in `agent-workspace/workflows/*.md` matches the
   request. If none clearly matches, say so and proceed as a normal task
   instead of forcing a workflow.
2. Read that workflow file in full before doing anything — it defines the
   stage order, which agent (from `agent-workspace/agents/`) handles each
   stage, and what gets checked between stages.
3. Execute stages in order via the Agent tool, using the `claude_model` field
   from each stage's agent file as the model override. Do not skip the
   checkpoints the workflow defines (e.g. "confirm plan with user before
   implementing") — those exist to keep a multi-stage run from running away
   from the user's actual intent.
4. Between stages, briefly report what the previous stage produced before
   starting the next one — the user should be able to redirect mid-workflow,
   not just see a final result.
5. If a stage's output contradicts something in `agent-memory` (a stale
   codemap, an outdated decision), flag it — don't silently proceed on stale
   context.
