#!/usr/bin/env bash
# Claude Code SessionStart hook: pulls agent-memory and prints index.md so
# it lands in context at the start of every session. Best-effort — never
# blocks or fails session start on a network hiccup.
set -uo pipefail

MEMORY_DIR="${AGENT_MEMORY_DIR:-$HOME/agent-memory}"

if [ -d "$MEMORY_DIR/.git" ]; then
  git -C "$MEMORY_DIR" pull --ff-only --quiet 2>/dev/null || true
fi

if [ -f "$MEMORY_DIR/index.md" ]; then
  cat "$MEMORY_DIR/index.md"
else
  echo "# agent-memory not found at $MEMORY_DIR — run agent-workspace/providers/claude.sh to set up." >&2
fi

exit 0
