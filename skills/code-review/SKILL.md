---
name: code-review
description: Apply repo coding standards to a diff with HIGH/MEDIUM/LOW confidence tiers. Pushes the standards to every review (always loaded), unlike skills which the implementer pulls on demand. Use as the human-side review pass after self-review.
---

# /code-review

Apply the repo's coding standards to a diff. This is the *push* side of *push the standards, pull the context*: standards are loaded every time, no opt-out.

## Standards pushed to the reviewer

These are the always-loaded standards for `commit-stats`:

### Bash standards

- **Mandatory header.** Every script starts with `#!/usr/bin/env bash` and `set -euo pipefail`.
- **Quote everything.** `"$var"`, `"$@"`. Bare `$var` is a HIGH finding unless the value is a known integer.
- **Local everything.** Every variable inside a function declared `local`. Otherwise HIGH.
- **No eval of user input.** Ever. HIGH.
- **No `curl | bash`.** Ever. HIGH.
- **Functions under 30 lines.** Over 30 is MEDIUM. Over 60 is HIGH.
- **No silent error swallowing.** No `command || true` without a comment explaining why.
- **No hardcoded paths.** `/Users/`, `/home/`, `/tmp/specific-thing` are HIGH unless tests.

### Test standards

- **Tests describe behaviour.** Tests asserting on internal helper output instead of CLI output are MEDIUM.
- **Real subprocesses, not mocks.** Mocked-everything tests are MEDIUM. Use temp git repos via `setup_test_repo`.
- **One slice per file.** `tests/summary.bats` for `summary`, `tests/by-author.bats` for `by-author`. Mixing is LOW.

### Conventional commits

- **Attribution tag present.** Either `[ai-assisted]` or `[human-only]`. Missing is HIGH (audit trail).
- **Imperative description.** Past tense or full stops in the description are LOW.
- **Type accurate.** A `feat` commit that only edits docs is MEDIUM.

## Confidence tiering

Mirror Sentry's confidence model:

| Tier | Definition | Reviewer action |
|---|---|---|
| **HIGH** | Confirmed standards violation with a specific line. | **Block merge until fixed.** |
| **MEDIUM** | Pattern matched, context unclear. Worth a human look. | Comment, do not block. |
| **LOW** | Style or best-practice. | Comment only, do not block. |

Only HIGH gates the merge. Goal: reviewer scans in 30 seconds, decides in 30 seconds.

## Output template

```markdown
## Code review

### HIGH (blocks merge)
- `commit-stats:42` Unquoted variable `$arg`. Quote as `"$arg"`. (per CLAUDE.md "Quote everything")

### MEDIUM
- `commit-stats:88` Function `parse_since` is 38 lines. Consider splitting.

### LOW
- `tests/by-author.bats:12` Test description could be more specific about the assertion.

### Standards conformance summary
- [x] Mandatory header on every script
- [ ] One HIGH finding to fix before merge

### Recommendation
<merge / fix HIGH then merge / needs deeper review>
```

## When NOT to use

- A draft PR. Reviewer waste.
- A docs-only change. Use a different skill (or just spell check).
