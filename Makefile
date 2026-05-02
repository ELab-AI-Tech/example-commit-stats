.PHONY: test lint ci help

help:
	@printf 'Targets:\n'
	@printf '  make test     run bats tests\n'
	@printf '  make lint     run shellcheck on the CLI\n'
	@printf '  make ci       lint + test (the CI gate)\n'

test:
	bats tests

lint:
	shellcheck commit-stats

ci: lint test
