FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        qemu-system-x86 \
        qemu-utils \
        novnc \
        websockify \
        curl \
        ca-certificates \
        x11vnc \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /workspaces/.windows

WORKDIR /workspaces
