#!/bin/bash
# Auto-boot Tiny10 - fully automatic, idempotent (safe to run multiple times)
set +e

W="/workspaces/.windows"
ISO="$W/tiny10.iso"
DISK="$W/disk.qcow2"
FLAG="$W/.installed"
QEMU_LOG="$W/qemu.log"
NOVNC_LOG="/tmp/novnc.log"
STATUS="$W/.status"

mkdir -p "$W"
echo "starting" > "$STATUS"

# ===== PHASE 1: ISO DOWNLOAD =====
if [ ! -f "$ISO" ] || [ "$(stat -c%s "$ISO" 2>/dev/null || echo 0)" -lt 500000000 ]; then
    echo "[$(date)] Downloading Tiny10 ISO..."
    echo "downloading" > "$STATUS"
    for URL in \
        "https://archive.org/download/tiny-10-23-h2/tiny10%20x64%2023h2.iso" \
        "https://archive.org/download/tiny-10-22-h2/tiny10%20x64%2022h2.iso"; do
        echo "  Trying: $URL"
        if curl -L --retry 3 --max-time 600 -o "$ISO.part" "$URL" 2>/dev/null; then
            SIZE=$(stat -c%s "$ISO.part" 2>/dev/null || echo 0)
            if [ "$SIZE" -gt 500000000 ]; then
                mv "$ISO.part" "$ISO"
                echo "  ISO ready: $(du -h "$ISO" | cut -f1)"
                break
            fi
        fi
        rm -f "$ISO.part"
    done
fi

# ===== PHASE 2: DISK CREATE =====
if [ ! -f "$DISK" ]; then
    echo "[$(date)] Creating 20GB virtual disk..."
    qemu-img create -f qcow2 "$DISK" 20G
fi

# ===== PHASE 3: KILL OLD PROCESSES =====
pkill -x qemu-system-x86 2>/dev/null
pkill -f websockify 2>/dev/null
sleep 1

# ===== PHASE 4: START noVNC on port 8006 =====
echo "[$(date)] Starting noVNC on port 8006..."
websockify --web=/usr/share/novnc 8006 localhost:5900 > "$NOVNC_LOG" 2>&1 &
sleep 2

# ===== PHASE 5: BOOT MODE =====
if [ -f "$FLAG" ]; then
    BOOT_FLAGS="-boot order=c"
    CDROM=""
    BOOT_MODE="installed (direct boot)"
else
    BOOT_FLAGS="-boot order=dc"
    CDROM="-drive file=$ISO,media=cdrom,readonly=on,if=ide,index=1"
    BOOT_MODE="first time (installer)"
fi

# ===== PHASE 6: LAUNCH QEMU =====
echo "[$(date)] Starting QEMU [$BOOT_MODE]..."
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
    -vnc 0.0.0.0:0 -daemonize -D "$QEMU_LOG"

sleep 3

# ===== PHASE 7: STATUS =====
if pgrep -x qemu-system-x86 > /dev/null; then
    echo "ready" > "$STATUS"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ✅ Tiny10 RUNNING on port 8006"
    echo "  📍 PORTS tab -> click 'Open Tiny10 Desktop'"
    if [ ! -f "$FLAG" ]; then
        echo "  ⏱️  First boot - installer will appear (15-25 min)"
    else
        echo "  🚀 Direct desktop boot (30-45 sec)"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "failed" > "$STATUS"
    echo ""
    echo "❌ Tiny10 FAILED to start"
    echo "📄 Check log: $QEMU_LOG"
fi