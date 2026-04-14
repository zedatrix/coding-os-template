# Skills

Store reusable internal skills in this directory. Skills are not separate personas; they are focused capabilities used by the same assistant in different situations.

## Structure
Follow the portable skill-folder pattern:

- `skills/<skill_name>/SKILL.md` as the required primary file
- optional `scripts/` for executable helpers
- optional `references/` for docs loaded only when needed
- optional `assets/` or `templates/` for reusable outputs

Use `kebab-case` for skill folder names.

## Documentation Rule
Every skill that can access private context, write files, call external services, or trigger side effects should document that behavior inside `SKILL.md` under a Permissions section covering reads, writes, network access, side effects, and human approval requirements.

Suggested layout:
- `skills/<skill_name>/SKILL.md`
- `skills/<skill_name>/scripts/`
- `skills/<skill_name>/references/`
- `skills/<skill_name>/assets/`

Keep routing metadata, permissions, triggers, and operational notes inside the skill itself, and update them whenever behavior changes.
