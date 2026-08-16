#!/usr/bin/env bash
# Wires this repo into Claude Code: installs agents/skills into ~/.claude
# and registers the SessionStart hook that loads agent-memory. Idempotent —
# safe to re-run any time, and must be re-run after editing anything in
# agents/ or skills/.
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
MEMORY_DIR="${AGENT_MEMORY_DIR:-$HOME/agent-memory}"

echo "==> Installing agents into $CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/agents"
for f in "$WORKSPACE_DIR"/agents/*.md; do
  name="$(basename "$f")"
  # Strip the non-standard multi-provider model fields (claude_model,
  # gemini_model, codex_model, opencode_model) — Claude Code only needs
  # name/description/tools/model. See references/claude-code-subagents.md.
  grep -Ev '^(claude_model|gemini_model|codex_model|opencode_model):' "$f" \
    > "$CLAUDE_DIR/agents/$name"
  echo "   - $name"
done

echo "==> Linking skills into $CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/skills"
for d in "$WORKSPACE_DIR"/skills/*/; do
  name="$(basename "$d")"
  ln -sfn "$d" "$CLAUDE_DIR/skills/$name"
  echo "   - $name -> $d"
done

echo "==> Registering SessionStart hook (agent-memory loader)"
python3 - "$CLAUDE_DIR/settings.json" "$WORKSPACE_DIR/scripts/sync-memory.sh" <<'PYEOF'
import json, sys, os

settings_path, hook_script = sys.argv[1], sys.argv[2]
settings = {}
if os.path.exists(settings_path):
    with open(settings_path) as f:
        content = f.read().strip()
        settings = json.loads(content) if content else {}

hooks = settings.setdefault("hooks", {})
session_start = hooks.setdefault("SessionStart", [])

entry = {"hooks": [{"type": "command", "command": hook_script}]}
already = any(
    h.get("command") == hook_script
    for group in session_start
    for h in group.get("hooks", [])
)
if not already:
    session_start.append(entry)

os.makedirs(os.path.dirname(settings_path), exist_ok=True)
with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
PYEOF
echo "   - hook -> $WORKSPACE_DIR/scripts/sync-memory.sh"

echo "==> Checking agent-memory"
if [ ! -d "$MEMORY_DIR" ]; then
  echo "   ! $MEMORY_DIR not found — clone or scaffold it before agent-memory does anything useful."
else
  echo "   - found at $MEMORY_DIR"
fi

chmod +x "$WORKSPACE_DIR"/scripts/*.sh

echo "==> Done. Start a new Claude Code session to pick up the hook and agents."
