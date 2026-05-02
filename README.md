# commit-stats

A tiny bash CLI that scans a git log and prints commit stats, including AI-attribution counts.

This is a **workshop demo repo** for the Eight Development Day 2 (Session 2) AI Foundations workshop. The point is the *workflow*, not the language. Bash is the demo language because every developer in the room reads bash regardless of stack (Android, firmware, QA, web). The skills, the planning loop, the TDD loop, the review loop, and the eval gates are what we are showcasing.

The repo ships intentionally empty. During the workshop, the agent builds three subcommands one vertical slice at a time:

| #   | Subcommand               | Demo step                                              |
| --- | ------------------------ | ------------------------------------------------------ |
| 1   | `commit-stats summary`   | total commits, authors, AI-tagged count                |
| 2   | `commit-stats by-author` | group commits by author with AI-attribution percentage |
| 3   | `commit-stats --since`   | date filter flag with a small parser                   |

## Layout

```
commit-stats/
├── README.md                 # this file
├── CLAUDE.md                 # repo-level rules and bash standards
├── UBIQUITOUS_LANGUAGE.md    # canonical terms
├── .claude/
│   └── skills/               # workshop skills
│       ├── plan/
│       ├── to-prd/
│       ├── to-issues/
│       ├── tdd/
│       ├── commit/
│       ├── pr/
│       ├── self-review/
│       ├── code-review/
│       └── security-review/
├── commit-stats              # the bash CLI (scaffold)
├── tests/
│   └── helper.bash           # bats-core test helper
├── Makefile                  # `make test`, `make lint`
└── .gitignore
```

## Prerequisites

- bash 4 or later
- git
- [bats-core](https://github.com/bats-core/bats-core) for tests
- [shellcheck](https://www.shellcheck.net/) for lint
- Claude Code (or compatible agent) with the skills in `.claude/skills/` discovered

## Running

```bash
./commit-stats summary            # not implemented yet, builds during the workshop
make test                         # bats tests
make lint                         # shellcheck
```

## Workshop flow

The demo runs through nine steps mapped to the workshop spine. Refer to `INSTRUCTIONS-DAY-2.md` at the Exercises folder root for the full exercise.

1. Ticket intake (`/plan`)
2. Plan, PRD, slices (`/to-prd`, `/to-issues`)
3. Develop (TDD red-green-refactor)
4. Commit (the `commit` skill)
5. Pull request and self-review (`pr`, `self-review` skills)
6. Code review (`code-review` skill)
7. QA and security gates (`security-review` skill, bats, shellcheck)
8. Production push (CI eval gate)
9. Improvement loop (capture failures back into skills)

## Credit

The `/plan`, `/to-prd`, `/to-issues`, and `/tdd` skills are adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT licence). The `/grill-me` skill there inspired the `/plan` skill here, renamed for the Eight Development rollout. ELab adapted, named, and shaped the `commit`, `pr`, `self-review`, `code-review`, and `security-review` skills for this workshop.
