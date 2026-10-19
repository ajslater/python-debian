# check=skip=InvalidDefaultArgInFrom
# BASE_VERSION has no default on purpose: this image tracks no one Python
# version. CI and compose pass it from .env.
ARG BASE_VERSION
FROM python:$BASE_VERSION
ARG BASE_VERSION
ARG VERSION
LABEL org.opencontainers.image.title="python-debian" \
    org.opencontainers.image.description="Python base image with a PUID/PGID remapped user" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.authors="AJ Slater <aj@slater.net>" \
    org.opencontainers.image.source="https://github.com/ajslater/python-debian" \
    org.opencontainers.image.licenses="GPL-3.0-only" \
    org.opencontainers.image.base.name="docker.io/library/python:${BASE_VERSION}"

# *** UID/GID Init and create default user ***
RUN adduser --uid 911 --home /home/abc --shell /bin/sh --disabled-password abc \
    && usermod -G users abc
COPY usr/local/sbin/*.sh /usr/local/sbin/

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["python3"]