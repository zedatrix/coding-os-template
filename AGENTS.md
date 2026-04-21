# AGENTS.md - Operating Instructions

## Purpose & Structure
This repository is a local AI coding OS: a system for one assistant with durable memory, reusable skills, automations, tools, and project context to assist a user across coding tasks.

## core
Assistant identity, personality, memory, user context, and tooling configuration. Four files, each with a distinct role:

- `core/SOUL.md` - persona, voice, behavioral defaults, and operating principles
- `core/MEMORY.md` - durable session memory that persists across chats
- `core/USER.md` - facts, preferences, and context about the user
- `core/TOOLS.md` - available tooling, API access, and integration config

Do not store raw transcripts here. Use `memory-writer` when updating `core/MEMORY.md`.

## skills
Reusable internal capabilities as portable skill folders. See [skills/README.md](skills/README.md). Use the skill `skills/skill-creator` when creating a new skill.

- **memory-writer**: Use after durable decisions, preference changes, or session outcomes that should survive beyond the current chat. [skills/memory-writer/SKILL.md](skills/memory-writer/SKILL.md)
- **session-start**: Required cold-start workflow at the beginning of every new session. [skills/session-start/SKILL.md](skills/session-start/SKILL.md)
- **session-close**: Use when the user is signing off or ending a session. [skills/session-close/SKILL.md](skills/session-close/SKILL.md)
- **find-skills**: Use when the user asks to find, compare, or install external skills. [skills/find-skills/SKILL.md](skills/find-skills/SKILL.md)
- **write-pr**: Draft PR descriptions from branch diffs and repository PR templates, or create/update PR bodies when asked. [skills/write-pr/SKILL.md](skills/write-pr/SKILL.md)

## commands
Reusable command designs for Cursor workflows. Store Cursor-oriented slash-style command definitions here when they should be easy to copy into a Cursor setup.

- **second-opinion**: Cursor command design for critiquing the latest plan version as an adversarial reviewer. [commands/second-opinion.md](commands/second-opinion.md)
- **rebuttal**: Cursor command design for responding to the latest critique and producing the next plan version. [commands/rebuttal.md](commands/rebuttal.md)

## projects
Project-specific context files. Each file captures the conventions, architecture patterns, domain knowledge, and personal preferences for a codebase the user works in. See [projects/README.md](projects/README.md) for the expected format.

When adding a new project, create `projects/{project-name}.md` and add a `repo:` line at the top with the workspace path so `session-start` can match it automatically.

## templates
Lightweight starters for recurring artifacts (workflows, currently the only one). See [templates/README.md](templates/README.md).

## cursor-rules
Always-applied Cursor rules stored as `.mdc` files. Symlinked to `~/.cursor/rules/` by `cursor-skills-sync` so they are active in every Cursor session across all projects. Edit here; the symlink ensures the change propagates immediately.

## tools
Local integrations and utilities. `cursor-skills-sync` symlinks the repo's skills into `~/.cursor/skills/` and cursor rules into `~/.cursor/rules/` so they are available at user level in every session. Run `cursor-skills-sync` after cloning or pulling to refresh symlinks.

## Continuity
Each session starts with limited live context. Files are how continuity is preserved.

On cold start, run `session-start` before substantial work. Update memory after durable changes.

## Post-Change Checklist
After any durable change to repository structure, operating rules, preferences, skills, or memory behavior:

1. Use `memory-writer` to update `core/MEMORY.md` immediately
2. Confirm in the response that memory was updated when it was
