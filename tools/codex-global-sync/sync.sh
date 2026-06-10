#!/usr/bin/env bash
#
# Installs the repo's global Codex cold-start instruction.
#
# Usage:
#   codex-global-sync
#   codex-global-sync /path/to/your-coding-os
#
# Target:
#   ~/.codex/AGENTS.md

set -euo pipefail

SOURCE="$0"
while [[ -L "$SOURCE" ]]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done

SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
REPO_ROOT="${1:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
TEMPLATE="$REPO_ROOT/codex/AGENTS.md.template"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
TARGET="$CODEX_HOME/AGENTS.md"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: template not found at $TEMPLATE" >&2
  exit 1
fi

mkdir -p "$CODEX_HOME"
sed "s#__CODING_OS_ROOT__#$REPO_ROOT#g" "$TEMPLATE" > "$TARGET"

echo "[codex-global-sync] Installed $TARGET"
