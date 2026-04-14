# Projects

Store project-specific context here.

## Purpose

Each file in this directory should capture the conventions, architecture notes, source docs, and personal preferences that matter for one codebase.

## File Format

Start each file with a `repo:` line so `skills/session-start/SKILL.md` can auto-match it to the current workspace.

Example:

```md
repo: /Users/you/dev/example-repo

# Example Project

## Required Reading
- `docs/architecture.md`
- `.cursor/BUGBOT.md`

## Notes
- Put conventions, domain notes, and workflow assumptions here.
```

## What To Include

- Required reading for session start
- Architecture notes and conventions
- Domain doc maps
- User-specific preferences for that codebase

## What To Avoid

- Raw transcript dumps
- Duplicated long docs that should be referenced instead
- Secrets or credentials
