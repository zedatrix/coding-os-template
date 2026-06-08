# codex-global-sync

Codex-specific tool that installs the global cold-start instruction into `~/.codex/AGENTS.md`.

Codex CLI may honor `developer_instructions` from `~/.codex/config.toml`, but Codex Desktop threads may not receive that config entry. The user-level `~/.codex/AGENTS.md` file is the global instruction surface this repo installs for Desktop and CLI sessions.

## Usage

```bash
# Run directly:
/path/to/your-coding-os/tools/codex-global-sync/sync.sh

# Or pass an explicit checkout path:
/path/to/your-coding-os/tools/codex-global-sync/sync.sh /path/to/your-coding-os
```

## Behavior

- Creates `~/.codex/` if it does not exist
- Renders `codex/AGENTS.md.template` with the checkout's absolute path
- Writes the result to `~/.codex/AGENTS.md`
