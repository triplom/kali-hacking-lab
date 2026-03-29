# Information Gathering Tools

> **Legal Notice:** Only use these tools on systems you own or have explicit written permission to test. Unauthorized scanning is illegal.

Information gathering (reconnaissance) is the first phase of any penetration test. The goal is to collect as much data as possible about the target before attempting any exploitation.

---

## Pentest Theory Foundations

Before using any tool, understand the frameworks that govern *why* and *when* each technique is applied.

### Cyber Kill Chain (Lockheed Martin)

| Step | Phase | Relevant Tools |
|------|-------|---------------|
| 1 | Reconnaissance | Nmap, theHarvester, Shodan, Recon-ng, dmitry |
| 2 | Weaponization | msfvenom, Veil, custom Python |
| 3 | Delivery | BeEF, phishing, USB drops |
| 4 | Exploitation | Metasploit, SQLmap, Burp Suite |
| 5 | Installation | Meterpreter persistence, cron jobs |
| 6 | Command & Control | Metasploit listeners, Python reverse shells |
| 7 | Actions on Objectives | Data exfil, ransomware sim, lateral movement |

### MITRE ATT&CK — Reconnaissance Tactics (TA0043)

Key techniques relevant to information gathering:

| Technique ID | Name | Tools |
|-------------|------|-------|
| T1595 | Active Scanning | Nmap, hping3, Masscan |
| T1592 | Gather Victim Host Info | Nmap -O, Netdiscover |
| T1593 | Search Open Websites/Domains | theHarvester, Google Dorks |
| T1596 | Search Open Technical Databases | Shodan, Censys, crt.sh |
| T1597 | Search Closed Sources | Maltego commercial transforms |
| T1598 | Phishing for Information | Social engineering |

Browse the full matrix at [attack.mitre.org/tactics/TA0043](https://attack.mitre.org/tactics/TA0043/)

### PTES — Intelligence Gathering Phase

PTES divides intelligence gathering into:
- **Passive** — no direct contact with target (OSINT, Shodan, GHDB, Maltego)
- **Active** — direct contact (Nmap scans, banner grabbing, zone transfers)

Full methodology: [http://www.pentest-standard.org/index.php/Intelligence_Gathering](http://www.pentest-standard.org/index.php/Intelligence_Gathering)

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/intro](https://pontocom.gitbook.io/infoseclab/vulntesting/intro)

---

## Nmap — Network Scanner

The most widely used network discovery and security auditing tool.

### Installation
Pre-installed on Kali Linux.

### Basic Usage

```bash
# Host discovery (ping scan)
nmap -sn 192.168.1.0/24

# Quick scan (top 1000 ports)
nmap 192.168.1.10

# Full port scan
nmap -p- 192.168.1.10

# Service/version detection
nmap -sV 192.168.1.10

# OS detection
nmap -O 192.168.1.10

# Aggressive scan (OS, version, scripts, traceroute)
nmap -A 192.168.1.10

# Scan with default scripts
nmap -sC 192.168.1.10

# UDP scan
nmap -sU 192.168.1.10

# Stealth SYN scan
nmap -sS 192.168.1.10

# Save output to file
nmap -oN output.txt 192.168.1.10
nmap -oX output.xml 192.168.1.10

# Scan speed (T1=slow/stealthy, T5=fast/loud)
nmap -T4 192.168.1.10

# Script categories
nmap --script vuln 192.168.1.10
nmap --script safe 192.168.1.10
nmap --script "http-*" 192.168.1.10
nmap --script smb-enum-shares 192.168.1.10
nmap --script smb-vuln-ms17-010 192.168.1.10  # EternalBlue check
```

### Docker Lab Targets

```bash
# Scan the entire lab network
nmap -sV -sC 10.10.0.0/24

# Scan Metasploitable 2 (InfoSecLab style)
nmap -sV -sC -O -p- 10.10.0.25
nmap --script vuln 10.10.0.25
```

### InfoSecLab Lab Exercise (Metasploitable 2)

```bash
# Step 1: Discover live hosts
nmap -sn 10.10.0.0/24

# Step 2: Full scan on Metasploitable 2
nmap -sV -sC -O -p- -oN metasploitable2-scan.txt 10.10.0.25

# Step 3: Run vuln scripts
nmap --script vuln -p 21,22,23,25,80,139,445,3306 10.10.0.25

# Expected open ports on Metasploitable 2:
# 21/tcp   vsftpd 2.3.4  (backdoor vulnerability!)
# 22/tcp   OpenSSH 4.7p1
# 23/tcp   telnet
# 25/tcp   Postfix SMTP
# 80/tcp   Apache 2.2.8
# 139/445  Samba 3.x (multiple exploits available)
# 3306/tcp MySQL 5.0.51a
# 5432/tcp PostgreSQL 8.3
```

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/scanning](https://pontocom.gitbook.io/infoseclab/vulntesting/scanning)

---

## hping3 — Raw Packet Crafting

hping3 is used for advanced port scanning, firewall testing, OS fingerprinting, and packet-level analysis. Unlike Nmap, it gives you full control over each packet field.

### Installation
Pre-installed on Kali Linux. If missing: `sudo apt install hping3`

### Basic Usage

```bash
# Default: TCP SYN to port 0
hping3 10.10.0.25

# TCP SYN scan on specific port (like Nmap -sS)
hping3 -S -p 80 10.10.0.25

# TCP ACK scan (bypass stateless firewalls)
hping3 -A -p 80 10.10.0.25

# UDP scan
hping3 --udp -p 53 10.10.0.25

# ICMP ping
hping3 --icmp 10.10.0.25

# Port range scan (increment port each packet)
hping3 -S --scan 1-1024 10.10.0.25

# OS fingerprinting via TTL and window size
hping3 -S -p 80 --tcp-timestamp 10.10.0.25

# Firewall rule testing — check if port is filtered vs closed
hping3 -S -p 22 10.10.0.25   # SYN/ACK = open, RST = closed, no reply = filtered

# Custom TTL (traceroute style)
hping3 --traceroute -V -1 10.10.0.25

# Send 3 packets and stop
hping3 -S -p 80 -c 3 10.10.0.25

# Set source port
hping3 -S -p 80 --baseport 1234 10.10.0.25

# Flood mode (DoS testing — lab only!)
hping3 --flood -S -p 80 10.10.0.25
```

### Comparison vs Nmap

| Use Case | Nmap | hping3 |
|----------|------|--------|
| Service detection | `nmap -sV` | Manual banner grab |
| Port scan | Automatic | Manual per port |
| Firewall test | `--packet-trace` | Fine-grained control |
| OS fingerprint | `-O` | TTL/window analysis |
| Packet crafting | Limited | Full control |
| DoS simulation | No | Yes (lab only) |

### Lab Exercise (InfoSecLab style)

```bash
# Compare hping3 vs Nmap on Metasploitable 2
nmap -sS -p 80 10.10.0.25         # Nmap SYN scan
hping3 -S -p 80 -c 3 10.10.0.25  # hping3 SYN — compare response flags

# Test firewall rules
hping3 -S -p 22 10.10.0.25  # SYN to SSH
hping3 -A -p 22 10.10.0.25  # ACK to SSH (different response = stateful FW)
```

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/hping3](https://pontocom.gitbook.io/infoseclab/vulntesting/hping3)

See also: [cheatsheets/hping3.md](../cheatsheets/hping3.md)

---

## Netdiscover — ARP Scanner

Passive/active ARP reconnaissance tool for local networks.

```bash
# Passive mode (just listen)
netdiscover -p

# Active scan a range
netdiscover -r 192.168.1.0/24

# Scan specific interface
netdiscover -i eth0 -r 192.168.1.0/24
```

---

## Masscan — Fastest Port Scanner

Can scan the entire internet in under 6 minutes. Use responsibly.

```bash
# Scan port 80 across a subnet
masscan 192.168.1.0/24 -p80

# Scan multiple ports
masscan 192.168.1.10 -p22,80,443,8080

# Rate limit (packets per second)
masscan 192.168.1.0/24 -p1-65535 --rate=1000
```

---

## Recon-ng — Web Reconnaissance Framework

Modular framework for web-based recon. Similar to Metasploit's structure.

```bash
recon-ng
# Inside recon-ng:
marketplace install all
workspaces create myproject
modules load recon/domains-hosts/hackertarget
options set SOURCE example.com
run

# Show results
show hosts
show contacts
```

**Useful modules:**
```
recon/domains-hosts/hackertarget        # subdomains via HackerTarget
recon/domains-hosts/certificate_transparency  # crt.sh SSL certs
recon/contacts-credentials/hibp         # HaveIBeenPwned lookup
recon/domains-companies/whois_org       # WHOIS company info
recon/hosts-hosts/bing_ip               # Bing reverse IP lookup
```

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/recon-ng](https://pontocom.gitbook.io/infoseclab/vulntesting/recon-ng)

---

## theHarvester — OSINT Email/Domain Tool

Gathers emails, subdomains, IPs from public sources (Google, Bing, LinkedIn, Shodan, crt.sh, etc.)

```bash
# Search using multiple sources
theHarvester -d example.com -b google,bing,linkedin

# Use all sources
theHarvester -d example.com -b all -l 200

# Save to HTML report
theHarvester -d example.com -b all -f output

# Specific sources useful for PT
theHarvester -d example.com -b shodan       # Shodan IPs
theHarvester -d example.com -b crtsh        # SSL certificate subdomains
theHarvester -d example.com -b linkedin     # Employee names
```

**Output includes:** emails, subdomains, IP addresses, virtual hosts, ASN info

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/theharvester](https://pontocom.gitbook.io/infoseclab/vulntesting/theharvester)

---

## dmitry — Deepmagic Information Gathering Tool

All-in-one OSINT tool: WHOIS, subdomains, email harvesting, Netcraft, TCP port scan.

### Installation
Pre-installed on Kali Linux.

### Usage

```bash
# Full sweep (all options)
dmitry -winsepfb example.com

# Options breakdown:
# -w  WHOIS lookup
# -i  Arin (IP WHOIS)
# -n  Netcraft (history, server info)
# -s  Subdomain search
# -e  Email harvesting
# -p  TCP port scan
# -f  Filter subdomains starting with www
# -b  Banner grabbing on open ports

# Just WHOIS + subdomains + emails
dmitry -wse example.com

# WHOIS + port scan with banner grabbing
dmitry -pb 10.10.0.25

# Save output to file
dmitry -winsepfb example.com -o dmitry-report.txt
```

**dmitry vs theHarvester:**
- `dmitry` — self-contained, no API keys, works offline, includes port scan
- `theHarvester` — more sources (Google, Bing, Shodan), requires API keys for full results

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry](https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry)

See also: [cheatsheets/dmitry.md](../cheatsheets/dmitry.md)

---

## Maltego — Visual Link Analysis

GUI-based OSINT and link analysis tool. Launch from Kali menu or:

```bash
maltego
```

Used for visualizing relationships between people, organizations, domains, IPs, emails, and social media profiles.

**Key transform categories:**
- Domain → IP, MX records, NS records, subdomains
- Person → email, phone, social media profiles
- IP → Netblock, ASN, BGP routing
- Email → LinkedIn, GitHub, breach data

**Free CE limitations:** 12 results per transform. Maltego One (paid) for unlimited.

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/maltego](https://pontocom.gitbook.io/infoseclab/vulntesting/maltego)

---

## DNSRecon — DNS Enumeration

```bash
# Standard enumeration
dnsrecon -d example.com

# Zone transfer attempt
dnsrecon -d example.com -t axfr

# Brute force subdomains
dnsrecon -d example.com -t brt -D /usr/share/wordlists/dnsmap.txt

# Reverse lookup range
dnsrecon -r 192.168.1.0/24

# Google enumeration
dnsrecon -d example.com -t goo
```

---

## Fierce — DNS Scanner

```bash
fierce --domain example.com
fierce --domain example.com --subdomains admin,mail,dev,test,api,vpn
```

---

## Sublist3r — Subdomain Enumeration

```bash
sublist3r -d example.com
sublist3r -d example.com -p 80,443 -e google,bing
sublist3r -d example.com -o subdomains.txt
```

---

## Amass — Advanced Subdomain Discovery

Amass is more thorough than Sublist3r — uses 50+ data sources including ASN lookups and certificate transparency.

```bash
# Passive enumeration
amass enum -passive -d example.com

# Active enumeration (DNS brute-force)
amass enum -active -d example.com -brute

# Save to JSON
amass enum -d example.com -json output.json

# Visualize results
amass viz -d example.com -dot
```

---

## Shodan CLI — Internet Device Search

Shodan indexes internet-connected devices. Essential for finding exposed services, default credentials, and unpatched systems.

### Setup
```bash
pip install shodan
shodan init YOUR_API_KEY   # free key at shodan.io
```

### Usage

```bash
# Search for services
shodan search "apache 2.4"
shodan search "port:22 country:US"
shodan search "port:22 country:PT"

# Search for vulnerable services
shodan search "has_vuln:true product:OpenSSH"
shodan search "vsftpd 2.3.4"           # backdoor version!

# Get host info
shodan host 8.8.8.8

# Count results
shodan count "webcam"
shodan count "Metasploitable"

# Download results
shodan download results "apache 2.4 country:PT" --limit 100
shodan parse results.json.gz --fields ip_str,port,org

# Find services by organization
shodan search "org:\"Vodafone Portugal\""

# Find cameras, printers, ICS
shodan search "webcam has_vuln:true"
shodan search "HP-ChaiSOE"              # HP printers
shodan search "port:502"                # Modbus (industrial)
```

### Shodan Dorks

```
ssl:"target.com"                        # find subdomains via SSL certs
http.title:"Dashboard"                  # admin dashboards
http.html:"<title>Login</title>"
"default password" country:BR
"MongoDB Server" -authentication
"Elasticsearch" port:9200
product:Kubernetes
```

**InfoSecLab reference:** [https://pontocom.gitbook.io/infoseclab/vulntesting/shodan](https://pontocom.gitbook.io/infoseclab/vulntesting/shodan)

---

## Google Dorks & GHDB

Google Hacking Database (GHDB) — curated list of dorks for finding sensitive information.

### Common Dork Operators

| Operator | Example | Effect |
|----------|---------|--------|
| `site:` | `site:example.com` | Limit to domain |
| `filetype:` | `filetype:pdf` | Specific file type |
| `intitle:` | `intitle:"index of"` | Page title match |
| `inurl:` | `inurl:admin` | URL contains string |
| `intext:` | `intext:"password"` | Page body match |
| `cache:` | `cache:example.com` | Google cached version |
| `link:` | `link:example.com` | Pages linking to target |

### Penetration Testing Dorks

```bash
# Find login panels
site:example.com inurl:login
site:example.com intitle:"admin login"
site:example.com inurl:"/wp-admin/"

# Find exposed files
site:example.com filetype:sql
site:example.com filetype:env
site:example.com filetype:cfg
site:example.com filetype:bak
site:example.com ext:log

# Find exposed directories
intitle:"index of" site:example.com
intitle:"index of" "parent directory"

# Find sensitive data
intext:"password" filetype:txt site:example.com
intext:"api_key" filetype:js site:example.com

# Find exposed cameras/devices
intitle:"webcamXP" "online"
inurl:"/view/index.shtml"

# Find phpMyAdmin
inurl:phpmyadmin
intitle:"phpMyAdmin" "Welcome to phpMyAdmin"
```

**GHDB:** [https://www.exploit-db.com/google-hacking-database](https://www.exploit-db.com/google-hacking-database)  
**GooFuzz** (automation): `goofuzz -d example.com -w /usr/share/wordlists/ghdb.txt`

---

## EyeWitness — Web Service Screenshot Tool

Takes screenshots of web services, RDP, and VNC. Useful for quickly reviewing large numbers of hosts.

```bash
# Install
sudo apt install eyewitness

# Screenshot all web services from Nmap XML
eyewitness --xml nmap-output.xml -d screenshots/

# Screenshot a URL list
eyewitness --web -f urls.txt -d screenshots/

# Screenshot with RDP
eyewitness --rdp --single rdp://192.168.1.10

# Screenshot with timeout
eyewitness --web -f urls.txt -d screenshots/ --timeout 10
```

Opens an HTML report grouping results by web server technology.

---

## Maigret — Username OSINT

Check if a username exists across 3000+ websites.

```bash
# Install
pip3 install maigret

# Search a username
maigret hacker_username

# Output to HTML report
maigret hacker_username --html report.html

# Search specific sites only
maigret hacker_username --site Twitter --site GitHub --site LinkedIn

# Multiple usernames
maigret -u usernames.txt
```

---

## wafw00f — WAF Detection

Detect Web Application Firewalls before scanning. WAFs block automated scanners and can get your IP banned.

```bash
# Detect WAF
wafw00f http://example.com

# Detect and show all WAF signatures tested
wafw00f -a http://example.com

# Multiple targets from file
wafw00f -i targets.txt

# Output to file
wafw00f http://example.com -o waf-output.txt -f json
```

**Common WAFs detected:** Cloudflare, ModSecurity, AWS WAF, Sucuri, Imperva, F5 BIG-IP

**If WAF detected:** use `--delay` in scanners, reduce scan intensity, try evasion techniques.

---

## SNMP Enumeration

SNMP (Simple Network Management Protocol) often leaks extensive system information when misconfigured with default community strings (`public`, `private`).

```bash
# Check if SNMP is running (port 161 UDP)
nmap -sU -p 161 10.10.0.25

# Walk the entire SNMP tree (v1, community string "public")
snmpwalk -c public -v1 10.10.0.25

# Walk with v2c
snmpwalk -c public -v2c 10.10.0.25

# Get specific OID — running processes
snmpwalk -c public -v2c 10.10.0.25 1.3.6.1.2.1.25.4.2.1.2

# Get specific OID — installed software
snmpwalk -c public -v2c 10.10.0.25 1.3.6.1.2.1.25.6.3.1.2

# Get network interfaces
snmpwalk -c public -v2c 10.10.0.25 1.3.6.1.2.1.2.2.1.2

# Use snmpenum for structured output
snmpenum 10.10.0.25 public linux.txt

# Brute-force community strings with Nmap
nmap -sU -p 161 --script=snmp-brute 10.10.0.25

# Enumerate with Metasploit
msfconsole -q -x "use auxiliary/scanner/snmp/snmp_enum; set RHOSTS 10.10.0.25; run"
```

**Key OIDs:**
| OID | Information |
|-----|-------------|
| `1.3.6.1.2.1.1.1.0` | System description |
| `1.3.6.1.2.1.1.5.0` | Hostname |
| `1.3.6.1.2.1.25.4.2.1.2` | Running processes |
| `1.3.6.1.2.1.25.6.3.1.2` | Installed packages |
| `1.3.6.1.2.1.4.20.1.1` | IP addresses |

**Metasploitable 2 — SNMP Lab:**
```bash
snmpwalk -c public -v1 10.10.0.25
# Should return extensive system info with default "public" community string
```

---

## SpiderFoot — Automated OSINT

```bash
# Web UI mode
spiderfoot -l 127.0.0.1:5001

# CLI mode — run all modules against a target
spiderfoot -s example.com -t INTERNET_NAME -o spiderfoot-report.csv
```

---

## Resources
- [InfoSecLab Vulnerability Testing](https://pontocom.gitbook.io/infoseclab/vulntesting/intro) — university lab guide
- [How to Discover Hidden Subdomains](https://www.freecodecamp.org/news/how-to-discover-hidden-subdomains-as-an-ethical-hacker/) — freeCodeCamp
- [Nmap Book (Free)](https://nmap.org/book/toc.html)
- [TryHackMe — Nmap Room](https://tryhackme.com/room/furthernmap)
- [MITRE ATT&CK Reconnaissance](https://attack.mitre.org/tactics/TA0043/)
- [Google Hacking Database](https://www.exploit-db.com/google-hacking-database)
- [Shodan Search Guide](https://help.shodan.io/the-basics/search-query-fundamentals)
- [Udemy: Hacker Ético Profissional — Sections 4-5](https://www.udemy.com/course/hacker-etico-profissional/)
