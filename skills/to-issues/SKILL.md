---
name: to-issues
description: Split a PRD into independently grabbable vertical-slice issues. Each slice ships a thin path through every layer that delivers a working piece of functionality. Use after /to-prd. Output is local markdown files in issues/ that an agent can grab one at a time.
---

# /to-issues

Take a PRD and split it into a Kanban of independently grabbable issues using vertical slices.

## What is a vertical slice

A slice is a thin path through every layer of the system that ships a working feature.

For `commit-stats`, a slice is one full subcommand end-to-end: parser, logic, output, test. Not "all parsers first, then all logic". One subcommand at a time.

## Rules

- **Each issue must be independently grabbable.** An agent should be able to pick up the issue without having to load the others. Use blocking relationships only when one slice genuinely depends on another's output (e.g. shared helper).
- **No horizontal slices.** If a proposed issue is "build all the parsers", reject it and split into per-subcommand parsers instead.
- **Each issue ships something demonstrable.** "Internal refactor done" is not a valid outcome. The user must be able to invoke or test the result.
- **Tag each issue as HITL or AFK.**
  - **HITL** (human in the loop): the issue needs the user to make decisions during execution. Examples: anything touching the public CLI surface, anything that changes a test contract.
  - **AFK** (away from keyboard): the agent can implement and commit without supervision. Examples: a clearly-scoped TDD slice with one subcommand.

## Output

Write one markdown file per issue under `issues/`:

```
issues/
├── 001-summary-subcommand.md
├── 002-by-author-subcommand.md
└── 003-since-flag.md
```

Each file uses this template:

```markdown
# <issue title>

**Type:** <HITL | AFK>
**Blocked by:** <issue numbers, or none>

## What ships
<one paragraph, observable behaviour>

## Acceptance
- [ ] <observable check 1>
- [ ] <observable check 2>

## Out of scope
- <explicit non-goal>
```

## When NOT to use

- Before `/to-prd`. Issues without a destination document drift.
- For a single-slice feature. Skip directly to TDD.
