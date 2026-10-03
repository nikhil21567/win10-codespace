#!/bin/bash
# AUTO MODE - Bas Codespace kholo, sab apne aap ho jayega.
# No commands needed. No setup. No manual steps.
set +e

WIN_DIR="/workspaces/.windows"
ISO="$WIN_DIR/tiny10.iso"
DISK="$WIN_DIR/disk.qcow2"
INSTALL_FLAG="$WIN_DIR/.installed"
LOG="$WIN_DIR/qemu.log"

mkdir -p "$WIN_DIR"

# ============ PHASE 1: ISO DOWNLOAD ============
if [ ! -f "$ISO" ] || [ "$(stat -c%s "$ISO" 2>/dev/null || echo 0)" -lt 500000000 ]; then
    echo "[AUTO] ISO download ho raha hai... (1-2 min)"
    for URL in \
        "https://archive.org/download/tiny-10-23-h2/tiny10%20x64%2023h2.iso" \
        "https://archive.org/download/tiny-10-22-h2/tiny10%20x64%2022h2.iso"; do
        if curl -L --retry 3 --max-time 600 -o "$ISO.part" "$URL" 2>/dev/null; then
            SIZE=$(stat -c%s "$ISO.part" 2>/dev/null || echo 0)
            if [ "$SIZE" -gt 500000000 ]; then
                mv "$ISO.part" "$ISO"
                echo "[AUTO] ISO ready: $(du -h "$ISO" | cut -f1)"
                break
            fi
        fi
        rm -f "$ISO.part"
    done
fi

# ============ PHASE 2: DISK CREATE ============
if [ ! -f "$DISK" ]; then
    echo "[AUTO] Disk ban raha hai (20GB)..."
    qemu-img create -f qcow2 "$DISK" 20G
fi

# ============ PHASE 3: noVNC START ============
pkill -f websockify 2>/dev/null
websockify --web=/usr/share/novnc 6080 localhost:5900 >/tmp/novnc.log 2>&1 &

# ============ PHASE 4: QEMU LAUNCH ============
if [ -f "$INSTALL_FLAG" ]; then
    # Already installed - boot from disk only
    BOOT_FLAGS="-boot order=c"
    CDROM=""
else
    # First time - boot from ISO
    BOOT_FLAGS="-boot order=dc"
    CDROM="-drive file=$ISO,media=cdrom,readonly=on,if=ide,index=1"
fi

# Start QEMU
qemu-system-x86_64 \
    -name "Tiny10" \
    -machine accel=tcg,usb=on \
    -cpu qemu64,+aes,+popcnt,+sse4.2 \
    -smp 1 -m 2G \
    -drive file="$DISK",format=qcow2,if=ide,index=0,cache=writeback \
    $CDROM \
    $BOOT_FLAGS \
    -vga std -netdev user,id=net0 -device e1000,netdev=net0 \
    -rtc base=localtime \
    -global I440FX-pcihost.piix3-4.acpi-pci-hotplug=off \
    -global I440FX-pcihost.piix3-4.acpi-memory-hotplug=off \
    -global I440FX-pcihost.piix3-4.acpi-cpu-hotplug=off \
    -usb -device usb-tablet \
    -vnc 0.0.0.0:0 -daemonize -D "$LOG"

sleep 3

# ============ PHASE 5: STATUS ============
if pgrep -x qemu-system-x86 > /dev/null; then
    echo ""
    echo "============================================"
    echo "  [OK] TINY10 CHALU HAI!"
    echo "============================================"
    echo ""
    echo "  PORTS tab me port 6080 pe click karo"
    echo "  Browser me Tiny10 desktop khulega"
    echo ""
    if [ ! -f "$INSTALL_FLAG" ]; then
        echo "  First time hai - install wizard aayega (15-25 min)"
        echo "  Install ke baad auto-boot hoga (no commands needed)"
    else
        echo "  Already installed - direct desktop aayega (30-45 sec)"
    fi
    echo "============================================"
else
    echo "[ERROR] QEMU start nahi hua. Log check karo: $LOG"
fi