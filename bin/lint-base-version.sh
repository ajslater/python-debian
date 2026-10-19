#!/usr/bin/env bash
# The Dockerfile's ARG BASE_VERSION default must match .env, which CI and
# compose build from, so a plain `docker build .` gets the same base image.
set -euo pipefail

env_version=$(sed -n 's/^BASE_VERSION=//p' .env)
dockerfile_version=$(sed -n 's/^ARG BASE_VERSION=//p' Dockerfile)
if [[ $env_version != "$dockerfile_version" ]]; then
  echo "BASE_VERSION mismatch: .env has '$env_version', Dockerfile ARG default has '$dockerfile_version'" >&2
  exit 1
fi
