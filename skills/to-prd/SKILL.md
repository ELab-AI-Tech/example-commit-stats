---
name: to-prd
description: Turn the current planning conversation into a product requirements document at the repo root. Use after /plan when the user is ready to capture the destination. No fresh interview, just synthesise what was already discussed.
---

# /to-prd

Take the conversation context (typically the output of `/plan`) and produce a product requirements document.

## Rules

- **No fresh interview.** Synthesise what is already in scope. If the context is too thin, stop and tell the user to run `/plan` first.
- **Use canonical terms.** Pull from `UBIQUITOUS_LANGUAGE.md`.
- **Keep the destination concrete.** A PRD is a description of where we are going, in user language and observable outcomes. Not implementation steps.
- **Note proposed module changes.** Before writing the PRD, list the files or modules likely to be touched. Surface this before generating the doc so the user can correct.

## Output template

Write to `PRD.md` (or the argument target):

```markdown
# <feature name>

## Problem
<one paragraph, in user language>

## Solution
<one paragraph, in user language. What changes for the user>

## User stories
- As a <user>, I can <action>, so that <outcome>.
- ...

## Implementation decisions
- <decision>: <what was agreed and why>

## Testing decisions
- <how we will know it works>

## Out of scope
- <what we are explicitly NOT doing>
```

## Stopping rule

A PRD is done when:

- Every open branch from the planning session is resolved or explicitly listed as out of scope.
- The user can read it once and answer "yes that is what we agreed".

## When NOT to use

- Before `/plan`. The PRD without the planning conversation is just guesswork.
- For a one-line bug fix. Use a commit message.
