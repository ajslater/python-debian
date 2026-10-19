# python-debian docker image

A Python Debian base image: the official
[`python:*-slim-trixie`](https://hub.docker.com/_/python) image plus an
unprivileged user that containers remap to the host's ids at start, in the
manner of linuxserver.io images.

## Image

[ghcr.io/ajslater/python-debian](https://github.com/ajslater/python-debian/pkgs/container/python-debian)

Tags are `<python image tag>_<build number>`, for example
`3.15.0-slim-trixie_0`. The build number starts at `0` for each Python tag and
increments when this image is rebuilt on the same Python tag, so every tag is
immutable. `latest` points at the newest build. Images are built for
`linux/amd64` and `linux/arm64`.

## Run as User

The image creates the user `abc` with uid and gid 911 and home `/home/abc`, and
runs the container `CMD` through `/usr/local/sbin/entrypoint.sh`:

- With `PUID` or `PGID` set, the entrypoint changes `abc` to that uid and gid
  (the other defaults to 911) and runs `CMD` as `abc` with `HOME=/home/abc`.
- With neither set, `CMD` runs as root.

The entrypoint uses `setpriv`, so `CMD` runs as PID 1 and receives signals
directly. Without a `CMD` the image runs `python3`, as the official image does.

### Hooks

- `/usr/local/sbin/moduser-local.sh`: if a derived image adds this script, the
  entrypoint runs it as root after remapping the user and before dropping
  privileges, for example to `chown` volumes.
- `DOCKER_IMAGE_DEPRECATED`: when set, the entrypoint prints its value as a
  deprecation warning at start.

## Building

`.env` holds the Python tag and the build number:

```sh
BASE_VERSION=3.15.0-slim-trixie
PKG_VERSION=0
```

To release a new image, change `BASE_VERSION` or increment `PKG_VERSION` and
open a pull request against `main`. The Dockerfile's `ARG BASE_VERSION` default
must match `.env`, so a plain `docker build .` gets the same base image;
`make lint` checks that. CI builds and smoke tests each architecture on the pull
request and publishes the multi-arch manifest on merge. Pull requests against
`develop` only lint.

Locally, `docker compose build` builds the image and
`bin/test-image.sh ghcr.io/ajslater/python-debian` runs the smoke test.
