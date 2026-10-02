# Windows 10 in GitHub Codespace (Free Tier Optimized)

> **Important:** Codespaces free tier = 2-core/8GB max. Windows 10 software emulation (TCG) se chalega, thoda slow feel hoga. For true lag-free, check alternatives at the bottom.

## Quick Start (Free Tier)

1. **Codespace open karo**: Code -> Codespaces -> Create codespace on main
   - Machine type: **2-core / 8GB RAM** select karo (max for free)
2. **Setup auto-run hoga** (1-2 min) - Tiny10 ISO download hoga
3. **Start command** terminal me:
   ```bash
   bash scripts/start.sh
   ```
4. **PORTS tab** me port **6080** ke globe icon pe click karo
5. Browser me Windows 10 desktop khulega (Tiny10 installer first time)

## First Boot (Installer)

- Tiny10 install wizard aayega (~20-35 min on 2-core)
- Install complete hone ke baad terminal me:
  ```bash
  touch /workspaces/.windows/.installed
  bash scripts/start.sh
  ```
- Ab directly Windows desktop boot hoga (~60-90 sec)

## Performance Reality Check (Free Tier 2-core/8GB)

| Task | Performance |
|------|-------------|
| Boot Windows | ~60-90 sec |
| Open Notepad | ~3-5 sec |
| Open Browser (Edge) | ~15-25 sec |
| File Explorer | OK |
| Heavy apps (Chrome, VS Code in Win) | Slow/laggy |

## Truly Lag-Free Alternatives (FREE)

### Oracle Cloud Free Tier (RECOMMENDED) 🚀

- **4 ARM cores + 24GB RAM + 200GB storage = FREE FOREVER**
- **Real KVM acceleration** (not TCG) = truly smooth Windows 10
- Setup guide: [Oracle Cloud Free Tier Setup](https://www.oracle.com/cloud/free/)

### Other Options

| Option | Cost | Performance | Setup |
|--------|------|-------------|-------|
| Oracle Cloud Free Tier | $0 forever | Smooth (KVM) | Medium |
| GitHub Codespaces Free | Free | Sluggish (TCG) | Easy (this repo) |
| GitHub Codespaces Pro ($4/mo) | Paid | Slightly better TCG | Easy |
| Hetzner CX22 | 4 EUR/mo | Smooth | Easy |

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

- **Tiny10 23H2** - Debloated Windows 10 (~3.5GB ISO)
- **QEMU TCG** - x86_64 software emulation (no KVM in Codespaces)
- **noVNC** - Browser-based VNC client
- **websockify** - VNC to WebSocket bridge

## Performance Tips

- Free tier = 2-core/2.5GB RAM allocated to Win10 (tight)
- Browser zoom out karo for better performance
- Avoid heavy apps - notepad/light apps best chalenge
- Be patient with installer (20-35 min)

## Troubleshooting

- **"You must select 16GB RAM for 4-core"**: Use 2-core/8GB machine (free tier max)
- **Port 6080 not showing**: Terminal me manually `bash scripts/start.sh` chalao
- **VNC blank screen**: 10-30 sec wait karo QEMU boot hone tak
- **Out of disk**: 32GB storage Codespace = tight. Cleanup commands:
  ```bash
  sudo apt-get clean && docker system prune -af
  ```
- **Very slow installer**: Normal hai on 2-core, 20-35 min lagega

## License

MIT