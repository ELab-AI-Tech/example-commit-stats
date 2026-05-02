# Setup

Skills live at `.agent/skills/`. Wire them to where your agent looks for them.

## Claude Code

```bash
cd commit-stats
mkdir -p .claude
ln -s ../.agent/skills .claude/skills
```

Verify:

```bash
ls -la .claude/skills
# should resolve to .agent/skills with 9 SKILL.md folders
```

Then start Claude Code in this directory and ask `list the skills you can see`. You should see all nine.

## Cursor

```bash
mkdir -p .cursor
ln -s ../.agent/skills .cursor/skills
```

## Codex / AGENTS.md route

The repo's `CLAUDE.md` lists every skill by name and path. Codex reads `CLAUDE.md` (or rename to `AGENTS.md`) and discovers skills from there.

## Other tools

The skills are plain markdown with YAML frontmatter. Every modern coding agent supports the format. Symlink `.agent/skills` to wherever your tool looks (consult its docs).

---

## Prerequisites

- bash 4 or later
- git
- [bats-core](https://github.com/bats-core/bats-core)
- [shellcheck](https://www.shellcheck.net/)
- [GitHub CLI](https://cli.github.com/) (for the PR exercise)

Install on macOS:

```bash
brew install bash git bats-core shellcheck gh
```

Install on Ubuntu / Debian:

```bash
sudo apt-get install -y bash git bats shellcheck gh
```

---

## Sanity check

Before starting the workshop:

```bash
./commit-stats --help     # prints usage, exits 0
make lint                  # shellcheck passes
make test                  # bats finds zero tests, exits 0
```

If those three commands succeed, the repo is ready. Open `INSTRUCTIONS.md` to start.
