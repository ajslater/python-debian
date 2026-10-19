#!/bin/sh
# Run the CMD as abc remapped to PUID & PGID, or as root if neither is set.
set -eu

if [ "${DOCKER_IMAGE_DEPRECATED:-}" != "" ]; then
  echo "--------------------------------------------------------"
  echo "⚠️  WARNING: This image is DEPRECATED ⚠️"
  echo "$DOCKER_IMAGE_DEPRECATED"
  echo "--------------------------------------------------------"
fi

if [ "${PUID:-}${PGID:-}" != "" ]; then
  /usr/local/sbin/moduser.sh
  LOCAL_USER_SCRIPT=/usr/local/sbin/moduser-local.sh
  if [ -f "$LOCAL_USER_SCRIPT" ]; then
    "$LOCAL_USER_SCRIPT"
  fi
  # setpriv only changes ids, so set what su used to set.
  export HOME=/home/abc USER=abc LOGNAME=abc
  # exec keeps the CMD as PID 1 and passes every argument through.
  exec setpriv --reuid=abc --regid=abc --init-groups --inh-caps=-all "$@"
fi
exec "$@"
