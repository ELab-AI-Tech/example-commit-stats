# CLAUDE.md

Repo-level rules. The agent reads this every session before any other context.

## Overview

`commit-stats` is a small bash CLI that scans a git log and prints stats including AI-attribution counts. It exists as a teaching repo for the Eight Development AI Foundations workshop. Optimise for clarity over cleverness. The point is to demonstrate the workflow, not to ship a production tool.

## Commands

```bash
./commit-stats <subcommand> [options]    # run the CLI
make test                                # run bats tests
make lint                                # run shellcheck
make ci                                  # lint + test (CI gate)
```

## Conventions

- Bash 4 or later. Always `set -euo pipefail` at the top of every script.
- Functions over scripts. Each subcommand is a function. Keep functions under 30 lines.
- Quote every variable expansion: `"$var"`, never `$var`.
- `local` for every variable inside a function.
- Use `printf` over `echo` for anything beyond a single literal string.
- Test with [bats-core](https://github.com/bats-core/bats-core). Tests live in `tests/`.
- One bats test file per subcommand: `tests/summary.bats`, `tests/by-author.bats`, etc.

## Never do

- Do not pipe `curl` into bash.
- Do not `eval` user input.
- Do not silently swallow errors. If a command can fail, handle it explicitly.
- Do not commit anything that touches the user's real git config or pushes to a real remote without asking first.

## Ask first

- Before running `git rebase`, `git reset --hard`, or any history-rewriting command.
- Before adding a new external dependency. Vanilla bash + git + standard POSIX tools cover everything we need.
- Before changing the public CLI surface (subcommands, flags). Surface changes need a PR description that calls out the change explicitly.

## Skills available

These skills live in `.claude/skills/` and the agent discovers them automatically. Use them by name.

| Skill | Purpose |
|---|---|
| `plan` | Interview the user one question at a time until plan and developer share the same design concept. |
| `to-prd` | Turn a planning conversation into a PRD markdown file. |
| `to-issues` | Split a PRD into independently grabbable vertical-slice issues. |
| `tdd` | Red-green-refactor loop with bats tests. |
| `commit` | Atomic conventional commit with `[ai-assisted]` attribution. |
| `pr` | Generate a PR description from the diff, the issues, and the commit history. |
| `self-review` | Review the agent's own work in a fresh context window. |
| `code-review` | Push the bash standards (this file) to the reviewer with HIGH/MEDIUM/LOW confidence tiers. |
| `security-review` | Apply the OWASP-relevant subset to bash code paths. |

## Output style

Bare bones. No preamble. No verbose summaries. Treat every word as if it costs a token.

## Glossary pointer

For terms used in this repo (commit, author, attribution tag, AI-assisted, slice), see `UBIQUITOUS_LANGUAGE.md`.
