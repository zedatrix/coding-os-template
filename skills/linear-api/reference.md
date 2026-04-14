# Linear GraphQL API — Reference

Expanded reference for common queries and mutations. Base URL: `https://api.linear.app/graphql`. Auth: `Authorization: $LINEAR_API_KEY` (no Bearer prefix for personal API keys).

## IssueCreateInput

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| teamId | String | Yes | Team UUID |
| title | String | No | Issue title (defaults to "Untitled") |
| description | String | No | Markdown body |
| assigneeId | String | No | User UUID |
| stateId | String | No | Workflow state UUID |
| projectId | String | No | Project UUID |
| priority | Int | No | 0=none, 1=urgent, 2=high, 3=medium, 4=low |
| labelIds | [String] | No | Label UUIDs |
| dueDate | String | No | YYYY-MM-DD (TimelessDate) |
| parentId | String | No | Parent issue UUID for sub-issues |

## IssueUpdateInput

Same fields as create, but all optional. Only include fields you want to change.

## IssueFilter (for queries)

| Field | Example | Description |
|-------|---------|--------------|
| team.id.eq | `"teamId"` | Filter by team |
| assignee.id.eq | `"userId"` | Filter by assignee |
| state.id.eq | `"stateId"` | Filter by workflow state |
| title.containsIgnoreCase | `"search"` | Full-text title search |
| project.id.eq | `"projectId"` | Filter by project |
| createdAt.gte | `"2024-01-01"` | Created after date |
| createdAt.lte | `"2024-12-31"` | Created before date |

## Pagination

Use `first`, `after` (cursor) for pagination:

```graphql
issues(filter: {...}, first: 50, after: "cursor") {
  nodes { ... }
  pageInfo { hasNextPage endCursor }
}
```

## CommentCreateInput

| Field | Type | Required |
|-------|------|----------|
| issueId | String | Yes |
| body | String | Yes (markdown) |
