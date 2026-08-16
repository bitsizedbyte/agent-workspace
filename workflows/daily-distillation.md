---
name: daily-distillation-workflow
description: The nightly process that turns the day's Claude Code session transcripts into durable agent-memory updates. Run by agents/distiller.md, triggered by scripts/sync-memory.sh via cron/launchd.
---

# Daily distillation workflow

1. **Gather.** Find session transcripts under `~/.claude/projects/**/*.jsonl`
   modified since the last recorded distillation run (track the timestamp in
   `agent-memory/sessions/.last-run`, a plain text ISO timestamp — create it
   if missing, treating "missing" as "distill everything from today").
2. **Read.** For each transcript, read it and extract only:
   - explicit user corrections or confirmations of approach → candidate
     `feedback/` entries
   - new durable facts about the user → candidate `user/profile.md` updates
   - project decisions and their reasoning → candidate
     `projects/<name>/decisions.md` entries
   - anything genuinely notable but not yet clearly durable → a session note
   Skip routine tool-call noise, debugging back-and-forth, and anything
   already covered by an existing memory note.
3. **Write.**
   - Update existing files where a clear home already exists; only create a
     new file when the topic has no home.
   - Always create at least one `sessions/YYYY-MM-DD-topic.md` per
     day-with-activity, even a short one, as the raw record.
   - Respect every size target and frontmatter rule in
     `agent-memory/CONVENTIONS.md`.
4. **Index.** Update `agent-memory/index.md`'s "Recent sessions" list to the
   five most recent session notes; older links drop off (the files stay,
   just unlisted — findable by grep).
5. **Commit.** Stage and commit `agent-memory` with a message like
   `Distill YYYY-MM-DD: <one-line summary>`. Push if a remote is configured
   and reachable; if push fails (offline, auth), leave the commit local and
   note it — don't block on network.
6. **Record.** Update `agent-memory/sessions/.last-run` to now.
