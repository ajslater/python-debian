#!/bin/sh
# Set correct uid & gid for abc user
set -eu
PUID=${PUID:-911}
PGID=${PGID:-911}

groupmod --non-unique --gid "$PGID" abc
usermod --non-unique --uid "$PUID" abc

echo "
User uid:    $(id -u abc)
User gid:    $(id -g abc)
-------------------------------------
"

# Possible fix for synology
if [ "${CHOWN_PYTHON_SITE_PACKAGES:-0}" ]; then
  chown -R abc:abc /usr/local/lib/python*/
fi
