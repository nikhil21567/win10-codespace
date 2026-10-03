#!/bin/bash
set -e
WIN_DIR="/workspaces/.windows"
ISO="$WIN_DIR/tiny10.iso"
DISK="$WIN_DIR/disk.qcow2"

mkdir -p "$WIN_DIR"

# Try multiple Tiny10 mirrors in order (lightest first)
MIRRORS=(
    "https://archive.org/download/tiny-10-23-h2/tiny10%20x64%2023h2.iso"
    "https://archive.org/download/tiny-10-22-h2/tiny10%20x64%2022h2.iso"
    "https://archive.org/download/tiny10-21h2/tiny10_21h2.iso"
)

if [ ! -f "$ISO" ] || [ "$(stat -c%s "$ISO" 2>/dev/null || echo 0)" -lt 500000000 ]; then
    echo "[*] Tiny10 ISO download ho raha hai..."
    for URL in "${MIRRORS[@]}"; do
        echo "  Try: $URL"
        if curl -L --retry 3 --max-time 900 -o "$ISO.part" "$URL" 2>/dev/null; then
            SIZE=$(stat -c%s "$ISO.part" 2>/dev/null || echo 0)
            if [ "$SIZE" -gt 500000000 ]; then
                mv "$ISO.part" "$ISO"
                echo "[OK] ISO downloaded: $(du -h "$ISO" | cut -f1)"
                break
            fi
        fi
        rm -f "$ISO.part"
    done
fi

if [ ! -f "$DISK" ]; then
    echo "[*] Virtual disk ban raha hai (20GB)"
    qemu-img create -f qcow2 "$DISK" 20G
fi

echo "[OK] Setup done."
df -h "$WIN_DIR"