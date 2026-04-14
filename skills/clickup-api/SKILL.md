---
name: clickup-api
description: >-
  Interact with ClickUp via its REST API v2 — manage tasks, lists, folders,
  comments, time tracking, documents, tags, members, and chat. Use when the
  user asks to create, read, update, or search ClickUp resources, or when
  Cursor's ClickUp MCP server tools are unavailable.
---

# ClickUp API

Provides direct ClickUp API v2 access via `curl` when the MCP server tools are not available in the agent session.

## Prerequisites

The ClickUp personal API token must be set in the repo's `.env` file:

```
CLICKUP_API_TOKEN=pk_...
```

From the repo root, load it before making requests:

```bash
export CLICKUP_API_TOKEN=$(rg '^CLICKUP_API_TOKEN=' .env | cut -d '=' -f2-)
```

## Base URL & Auth

All requests target `https://api.clickup.com/api/v2` with the token in the `Authorization` header.

```bash
curl -s -H "Authorization: $CLICKUP_API_TOKEN" \
  "https://api.clickup.com/api/v2/..."
```

For POST/PUT requests, add `-H "Content-Type: application/json"` and pass JSON with `-d`.

## Quick Reference

### Workspace & Hierarchy

| Action | Method | Endpoint |
|--------|--------|----------|
| Get workspaces (teams) | GET | `/team` |
| Get workspace hierarchy | GET | `/team/{team_id}/space?archived=false` |
| Get workspace members | GET | `/team/{team_id}/member` (v3: `/workspaces/{team_id}/members`) |

### Spaces

| Action | Method | Endpoint |
|--------|--------|----------|
| Get spaces | GET | `/team/{team_id}/space?archived=false` |
| Get space | GET | `/space/{space_id}` |

### Folders

| Action | Method | Endpoint |
|--------|--------|----------|
| Get folders | GET | `/space/{space_id}/folder?archived=false` |
| Create folder | POST | `/space/{space_id}/folder` |
| Get folder | GET | `/folder/{folder_id}` |
| Update folder | PUT | `/folder/{folder_id}` |

### Lists

| Action | Method | Endpoint |
|--------|--------|----------|
| Get lists in folder | GET | `/folder/{folder_id}/list?archived=false` |
| Get folderless lists | GET | `/space/{space_id}/list?archived=false` |
| Create list in folder | POST | `/folder/{folder_id}/list` |
| Create folderless list | POST | `/space/{space_id}/list` |
| Get list | GET | `/list/{list_id}` |
| Update list | PUT | `/list/{list_id}` |

### Tasks

| Action | Method | Endpoint |
|--------|--------|----------|
| Get tasks in list | GET | `/list/{list_id}/task` |
| Search tasks | GET | `/team/{team_id}/task?<filters>` |
| Create task | POST | `/list/{list_id}/task` |
| Get task | GET | `/task/{task_id}` |
| Update task | PUT | `/task/{task_id}` |
| Add tag to task | POST | `/task/{task_id}/tag/{tag_name}` |
| Remove tag from task | DELETE | `/task/{task_id}/tag/{tag_name}` |

### Comments

| Action | Method | Endpoint |
|--------|--------|----------|
| Get task comments | GET | `/task/{task_id}/comment` |
| Create task comment | POST | `/task/{task_id}/comment` |

### Time Tracking

| Action | Method | Endpoint |
|--------|--------|----------|
| Get task time entries | GET | `/task/{task_id}/time` |
| Add time entry | POST | `/team/{team_id}/time_entries` |
| Start timer | POST | `/team/{team_id}/time_entries/start` |
| Stop timer | POST | `/team/{team_id}/time_entries/stop` |
| Get running timer | GET | `/team/{team_id}/time_entries/current` |

### Documents (API v3)

| Action | Method | Endpoint |
|--------|--------|----------|
| Create document | POST | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/docs` |
| List document pages | GET | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/docs/{doc_id}/pages` |
| Get document pages | GET | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/docs/{doc_id}/pages/{page_id}` |
| Create document page | POST | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/docs/{doc_id}/pages` |
| Update document page | PUT | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/docs/{doc_id}/pages/{page_id}` |

### Chat (API v3)

| Action | Method | Endpoint |
|--------|--------|----------|
| Get chat channels | GET | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/chat/channels` |
| Send chat message | POST | `https://api.clickup.com/api/v3/workspaces/{workspace_id}/chat/channels/{channel_id}/messages` |

### Attachments

| Action | Method | Endpoint |
|--------|--------|----------|
| Attach file to task | POST | `/task/{task_id}/attachment` (multipart/form-data) |

## Common Patterns

### Search tasks by name

```bash
curl -s -H "Authorization: $CLICKUP_API_TOKEN" \
  "https://api.clickup.com/api/v2/team/{team_id}/task?name={query}&include_closed=true" | jq
```

### Create a task

```bash
curl -s -X POST \
  -H "Authorization: $CLICKUP_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Task name","description":"Details","assignees":[],"priority":3}' \
  "https://api.clickup.com/api/v2/list/{list_id}/task" | jq
```

### Update a task

```bash
curl -s -X PUT \
  -H "Authorization: $CLICKUP_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated name","status":"in progress"}' \
  "https://api.clickup.com/api/v2/task/{task_id}" | jq
```

### Post a comment

```bash
curl -s -X POST \
  -H "Authorization: $CLICKUP_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"comment_text":"Your comment here"}' \
  "https://api.clickup.com/api/v2/task/{task_id}/comment" | jq
```

## Workflow

1. **Load token**: Export `CLICKUP_API_TOKEN` from `.env`.
2. **Discover workspace**: `GET /team` to get the `team_id`.
3. **Navigate hierarchy**: Spaces → Folders → Lists → Tasks.
4. **Perform action**: Use the appropriate endpoint from the reference above.
5. **Parse response**: Pipe through `jq` for readable output.

## Rate Limits

ClickUp enforces per-token rate limits that vary by workspace plan. If you receive a `429` response, wait and retry. The `X-RateLimit-Remaining` and `X-RateLimit-Reset` headers indicate quota status.

## Additional Resources

- [ClickUp API Reference](https://clickup.com/api)
- [API v2 vs v3 Terminology](https://developer.clickup.com/docs/general-v2-v3-api)
- For detailed endpoint parameters, see [reference.md](reference.md)
