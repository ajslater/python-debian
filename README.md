# python-debian docker image

A Python Debian base image.

## Run as User

The entrypoint runs the docker `CMD` as the specified PUID & PGID environment
variables. If omitted, these variables the `CMD` runs as root.

## Docker Image

[ghcr.io/ajslater/python-debian](https://github.com/ajslater/python-debian/pkgs/container/python-debian)
