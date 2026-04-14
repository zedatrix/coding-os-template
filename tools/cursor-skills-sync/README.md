# cursor-skills-sync

Cursor-specific tool that symlinks all repo skills into `~/.cursor/skills/`.

User-level skills are available in every Cursor session regardless of which project or directory is open. Symlinking from the repo keeps skills in sync: edits in the repo are reflected immediately in Cursor.

## Usage

```bash
# From anywhere, if symlinked to ~/.local/bin:
skills-sync

# Or with explicit path:
skills-sync /path/to/your-coding-os

# Run directly:
/path/to/your-coding-os/tools/cursor-skills-sync/sync.sh
```

## Setup

Symlink for CLI access:

```bash
ln -sf /path/to/your-coding-os/tools/cursor-skills-sync/sync.sh ~/.local/bin/skills-sync
```

## Behavior

- Creates `~/.cursor/skills/` if it doesn't exist
- For each folder in `skills/` that contains `SKILL.md`, creates a symlink
- Skips non-skill folders (e.g. no SKILL.md)
- Replaces existing symlinks that point elsewhere; skips non-symlink files/dirs
