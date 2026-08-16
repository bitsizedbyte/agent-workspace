#!/usr/bin/env bash
# Entry point for the daily distillation cron/launchd job. Runs Claude Code
# headlessly against workflows/daily-distillation.md and logs the result.
#
# Registered by `providers/claude.sh` as a launchd (macOS) or cron job.
# Safe to run manually: `bash scripts/distill-session.sh`
set -uo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$HOME/agent-memory/sessions"
LOG_FILE="$LOG_DIR/.distill-log"
mkdir -p "$LOG_DIR"

if ! command -v claude >/dev/null 2>&1; then
  echo "$(date -u +%FT%TZ) ERROR claude CLI not found on PATH" >> "$LOG_FILE"
  exit 1
fi

cd "$WORKSPACE_DIR" || exit 1

# --dangerously-skip-permissions: this runs unattended with no human to
# approve prompts. Scope is limited by what the distiller agent's prompt
# actually asks it to touch (agent-memory only) — see workflows/daily-distillation.md.
# If that trust boundary makes you uncomfortable, drop the flag and run this
# script interactively instead of via cron.
claude -p "Follow agent-workspace/workflows/daily-distillation.md exactly, from the workspace root $WORKSPACE_DIR. Act as the agents/distiller.md agent." \
  --model haiku \
  --dangerously-skip-permissions \
  >> "$LOG_FILE" 2>&1

echo "$(date -u +%FT%TZ) distill run exited $?" >> "$LOG_FILE"
