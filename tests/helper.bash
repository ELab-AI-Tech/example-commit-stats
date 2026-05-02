# tests/helper.bash
#
# Shared bats helpers for commit-stats tests. Source from each test file:
#
#   load 'helper'
#

CLI="${BATS_TEST_DIRNAME}/../commit-stats"

# Make a temp git repo seeded with a known commit log for tests to operate on.
# Sets REPO to the path. Caller is responsible for cleanup via teardown().
setup_test_repo() {
  REPO="$(mktemp -d)"
  (
    cd "$REPO"
    git init --quiet --initial-branch=main
    git config user.email "test@example.com"
    git config user.name "Test User"
    GIT_AUTHOR_DATE="2026-01-01T00:00:00Z" \
    GIT_COMMITTER_DATE="2026-01-01T00:00:00Z" \
      git commit --quiet --allow-empty \
      -m "feat(scope): first slice [issue-1] [ai-assisted]"
    GIT_AUTHOR_DATE="2026-02-01T00:00:00Z" \
    GIT_COMMITTER_DATE="2026-02-01T00:00:00Z" \
      git commit --quiet --allow-empty \
      -m "fix(scope): correct off-by-one [issue-2] [human-only]"
    GIT_AUTHOR_DATE="2026-03-01T00:00:00Z" \
    GIT_COMMITTER_DATE="2026-03-01T00:00:00Z" \
      git commit --quiet --allow-empty \
      -m "chore: tidy up build [ai-assisted]"
  )
}

teardown_test_repo() {
  if [[ -n "${REPO:-}" && -d "$REPO" ]]; then
    rm -rf "$REPO"
  fi
}
