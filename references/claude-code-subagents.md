# Claude Code subagent file format (reference)

Notes for whoever adds or edits a file in `agents/`. Claude Code subagents are
markdown files with YAML frontmatter, discovered from `~/.claude/agents/` (or
a project's `.claude/agents/`).

```yaml
---
name: kebab-case-name          # invoked via the Agent tool's subagent_type
description: when to use this agent — this is what the orchestrator matches against
tools: Comma, Separated, List  # omit entirely to inherit all tools
model: sonnet | opus | haiku | inherit
---

System prompt body — instructions for the agent, written in second person.
```

This repo's `agents/*.md` files add extra, non-standard frontmatter keys
(`claude_model`, `gemini_model`, `codex_model`, `opencode_model`) so the same
role definition can be reused across harnesses once `providers/*` for those
tools exist — see `docs/OTHER_AGENTS_SETUP.md`. The `providers/claude.sh`
setup script strips these extra keys down to the standard `name` /
`description` / `tools` / `model` fields when it symlinks/copies into
`~/.claude/agents/`, since Claude Code ignores unknown keys but there's no
guarantee that stays true.

**Description field matters more than it looks.** The orchestrating model
picks a subagent by matching the task against every `description` in the
directory — vague or overlapping descriptions cause wrong dispatch. Say
explicitly what the agent is for *and* what it's not for for agents whose
scope could be confused with a sibling (see `researcher.md` vs
`feature-implementer.md`).
