# Ubiquitous Language

Canonical terms for `commit-stats`. The agent uses these names in code, tests, output, and docs.

## Core

| Term | Definition | Aliases to avoid |
|---|---|---|
| **Commit** | A single git commit object on the current branch. | revision, change, patch |
| **Author** | The committer's name as recorded in the commit metadata. | dev, contributor, person |
| **Attribution tag** | A trailing token in the commit message that signals authorship of the change. The repo currently recognises `[ai-assisted]` and `[human-only]`. | tag, label, marker |
| **AI-assisted commit** | A commit whose message contains the `[ai-assisted]` attribution tag. | AI commit, AI-written commit |
| **Human-only commit** | A commit whose message contains the `[human-only]` attribution tag, or no attribution tag at all. | human commit, manual commit |
| **Subcommand** | A named action invoked as `commit-stats <subcommand>`. The repo ships three: `summary`, `by-author`, and date-filtered variants via `--since`. | command, action, verb |
| **Stat** | A single computed metric printed by the CLI. | metric, number, count |
| **Slice** | A vertical slice of work. One subcommand plus its tests plus its CLI wiring counts as one slice. | feature, ticket, chunk |

## Relationships

- A **Commit** has exactly one **Author**.
- A **Commit** may carry zero or one **Attribution tag**.
- A **Subcommand** prints zero or more **Stats**.
- A **Slice** ships exactly one **Subcommand** end-to-end.

## Flagged ambiguities

- *AI-tagged* and *AI-assisted* are used interchangeably in conversation. **Use `AI-assisted` everywhere in code, tests, and output.** Retire `AI-tagged`.
- *Run* could mean *invoke the CLI* or *execute the test suite*. **Use `invoke` for the CLI and `run` for tests.**
