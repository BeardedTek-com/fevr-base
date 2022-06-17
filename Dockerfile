FROM ghcr.io/home-assistant/amd64-base-python:3.10-alpine3.15
COPY rootfs /
RUN apk --no-cache add py3-pip pcre pcre2 git nano tailscale caddy && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apk --no-cache del python3-dev build-base linux-headers pcre-dev && \
    adduser -u 1000 -h /fevr -D fevr && \
    chown -R fevr /fevr
WORKDIR /fevr
