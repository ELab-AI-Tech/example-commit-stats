---
name: commit
description: Make an atomic conventional commit with the AI-attribution tag. Use after every TDD green-refactor cycle, after a PRD lands, or whenever a unit of work is complete. Enforces the conventional commits format and the [ai-assisted] attribution tag for audit traceability.
---

# /commit

Make a single atomic commit using the conventional commits format with an attribution tag.

## Format

```
<type>(<scope>): <imperative description> [<issue-id>] [ai-assisted]

[optional body, wrapped at 72 cols]
```

| Field | Rules |
|---|---|
| `type` | `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `build`, `ci`. Pick the narrowest accurate one. |
| `scope` | The subcommand or module affected. For `commit-stats`: `summary`, `by-author`, `cli`, `tests`, `docs`. |
| `description` | Imperative voice, lower case, no full stop. Under 60 characters. |
| `issue-id` | The issue number from `issues/` if there is one. Optional for chores. |
| `[ai-assisted]` | Required if any AI agent contributed code, tests, or docs to this commit. Otherwise `[human-only]`. |

## Examples

```
feat(summary): print total commits and AI-assisted count [issue-1] [ai-assisted]
fix(cli): handle empty git log without crashing [issue-4] [human-only]
test(by-author): cover author with no AI commits [issue-2] [ai-assisted]
docs(readme): document --since flag [ai-assisted]
```

## Rules

- **Atomic.** One commit, one logical change. If you find yourself listing two unrelated things in the body, split into two commits.
- **Tests included.** A `feat` or `fix` commit that does not also touch the test file is suspect. Either add tests in the same commit, or explain in the body why not.
- **Attribution is non-negotiable.** Every commit gets either `[ai-assisted]` or `[human-only]`. No silent commits. This is the audit-evidence trail.
- **Refuse to commit dirty state.** If `make ci` (lint + tests) does not pass, do not commit. Surface the failure to the user.

## Pre-commit hooks

This repo recommends running these before every commit. The `commit` skill enforces them programmatically:

- `shellcheck commit-stats` (lint)
- `bats tests` (tests)
- `git diff --cached | grep -iE '\b(TODO|XXX|FIXME)\b'` (no debt smuggled in)
- Block on `set +e` introduced anywhere
- Block on hard-coded paths starting with `/Users/` or `/home/`

## When NOT to use

- A WIP checkpoint that should not be in the permanent log. Use `git stash` instead.
- A merge commit. Use the merge tooling directly.
