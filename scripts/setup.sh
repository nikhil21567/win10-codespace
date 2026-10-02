#!/bin/bash
set -e
WIN_DIR="/workspaces/.windows"
ISO="$WIN_DIR/tiny10.iso"
DISK="$WIN_DIR/disk.qcow2"
ISO_URL="https://archive.org/download/tiny-10-23-h2/tiny10%20x64%2023h2.iso"

mkdir -p "$WIN_DIR"

if [ ! -f "$ISO" ] || [ "$(stat -c%s "$ISO")" -lt 1000000000 ]; then
    echo "[*] Tiny10 ISO download ho raha hai (~3.5GB)..."
    curl -L --retry 5 -o "$ISO.part" "$ISO_URL"
    mv "$ISO.part" "$ISO"
fi

if [ ! -f "$DISK" ]; then
    echo "[*] Virtual disk ban raha hai (25GB)..."
    qemu-img create -f qcow2 "$DISK" 25G
fi

echo "[OK] Setup done. Ab 'bash scripts/start.sh' chalao."
