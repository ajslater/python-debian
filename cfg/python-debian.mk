.PHONY: lint-actions
## Lint the GitHub Actions workflows
## @category Lint
lint-actions:
	actionlint .github/workflows/*.yml

.PHONY: lint
## Lint the workflows too
## @category Lint
lint:: lint-actions
