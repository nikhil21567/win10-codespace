#!/bin/bash
# Tiny10 boot script - NO KVM, TCG mode, optimized for free Codespace
WIN_DIR="/workspaces/.windows"
ISO="$WIN_DIR/tiny10.iso"
DISK="$WIN_DIR/disk.qcow2"
INSTALL_FLAG="$WIN_DIR/.installed"
LOG="$WIN_DIR/qemu.log"

# noVNC start
pkill -f websockify 2>/dev/null || true
websockify --web=/usr/share/novnc 6080 localhost:5900 >/tmp/novnc.log 2>&1 &

# Smart boot
if [ -f "$INSTALL_FLAG" ]; then
    BOOT_FLAGS="-boot order=c"
    CDROM=""
else
    BOOT_FLAGS="-boot order=dc"
    CDROM="-drive file=$ISO,media=cdrom,readonly=on,if=ide,index=1"
fi

# TCG-mode QEMU - optimized for free tier (2-core/8GB)
# NO KVM (not available in Codespaces)
# Settings tuned to minimize Win10 BSOD + hang
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

sleep 2

echo ""
echo "============================================"
echo "  Tiny10 booting..."
echo "============================================"
echo "Step 1: Wait 30-60 sec for first boot"
echo "Step 2: PORTS tab -> 6080 -> click globe"
echo "Step 3: Browser me VNC client khulega"
echo ""
echo "Install wizard first time: 15-25 min (halka wait)"
echo "After install: 30-45 sec boot (smooth)"
echo "============================================"
echo ""
echo "Install complete hone ke baad:"
echo "  touch $INSTALL_FLAG"
echo "  bash scripts/start.sh"
echo "============================================"
echo ""
echo "VNC URL: http://localhost:6080/vnc.html"