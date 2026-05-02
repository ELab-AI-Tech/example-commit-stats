---
name: plan
description: Interview the user one question at a time about a feature, change, or fix until plan and developer share the same design concept. Use when the user invokes /plan, when a ticket is ambiguous, or before any code is written. Reaches alignment first, code second. Adapted from Matt Pocock's grill-me skill.
---

# /plan

Interview the user relentlessly about $ARGUMENTS (or the topic in scope if no arguments given), one question at a time, until you and the user share the same design concept.

## Rules

- **One question at a time.** Wait for the answer before the next question.
- **Recommend an answer with every question.** One sentence on why. The user can accept or override.
- **Read the code first.** If a question can be answered by reading files, configs, or `UBIQUITOUS_LANGUAGE.md`, read them instead of asking.
- **Use canonical terms only.** Names from `UBIQUITOUS_LANGUAGE.md` if it exists.
- **Walk the decision tree branch by branch.** Resolve dependencies between decisions one by one.
- **Ask the highest-leverage question first.** What is the user actually trying to achieve.
- **Append every resolved decision** to a working file (`PLAN.md` by default, override with the argument):

  ```
  ## Q<n>: <question>
  - Recommendation: <yours>
  - Decision: <what we agreed>
  - Why: <one sentence>
  - Open follow-ups: <none, or bullets>
  ```

- **Stop when the user says "we're done"** or when no open branches remain.

## Common failure modes to push back on

- **Drift to generic.** If the user's answers veer toward generic best practice, redirect: *Stay inside this codebase. Ask only about decisions specific to it.*
- **Multi-question creep.** Never ask two questions in one turn.
- **Premature commitment.** If you find yourself proposing implementation before requirements are clear, pause and ask the requirements question instead.

## Output

A `PLAN.md` (or named target) at the repo root with every resolved decision. The conversation history itself is the asset; the markdown file is the receipt.

## When NOT to use

- A trivial fix where the user already knows exactly what to change. Skip `/plan`, go straight to TDD.
- A pure exploration session where the user is thinking out loud. Plan when the goal is clear.
