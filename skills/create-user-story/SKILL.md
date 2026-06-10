---
name: create-user-story
description: Create or improve user stories, tickets, and epics in a clean product-facing format. Use when the user asks to create, write, draft, rewrite, or improve a user story, ticket, or epic for the active project, especially when raw implementation notes need to be turned into clear requirements.
---

# Create User Story

Generate user stories for the active project using the team's standardized format.

Default to concise, behavior-focused stories. Use codebase research to understand the current product and constraints, but do not turn the final story into a file-by-file or code-by-code implementation checklist unless the user explicitly asks for an engineering-heavy ticket.

## Pre-Research (Required)

Before writing any story, search the relevant GitHub repos for related code so the story is accurate and grounded in the actual codebase.

Identify the project's repositories and reference branches from the matching project file in `projects/`, or ask the user if they are not recorded there. For example:

- **Backend**: `your-org/example-backend` (production: `master`, dev: `dev`)
- **Frontend**: `your-org/example-frontend` (production: `main`, dev: `dev`)

Use the project's dev branch as the point of reference unless told otherwise.

```bash
# Search a repo for related code
gh search code "SEARCH_TERM" --repo your-org/example-backend

# Read specific files for full context
gh api repos/your-org/example-backend/contents/PATH --jq '.content' | base64 -d
```

Read every file found in your search. Understand the relevant behavior, permissions, user flow, and constraints before writing.

Research is for accuracy. The final story should usually describe product behavior, business intent, user experience, permissions, and success criteria, not internal file locations, function names, routes, or code snippets.

## Default Story Format

Every user story MUST use this exact layout. Each section heading must be **bolded**. The title has no section label.

Use the core format below by default:

```md
**[Title text here]**

**User Story**
As a [user], I want [feature] so that [benefit].

**Context**
[Why this story exists, what problem it solves, and why it matters.]

**Description & Details**
[Describe the required behavior in product-facing language. Cover scope, supported states, user flow, success outcomes, error handling, and any important constraints without calling out specific files, functions, endpoints, components, hooks, utilities, or code snippets.]

**Permissions & Entitlements**
[RBAC permissions required. Entitlements needed for the feature.]

**Acceptance Criteria**
- [Short, specific bullet point]
- [Short, specific bullet point]
- [Short, specific bullet point]
```

## Optional Technical Sections

Only include sections like **Database Schema**, **API Routes**, or **Implementation Notes** when at least one of these is true:

- The user explicitly asks for a technical or implementation-ready ticket
- The schema or API contract is itself the main requirement
- Omitting the technical detail would make the story materially incomplete

When you include technical sections, keep them scoped and purposeful. Do not mirror raw implementation notes line-by-line.

## Translation Rules

When the user pastes raw implementation notes, code snippets, endpoint paths, file names, or component references:

1. Treat them as source material, not final wording
2. Translate them into behavior-focused requirements
3. Preserve the real business intent, user experience, permissions, status coverage, notifications, and success or failure outcomes
4. Strip out file paths, code symbols, exact endpoint URLs, utility names, and framework-specific wiring by default
5. Keep the main story readable by product, design, QA, and engineering stakeholders
6. Only surface exact technical details when the user clearly wants them

## Writing Rules

1. Write in a formal, professional tone suitable for business and technical teams.
2. Use the standard agile format: "As a [user], I want [feature] so that [benefit]."
3. If the request is unclear, ask clarifying questions before finalizing.
4. Prefer concise, product-facing language over implementation-heavy language.
5. Do not echo raw code, file paths, function names, route names, or component names unless explicitly requested.
6. Acceptance Criteria is never empty. If insufficient info is provided, deduce what belongs there using your own reasoning.
7. Acceptance criteria must use unordered bullet points, be short and direct, and never contain emojis.
8. Every section heading must be **bolded**.
9. Never use page breaks, horizontal rules, or em dashes.
10. Never use placeholders, TODOs, `// ...`, `[...]`, or unfinished segments. Never omit for brevity. Never defer to the user. Complete the task fully.
11. If there is no correct answer or you do not know something, say so. Do not guess.
12. When technical detail is needed, group it into optional technical sections instead of letting it dominate the story.

## Epics

When asked for an epic (not a story):

- Create a single high-level ticket
- Keep it brief
- Do not include technical implementation details unless explicitly requested
- Still follow the same layout, but with less granularity in each section

## Backend and Frontend Guidance

When the request touches backend or frontend implementation:

- Describe the capability, business rules, integrations, authorization, and user-visible outcomes at a system level
- Mention lifecycle behavior only when it matters to the feature outcome
- Avoid prescribing specific files, controllers, requests, policies, observers, components, hooks, or route names unless the user asks for engineering-level detail
- If permissions or entitlements matter, include them clearly

## Example

**Clone Job Listing**

**User Story**
As a recruiter, I want to clone an existing job listing so that I can create a new draft from a similar role without rebuilding it manually.

**Context**
Recruiters often need to recreate similar roles and currently must re-enter the same information more than once. A clone workflow would reduce repetitive effort, speed up job creation, and make it easier to launch new drafts based on existing listings.

**Description & Details**
A new `Clone Job` action should be available anywhere a user can manage eligible job listings. When selected, the system should create a new draft based on the chosen listing and take the user directly into the draft editing flow with the copied information already populated. The action should follow the existing success and error notification patterns, and it should prevent duplicate submissions while the clone is being created.

**Permissions & Entitlements**
- Permission: Users with access to create and manage job listings should be able to clone eligible listings
- Entitlement: Recruiting module enabled

**Acceptance Criteria**
- Users can clone eligible job listings from both the listings view and the details view
- The cloned job listing is created as a new draft
- The user is taken directly to the new draft editing flow after a successful clone
- Success and error notifications are shown appropriately
- The action prevents duplicate submissions while the clone is processing
