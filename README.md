# Tiny10 in Codespace - AUTO MODE ✨

> **Koi command nahi chalana. Bas Codespace kholo, Tiny10 ready ho jayega.**

## How to Use (3 Steps)

### 1️⃣ Codespace banao
- Repo page pe jaao → **Code** button → **Codespaces** tab → **Create codespace on main**
- Machine: **2-core / 8GB RAM / 32GB storage** (free tier max)

### 2️⃣ Wait (2-3 min)
- Codespace open hoga
- ISO + disk auto-download hoga
- QEMU auto-launch hoga
- Sab terminal me dikhega

### 3️⃣ Tiny10 Desktop kholo
- **PORTS** tab pe jaao
- Port **6080** ke paas **globe icon** pe click karo (ya **Open Tiny10 Desktop** label)
- Browser me Tiny10 desktop khulega 🎯

**That's it. No commands. No setup. Sab automatic.**

## First Time vs Next Time

| Boot | What Happens |
|------|--------------|
| **First time** | Tiny10 installer aayega (~15-25 min wait karo, install complete karo) |
| **Next time** | Direct Windows desktop boot (30-45 sec) |

Install complete hone ke baad desktop khula rahega, restart kar do bas. Codespace me stored hai sab.

## Features

- ✅ Auto ISO download
- ✅ Auto disk create
- ✅ Auto noVNC server start
- ✅ Auto QEMU launch
- ✅ Auto Windows boot
- ✅ TCG mode (no KVM needed)
- ✅ Lightweight (Tiny10 = 2.5GB stripped Win10)
- ✅ Browser-based desktop access

## Performance

TCG mode hai (no KVM), to expected performance:
- Boot: 30-45 sec
- Notepad: 2-4 sec
- File Explorer: OK
- Browser in Tiny10: Laggy (avoid)
- Heavy apps: Hang (avoid)

Light apps like Notepad, Calculator, File Explorer sab smooth chalenge.

## Troubleshooting

### Port 6080 nahi dikh raha
- Terminal me dekhna - "PORT TINGO" message aaya hoga
- PORTS tab me refresh karo (Ctrl+R)
- Ya "PORTS" ke neeche "Add Port" pe 6080 manually add karo

### Tiny10 nahi dikh raha
- 30-60 sec wait karo (QEMU boot time)
- Page refresh karo

### Codespace slow hai
- 2-core/8GB Codespace pe normal hai TCG mode
- Heavy apps avoid karo

### Disk full
- Codespace me 32GB storage = tight
- Codespace ko delete karke naya banao (free tier 30 din tak active)

## Technical

- Tiny10 23H2 ISO (~2.5GB)
- QEMU TCG mode (no KVM, software emulation)
- noVNC + websockify (browser VNC client)
- Ubuntu 22.04 base image

## License

MIT