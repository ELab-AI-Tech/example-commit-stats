---
name: pr
description: Generate a pull request description from the diff, the linked issues, and the commit history. Use when opening a PR. Output is a markdown block ready to paste into the PR body. Pairs with the self-review skill.
---

# /pr

Produce a PR description from the diff, the linked issues, and the commit history on the branch.

## Sources to read

- `git diff main...HEAD` for the changes
- The issue files under `issues/` referenced in commit messages
- The commit log on this branch

## Output template

```markdown
## What changed
<one paragraph in user language. What is observable now that was not before>

## Why
<one paragraph. The problem this solves, in user language. Reference the issue>

## How
- <key implementation decision 1>
- <key implementation decision 2>
- <key implementation decision 3>

## Tests
- <new test file or test added, and what it covers>

## Risks called out
- <anything reviewers should look at twice>

## Out of scope
- <anything explicitly not done in this PR that someone might expect>

## Attribution
- AI-assisted commits: <count>
- Human-only commits: <count>
- Issues addressed: <list>
```

## Rules

- **Lead with what changed for the user, not the file list.** Reviewers look at the diff for the file list.
- **Risks called out is not optional.** If the PR touches input parsing, file IO, or the public CLI surface, name the risk explicitly. Reviewers cannot prioritise what they cannot see.
- **Attribution counts pulled from the commit log.** Count `[ai-assisted]` vs `[human-only]` tags on the branch. This is audit data.
- **No marketing language.** No "powerful", "seamless", "robust". Plain description of what changed.

## When NOT to use

- A draft PR for early feedback. Use a one-line description, mark it as draft.
- A PR that is just a version bump. Use the conventional commit message as the PR body.
