# Tiny10 (Lightweight Windows 10) in GitHub Codespace - FREE

> **NO KVM mode** - TCG software emulation use karta hai. Performance light hai, but boot hota hai reliably.

## Setup (One-time)

1. Repo pe jaake **Code -> Codespaces -> Create codespace on main**
2. Machine type: **2-core / 8GB RAM / 32GB storage** (free tier max)
3. Codespace open hone ke baad terminal me:
   ```bash
   bash scripts/setup.sh    # 1-2 min: ISO + disk download
   bash scripts/start.sh    # 30-60 sec: Tiny10 boot
   ```
4. **PORTS tab** me port `6080` ke globe icon pe click karo
5. Browser me **Tiny10 installer** khulega (halka wait 15-25 min)

## After Install

```bash
touch /workspaces/.windows/.installed
bash scripts/start.sh
```
Har baar 30-45 sec me Tiny10 boot hoga, smooth.

## Performance (Free Tier, TCG Mode)

| Task | Time | Status |
|------|------|--------|
| Win10 boot | 30-45 sec | OK |
| Notepad open | 2-4 sec | OK |
| File Explorer | OK | OK |
| Edge browser | 20-30 sec | Laggy |
| Heavy apps | Hang karenge | Avoid |

## Tips for Smoother Experience

1. **Boot fast karne ke liye**:
   - Tiny10 me Fast Startup ON karo (Control Panel -> Power Options)
   - Visual effects off karo (System Properties -> Advanced -> Performance)

2. **Lag kam karne ke liye**:
   - Browser me sirf noVNC use karo (Chrome/Edge open mat karo inside)
   - File operations minimal rakho

3. **Storage full hone pe**:
   ```bash
   sudo apt-get clean
   docker system prune -af
   rm -rf ~/.cache/*
   ```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Port 6080 not showing | `bash scripts/start.sh` manually chalao |
| VNC blank | 30-60 sec wait karo |
| BSOD | Disk delete karo: `rm /workspaces/.windows/disk.qcow2`, setup.sh phir se chalao |
| Install hang | Force restart: PORTS tab se kill karo, start.sh phir se chalao |

## Note

- **NO KVM** in Codespaces - TCG software emulation forced hai
- For true lag-free Windows 10, Oracle Cloud free tier (with KVM) is the only free option
- Tiny10 = ~2.5GB stripped Win10, runs on 1GB RAM min
- QEMU RAM allocation: 2GB (tight but works for basic apps)

## License

MIT