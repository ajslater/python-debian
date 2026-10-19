#!/usr/bin/env bash
# Smoke test a built image: bin/test-image.sh IMAGE
# Proves the entrypoint remaps PUID & PGID, passes every CMD word through,
# keeps root when neither is set, and that the default CMD is python3.
set -euo pipefail

image=${1:?usage: $0 IMAGE}

check() {
  local name=$1 expected=$2 actual=$3
  if [[ $actual != "$expected" ]]; then
    echo "FAIL $name: expected '$expected', got '$actual'" >&2
    exit 1
  fi
  echo "ok: $name"
}

# moduser.sh prints a banner first, so only the last line is the answer.
ids() {
  docker run --rm "$@" "$image" sh -c 'echo "$(id -u):$(id -g):$HOME"' | tail -n 1
}

check "remaps uid, gid and home" "1234:4321:/home/abc" "$(ids -e PUID=1234 -e PGID=4321)"
check "defaults gid to 911" "1234:911:/home/abc" "$(ids -e PUID=1234)"
check "passes every CMD word through" "1234" \
  "$(docker run --rm -e PUID=1234 "$image" python -c 'import os; print(os.getuid())' | tail -n 1)"
check "runs as root without PUID or PGID" "0" "$(docker run --rm "$image" id -u)"
check "defaults CMD to python3" '["python3"]' \
  "$(docker inspect --format '{{json .Config.Cmd}}' "$image")"
