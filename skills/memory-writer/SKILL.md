---
name: memory-writer
description: Use this skill when durable information from a session should be written into the repository's memory system. This includes stable user preferences, assistant operating defaults, current priorities, important repository decisions, and dated memories worth retaining beyond the current chat.
---

# Memory Writer

Persist durable information from the current session into the core files so future sessions recover context without relying on chat history.

Do not wait for an explicit "save memory" request. Durable context should be preserved by default.

## When To Use

Use this skill when:

- a user preference is established or changed
- assistant voice, tone, or behavior is corrected or refined
- working patterns or collaboration style becomes clearer
- important architecture or repository decisions are made
- current priorities or active focus meaningfully change
- a new tool, integration, or workflow preference is discovered
- the user explicitly asks to remember something
- a session is about to end
- the continuous-learning rule triggers a check

Do not use this skill for:

- temporary back-and-forth that does not affect future work
- raw transcript storage
- information that only matters for the current task

Speculative or assistant-originated thoughts may be stored if they are likely to matter later, but they must be labeled clearly as observations, proposals, or open questions rather than recorded as settled facts.

## Routing

Each piece of durable information belongs in exactly one file. Route it correctly.

### SOUL.md — Who I Am

Write here when:
- the user corrects my tone, voice, or personality
- a humor style or communication pattern is refined
- I discover something about how my persona should work
- new voice examples (positive or negative) emerge naturally

Examples: "Stop hedging so much." "That response was too formal." "More of that energy."

### USER.md — Who the User Is

Write here when:
- a new personal or professional fact is shared
- a communication preference is clarified or changed
- working style patterns become clearer
- role or project context shifts

Examples: "I'm taking over the mobile app too." "Don't explain things I already know." "I'm a morning person."

### MEMORY.md — What Happened and What's Open

Write here when:
- meaningful work is completed or decisions are made (Log section)
- new tasks or threads are opened or existing ones are resolved (Open Threads section)
- collaboration patterns emerge (Working Patterns section)
- something is noticed but not yet settled (Observations section)

This is the most frequently updated file. Use the existing section structure:
- **Open Threads** — active work, unfinished business
- **Working Patterns** — how we collaborate
- **Observations** — things noticed, labeled as such
- **Log** — dated factual record of what happened

### TOOLS.md — How I Work

Write here when:
- a new tool or integration is discovered or configured
- a tool preference changes (prefer X over Y)
- a working style principle is established or refined
- access to something new is granted or revoked

## Writing Rules

- Store summaries, not transcripts.
- Keep entries concise and durable.
- Avoid duplication across files. If it exists somewhere, don't repeat it elsewhere.
- Label unsettled ideas clearly so future sessions don't treat them as facts.
- When updating MEMORY.md's Log, use date headers (### YYYY-MM-DD) and append to existing date sections.
- When resolving an Open Thread, remove it. Don't mark it done, just remove it.
- Condense noisy entries rather than appending more detail.

## Procedure

1. Identify what durable information emerged.
2. Route each piece to the correct core file using the rules above.
3. Read the target file(s) to check for duplication or conflicts.
4. Write concise updates. One file at a time.
5. If something was in the wrong file, move it rather than duplicating.

## Permissions

### Reads
- `core/SOUL.md`
- `core/USER.md`
- `core/MEMORY.md`
- `core/TOOLS.md`

### Writes
- `core/SOUL.md`
- `core/USER.md`
- `core/MEMORY.md`
- `core/TOOLS.md`

### Human Approval
- Required before storing sensitive personal data not already needed for operation.
- Not required for normal preference, state, and memory updates requested by the user or clearly implied by the workflow.

## Recovery

If memory is written to the wrong file, move it rather than duplicating it. If an entry is too noisy, condense it. If two entries conflict, keep the more recent one and note the change.
