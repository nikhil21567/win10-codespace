# Tiny10 in Codespace - ZERO COMMANDS ✨

> **Bus Codespace kholo, port 6080 pe click karo, Tiny10 desktop mil jayega. NO commands, NO setup.**

## Kaise Use Karna Hai (3 Steps)

### Step 1: Codespace banao
- Yaha jaao: https://github.com/nikhil21567/win10-codespace
- **Code** button → **Codespaces** tab → **Create codespace on main**
- Machine: **2-core / 8GB RAM / 32GB storage** (free tier max)

### Step 2: Wait (2-3 min)
Codespace open hoga → sab kuch background me auto chalega:
- Tiny10 ISO download
- Virtual disk create
- noVNC server start
- QEMU launch
- Tiny10 boot

### Step 3: Tiny10 Desktop kholo
- **PORTS** tab pe jaao
- Port **6080** ke paas **"🖥️ Open Tiny10 Desktop"** label pe click karo
- Browser me Tiny10 desktop khulega! 🎯

**Bas. No commands. Sab automatic.**

---

## What Happens Behind the Scenes

Codespace open hote hi automatically:

```
postCreateCommand → init.sh
   ↓ (returns immediately)
   launches daemon.sh in background
       ↓ (runs forever)
       supervises auto.sh
           ↓ (idempotent)
           downloads ISO if missing
           creates disk if missing
           starts noVNC on port 6080
           launches QEMU
           if QEMU dies → auto.sh runs again
```

## First Time vs Next Time

| Boot | Result |
|------|--------|
| **First time** | Tiny10 installer appears (~15-25 min) |
| **Next time** | Direct desktop boot (30-45 sec) |

Install complete hone ke baad **Codespace stop kar do, phir restart karo** — desktop auto-boot hoga, no commands.

## Architecture

```
win10-codespace/
├── .devcontainer/
│   └── devcontainer.json    # Runs init.sh on create+start, port 6080
├── scripts/
│   ├── init.sh              # Background launcher (returns immediately)
│   ├── daemon.sh            # Forever-running supervisor
│   └── auto.sh              # Auto-boot Tiny10 (idempotent)
├── .gitignore
├── README.md (this file)
└── LICENSE (MIT)
```

## Troubleshooting

### Port 6080 nahi dikh raha (1+ min wait)
1. **PORTS** tab → **"+" Add Port** → type **6080**
2. Visibility: Public rakho
3. Label: "Tiny10" likh do

### "502 Bad Gateway" on port 6080
Codespace me tiny10.sh supervisor chal raha hai, lekin QEMU abhi boot ho rahi hai. 30-60 sec wait karo, page refresh karo.

### Tiny10 desktop blank hai
- 30-60 sec wait (QEMU boot time)
- Browser page refresh karo
- Tiny10 installer chal raha hoga first time

### Tiny10 nahi chala
1. **PORTS** tab me port 6080 ke URL copy karo
2. Browser me direct URL open karo (not port forwarding page)

## Performance

TCG mode (no KVM in Codespaces):
- Boot: 30-45 sec
- Notepad: 2-4 sec
- File Explorer: OK
- Browser in Tiny10: Laggy (avoid)
- Heavy apps: Hang (avoid)

Light apps like Notepad, Calculator, File Explorer smooth chalenge.

## Technical Details

- Tiny10 23H2 ISO (~2.5GB stripped Win10)
- QEMU TCG software emulation (no KVM)
- noVNC + websockify (browser VNC client)
- Background daemon with auto-restart
- Idempotent setup (safe to re-run)

## License

MIT

---

## ⭐ Useful Links

- Repo: https://github.com/nikhil21567/win10-codespace
- Codespace docs: https://docs.github.com/codespaces
- Tiny10 ISO: https://archive.org/details/tiny-10-23-h2