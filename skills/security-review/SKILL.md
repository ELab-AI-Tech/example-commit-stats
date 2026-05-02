---
name: security-review
description: Security review pass on a diff using the OWASP-relevant subset for bash and CLI tools. Use after code-review and before merge. Confidence-tiered output to keep noise down. Anthropic ships a built-in /security-review slash command in Claude Code; this skill is the repo-tuned variant.
---

# /security-review

Security review pass on a diff. Tuned for bash and CLI tools.

## Categories to scan

For `commit-stats`, the relevant attack surfaces are:

| Category | What to look for |
|---|---|
| **Command injection** | Unquoted variables in `eval`, `bash -c`, or any subshell. User input flowing into `git log <here>` without quoting or validation. |
| **Path traversal** | User-supplied paths that could escape the repo. Lack of `realpath` checks. |
| **Argument parsing** | Flag values not validated. Date strings passed to `git log --since` without sanitisation. |
| **Subprocess discipline** | `set -e` not respected (e.g. inside `$()`). Missing `--` before file lists. |
| **Output integrity** | User-controlled strings echoed verbatim could contain terminal control sequences. |
| **Supply chain** | New external commands (curl, wget, network calls) introduced without justification. |
| **Secrets** | Anything that looks like a token, key, or credential committed by accident. |

## Confidence tiering

Match the `code-review` skill:

| Tier | Definition | Action |
|---|---|---|
| **HIGH** | Confirmed vulnerability with attacker-controlled input. | Block merge. |
| **MEDIUM** | Pattern matched, exploitability unclear. | Comment, do not block. |
| **LOW** | Theoretical / hardening suggestion. | Comment only. |

Anthropic's [built-in `/security-review`](https://github.com/anthropics/claude-code-security-review) is the upstream reference. This skill complements it: Anthropic's covers general patterns, this one is repo-tuned for bash specifically.

## Output template

```markdown
## Security review

### HIGH (blocks merge)
- `commit-stats:42` User-supplied `--since` value flows into `git log` without validation. Possible argument injection. Add a regex check (`^[0-9]{4}-[0-9]{2}-[0-9]{2}$` or similar).

### MEDIUM
- `commit-stats:88` Output not stripped of terminal control sequences. Likely safe, worth a human eye if the output ever flows to logs.

### LOW
- Consider rejecting paths outside the repo with `realpath --relative-to`.

### Categories scanned
- [x] Command injection
- [x] Path traversal
- [x] Argument parsing
- [x] Subprocess discipline
- [x] Output integrity
- [x] Supply chain (new dependencies)
- [x] Secrets

### Recommendation
<merge / fix HIGH then merge / escalate>
```

## When NOT to use

- A docs-only change.
- A test-only change that does not touch the CLI surface.
