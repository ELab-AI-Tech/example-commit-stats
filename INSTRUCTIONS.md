# commit-stats workshop instructions

End-to-end AI development workflow on a small bash repo. Copy-paste your way through. ~90 minutes.

## Prerequisites

```bash
# macOS
brew install bash git bats-core shellcheck gh

# Ubuntu / Debian
sudo apt-get install -y bash git bats shellcheck gh
```

You also need an AI agent with skills support. Claude Code is the reference. Codex and Cursor work the same way.

---

## Setup (5 minutes)

### 1. Get the repo on your machine

```bash
cd ~/work
cp -R "/path/to/Exercises/commit-stats" .
cd commit-stats
```

### 2. Wire skills to your agent

The skills live at `.agent/skills/`. Symlink them to where your agent looks for them.

**Claude Code:**

```bash
mkdir -p .claude
ln -s ../.agent/skills .claude/skills
```

**Cursor:**

```bash
mkdir -p .cursor
ln -s ../.agent/skills .cursor/skills
```

**Codex / other AGENTS.md-aware tools:** the agent reads `AGENTS.md` at the repo root. The skills directory is already referenced in `CLAUDE.md`.

### 3. Sanity check

```bash
./commit-stats --help     # prints usage
make lint                  # shellcheck passes (the scaffold is clean)
make test                  # bats finds zero tests, exits 0
```

All three must succeed before you start. If `make test` errors with *bats: command not found*, install bats-core (see prerequisites above).

### 4. Start your agent in this directory

```bash
claude          # or: cursor . / codex / your tool of choice
```

Once your agent is running, ask:

```
list the skills you can see
```

You should see all nine: `plan`, `to-prd`, `to-issues`, `tdd`, `commit`, `pr`, `self-review`, `code-review`, `security-review`. If any are missing, the symlink did not take. Check `ls -la .claude/skills` (or `.cursor/skills`) and the target.

---

## Exercise 1 — `/plan` to alignment (~15 min)

**Goal.** End with `PLAN.md` at the repo root with 10 to 25 resolved decisions you and the agent both agree on.

### Step 1.1. Run /plan

Paste this into your agent:

```
/plan I want a CLI that scans a git log and prints commit stats. It should show total commits, authors, and how many commits are AI-assisted. I might also want a date filter later. Append every decision to PLAN.md at the repo root. Use UBIQUITOUS_LANGUAGE.md and CLAUDE.md as context.
```

### Step 1.2. Answer one question at a time

The agent will ask you one question at a time and recommend an answer. For each:

- Read the recommendation.
- Either say *go with the recommendation* or override with your own answer.
- *I do not know* is a valid answer — pick the recommendation.

Push back when:

- The agent asks two questions in one turn → *one at a time, highest leverage first*.
- The agent drifts to generic advice (microservices, ORMs) → *stay inside this codebase*.
- The agent jumps to implementation before requirements are clear → *back up and ask the requirements question first*.

### Step 1.3. Stop when the tree closes

When the agent stops asking new questions, paste:

```
we are done. summarise PLAN.md.
```

Read the summary. If it looks right, you are ready for Exercise 2.

### Step 1.4. Verify the output

```bash
test -f PLAN.md && wc -l PLAN.md && head -40 PLAN.md
```

You should see 10 to 25 decisions in `## Q<n>` blocks. If `PLAN.md` is empty, the agent did not append. Re-run `/plan` and tell it to append to `PLAN.md` explicitly.

---

## Exercise 2 — Vertical slices (~10 min)

**Goal.** A `PRD.md` and three issue files in `issues/` ready for an agent to grab one at a time.

### Step 2.1. Generate the PRD

In the same agent session (so `PLAN.md` is still in context), paste:

```
/to-prd PLAN.md → PRD.md at the repo root
```

### Step 2.2. Verify the PRD

```bash
test -f PRD.md && head -60 PRD.md
```

Skim once. If a section is wrong, tell the agent:

```
PRD.md section X is wrong. <describe>. Revise.
```

### Step 2.3. Split into issues

Paste:

```
/to-issues PRD.md → issues/ directory. Three vertical slices. Each independently grabbable.
```

### Step 2.4. Verify the issues

```bash
ls -1 issues/
```

You should see three files:

```
001-summary-subcommand.md
002-by-author-subcommand.md
003-since-flag.md
```

For each issue, ask yourself:

- Independently shippable? An agent could grab this without loading the others.
- Vertical, not horizontal? *The summary subcommand end-to-end* is vertical. *All parsers* is horizontal.
- Acceptance is observable? *Prints `3 commits` when run on the seeded test repo* is observable.

If any issue is wrong, tell the agent to fix it.

---

## Exercise 3 — Ship slice 1 with TDD (~25 min)

**Goal.** `commit-stats summary` ships. Bats tests pass. Atomic commits with attribution tags on a feature branch.

### Step 3.1. Branch off

```bash
git checkout -b feat/summary-subcommand
```

### Step 3.2. Run /tdd on the first issue

Paste:

```
/tdd issues/001-summary-subcommand.md. Use bats. One test, one implementation, one commit per cycle. Then move to the next behaviour.
```

### Step 3.3. Watch the loop

For each acceptance criterion the agent should:

1. Write a failing bats test in `tests/summary.bats`.
2. Run `bats tests/summary.bats`. **Confirm it fails for the expected reason** (not *command not found*, the actual assertion failing).
3. Implement the minimum bash to make the test pass.
4. Run the test again. Green.
5. Refactor if needed. Test still passes.
6. Run `/commit`.

Three or four cycles is normal for slice 1.

### Step 3.4. Push back when

- Agent writes three tests up front before any implementation → *one at a time*.
- Agent skips the red step → *confirm the test fails for the expected reason before implementing*.
- Agent over-mocks → *use the real `git log` against `setup_test_repo`*.

### Step 3.5. Verify the slice ships

```bash
make ci                    # lint + test, must pass
./commit-stats summary     # prints stats from this repo, exits 0
git log --oneline -10      # commits with [ai-assisted] tags
```

If `make ci` fails, the slice is not done. Tell the agent to fix it.

---

## Exercise 4 — PR + three reviews (~25 min)

**Goal.** A PR with description, three review reports (self-review, code-review, security-review), all HIGH findings addressed.

### Step 4.1. Push the branch and open a PR

```bash
git push -u origin feat/summary-subcommand
gh pr create --fill
```

### Step 4.2. Generate the PR description

In the same agent session:

```
/pr generate the PR description from the diff and the commit log on this branch. Output as markdown.
```

Paste the result into the PR body:

```bash
gh pr edit --body "$(cat /tmp/pr-body.md)"     # or paste through the GitHub UI
```

### Step 4.3. Self-review (clear context first)

Clear the agent context:

```
/clear
```

Then paste:

```
/self-review the diff between main and HEAD. Use HIGH/MEDIUM/LOW tiers. Refuse to run if you suspect you are in the same session as the implementer.
```

Read every HIGH finding. Either fix it (locally, then push) or argue back with reasoning.

### Step 4.4. Code review (clear context again)

```
/clear
```

Then:

```
/code-review the diff. Push the bash standards from CLAUDE.md. HIGH/MEDIUM/LOW tiers. End with a recommendation: merge / fix HIGH then merge / needs deeper review.
```

Address every HIGH.

### Step 4.5. Security review (clear context one more time)

```
/clear
```

Then:

```
/security-review the diff. Categories: command injection, path traversal, argument parsing, subprocess discipline, output integrity, supply chain, secrets.
```

Address every HIGH.

### Step 4.6. Merge

When all three reviewers say *merge*:

```bash
gh pr merge --squash
```

### Step 4.7. Verify

```bash
git checkout main
git pull
make ci                                # passes on main
git log --oneline | head -5            # see the merge
gh pr view --json reviewComments       # three review reports attached
```

---

## Exercise 5 — Close the loop (~15 min)

**Goal.** One concrete update to a skill or `CLAUDE.md` so the next agent does not repeat a mistake from this session.

### Step 5.1. Identify one failure

Look back at the session. Pick one moment the agent did something wrong, slow, or off-style. Examples:

- Wrote three tests up front. The `/tdd` skill should have stopped it.
- Missed a quoting issue. The `/code-review` skill should have flagged it.
- Forgot the attribution tag. The `/commit` skill should have refused without it.

### Step 5.2. Open the relevant skill

```bash
code .agent/skills/<skill-name>/SKILL.md
```

(Replace `code` with your editor: `nano`, `vim`, `cursor`, etc.)

### Step 5.3. Apply one of three fixes

1. **Rule exists, agent ignored it.** Make it more prominent. Move it up. Restate it bluntly.
2. **Rule does not exist.** Add it. Include a concrete example.
3. **Rule exists but is wrong.** Fix it. Note why.

### Step 5.4. Commit the change

```bash
git add .agent/skills/<skill-name>/SKILL.md
git commit -m "chore(skills): tighten <skill-name> rule on <topic> [ai-assisted]"
```

(Use `[human-only]` if you wrote the change without AI help.)

### Step 5.5. Note it in PLAN.md

Append to `PLAN.md`:

```markdown
## Skill updates this session

- `<skill-name>`: <what changed and why>
```

```bash
git add PLAN.md
git commit -m "docs(plan): note skill update [human-only]"
```

---

## Bring to office hours

Before your slot with Franco, gather:

- [ ] `PLAN.md`
- [ ] `PRD.md`
- [ ] `issues/*.md`
- [ ] The merged PR link
- [ ] The numbers:
  - Time-to-first-commit
  - Number of `/plan` iterations (questions asked)
  - Test coverage delta
  - Slop iterations avoided (count of times you pushed back vs accepted)
  - `[ai-assisted]` vs `[human-only]` commit count
- [ ] One thing the agent got obviously wrong, even with the skills loaded
- [ ] The skill update from Exercise 5

Quick way to grab the commit counts:

```bash
git log --oneline | grep -c '\[ai-assisted\]'
git log --oneline | grep -c '\[human-only\]'
```

---

## Troubleshooting

**Agent does not see skills.** Check the symlink: `ls -la .claude/skills` should resolve to `.agent/skills/`. Fix:

```bash
rm -f .claude/skills
ln -s ../.agent/skills .claude/skills
```

**`bats: command not found`.** Install bats-core (see Prerequisites).

**`shellcheck: command not found`.** Install shellcheck (see Prerequisites).

**`./commit-stats: Permission denied`.** Make it executable:

```bash
chmod +x commit-stats
```

**Agent commits without `[ai-assisted]` tag.** The `/commit` skill should refuse. If it does not, that is your Exercise 5 fix.

**`gh pr create` fails with auth error.** Run `gh auth login` and retry.

---

## End of Day 2

You walk out with the full nine-step workflow run end-to-end on real code:

1. Ticket intake (`/plan`)
2. Plan, PRD, vertical slices (`/to-prd`, `/to-issues`)
3. Develop (`/tdd`)
4. Commit (`/commit` with attribution)
5. PR (`/pr`)
6. Self-review (`/self-review` in fresh context)
7. Code review (`/code-review` with pushed standards)
8. Security review (`/security-review`)
9. Capture failures back into the skills (close the loop)

Same shape on your stack. Swap bats for your test runner, swap shellcheck for your linter, swap the bash standards for your team's. The workflow does not change.
