---
name: write-pr
description: Write pull request descriptions from git history, full branch diffs, and repository PR templates. Use whenever the user asks to write a PR, draft a pull request description/body, update an existing PR body, or create a PR and the description needs to be assembled first.
---

# Write Pull Request

Draft PR descriptions from the real branch diff, not from memory or the latest commit alone.

## What to Read First

1. Inspect the branch state with `git status`, `git log`, and `git diff <base>...HEAD`.
2. Read the repository PR template if it exists, usually `.github/PULL_REQUEST_TEMPLATE.md`.
3. Read any repo-specific PR guidance if it exists, such as `docs/pull-request-guidelines.md`.
4. Honor project-specific branch guidance when choosing the base branch.

## Workflow

1. Determine the base branch from repo context.
2. Analyze the full diff from the base branch, not just unstaged changes or the latest commit.
3. Build a concise change summary covering:
   - what changed
   - why the change exists
   - how it should be tested
   - dependencies, rollout notes, or reviewer context if relevant
4. Fill the repository PR template if one exists.
5. Omit sections with no value.
6. Remove template comments and placeholder text before returning the final body.
7. If the user only asked to write the PR, return the completed body in chat.
8. If the user asked to create or update the PR, use `gh pr create` or `gh pr edit` with the drafted body.

## Ticket Links

- If the branch name contains `CU-<ticket-id>`, use the fully qualified ClickUp URL `https://app.clickup.com/t/<ticket-id>`.
- If the branch name or context contains another tracker ID, include a fully qualified URL only when the correct base URL is known from the repo or the user.
- Do not invent tracker URLs when uncertain.

## Fallback Template

If the repository does not provide a PR template, use this structure and omit empty sections:

```markdown
# Pull Request Description

## ClickUp Ticket
<fully qualified ticket URL>

## Overview
<summary>

## Type of Change
- [ ] Client-side changes
- [ ] Backend changes
- [ ] Both client and backend changes
- [ ] Configuration changes
- [ ] Documentation updates

## Dependencies
- [ ] No dependencies

## Testing Steps
1.
2.
3.

## Testing Environment
- [ ] Local development
- [ ] Staging
- [ ] Production

## Screenshots/Recordings
<optional>

## Additional Notes
<optional>

## Checklist
- [ ] I have tested these changes locally
- [ ] I have updated the documentation accordingly
- [ ] I have added/updated tests as needed
- [ ] My code follows the project's coding standards
```

## Style

- Keep the overview tight and specific.
- Prefer concrete testing steps over vague statements like "tested locally."
- Match the repository's existing PR tone and structure.
- Do not create a temporary file unless the user explicitly wants one; the default output is chat text or a direct `gh` invocation.

## Permissions

### Reads

- `git status`, `git log`, `git diff <base>...HEAD`
- Repository PR templates
- Repository PR guidelines and related docs

### Writes

- None when drafting only
- May create or update a GitHub PR body via `gh` when the user explicitly asks

### Network Access

- GitHub via `gh`
- Tracker pages or APIs only when needed to confirm ticket context

### Side Effects

- Creating or editing a PR changes remote GitHub state
- Pushing a branch may be required before creating the PR

### Human Approval

- Not required to draft the PR body in chat
- Required before pushing or creating/updating a PR unless the user explicitly asked for that in the current request
