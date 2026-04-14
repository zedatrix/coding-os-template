# ClickUp API v2 — Detailed Endpoint Reference

Expanded parameter details for each endpoint group. All v2 endpoints use base URL `https://api.clickup.com/api/v2`. All v3 endpoints use `https://api.clickup.com/api/v3`.

## Authentication

Every request requires the `Authorization` header with a personal API token (no `Bearer` prefix).

```
Authorization: pk_81435770_...
```

---

## Workspace / Team

### GET /team

Returns all workspaces (called "teams" in v2) the token has access to.

Response shape:
```json
{ "teams": [{ "id": "...", "name": "...", "members": [...] }] }
```

### GET /team/{team_id}/member

Returns workspace members. Use v3 equivalent `/workspaces/{team_id}/members` for richer data.

---

## Spaces

### GET /team/{team_id}/space

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| archived | boolean | false | Include archived spaces |

### GET /space/{space_id}

Returns a single space with its statuses, features, and settings.

---

## Folders

### GET /space/{space_id}/folder

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| archived | boolean | false | Include archived folders |

### POST /space/{space_id}/folder

Body: `{ "name": "Folder Name" }`

### GET /folder/{folder_id}

Returns folder details including its lists.

### PUT /folder/{folder_id}

Body: `{ "name": "New Name" }`

### DELETE /folder/{folder_id}

Permanently deletes the folder.

---

## Lists

### GET /folder/{folder_id}/list

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| archived | boolean | false | Include archived lists |

### GET /space/{space_id}/list

Folderless lists in a space.

### POST /folder/{folder_id}/list

Body:
```json
{
  "name": "List Name",
  "content": "Description",
  "due_date": 1567780450202,
  "priority": 1,
  "status": "red"
}
```

### POST /space/{space_id}/list

Same body as above, creates a folderless list.

### GET /list/{list_id}

Returns list details including task count and statuses.

### PUT /list/{list_id}

Body: any subset of list fields to update.

---

## Tasks

### GET /list/{list_id}/task

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| archived | boolean | false | Include archived |
| include_closed | boolean | false | Include closed tasks |
| page | integer | 0 | Page number (100 tasks/page) |
| order_by | string | created | Sort: id, created, updated, due_date |
| reverse | boolean | false | Reverse sort order |
| subtasks | boolean | false | Include subtasks |
| statuses[] | string[] | — | Filter by status name |
| assignees[] | integer[] | — | Filter by assignee user IDs |
| tags[] | string[] | — | Filter by tag names |
| due_date_gt | integer | — | Due date greater than (unix ms) |
| due_date_lt | integer | — | Due date less than (unix ms) |
| date_created_gt | integer | — | Created after (unix ms) |
| date_created_lt | integer | — | Created before (unix ms) |
| date_updated_gt | integer | — | Updated after (unix ms) |
| date_updated_lt | integer | — | Updated before (unix ms) |
| include_timl | boolean | false | Include tasks in multiple lists |

### GET /team/{team_id}/task (Filtered Team Tasks)

Same filters as above, plus:

| Param | Type | Description |
|-------|------|-------------|
| space_ids[] | string[] | Filter by space IDs |
| folder_ids[] | string[] | Filter by folder IDs |
| list_ids[] | string[] | Filter by list IDs |
| project_ids[] | string[] | Filter by project IDs |

### POST /list/{list_id}/task

Body:
```json
{
  "name": "Task Name",
  "description": "Task description in markdown",
  "assignees": [123],
  "tags": ["tag1"],
  "status": "Open",
  "priority": 3,
  "due_date": 1567780450202,
  "due_date_time": true,
  "time_estimate": 3600000,
  "start_date": 1567780450202,
  "start_date_time": true,
  "notify_all": true,
  "parent": null,
  "links_to": null,
  "custom_fields": [
    { "id": "field_uuid", "value": "field_value" }
  ]
}
```

Priority values: 1=Urgent, 2=High, 3=Normal, 4=Low.

### GET /task/{task_id}

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| custom_task_ids | boolean | false | Use custom task IDs |
| include_subtasks | boolean | false | Include subtasks |
| include_markdown_description | boolean | false | Return markdown description |

### PUT /task/{task_id}

Body: any subset of task fields to update.

---

## Comments

### GET /task/{task_id}/comment

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| start | integer | — | Start offset for pagination |
| start_id | string | — | Start from this comment ID |

### POST /task/{task_id}/comment

Body:
```json
{
  "comment_text": "Plain text comment",
  "assignee": 123,
  "notify_all": true
}
```

For rich text, use `comment` array instead of `comment_text`:
```json
{
  "comment": [
    { "text": "Bold text", "attributes": { "bold": true } },
    { "text": "\n" }
  ]
}
```

---

## Tags

### POST /task/{task_id}/tag/{tag_name}

Adds the tag to the task. Creates the tag if it doesn't exist in the space.

### DELETE /task/{task_id}/tag/{tag_name}

Removes the tag from the task.

---

## Time Tracking

### GET /task/{task_id}/time

Returns all time entries for a task.

### POST /team/{team_id}/time_entries

Body:
```json
{
  "description": "What was worked on",
  "tid": "task_id",
  "start": 1567780450202,
  "duration": 3600000,
  "assignee": 123,
  "billable": true
}
```

Duration is in milliseconds.

### POST /team/{team_id}/time_entries/start

Body:
```json
{
  "tid": "task_id",
  "description": "Working on feature",
  "billable": true
}
```

### POST /team/{team_id}/time_entries/stop

Stops the currently running timer for the authenticated user.

### GET /team/{team_id}/time_entries/current

Returns the currently running time entry, if any.

---

## Attachments

### POST /task/{task_id}/attachment

Uses `multipart/form-data`. The file field name is `attachment`.

```bash
curl -X POST \
  -H "Authorization: $CLICKUP_API_TOKEN" \
  -F "attachment=@/path/to/file.pdf" \
  "https://api.clickup.com/api/v2/task/{task_id}/attachment"
```

---

## Documents (API v3)

### POST /workspaces/{workspace_id}/docs

Body:
```json
{
  "name": "Document Title",
  "parent": { "id": "list_id", "type": 6 },
  "visibility": "PUBLIC"
}
```

Parent types: 4=Space, 5=Folder, 6=List, 7=Everything (workspace level).

### GET /workspaces/{workspace_id}/docs/{doc_id}/pages

Returns all pages in a document.

### GET /workspaces/{workspace_id}/docs/{doc_id}/pages/{page_id}

Returns a single page with content.

### POST /workspaces/{workspace_id}/docs/{doc_id}/pages

Body:
```json
{
  "name": "Page Title",
  "content": "Page content in markdown"
}
```

### PUT /workspaces/{workspace_id}/docs/{doc_id}/pages/{page_id}

Body: `{ "name": "...", "content": "..." }`

---

## Chat (API v3)

### GET /workspaces/{workspace_id}/chat/channels

Returns chat channels in the workspace.

### POST /workspaces/{workspace_id}/chat/channels/{channel_id}/messages

Body:
```json
{
  "content": "Message text"
}
```

---

## Error Handling

| Status | Meaning |
|--------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad request (check body/params) |
| 401 | Invalid or missing token |
| 403 | Insufficient permissions |
| 404 | Resource not found |
| 429 | Rate limited — check `X-RateLimit-Reset` header |
| 500 | ClickUp server error |

## Pagination

Task list endpoints return max 100 results per page. Use `page=0`, `page=1`, etc. When fewer than 100 results are returned, you've reached the last page.
