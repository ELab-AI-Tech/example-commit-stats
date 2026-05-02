# Day 2 — End-to-end AI development workflow on a real repo

Pick the `commit-stats` repo (provided) or a tiny repo of your own. Same one all five exercises. The point is to walk one feature from ticket to merged PR using the workflow we cover in the slide deck. The repo is bash so every developer in the room can read along regardless of stack.

The arc:

- **Ex 1:** turn a vague brief into an aligned plan → `PLAN.md`
- **Ex 2:** split the plan into vertical slices → `PRD.md` + `issues/*.md`
- **Ex 3:** ship one slice using TDD → working code + tests + commit
- **Ex 4:** open a PR, run the self-review, run the code-review, run the security-review → merge gate
- **Ex 5:** capture one failure as a skill update → close the loop

Each exercise feeds the next. Don't skip.

---

## What you need

- The `commit-stats/` repo from this Exercises folder (or your own tiny repo)
- An AI tool with skill support (Claude Code recommended, Codex or Cursor work too)
- Skills wired up per `commit-stats/SETUP.md`
- 90 minutes

---

## Exercise 1 — `/plan` to alignment (~15 min)

**Goal.** End with a `PLAN.md` of resolved decisions that you and the agent both agree on.

**Why.** Plan mode is reactive. The IDE jumps in eager and guesses at intent. `/plan` is proactive: the agent interviews you until you share a design concept. This is the highest-leverage habit change in the whole workflow.

**Steps:**

- Pick the brief. The default brief for `commit-stats`:

  > *I want a CLI that scans a git log and prints commit stats. It should show total commits, authors, and how many commits are AI-assisted. I might also want a date filter later.*

- In a fresh agent session, paste:

  > *Run /plan on this brief, with `commit-stats/UBIQUITOUS_LANGUAGE.md` and `commit-stats/CLAUDE.md` loaded. Append every decision to `PLAN.md` at the repo root.*

- Answer one question at a time. *"I don't know"* and *"go with the recommendation"* are both fine answers. Expect 10 to 25 questions for this brief.

- Push back when:
  - The agent drifts to generic advice (microservices, ORMs, frameworks). *Stay inside this codebase.*
  - The agent asks two questions in one turn. *One at a time, highest leverage first.*

- Say *we're done* when the tree closes.

**Output.** `PLAN.md` at the repo root. 10 to 25 decisions.

---

## Exercise 2 — Vertical slices (~10 min)

**Goal.** A `PRD.md` and three issue files in `issues/` that the agent could grab and ship one at a time.

**Why.** AI loves to code horizontally: all the parsing, then all the logic, then all the output. No working feature until phase three. Vertical slices ship one thin path through every layer at a time. You get feedback at the end of slice 1, not slice 3.

**Steps:**

- In the same agent session (so it still has `PLAN.md` loaded), paste:

  > *Run /to-prd to generate `PRD.md`. Then run /to-issues to split it into independently grabbable vertical-slice issues under `issues/`.*

- Read the PRD once. If the destination is wrong, say so and ask for a revision. Trust the language doc, not the agent's invented terms.

- Read each issue file. For each, ask:
  - Is this slice independently shippable? Could an agent grab it without loading the others?
  - Is it horizontal in disguise? "All parsers" is horizontal. "The summary subcommand end-to-end" is vertical.
  - Is the acceptance criterion observable? "Returns the right value" is not observable. "Prints `3 commits` when run on the seeded test repo" is.

- For `commit-stats` you should end with three issues:
  - `001-summary-subcommand.md` — `commit-stats summary` prints total commits, authors, and AI-assisted count.
  - `002-by-author-subcommand.md` — groups commits by author with AI-assisted percentage per author.
  - `003-since-flag.md` — adds a `--since` flag that filters commits by date.

**Output.** `PRD.md` plus three files under `issues/`.

---

## Exercise 3 — Ship slice 1 with TDD (~25 min)

**Goal.** `commit-stats summary` ships, with bats tests that fail meaningfully when the implementation is wrong, and a clean commit on the branch.

**Why.** Tests-after lets the AI write tests that match its own (possibly wrong) implementation. Tests-first forces the AI to describe the behaviour first, then prove the implementation matches. Same red-green-refactor loop you would use on Robolectric for Android, on a host-side simulator for firmware, on Vitest for web.

**Steps:**

- Create a feature branch: `git checkout -b feat/summary-subcommand`.

- In the agent session, paste:

  > *Run /tdd on `issues/001-summary-subcommand.md`. Use bats. One test, one implementation step, one commit. Then move to the next behaviour the issue calls for.*

- Watch the loop. The agent should:
  1. Write a failing bats test in `tests/summary.bats`.
  2. Run `bats tests/summary.bats`. Confirm it fails for the expected reason (not "command not found", but the actual assertion failing).
  3. Implement the minimum bash to make the test pass.
  4. Run the test again. Confirm green.
  5. Refactor if needed. Test still passes.
  6. Run `/commit`.

- Repeat per acceptance criterion. Three or four cycles is normal for slice 1.

- Push back when:
  - The agent writes three tests up front before any implementation. *One at a time.*
  - The agent skips the red step. *Confirm the test fails for the expected reason before implementing.*
  - The agent over-mocks. *Use the real `git log` against `setup_test_repo`. Mocks-everywhere is a smell.*

**Output.** Commits on the branch, each with `[ai-assisted]` or `[human-only]` attribution. `make ci` passes.

---

## Exercise 4 — PR, self-review, code-review, security-review (~25 min)

**Goal.** A PR description, a fresh-context self-review, a standards-pushed code-review, and a security pass. Only HIGH findings block.

**Why.** The agent that wrote the code is in the dumb zone. Reviews need a fresh context to land in the smart zone. Standards must be *pushed* to the reviewer (always loaded), separate from the *pulled* skills the implementer used. Confidence tiers (HIGH / MEDIUM / LOW) cut review noise by about 80%.

**Steps:**

- Push your branch and open a PR (or use `gh pr create`).

- In the same session, run:

  > */pr — generate the PR description from the diff and the commit log. Paste the result into the PR body.*

- **Clear context.** Start a fresh agent session.

- In the fresh session:

  > */self-review on the diff between main and HEAD. Use HIGH/MEDIUM/LOW tiers. Refuse to run if you suspect you are in the same session as the implementer.*

  Read every HIGH finding. Fix them or argue back. MEDIUM and LOW are comments only.

- **Clear context again.**

- In another fresh session:

  > */code-review on the diff. Push the bash standards from `CLAUDE.md`. HIGH/MEDIUM/LOW tiers. Recommend merge / fix HIGH then merge / needs deeper review.*

- **Clear context once more.** (Yes really. Each review is a fresh smart-zone.)

- In a final fresh session:

  > */security-review on the diff. Categories: command injection, path traversal, argument parsing, subprocess discipline, output integrity, supply chain, secrets.*

- Address every HIGH from any of the three reviews. Merge when all three reviewers say *merge*.

**Output.** A merged PR. Tagged commits. Three review reports in the PR comments.

---

## Exercise 5 — Close the loop (~15 min)

**Goal.** One concrete update to a skill or `CLAUDE.md` so the next agent does not repeat a mistake you saw in this session.

**Why.** The improvement loop is what turns AI from a one-shot tool into a compounding asset. *Treat your skills like products, not docs.* When AI ships bad code, fix the skill, not just the PR.

**Steps:**

- Look back at the session. Pick one moment where the agent did something wrong, slow, or off-style. Examples:
  - It tried to write three tests up front. The `/tdd` skill should have stopped it.
  - It missed a quoting issue. The `/code-review` skill should have flagged it.
  - It forgot the attribution tag. The `/commit` skill should have refused to commit without one.

- Open the relevant skill. Read it. Find the rule that should have caught the mistake.

- One of three things will be true:
  1. The rule exists and the agent ignored it. **Make the rule more prominent.** Move it up. Restate it bluntly.
  2. The rule does not exist. **Add it.** With a concrete example.
  3. The rule exists but is wrong. **Fix it.** Note why.

- Commit the skill change with `[ai-assisted]` if you used the agent to draft it, `[human-only]` otherwise.

- Note the change in `PLAN.md` at the bottom under `## Skill updates this session`.

**Output.** One updated `SKILL.md`. One commit. One note in `PLAN.md`.

---

## Bring to office hours

- All four files (`PLAN.md`, `PRD.md`, `issues/*.md`, the merged PR link).
- The numbers: time-to-first-commit, number of `/plan` iterations, test coverage delta, slop iterations avoided, count of `[ai-assisted]` versus `[human-only]` commits.
- One thing the agent got obviously wrong, even with the skills loaded.
- The skill update from Exercise 5.

---

## End of Day 2

You walk out with the full nine-step workflow run end-to-end on real code:

1. Ticket intake (`/plan`)
2. Plan, PRD, vertical slices (`/to-prd`, `/to-issues`)
3. Develop (`/tdd` red-green-refactor)
4. Commit (`/commit` with attribution)
5. PR (`/pr`)
6. Self-review (`/self-review` in fresh context)
7. Code review (`/code-review` with pushed standards)
8. Security review (`/security-review`)
9. Capture failures back into the skills (close the loop)

Same shape on your stack. Robolectric replaces bats for Android. A host-side simulator replaces bats for firmware. Detekt + Compose Rules replace shellcheck for Kotlin. MISRA-C replaces shellcheck for firmware C. The workflow does not change.
