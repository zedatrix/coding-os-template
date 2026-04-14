# Coding OS Template

This repository is a template for a local AI coding OS: a durable, repo-backed system where one assistant can work across memory, skills, rules, tools, and project context in a consistent way.

Clone it, rename it, and tailor the core files to your own user, voice, tools, and projects.

## Structure

```
coding-os-template/
├── core/                  # Assistant identity, memory, user context, tools
│   ├── SOUL.md            # Persona, voice, behavioral defaults
│   ├── MEMORY.md          # Durable session memory
│   ├── USER.md            # User facts and preferences
│   └── TOOLS.md           # Available tooling and integrations
├── skills/                # Reusable assistant capabilities
├── cursor-rules/          # Always-applied Cursor IDE rules
├── projects/              # Optional project-specific context files
├── templates/             # Starter templates for recurring artifacts
└── tools/                 # Local integrations and utilities
```

## Principles

- One assistant, many skills
- Local-first where practical
- Explicit permissions over hidden behavior
- Durable memory over repeated re-explanation
- Document conventions before they spread

## Start Here

- Read [AGENTS.md](AGENTS.md) for repository-wide operating guidance
- Fill in `core/SOUL.md`, `core/USER.md`, `core/TOOLS.md`, and `core/MEMORY.md`
- Set up cold-start behavior for your client (see [Cold Start](#cold-start) below)
- Read [skills/README.md](skills/README.md) for the skill structure
- Read [projects/README.md](projects/README.md) for project context conventions
- Read [templates/README.md](templates/README.md) for starter templates

## Cold Start

Every new session, regardless of which project or directory is open, should execute the cold-start workflow at `skills/session-start/SKILL.md` before any normal user-facing reply. Do not answer the user's request, including greetings or small talk, until that workflow has completed or failed.

### Cursor

Create a user-level rule file at `~/.cursor/rules/cold-start.mdc` with `alwaysApply: true`:

```markdown
---
description: Require the session-start cold-start workflow before any substantive reply in every new session, regardless of project or directory
alwaysApply: true
---

# Cold Start

On the first user message of every new session, regardless of which project, repository, or directory is open, before any normal user-facing reply, read and execute the cold-start workflow at /path/to/your-coding-os/skills/session-start/SKILL.md.

Do not answer the user's request, including greetings or small talk, until that workflow has completed or failed. If it fails, report the failure briefly and stop.
```

Replace `/path/to/your-coding-os` with the absolute path to your local checkout. User-level rules in `~/.cursor/rules/` apply to every session in every project.

### Codex

Add a `developer_instructions` entry in `~/.codex/config.toml`:

```toml
developer_instructions = """
On the first user message of every new session, before any normal user-facing reply, execute the cold-start workflow at /path/to/your-coding-os/skills/session-start/SKILL.md.

Do not answer the user's request, including greetings or small talk, until that workflow has completed or failed.

If it fails, report the failure briefly and stop.
"""
```

Replace `/path/to/your-coding-os` with the absolute path to your local checkout.
