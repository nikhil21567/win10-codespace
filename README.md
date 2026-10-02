# Windows 10 in GitHub Codespace

> **Note:** Codespaces me Windows 10 software emulation (TCG) se chalta hai - KVM acceleration nahi milta. Iska matlab thoda slow feel hoga. For true lag-free, check alternatives at the bottom.

## Quick Start

1. **Codespace open karo**: Code -> Codespaces -> Create codespace on main
   - Machine type: **4-core / 16GB RAM** choose karo (recommended)
2. **Setup auto-run hoga** (1-2 min) - Tiny10 ISO download hoga
3. **Start command** terminal me:
   ```bash
   bash scripts/start.sh
   ```
4. **PORTS tab** me port **6080** ke globe icon pe click karo
5. Browser me Windows 10 desktop khulega (Tiny10 installer first time)

## First Boot (Installer)

- Tiny10 install wizard aayega (~15-25 min lagega)
- Install complete hone ke baad terminal me:
  ```bash
  touch /workspaces/.windows/.installed
  bash scripts/start.sh
  ```
- Ab directly Windows desktop boot hoga (~30-60 sec)

## File Tree

```
win10-codespace/
├── .devcontainer/
│   ├── devcontainer.json   # Codespace config + port forward
│   └── Dockerfile          # Ubuntu + QEMU + noVNC install
├── scripts/
│   ├── setup.sh            # One-time: ISO + disk download
│   └── start.sh            # Every boot: QEMU + noVNC launch
├── .gitignore
└── README.md
```

## Tech Stack

- **Tiny10 23H2** - Debloated Windows 10 (~3.5GB ISO, runs on 2GB RAM)
- **QEMU TCG** - x86_64 emulation (no KVM in Codespaces)
- **noVNC** - Browser-based VNC client
- **websockify** - VNC to WebSocket bridge

## Performance Tips

- Tiny10 use kiya hai (regular Win10 22GB hai, ye 3.5GB)
- `-smp 2 -m 4G` allocation - Windows 10 minimum requirements
- Browser me zoom out karo for better performance
- Avoid heavy apps (Chrome, Photoshop) - notepad/browser-based tools best chalenge

## Truly Lag-Free Alternatives

| Option | Cost | Performance | Setup |
|--------|------|-------------|-------|
| **Oracle Cloud Free Tier** (ARM, KVM support) | $0 forever | Smooth (real KVM) | Medium |
| Hetzner cloud VPS (CX22) | 4 EUR/mo | Smooth | Easy |
| Codespaces + Tiny10 (this) | Free/Pro | Sluggish but works | - |

**Oracle Cloud Free Tier** = 4 ARM cores + 24GB RAM + 200GB storage - wahan pe KVM ke saath Windows 10 chalega bilkul smooth.

## Troubleshooting

- **Port 6080 not showing**: Terminal me manually `bash scripts/start.sh` chalao
- **VNC blank screen**: 10-15 sec wait karo QEMU boot hone tak
- **Out of disk**: Codespace me 64GB+ storage choose karo
- **Slow installer**: Normal hai, TCG mode me 15-25 min lagega first time

## License

MIT
