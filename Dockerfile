FROM ghcr.io/home-assistant/amd64-base-python:3.10-alpine3.15 as build

COPY rootfs /

WORKDIR /fevr

RUN apk --no-cache add py3-pip pcre pcre2 git nano tailscale caddy && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apk --no-cache add python3-dev build-base linux-headers pcre-dev && \
    python3 -m venv venv && \
    source venv/bin/activate && \
    wget https://raw.githubusercontent.com/BeardedTek-com/fEVR/main/requirements.txt && \
    source venv/bin/activate && \
    pip install wheel && \
    pip install -r requirements.txt && \
    apk --no-cache del python3-dev build-base linux-headers pcre-dev && \
    adduser -u 1000 -h /fevr -D fevr && \
    chown -R fevr /fevr && \
    wget -O /usr/bin/getnetwork https://raw.githubusercontent.com/BeardedTek-com/tailscale/main/rootfs/usr/bin/getnetwork && \
    sed -i 's/venv/usr/' /usr/bin/getnetwork && \
    chmod +x /usr/bin/getnetwork

FROM scratch
COPY --from=build / /
ENTRYPOINT ["/init"]