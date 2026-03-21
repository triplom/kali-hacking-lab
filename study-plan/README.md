# Study Plan — 12-Month Deep Dive

> Week-by-week curriculum to master every Kali Linux tool from scratch.

**Duration:** ~12 Months · **Approach:** Theory → Lab → CTF → Report  
**Prerequisites:** Basic Linux CLI, TCP/IP networking fundamentals, Python basics

---

## Roadmap

```
Month 1-2   →  Information Gathering
Month 3     →  Vulnerability Analysis
Month 4     →  Web Application Testing
Month 5     →  Password Attacks
Month 6     →  Wireless Attacks
Month 7     →  Exploitation
Month 8     →  Sniffing & Spoofing
Month 9     →  Digital Forensics
Month 10    →  Reverse Engineering
Month 11    →  Reporting & Integration
Month 12    →  Capstone — Full Pentest Simulation
```

---

## Week 0 — Prerequisites

Before starting, ensure you have:

- [ ] Kali Linux installed (bare metal, VM, or WSL)
- [ ] Docker + docker-compose set up (see [Docker Lab](../docker-lab/README.md))
- [ ] Comfortable with: `ls`, `cd`, `grep`, `cat`, `chmod`, `sudo`, pipes
- [ ] Basic networking: OSI model, TCP/IP, DNS, HTTP/S, subnetting

**Free resources to fill gaps:**
- [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) — Linux wargame
- [freeCodeCamp: Linux Basics for Hackers](https://www.freecodecamp.org/news/linux-basics/) — free article
- Professor Messer Network+ — free YouTube series
- [freeCodeCamp: Kali Linux Course](https://youtu.be/ug8W0sFiVJo) — covers terminal basics

**Girus warm-up labs (interactive, in-browser — no setup required):**

| Girus Lab ID | What it covers | Week 0 skill |
|-------------|----------------|-------------|
| `linux-comandos-basicos` | `ls`, `cd`, `cp`, `mv`, pipes, redirection | Core CLI fluency |
| `linux-permissoes-arquivos` | `chmod`, `chown`, SUID/SGID/sticky bit | File permissions |
| `linux-gerenciamento-processos` | `ps`, `kill`, `top`, signals, background jobs | Process management |
| `linux-monitoramento-sistema` | `ss`, `netstat`, `journalctl`, resource monitoring | Network and system monitoring |
| `docker-fundamentos` | `docker run`, `ps`, `stop`, `rm`, image lifecycle | Docker basics for the lab |

```bash
# Launch Girus and start with Linux basics
girus list clusters    # Confirm cluster is active
girus lab start linux-comandos-basicos
xdg-open http://localhost:8000
```

See [`docker-lab/girus-warmups.md`](../docker-lab/girus-warmups.md) for the full guided exercise guide.

---

## Month 1–2: Information Gathering

**Tools:** Nmap · Recon-ng · Maltego · theHarvester · Spiderfoot · Amass  
**Docker Lab:** `./lab.sh start web` then scan `10.10.0.0/24`

### Week 1–2: Nmap
- Scan types: `-sS`, `-sV`, `-sC`, `-O`, `-A`, `-p-`
- Timing: `-T0` to `-T5`; output: `-oN`, `-oX`, `-oG`
- NSE scripts: `--script=vuln`, `--script=http-title`
- **Lab:** Full scan of all Docker containers, document every service

### Week 3: theHarvester & Amass
- Passive vs active recon; OSINT sources: Shodan, crt.sh, Google Dorks
- **Lab:** Bug bounty target (in-scope) — enumerate subdomains and emails

### Week 4: Recon-ng & Maltego
- Recon-ng workspaces, modules, API keys
- Maltego entity relationships and transforms
- **Milestone:** Full recon report on a practice target using all 6 tools

**freeCodeCamp alignment:** The [Kali Linux course](https://youtu.be/ug8W0sFiVJo) covers Nmap port scanning directly in its "Introduction to Nmap" and "Scan Ports" sections.

---

## Month 3: Vulnerability Analysis

**Tools:** Nikto · OpenVAS · Legion · Lynis  
**Docker Lab:** `./lab.sh start web` — scan DVWA, Mutillidae, WordPress

### Week 1: Nikto
- Web server fingerprinting, dangerous files, CVE detection
- **Lab:** Scan all web containers, compare findings

### Week 2: OpenVAS / GVM
- CVE scoring (CVSS), authenticated vs unauthenticated scans
- **Lab:** Full scan of lab network, generate vulnerability report

### Week 3: Lynis & Legion
- System hardening audits with Lynis
- Semi-automated network scanning with Legion
- **Milestone:** Vulnerability assessment report with CVEs, CVSS scores, remediation

---

## Month 4: Web Application Testing

**Tools:** Burp Suite · OWASP ZAP · SQLmap · WPScan · Gobuster · ffuf · Wfuzz · Dirb  
**Docker Lab:** DVWA (8080), WebGoat (8081), Juice Shop (3000), WordPress (8083)

### Week 1: Burp Suite
- Proxy, Repeater, Intruder, Scanner
- OWASP Top 10 walkthrough on DVWA
- **Resource:** [PortSwigger Web Security Academy](https://portswigger.net/web-security) (free)

### Week 2: SQLmap & WPScan
- SQL injection enumeration and exploitation
- WordPress user/plugin/theme enumeration and brute-force

### Week 3: Content Discovery (Gobuster / ffuf / Wfuzz / Dirb)
- Directory and file fuzzing with wordlists
- DNS subdomain brute-forcing
- **Milestone:** Complete 10 PortSwigger labs: SQLi, XSS, CSRF, IDOR, SSRF

---

## Month 5: Password Attacks

**Tools:** John the Ripper · Hashcat · Hydra · Medusa · CeWL · Crunch  
**Docker Lab:** `./lab.sh start passwords` — crack hashes from hash server (port 8087)

### Week 1: John & Hashcat
- Hash identification, dictionary attacks, rule-based attacks
- GPU acceleration with Hashcat; CPU with John
- **Resource:** [freeCodeCamp: How to Crack Hashes with Hashcat](https://www.freecodecamp.org/news/hacking-with-hashcat-a-practical-guide/)

### Week 2: Hydra & Medusa
- SSH, FTP, HTTP form brute-force
- **Resource:** [freeCodeCamp: How to Use Hydra](https://www.freecodecamp.org/news/how-to-use-hydra-pentesting-tutorial/)
- **Lab:** Brute-force SSH container (port 2223) and WordPress (port 8083)

### Week 3: CeWL & Crunch
- Generate custom wordlists from target websites
- Pattern-based wordlist generation
- **Milestone:** Crack all hashes from a retired HTB machine

---

## Month 6: Wireless Attacks

**Tools:** Aircrack-ng · Kismet · Wifite · Fern WiFi Cracker · Bully  
**Requirement:** WiFi adapter with monitor mode (e.g., Alfa AWUS036ACH) + test AP

> **Note:** No Docker equivalent for wireless — requires real hardware. Set up a test AP with a known password.

### Week 1: Aircrack-ng Suite
- Monitor mode, packet capture, WPA2 handshake capture
- De-authentication attacks, dictionary cracking
- **freeCodeCamp alignment:** Entire wireless section of the [Kali course](https://youtu.be/ug8W0sFiVJo) maps directly here:
  - "Introduction to Aircrack-ng" ✓
  - "Monitor Mode vs Managed Mode" ✓
  - "Enable Monitor Mode" ✓
  - "Scan Wi-Fi Networks & Capture Traffic" ✓
  - "What is a 4-Way Handshake" ✓
  - "Capture 4-Way Handshake Using De-authentication Attack" ✓
  - "Wordlists & Dictionary Attacks" ✓
  - "Crack / Recover Wi-Fi Password" ✓
  - "Detect De-authentication Attacks" ✓
- **Resource:** [freeCodeCamp: Wi-Fi Hacking 101](https://www.freecodecamp.org/news/wi-fi-hacking-101/)

### Week 2: Wifite & Kismet
- Automated WPA/WEP/WPS attacks
- Passive wireless monitoring and IDS

### Week 3: Fern & Bully
- GUI-based auditing with Fern
- WPS PIN brute-force with Bully
- **Milestone:** Capture and crack a WPA2 handshake on your test AP

---

## Month 7: Exploitation

**Tools:** Metasploit Framework · BeEF · SearchSploit · RouterSploit · Commix  
**Docker Lab:** `./lab.sh start network` — Metasploitable3, SSH, FTP, API

### Week 1: Metasploit Framework
- Architecture: modules, payloads, encoders, post-exploitation
- Meterpreter shell, privilege escalation, persistence
- **Lab:** Exploit Metasploitable3 end-to-end

### Week 2: SearchSploit & BeEF
- Offline Exploit-DB search and customization
- Browser hooking and social engineering with BeEF

### Week 3: RouterSploit & Commix
- Embedded device exploitation
- Command injection automation
- **Milestone:** Full compromise chain: access → priv esc → persistence → evidence

---

## Month 8: Sniffing & Spoofing

**Tools:** Wireshark · Ettercap · Responder · Bettercap · tcpdump · Yersinia  
**Docker Lab:** Capture traffic on `docker0` interface while attacking lab containers

### Week 1: Wireshark & tcpdump
- Protocol analysis, filter syntax, credential capture
- **freeCodeCamp alignment:** "Wireshark Tutorial" section of the [Kali course](https://youtu.be/ug8W0sFiVJo) maps here ✓
- **Lab:** Analyze PCAPs from [PicoCTF](https://picoctf.org) challenges

### Week 2: Ettercap & Bettercap
- ARP poisoning, MITM, SSL stripping
- **Lab:** MITM against DVWA container, capture login credentials

### Week 3: Responder & Yersinia
- LLMNR/MDNS/NBT-NS poisoning, NTLM hash capture
- Layer 2 protocol attacks
- **Milestone:** Capture and crack credentials via MITM in lab

---

## Month 9: Digital Forensics

**Tools:** Autopsy · Volatility · Binwalk · Foremost · Sleuth Kit · bulk_extractor  
**Docker Lab:** `./lab.sh start forensics` — serve forensic images locally

### Week 1: Autopsy & Sleuth Kit
- Disk image analysis, timeline, deleted file recovery
- **Lab:** [CyberDefenders](https://cyberdefenders.org) disk forensics challenges

### Week 2: Volatility (Memory Forensics)
- Process listing, network connections, memory dumps, string analysis
- **Lab:** [MemLabs](https://github.com/stuxnet999/MemLabs) challenges

### Week 3: Binwalk & Foremost
- Firmware extraction, file carving, bulk feature extraction
- **Milestone:** Full investigation on a CyberDefenders challenge with written report

---

## Month 10: Reverse Engineering

**Tools:** Ghidra · Radare2 · GDB · pwndbg · strace / ltrace

### Week 1: GDB & pwndbg
- Dynamic analysis, breakpoints, stack inspection, exploit dev
- **Lab:** [pwn.college](https://pwn.college) — intro to binary exploitation

### Week 2: Ghidra
- Static analysis, decompilation, function renaming
- **Lab:** [crackmes.one](https://crackmes.one) — beginner crackmes

### Week 3: Radare2 & strace/ltrace
- CLI-based reverse engineering, visual mode
- System/library call tracing
- **Milestone:** Solve 5 RE challenges on [picoCTF](https://picoctf.org)

---

## Month 11: Reporting & Integration

**Tools:** CherryTree · Dradis · Faraday · Pipal  
**Docker Lab:** `./lab.sh start reporting` — Dradis at port 3001

### Week 1–2: Documentation Best Practices
- CherryTree node hierarchy for engagements
- Professional report structure: Executive Summary → Findings → Remediation

### Week 3–4: Dradis & Faraday
- Import Nmap XML, Burp XML, Nikto XML into Dradis
- Collaborative vulnerability tracking in Faraday
- **Milestone:** Document a full VulnHub engagement in Dradis

---

## Month 12: Capstone

Pick a complex retired HTB or VulnHub machine and perform a **complete penetration test**:

1. Scoping — define rules of engagement, targets, timeline
2. Reconnaissance — Nmap, theHarvester, Recon-ng, Amass
3. Vulnerability Analysis — Nikto, OpenVAS
4. Exploitation — Metasploit, SQLmap, Burp Suite, custom exploits
5. Post-Exploitation — privilege escalation, lateral movement, persistence
6. Evidence Collection — screenshots, hash dumps, proof.txt
7. Report — professional pentest report in Dradis with executive summary

---

## Weekly Schedule Template

| Day | Activity | Duration |
|-----|---------|---------|
| Monday | Theory & reading | 1–2 hrs |
| Tuesday | Tool practice in Docker lab | 2 hrs |
| Wednesday | CTF challenge / practice platform | 2 hrs |
| Thursday | Tool practice + CherryTree notes | 2 hrs |
| Friday | Review notes, write mini-report | 1 hr |
| Weekend | VulnHub / HTB machine | 3–4 hrs total |

---

## Certifications Roadmap

| Cert | Relevance | Target After |
|------|-----------|-------------|
| CompTIA Security+ | Foundations | Month 2 |
| eJPT (eLearnSecurity) | Entry pentest | Month 5 |
| PNPT (TCM Security) | Practical pentest | Month 8 |
| CEH | Broad coverage | Month 6 |
| OSCP (OffSec) | Industry gold standard | Month 12 |
