# Kali Linux Hacking Lab 🛡️

> A complete, structured cybersecurity learning environment — tools reference, 12-month study plan, Docker lab, and curated free resources.

**System:** Kali GNU/Linux Rolling 2026.1 · **Docker:** 27.5.1  
**Author:** [@triplom](https://github.com/triplom) · **Updated:** March 2026

---

## Girus Integration

Reinforce Linux and Docker fundamentals with **Girus** — a local, in-browser guided lab platform — before diving into the hacking tools.

```bash
# Verify Girus is running
girus list clusters

# Recommended warm-up labs (run before starting the Docker lab)
girus lab start linux-comandos-basicos        # Week 0 prerequisites
girus lab start linux-permissoes-arquivos      # File permissions (chmod, SUID)
girus lab start linux-gerenciamento-processos  # ps, kill, signals
girus lab start linux-monitoramento-sistema    # Monitoring, ss, netstat
girus lab start docker-fundamentos             # Docker basics for the Docker lab
girus lab start docker-gerenciamento-containers # Container management

xdg-open http://localhost:8000
```

See [`docker-lab/girus-warmups.md`](./docker-lab/girus-warmups.md) for full step-by-step exercises.

---

## What's Inside

| Section | Description |
|---------|-------------|
| [📚 Study Plan](./study-plan/) | 12-month deep-dive curriculum, week-by-week |
| [🔧 Tools Reference](./tools-reference/) | All 40+ Kali tools explained by category |
| [🐳 Docker Lab](./docker-lab/) | Spin up 15 vulnerable containers in one command |
| [📖 Resources](./resources/) | freeCodeCamp course, YouTube videos, practice platforms |
| [📋 Cheatsheets](./cheatsheets/) | Quick-reference command cards per tool |
| [📄 Docs](./docs/) | PDFs of all guides |

---

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/triplom/kali-hacking-lab.git
cd kali-hacking-lab
```

### 2. Start the Docker lab

```bash
cd docker-lab
./lab.sh start web        # Web application labs
./lab.sh status           # Check URLs and status
```

### 3. Pick your study month

```
Month 1-2   →  Information Gathering (Nmap, Recon-ng, Amass...)
Month 3     →  Vulnerability Analysis (Nikto, OpenVAS...)
Month 4     →  Web App Testing (Burp Suite, SQLmap, WPScan...)
Month 5     →  Password Attacks (Hashcat, Hydra, John...)
Month 6     →  Wireless Attacks (Aircrack-ng, Wifite...)
Month 7     →  Exploitation (Metasploit, BeEF, SearchSploit...)
Month 8     →  Sniffing & Spoofing (Wireshark, Responder...)
Month 9     →  Digital Forensics (Autopsy, Volatility, Binwalk...)
Month 10    →  Reverse Engineering (Ghidra, Radare2, GDB...)
Month 11    →  Reporting (Dradis, CherryTree, Faraday...)
Month 12    →  Capstone — Full Pentest Simulation
```

→ See the full [Study Plan](./study-plan/README.md)

---

## Docker Lab Overview

```
docker-lab/
├── docker-compose.yml     # 15 vulnerable containers
├── lab.sh                 # Lab manager (start/stop/reset/status)
├── kali-attacker.sh       # Isolated Kali attacker container
└── setup-wordlists.sh     # Wordlist setup helper
```

**Containers included:**

| Category | Containers |
|----------|-----------|
| Web App Testing | DVWA, WebGoat, Juice Shop, Mutillidae, WordPress |
| Network / Exploitation | Metasploitable3, SSH server, FTP server, Vulnerable API |
| Password Attacks | Hash challenge server |
| Forensics | Forensic file server |
| Reporting | Dradis, ntopng, notes server |

→ Full instructions: [Docker Lab Guide](./docker-lab/README.md)

---

## freeCodeCamp Course Coverage

The [freeCodeCamp Ethical Hacking with Kali Linux](https://www.freecodecamp.org/news/learn-cybersecurity-and-ethical-hacking-using-kali-linux/) course (4h, free on YouTube) covers:

| Course Section | Mapped to Study Plan |
|----------------|----------------------|
| Basic Commands & Terminal | Prerequisites (Week 0) |
| Nmap — Scan Ports | Month 1: Information Gathering |
| Aircrack-ng, Monitor Mode | Month 6: Wireless Attacks |
| WPA2 Handshake Capture | Month 6: Wireless Attacks |
| De-auth Attacks | Month 6: Wireless Attacks |
| Wordlists & Dictionary Attacks | Month 5: Password Attacks |
| Wireshark Tutorial | Month 8: Sniffing & Spoofing |

→ Full analysis: [Resources / freeCodeCamp](./resources/freecodecamp/README.md)

---

## Tools Covered (40+)

<details>
<summary><strong>Information Gathering</strong> — Nmap, Recon-ng, Maltego, theHarvester, Spiderfoot, Amass</summary>

See [tools-reference/01-information-gathering.md](./tools-reference/01-information-gathering.md)
</details>

<details>
<summary><strong>Vulnerability Analysis</strong> — Nikto, OpenVAS, Legion, Lynis</summary>

See [tools-reference/02-vulnerability-analysis.md](./tools-reference/02-vulnerability-analysis.md)
</details>

<details>
<summary><strong>Web Application Testing</strong> — Burp Suite, OWASP ZAP, SQLmap, WPScan, Gobuster, ffuf, Wfuzz, Dirb</summary>

See [tools-reference/03-web-application.md](./tools-reference/03-web-application.md)
</details>

<details>
<summary><strong>Password Attacks</strong> — John, Hashcat, Hydra, Medusa, CeWL, Crunch</summary>

See [tools-reference/04-password-attacks.md](./tools-reference/04-password-attacks.md)
</details>

<details>
<summary><strong>Wireless Attacks</strong> — Aircrack-ng, Kismet, Wifite, Fern, Bully</summary>

See [tools-reference/05-wireless.md](./tools-reference/05-wireless.md)
</details>

<details>
<summary><strong>Exploitation</strong> — Metasploit, BeEF, SearchSploit, RouterSploit, Commix</summary>

See [tools-reference/06-exploitation.md](./tools-reference/06-exploitation.md)
</details>

<details>
<summary><strong>Sniffing & Spoofing</strong> — Wireshark, Ettercap, Responder, Bettercap, tcpdump</summary>

See [tools-reference/07-sniffing-spoofing.md](./tools-reference/07-sniffing-spoofing.md)
</details>

<details>
<summary><strong>Digital Forensics</strong> — Autopsy, Volatility, Binwalk, Foremost, Sleuth Kit</summary>

See [tools-reference/08-forensics.md](./tools-reference/08-forensics.md)
</details>

<details>
<summary><strong>Reverse Engineering</strong> — Ghidra, Radare2, GDB, pwndbg, strace</summary>

See [tools-reference/09-reverse-engineering.md](./tools-reference/09-reverse-engineering.md)
</details>

<details>
<summary><strong>Reporting</strong> — CherryTree, Dradis, Faraday, Pipal</summary>

See [tools-reference/10-reporting.md](./tools-reference/10-reporting.md)
</details>

---

## Practice Platforms

| Platform | Type | Cost |
|----------|------|------|
| [TryHackMe](https://tryhackme.com) | Guided labs | Free/Paid |
| [Hack The Box](https://hackthebox.com) | CTF machines | Free/Paid |
| [VulnHub](https://vulnhub.com) | Offline VMs | Free |
| [PortSwigger Academy](https://portswigger.net/web-security) | Web app labs | Free |
| [picoCTF](https://picoctf.org) | CTF challenges | Free |
| [pwn.college](https://pwn.college) | Binary exploitation | Free |
| [CyberDefenders](https://cyberdefenders.org) | Blue team/forensics | Free/Paid |

---

## Certifications Roadmap

```
Month 2  →  CompTIA Security+    (foundations)
Month 5  →  eJPT                 (entry-level pentest)
Month 8  →  PNPT                 (practical pentest)
Month 12 →  OSCP                 (industry gold standard)
```

---

## Legal Notice

> All vulnerable containers and exercises in this lab are for **educational purposes only**.  
> Only use these tools on systems you own or have **explicit written permission** to test.  
> Unauthorized access to computer systems is illegal.

---

## License

MIT © 2026 [@triplom](https://github.com/triplom)
