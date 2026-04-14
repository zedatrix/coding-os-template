---
name: session-close
description: Use this skill when a session is ending, when the user says good night, signs off, is about to shut down, or otherwise indicates this may be the last chance to persist work. This skill ensures durable changes are written to memory, checks git state, and makes the local-vs-remote status explicit before the session ends.
---

# Session Close

Use this skill when the user is wrapping up for the session or when there is a real risk that local work will be lost before the next interaction.

## Purpose

Create a reliable end-of-session handoff by making sure durable changes are written to memory, local changes are staged and committed when appropriate, and the user clearly knows whether the current state exists only locally, has been committed locally, or has been pushed.

## When To Use

Use this skill when:

- the user says good night, signs off, or says they are leaving
- the user says they are shutting down the computer or ending work for now
- the conversation reaches a natural stopping point after meaningful changes
- the user asks whether everything has been saved

## Procedure

1. Identify durable changes from the current session.
2. **Update memory first.** Use `memory-writer` to update the relevant memory files immediately. Do not proceed to commit until memory is updated. This step is frequently skipped; it is required.
3. Review the conversation transcript for this session and determine if an update to any of the following is necessary: 
   3a. Your soul and general behavior and response structure in `core/SOUL.md` is required
   3b. Your user preferences in `core/USER.md`
   3c. Your tooling access and configurations in `core/TOOLS.md`
4. Check `git status --short`.
5. If there are local changes worth preserving, run `git add` and `git commit` in sequence unless the user has explicitly said not to create a commit.
6. If there are uncommitted changes left intentionally, tell the user explicitly that the latest state is only local and uncommitted.
7. Push only if the user asks for remote persistence or has already made that preference explicit for the current task.
8. In the final response, state clearly which of these is true:
   - memory updated only
   - committed locally
   - pushed to remote

## Required Checks

- confirm whether memory was updated for the final session changes
- confirm whether there are unstaged or uncommitted changes
- confirm whether a local commit was created
- confirm whether the latest commit is on the remote or only local