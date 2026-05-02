---
name: self-review
description: Review the agent's own work in a fresh context window before a human reviewer sees it. Catches obvious problems early, in the smart zone. Use after the PR description is generated and before the human is pinged. Refuse to run in the same session as the implementer.
---

# /self-review

Review the agent's own work in a fresh context window. Catch the obvious problems before a human is pinged.

## Hard rule

**Refuse to run in the same session as the implementer.** The agent that wrote the code is in the dumb zone. A clean session with the diff, the standards, and `CLAUDE.md` reviews better. If you are running in the same session that wrote the code, stop and tell the user to clear context first.

## Inputs to load

1. The diff: `git diff main...HEAD`
2. `CLAUDE.md` (the bash standards, the never-do list, the ask-first list)
3. `UBIQUITOUS_LANGUAGE.md` (the canonical terms)
4. The PR description (from `/pr`)
5. The linked issue files under `issues/`

## Confidence-tiered output

Mirror the Sentry / Trail of Bits pattern. Classify every finding:

| Tier | Definition |
|---|---|
| **HIGH** | Confirmed violation. Vulnerable pattern + attacker-controlled input proven. Standards violation with a specific line. Test that does not test what it claims. **HIGH gates the merge.** |
| **MEDIUM** | Pattern matched, context unclear. Worth a human look. Does not gate the merge. |
| **LOW** | Theoretical or best-practice. Comment only, do not gate. |

Only HIGH issues are blockers. Reviewers should be able to scan the report in 30 seconds and know whether to merge.

## What to look for

- **Standards violations** (per `CLAUDE.md`): missing `set -euo pipefail`, unquoted variables, `eval` of user input, silent error swallowing.
- **Test integrity.** Does each test fail when the implementation is broken? Or is the assertion always true?
- **Description matches diff.** The PR says "added `--since` flag". Does the diff actually add a `--since` flag?
- **Acceptance criteria met.** For each `- [ ]` in the linked issues, find the line of code or test that satisfies it.
- **Out of scope respected.** Does the diff touch anything the issue said was out of scope?
- **Risks called out are real.** If the PR description names a risk, the diff should show evidence of it being mitigated or accepted.

## Output template

```markdown
## Self-review

### HIGH (blocks merge)
- <finding> (commit-stats:LINE) — <reason>

### MEDIUM (worth a human look)
- <finding> — <reason>

### LOW (comment only)
- <finding> — <reason>

### Description / diff alignment
- [x] Description "what changed" matches diff: <yes/no, evidence>
- [x] Acceptance criteria met: <list, with evidence>
- [x] Out of scope respected: <yes/no, evidence>
```

## When NOT to use

- A draft PR. Self-review is for PRs that are about to ask for human time.
- A PR that only touches docs. Use a doc-style spell check instead.
