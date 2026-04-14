#!/usr/bin/env bash
#
# Symlinks repo skills and cursor rules into Cursor's user-level directories.
# User-level skills and rules are available in every Cursor session regardless of project.
#
# Usage:
#   skills-sync              # sync from default (script's repo)
#   skills-sync /path/to/your-coding-os
#
# Symlink targets:
#   ~/.cursor/skills/<skill_name>  -> repo/skills/<skill_name>
#   ~/.cursor/rules/<rule_name>    -> repo/cursor-rules/<rule_name>

set -euo pipefail

SOURCE="$0"
while [[ -L "$SOURCE" ]]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
REPO_ROOT="${1:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

# --- Skills sync ---

SKILLS_SRC="$REPO_ROOT/skills"
CURSOR_SKILLS="$HOME/.cursor/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "Error: skills directory not found at $SKILLS_SRC" >&2
  exit 1
fi

mkdir -p "$CURSOR_SKILLS"

linked=0
for skill_dir in "$SKILLS_SRC"/*/; do
  [[ -d "$skill_dir" ]] || continue
  skill_name="$(basename "$skill_dir")"
  skill_md="$skill_dir/SKILL.md"
  [[ -f "$skill_md" ]] || continue

  target="$CURSOR_SKILLS/$skill_name"
  if [[ -L "$target" ]]; then
    current="$(readlink "$target")"
    if [[ "$current" == "$skill_dir" ]]; then
      echo "  $skill_name (already linked)"
      linked=$((linked + 1))
      continue
    fi
    rm "$target"
  elif [[ -e "$target" ]]; then
    echo "  $skill_name (skipped: exists and is not a symlink)" >&2
    continue
  fi

  ln -s "$skill_dir" "$target"
  echo "  $skill_name -> $skill_dir"
  linked=$((linked + 1))
done

echo "[skills-sync] Linked $linked skill(s) to $CURSOR_SKILLS"

# --- Cursor rules sync ---

RULES_SRC="$REPO_ROOT/cursor-rules"
CURSOR_RULES="$HOME/.cursor/rules"

if [[ ! -d "$RULES_SRC" ]]; then
  echo "[rules-sync] No cursor-rules directory found, skipping."
  exit 0
fi

mkdir -p "$CURSOR_RULES"

rules_linked=0
for rule_file in "$RULES_SRC"/*.mdc; do
  [[ -f "$rule_file" ]] || continue
  rule_name="$(basename "$rule_file")"

  target="$CURSOR_RULES/$rule_name"
  if [[ -L "$target" ]]; then
    current="$(readlink "$target")"
    if [[ "$current" == "$rule_file" ]]; then
      echo "  $rule_name (already linked)"
      rules_linked=$((rules_linked + 1))
      continue
    fi
    rm "$target"
  elif [[ -e "$target" ]]; then
    echo "  $rule_name (skipped: exists and is not a symlink)" >&2
    continue
  fi

  ln -s "$rule_file" "$target"
  echo "  $rule_name -> $rule_file"
  rules_linked=$((rules_linked + 1))
done

echo "[rules-sync] Linked $rules_linked rule(s) to $CURSOR_RULES"
