SHELL := /usr/bin/env bash

# include cfg/django.mk
# include cfg/frontend.mk
# include cfg/python.mk
# include cfg/ci.mk
include cfg/docker.mk
# include cfg/docs.mk
include cfg/node.mk
include cfg/node_root.mk
include cfg/common.mk
include cfg/help.mk

.PHONY: all
.PHONY: lint
## Check the Dockerfile BASE_VERSION default against .env
## @category Lint
lint::
	bin/lint-base-version.sh