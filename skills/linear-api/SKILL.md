---
name: linear-api
description: >-
  Interact with Linear via its GraphQL API — query and create issues, comments,
  teams, projects, and workflow states. Use when the user asks to create, read,
  update, or search Linear issues, or when Cursor's Linear MCP server tools are
  unavailable.
---

# Linear API

Provides direct Linear GraphQL API access via `curl` when MCP server tools are not available in the agent session.

## Prerequisites

The Linear personal API key must be set in the repo's `.env` file:

```
LINEAR_API_KEY=lin_api_...
```

Generate a key at: **Linear → Settings → API → Personal API keys**

From the repo root, load it before making requests:

```bash
export LINEAR_API_KEY=$(rg '^LINEAR_API_KEY=' .env | cut -d '=' -f2-)
```

## Base URL & Auth

All requests are POST to `https://api.linear.app/graphql` with the API key in the `Authorization` header (no `Bearer` prefix for personal API keys).

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query":"..."}' \
  "https://api.linear.app/graphql"
```

For mutations, pass `query` and `variables` in the JSON body.

## Quick Reference

### Teams & Organization

| Action | Query/Mutation |
|--------|----------------|
| Get current user (viewer) | `viewer { id name email }` |
| List teams | `teams { nodes { id name key } }` |
| Get team by ID | `team(id: "...") { id name key }` |

### Issues

| Action | Query/Mutation |
|--------|----------------|
| List issues (filtered) | `issues(filter: {...}, first: 50)` |
| Get single issue | `issue(id: "...")` |
| Create issue | `issueCreate(input: {...})` |
| Update issue | `issueUpdate(id: "...", input: {...})` |

### Comments

| Action | Query/Mutation |
|--------|----------------|
| Get issue comments | `issue(id: "...") { comments { nodes { ... } } }` |
| Create comment | `commentCreate(input: { issueId, body })` |

## Common Patterns

### List teams (get team IDs)

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query":"query { teams { nodes { id name key } } }"}' \
  "https://api.linear.app/graphql" | jq
```

### Search / list issues by team

```bash
# Replace TEAM_ID with a team UUID from the teams query
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query($filter: IssueFilter) { issues(filter: $filter, first: 50) { nodes { id identifier title state { name } assignee { name } } } }",
    "variables": {
      "filter": { "team": { "id": { "eq": "TEAM_ID" } } }
    }
  }' \
  "https://api.linear.app/graphql" | jq
```

### Search issues by title (full-text)

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query($filter: IssueFilter) { issues(filter: $filter, first: 50) { nodes { id identifier title url state { name } assignee { name } } } }",
    "variables": {
      "filter": { "title": { "containsIgnoreCase": "search term" } }
    }
  }' \
  "https://api.linear.app/graphql" | jq
```

### Create an issue

```bash
# Required: teamId, title. Optional: description, assigneeId, stateId, priority, projectId, labelIds, dueDate
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation($input: IssueCreateInput!) { issueCreate(input: $input) { success issue { id identifier title url } } }",
    "variables": {
      "input": {
        "teamId": "TEAM_ID",
        "title": "Issue title",
        "description": "Optional markdown description",
        "priority": 2
      }
    }
  }' \
  "https://api.linear.app/graphql" | jq
```

**Priority values:** 0 = none, 1 = urgent, 2 = high, 3 = medium (normal), 4 = low

### Update an issue

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation($id: String!, $input: IssueUpdateInput!) { issueUpdate(id: $id, input: $input) { success issue { id identifier title state { name } } } }",
    "variables": {
      "id": "ISSUE_ID",
      "input": { "title": "Updated title", "stateId": "STATE_ID" }
    }
  }' \
  "https://api.linear.app/graphql" | jq
```

### Create a comment on an issue

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation($input: CommentCreateInput!) { commentCreate(input: $input) { success comment { id body } } }",
    "variables": {
      "input": {
        "issueId": "ISSUE_ID",
        "body": "Comment text (markdown supported)"
      }
    }
  }' \
  "https://api.linear.app/graphql" | jq
```

### Get workflow states for a team (for stateId)

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query($id: String!) { team(id: $id) { states { nodes { id name type } } } }",
    "variables": { "id": "TEAM_ID" }
  }' \
  "https://api.linear.app/graphql" | jq
```

### Get labels for a team

```bash
curl -s -X POST \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query($filter: IssueLabelFilter) { issueLabels(filter: $filter, first: 100) { nodes { id name } } }",
    "variables": {
      "filter": { "team": { "id": { "eq": "TEAM_ID" } } }
    }
  }' \
  "https://api.linear.app/graphql" | jq
```

## Workflow

1. **Load token**: Export `LINEAR_API_KEY` from the repo `.env`.
2. **Discover team**: `teams { nodes { id name key } }` to get `teamId` (UUID).
3. **Query or create**: Use `issues` query or `issueCreate` mutation.
4. **Parse response**: Pipe through `jq` for readable output.

## Rate Limits

Linear enforces rate limits. If you receive a `429` response, wait and retry. The API returns structured errors in the response body.

## Additional Resources

- [Linear GraphQL API](https://developers.linear.app/docs/graphql/working-with-the-graphql-api)
- [Linear API Reference](https://developers.linear.app)
- For detailed schema and filters, see [reference.md](reference.md)
