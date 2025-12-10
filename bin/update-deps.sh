#!/bin/bash
# Update python and npm dependencies
set -euo pipefail
# uv tree --all-groups --depth 1 --upgrade --outdated | grep --color=always "(latest:.*)" || true
# uv sync --no-install-project --all-extras --all-groups --all-packages --upgrade
npm update
npm outdated
if [ -d frontend ]; then
  cd frontend
  npm update
  npm outdated
fi
