# Setup

## Prerequisites
- `agent-memory` cloned or scaffolded at `~/agent-memory` (a sibling repo —
  see its own `README`/`CONVENTIONS.md`).
- `python3` on PATH (used by `providers/claude.sh` to safely merge
  `~/.claude/settings.json` without clobbering existing hooks).
- `git`, and `gh` if you want the daily distiller to push automatically.

## One-time setup

```bash
bash setup.sh
```

This runs `providers/claude.sh`, which:
1. Copies `agents/*.md` into `~/.claude/agents/` (stripping the
   multi-provider frontmatter fields Claude Code doesn't need).
2. Symlinks `skills/*/` into `~/.claude/skills/`.
3. Registers a `SessionStart` hook in `~/.claude/settings.json` that runs
   `scripts/sync-memory.sh` — pulls `agent-memory` and loads `index.md` into
   context at the start of every session.

Re-run `bash setup.sh` any time you edit a file in `agents/` or `skills/` —
it's idempotent and picks up the changes.

## Daily distillation

Not registered automatically — this touches your crontab/launchd, worth a
manual look first. `scripts/distill-session.sh` is the entrypoint; it runs
Claude Code headlessly against `workflows/daily-distillation.md`.

macOS (launchd), running at 11pm daily:

```bash
cat > ~/Library/LaunchAgents/com.agent-workspace.distill.plist <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.agent-workspace.distill</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$HOME/agent-workspace/scripts/distill-session.sh</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict><key>Hour</key><integer>23</integer><key>Minute</key><integer>0</integer></dict>
</dict></plist>
PLIST
launchctl load ~/Library/LaunchAgents/com.agent-workspace.distill.plist
```

Logs land in `~/agent-memory/sessions/.distill-log`.

To remove: `launchctl unload ~/Library/LaunchAgents/com.agent-workspace.distill.plist`.

## Verifying it worked

- Start a fresh Claude Code session and check that `index.md`'s content
  appears as context (ask "what's in your memory index").
- `ls ~/.claude/agents/` should list this repo's agent files.
- Run `bash scripts/distill-session.sh` manually once to confirm it
  completes and writes to `~/agent-memory/sessions/.distill-log`.
