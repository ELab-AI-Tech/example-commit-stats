# Setup

Once you have the repo on your machine, point your AI agent at the skills.

## Claude Code

```bash
cd commit-stats
mkdir -p .claude
ln -s ../skills .claude/skills
```

Verify the agent finds them:

```bash
claude /plan
```

You should see the `/plan` skill load.

## Cursor

```bash
mkdir -p .cursor
ln -s ../skills .cursor/skills
```

## Codex (AGENTS.md route)

Add a section to `CLAUDE.md` (or a new `AGENTS.md`) listing each skill by name and where to find it. Codex does not yet have native skill discovery, so the agent reads the skill index from the markdown.

## Other tools

The skills are plain markdown with YAML frontmatter. Every modern coding agent supports the format. Check your tool's docs for the discovery path.

## Prerequisites

- bash 4 or later
- git
- [bats-core](https://github.com/bats-core/bats-core)
- [shellcheck](https://www.shellcheck.net/)

Install on macOS:

```bash
brew install bash git bats-core shellcheck
```

Install on Ubuntu:

```bash
sudo apt-get install -y bash git bats shellcheck
```

## Sanity check

```bash
./commit-stats --help     # should print usage
make lint                  # should pass
make test                  # should pass with zero tests (until you add some)
```

If those three commands succeed, the repo is ready for the workshop.
