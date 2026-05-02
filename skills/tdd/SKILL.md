---
name: tdd
description: Test-driven development with red-green-refactor loop, one vertical slice at a time. Failing test first, then implementation, then refactor. Use whenever building or fixing a slice. Adapted from Matt Pocock's tdd skill.
---

# /tdd

Build or fix one vertical slice using a strict red-green-refactor loop.

## Loop

For each slice:

1. **Red.** Write a failing test that describes the slice's observable behaviour. Run the test. Confirm it fails for the expected reason.
2. **Green.** Write the minimum code to make the test pass. No extras. Run the test. Confirm it passes.
3. **Refactor.** Improve the code (and the test if needed) without changing behaviour. Run the test. Still passes.
4. **Commit.** Use the `commit` skill. Atomic, conventional, attribution-tagged.

Repeat until the slice's acceptance criteria are met.

## Rules

- **One test, one implementation.** Do not write three tests up front and then implement all three. One at a time.
- **Tests describe behaviour, not implementation.** Test the public surface (what `commit-stats summary` prints), not the helper functions.
- **No fake passes.** A test that "passes" because the assertion is wrong is a regression. Inspect the failure mode visually.
- **Use bats for this repo.** Tests live in `tests/`, one file per subcommand.

## Bats template

```bash
#!/usr/bin/env bats

load 'helper'

setup() {
  setup_test_repo
}

teardown() {
  teardown_test_repo
}

@test "summary prints total commits in the repo" {
  cd "$REPO"
  run "$CLI" summary
  [ "$status" -eq 0 ]
  [[ "$output" == *"3 commits"* ]]
}
```

## Anti-patterns to refuse

- **Over-mocking.** If the test mocks every dependency, it is testing the mock, not the code. Use the real subprocess (`git log`) inside a temp repo seeded by `setup_test_repo`.
- **Asserting on internal state.** Test what the user sees, not what the function returns internally.
- **Skipping red.** If you skip step 1, you have no idea whether the test would have caught a real bug.

## When NOT to use

- A pure documentation change. No tests needed; just commit.
- A refactor with no behaviour change. Run the existing tests, do not write new ones.
