# Rebuttal

Cursor command design for a reusable plan-revision workflow.

## Overview

You are the plan's author. A reviewer (possibly more than one, across previous rounds) has pushed back on the latest version. Your job is to weigh each concern, decide what to accept, and produce the next version of the plan.

Reviewers are advisors, not gatekeepers. Accept what sharpens the plan. Reject what's off-base or out of scope. Explain your reasoning either way.

## Usage

`/rebuttal` — no arguments. The author is always you.

## Inputs to read from the chat

1. The **latest `## Current Plan (v{N})` block**, or the original plan if this is round one.
2. The **most recent critique block** — look for `## {Name}'s Critique of Plan v{N}` or `## Reviewer Critique of Plan v{N}`. That's what you're responding to.
3. Any **earlier critiques and rebuttals** still in the chat. Use them to detect conflicts between reviewers.

## Rules of engagement

- **Per-item decisions.** For every concern in the latest critique, make a call: ACCEPT, MODIFY, or REJECT. No glossing over.
- **One-sentence reasoning per decision.** Short, specific, honest. "Rejected: we don't have two call sites yet, premature abstraction." Not "good point but we'll revisit later."
- **Attribute by name.** If the critique has a reviewer name in its heading (`Gemini's Critique of Plan v2`), attribute decisions as "Gemini raised X → ACCEPT". If unnamed, use "Reviewer raised X".
- **Handle conflicts explicitly.** When the current critique contradicts a prior reviewer's accepted point, name the conflict in-line ("Gemini wanted X in v2, GPT is arguing for Y — siding with Y because {reason}") and make the call.
- **No free passes, no automatic rejections.** Reviewers aren't always right. Neither are you. Judge each point on merit.
- **No code, no implementation.** This command produces plan text only. Do not start the work. Wait for an explicit go-ahead.
- **No-op is legal.** If nothing warrants a change, say so plainly and keep the current version number. Do not bump v{N} → v{N+1} just to produce output.

## Output format

### Normal case (at least one change accepted)

```
## Rebuttal to {Name}'s Critique of Plan v{N}

### Decisions

1. **[ACCEPT|MODIFY|REJECT]** — {Name} raised: {brief summary of concern}
   - **Reasoning:** {one sentence}
   - **Change:** {what's different in v{N+1}, or "no change" for REJECT}

2. **[...]** — ...

{If applicable: conflict note, e.g. "Note: Gemini (v2) wanted X. GPT is now arguing for Y. Siding with Y — {reason}."}

## Current Plan (v{N+1})

{Full updated plan text. Not a diff. Headings, sections, file paths, the works. Future reviewers need the complete artifact to critique.}

### Changes from v{N}

- {Change 1} — per {Name}'s concern #{n}
- {Change 2} — per {Name}'s concern #{n}
- {...}
```

### No-op case (nothing warranted a change)

```
## Rebuttal to {Name}'s Critique of Plan v{N}

### Decisions

1. **REJECT** — {Name} raised: {...}
   - **Reasoning:** {...}

2. **REJECT** — ...

**Verdict:** No changes warranted. Plan v{N} stands.
```

Do not produce a new `## Current Plan (v{N+1})` block when nothing changed. Keep the version number exactly where it was so future `/second-opinion` calls target the same artifact.
