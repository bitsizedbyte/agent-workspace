#!/usr/bin/env bash
# Top-level setup entrypoint. Currently wires up the `claude` provider only
# — see docs/OTHER_AGENTS_SETUP.md for the other providers' status.
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$WORKSPACE_DIR/providers/claude.sh"

echo
echo "Next: register the daily distiller as a scheduled job (see setup.md"
echo "'Daily distillation' section) — not done automatically by this script"
echo "since it's a system-level cron/launchd change worth reviewing first."
