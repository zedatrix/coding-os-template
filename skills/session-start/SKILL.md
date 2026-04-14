---
name: session-start
description: Use this skill at the beginning of a new session or any cold start to recover the minimum required repo, core, memory, and task-specific context before acting.
---

# Session Start

Use this skill when a session begins with limited live context and continuity must be recovered from repository files.

## Purpose

Create a reliable cold-start routine so the assistant reads the right instructions and memory before taking action.

## When To Use

Use this skill when:

- a new session starts
- the user returns after a shutdown or long gap
- the assistant has no reliable live context for the current repo state
- the user asks what should be loaded before work begins

## Procedure

**CRITICAL: Steps 1-6 are non-negotiable. Every file listed in those steps MUST be read. Do not cherry-pick, skip, or summarize from memory. Do not batch only a subset to save time. If a file fails to load, note the failure and continue with the rest. Shortcutting this procedure defeats the entire purpose of cold start.**

1. (Cursor only) Ensure skills are symlinked: run `cursor-skills-sync` or `tools/cursor-skills-sync/sync.sh` from the repo root. Infer the repo root from this file's path (`.../skills/session-start/SKILL.md` → parent of `skills/`). This ensures all repo skills are symlinked to `~/.cursor/skills/` and any new skills are added automatically.
2. Read [AGENTS.md](../../AGENTS.md).
3. Read ALL core identity and operating files:
   - [core/SOUL.md](../../core/SOUL.md)
   - [core/MEMORY.md](../../core/MEMORY.md)
   - [core/USER.md](../../core/USER.md)
   - [core/TOOLS.md](../../core/TOOLS.md)
4. If the user names a skill or the request clearly matches one, open that skill's `SKILL.md` before proceeding.
5. **Load project context.** Check if the current workspace matches a project file in `projects/`. Inspect each Markdown file there except `README.md`, compare the workspace path against the `repo:` line near the top of the file, and if a match is found, read that project file. If no match is found, skip this step silently.
6. **Validate freshness.** After loading, check the core files for staleness:
   - Are any Open Threads in MEMORY.md clearly resolved or outdated? Flag them.
   - Do Observations in MEMORY.md look stale or already settled? Flag them.
   - Does USER.md reference a role, project, or context that may have shifted? Note it.
   - Has enough time passed since the last Log entry that a "what changed?" check-in with the user might be warranted?
   - If anything looks stale, mention it briefly after the load confirmation. Don't block on it.
7. Before substantial work, actively reload the assistant voice from `core/SOUL.md`, including core presence, mode behavior, and failure modes, so the response style is intentional rather than generic.

### Verification

After completing steps 1-6, confirm which files were loaded by listing them (including any project context file). If any file was skipped or failed, state that explicitly. If any staleness was flagged in step 6, mention it concisely. Do not proceed to step 7 until all mandatory files from steps 2-5 have been read.

## Minimum Output

Before substantial work, be able to state:

- who the user is
- the assistant's current tone and operating defaults
- the assistant's voice blueprint and failure modes
- the repository's purpose and current focus
- all user preferences in `core/USER.md`
- what tools you have access to from `core/TOOLS.md`
- which project context was loaded (if any)
- any flagged staleness from the validation step
