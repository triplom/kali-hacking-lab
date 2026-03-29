# Kali Linux Hacking Lab

> A complete, structured cybersecurity learning environment — tools reference, 13-month study plan, Docker lab, and curated free resources.

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
| [Study Plan](./study-plan/) | 13-month deep-dive curriculum, week-by-week |
| [Tools Reference](./tools-reference/) | 55+ tools explained by category |
| [Docker Lab](./docker-lab/) | Spin up 16 vulnerable containers in one command |
| [Resources](./resources/) | Courses, videos, practice platforms, lab guides |
| [Cheatsheets](./cheatsheets/) | Quick-reference command cards per tool |
| [Docs](./docs/) | PDFs of all guides |

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
./lab.sh start network    # Network/exploitation labs (includes Metasploitable 2)
./lab.sh status           # Check URLs and status
```

### 3. Pick your study month

```
Week 0      →  Prerequisites + Pentest Theory (Kill Chain, MITRE ATT&CK, PTES)
Month 1-2   →  Information Gathering (Nmap, hping3, Recon-ng, Amass, Shodan, dmitry...)
Month 3     →  Vulnerability Analysis (Nikto, OpenVAS, Nessus...)
Month 4     →  Web App Testing (Burp Suite, SQLmap, WPScan, ZAP...)
Month 5     →  Password Attacks (Hashcat, Hydra, John...)
Month 6     →  Wireless Attacks (Aircrack-ng, Wifite...)
Month 7     →  Exploitation (Metasploit, BeEF, SearchSploit...)
Month 8     →  Python for Hacking (Scapy, sockets, web assessment, wireless...)
Month 9     →  Sniffing & Spoofing (Wireshark, Responder...)
Month 10    →  Anonymity, OPSEC & Evasion (Tor, ProxyChains, Macchanger...)
Month 11    →  Digital Forensics (Autopsy, Volatility, Binwalk...)
Month 12    →  Reverse Engineering & Reporting (Ghidra, Dradis...)
Month 13    →  Capstone — Full Pentest + Bug Bounty
```

→ See the full [Study Plan](./study-plan/README.md)

---

## Learning Resources

### Primary Courses

| Resource | Language | Cost | Coverage |
|----------|----------|------|----------|
| [freeCodeCamp: Ethical Hacking with Kali Linux](https://www.freecodecamp.org/news/learn-cybersecurity-and-ethical-hacking-using-kali-linux/) | English | Free | Nmap, Aircrack-ng, Wireshark basics |
| [Udemy: Hacker Ético Profissional com Kali Linux v2025](https://www.udemy.com/course/hacker-etico-profissional/) | PT-BR | Paid | 241 lectures, 37 sections — full curriculum |
| [InfoSecLab Vulnerability Testing](https://pontocom.gitbook.io/infoseclab/vulntesting/intro) | PT-PT | Free | University lab guide — Metasploitable 2 |

### freeCodeCamp Course Mapping

| Course Section | Study Plan |
|----------------|------------|
| Basic Commands & Terminal | Prerequisites (Week 0) |
| Nmap — Scan Ports | Month 1: Information Gathering |
| Aircrack-ng, Monitor Mode | Month 6: Wireless Attacks |
| WPA2 Handshake Capture | Month 6: Wireless Attacks |
| De-auth Attacks | Month 6: Wireless Attacks |
| Wordlists & Dictionary Attacks | Month 5: Password Attacks |
| Wireshark Tutorial | Month 9: Sniffing & Spoofing |

### Udemy Course Mapping (Hacker Ético Profissional)

| Sections | Topic | Study Plan |
|---------|-------|------------|
| 1-3 | Lab Setup, Anonymity Intro, Kali | Week 0 |
| 4-5 | Information Gathering, OSINT | Month 1-2 |
| 6 | Metasploit | Month 7 |
| 7 | Bypass AV / Evasion | Month 10 |
| 8-9 | Vulnerability Analysis | Month 3 |
| 10 | Scanning (hping3) | Month 1-2 |
| 17 | Wireshark (attack analysis) | Month 9 |
| 18 | Tor, ProxyChains, Macchanger, Nipe | Month 10 |
| 19-27 | Python for Hacking (9 sections) | Month 8 |
| 36 | Bug Bounty | Month 13 |
| 37 | AI / ShellGPT integration | Month 13 |

→ Full mapping: [Resources / InfoSecLab](./resources/infoseclab/README.md)

---

## Docker Lab Overview

```
docker-lab/
├── docker-compose.yml     # 16 vulnerable containers
├── lab.sh                 # Lab manager (start/stop/reset/status)
├── kali-attacker.sh       # Isolated Kali attacker container
└── setup-wordlists.sh     # Wordlist setup helper
```

**Containers included:**

| Category | Containers |
|----------|-----------|
| Web App Testing | DVWA, WebGoat, Juice Shop, Mutillidae, WordPress |
| Network / Exploitation | Metasploitable2, Metasploitable3, SSH server, FTP server, Vulnerable API |
| Password Attacks | Hash challenge server |
| Forensics | Forensic file server |
| Reporting | Dradis, ntopng, notes server |

### Container Quick Reference

| Container | IP | Ports | Credentials | Tools |
|-----------|-----|-------|-------------|-------|
| DVWA | 10.10.0.10 | 8080 | admin/password | Burp, SQLmap, Nikto |
| WebGoat | 10.10.0.12 | 8081 | guest/guest | Burp, ZAP |
| Juice Shop | 10.10.0.13 | 3000 | auto-register | Burp, ffuf |
| Mutillidae | 10.10.0.14 | 8082 | admin/adminpass | Burp, SQLmap |
| WordPress | 10.10.0.15 | 8083 | admin/adminpass | WPScan, Hydra |
| **Metasploitable2** | **10.10.0.25** | 2220/SSH, 2121/FTP, 8090/HTTP | msfadmin/msfadmin | Nmap, Metasploit, OpenVAS |
| Metasploitable3 | 10.10.0.20 | 2222/SSH, 8084/HTTP | vagrant/vagrant | Metasploit, Nikto |
| Vulnerable SSH | 10.10.0.21 | 2223 | admin/password123 | Hydra, Medusa |
| Vulnerable API | 10.10.0.23 | 8086 | - | Burp, ffuf |
| Dradis | 10.10.0.50 | 3001 | setup on first run | Reporting |

→ Full instructions: [Docker Lab Guide](./docker-lab/README.md)

---

## Tools Covered (55+)

<details>
<summary><strong>Information Gathering</strong> — Nmap, hping3, Recon-ng, Maltego, theHarvester, Spiderfoot, Amass, dmitry, EyeWitness, Maigret, GooFuzz, Shodan, wafw00f, SNMP tools</summary>

See [tools-reference/01-information-gathering.md](./tools-reference/01-information-gathering.md)
</details>

<details>
<summary><strong>Vulnerability Analysis</strong> — Nikto, OpenVAS/GVM, Nessus, Legion, Lynis, Wapiti, WPScan, OpenSCAP</summary>

See [tools-reference/02-vulnerability-analysis.md](./tools-reference/02-vulnerability-analysis.md)
</details>

<details>
<summary><strong>Web Application Testing</strong> — Burp Suite, OWASP ZAP, SQLmap, WPScan, Gobuster, ffuf, Wfuzz, Dirb</summary>

See [tools-reference/03-web-application-attacks.md](./tools-reference/03-web-application-attacks.md)
</details>

<details>
<summary><strong>Password Attacks</strong> — John, Hashcat, Hydra, Medusa, CeWL, Crunch</summary>

See [tools-reference/04-password-attacks.md](./tools-reference/04-password-attacks.md)
</details>

<details>
<summary><strong>Wireless Attacks</strong> — Aircrack-ng, Kismet, Wifite, Fern, Bully</summary>

See [tools-reference/06-wireless-attacks.md](./tools-reference/06-wireless-attacks.md)
</details>

<details>
<summary><strong>Exploitation</strong> — Metasploit, BeEF, SearchSploit, RouterSploit, Commix</summary>

See [tools-reference/05-exploitation.md](./tools-reference/05-exploitation.md)
</details>

<details>
<summary><strong>Python for Hacking</strong> — socket, Scapy, requests, paramiko; port scanner, sniffer, brute-forcer, web fuzzer, wireless tools (NEW)</summary>

See [tools-reference/11-python-hacking.md](./tools-reference/11-python-hacking.md)
</details>

<details>
<summary><strong>Sniffing & Spoofing</strong> — Wireshark, Ettercap, Responder, Bettercap, tcpdump, Yersinia</summary>

See [tools-reference/07-sniffing-spoofing.md](./tools-reference/07-sniffing-spoofing.md)
</details>

<details>
<summary><strong>Anonymity & OPSEC</strong> — Tor, ProxyChains, Macchanger, Nipe, VPN, Veil (NEW)</summary>

See [tools-reference/12-anonymity-opsec.md](./tools-reference/12-anonymity-opsec.md)
</details>

<details>
<summary><strong>Digital Forensics</strong> — Autopsy, Volatility, Binwalk, Foremost, Sleuth Kit</summary>

See [tools-reference/08-post-exploitation.md](./tools-reference/08-post-exploitation.md)
</details>

<details>
<summary><strong>Reverse Engineering</strong> — Ghidra, Radare2, GDB, pwndbg, strace</summary>

See [tools-reference/09-forensics-reporting.md](./tools-reference/09-forensics-reporting.md)
</details>

<details>
<summary><strong>Reporting</strong> — CherryTree, Dradis, Faraday, Pipal</summary>

See [tools-reference/10-social-engineering-misc.md](./tools-reference/10-social-engineering-misc.md)
</details>

<details>
<summary><strong>Bug Bounty</strong> — Subfinder, Nuclei, ffuf, Amass, gau, waybackurls, httpx (NEW)</summary>

See [tools-reference/13-bug-bounty.md](./tools-reference/13-bug-bounty.md)
</details>

---

## Cheatsheets

| Tool | File |
|------|------|
| Nmap | [cheatsheets/nmap.md](./cheatsheets/nmap.md) |
| Metasploit | [cheatsheets/metasploit.md](./cheatsheets/metasploit.md) |
| Hydra | [cheatsheets/hydra.md](./cheatsheets/hydra.md) |
| SQLmap | [cheatsheets/sqlmap.md](./cheatsheets/sqlmap.md) |
| Hashcat | [cheatsheets/hashcat.md](./cheatsheets/hashcat.md) |
| Aircrack-ng | [cheatsheets/aircrack.md](./cheatsheets/aircrack.md) |
| Burp Suite | [cheatsheets/burpsuite.md](./cheatsheets/burpsuite.md) |
| hping3 (NEW) | [cheatsheets/hping3.md](./cheatsheets/hping3.md) |
| dmitry (NEW) | [cheatsheets/dmitry.md](./cheatsheets/dmitry.md) |

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
| [HackerOne](https://hackerone.com) | Real bug bounty | Free |
| [Bugcrowd](https://bugcrowd.com) | Real bug bounty | Free |

---

## Certifications Roadmap

```
Month 2  →  CompTIA Security+    (foundations)
Month 5  →  eJPT                 (entry-level pentest)
Month 9  →  PNPT                 (practical pentest)
Month 13 →  OSCP                 (industry gold standard)
```

---

## Related Projects

| Project | Relationship |
|---------|-------------|
| [python_learning](https://github.com/triplom/python_learning) | **Month 8 — Python for Hacking** directly uses Python scripting skills from this repo: socket programming, Scapy, web automation, wireless tools. Start with Modules 04–07 before Month 8. |
| [machine-learning-lab](https://github.com/triplom/machine-learning-lab) | **Threat intelligence** — ML anomaly detection (clustering, classification) and NLP log analysis techniques augment vulnerability analysis (Month 3) and sniffing/forensics (Month 9, 11) |
| [lpic3-study-lab](https://github.com/triplom/lpic3-study-lab) | **Deep security overlap** — LPIC-3 303 Security (cryptography, host security, network security, threat assessment) covers the same tools used here: `openssl`, `nmap`, `iptables`, `wireshark`, `metasploit` |
| [cka-study-lab](https://github.com/triplom/cka-study-lab) | **Container security** — Kubernetes NetworkPolicy, RBAC, and secrets management (CKA domains) are the defender's view of attack surfaces explored here in Month 7 (Exploitation) and Month 10 (OPSEC) |

---

## Legal Notice

> All vulnerable containers and exercises in this lab are for **educational purposes only**.  
> Only use these tools on systems you own or have **explicit written permission** to test.  
> Unauthorized access to computer systems is illegal.

---

## License

MIT © 2026 [@triplom](https://github.com/triplom)
