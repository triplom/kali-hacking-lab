# Information Gathering Tools

> **Legal Notice:** Only use these tools on systems you own or have explicit written permission to test. Unauthorized scanning is illegal.

Information gathering (reconnaissance) is the first phase of any penetration test. The goal is to collect as much data as possible about the target before attempting any exploitation.

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
```

### Docker Lab Target
```bash
# Scan the entire lab network
nmap -sV -sC 172.20.0.0/24
```

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

Modular framework for web-based recon.

```bash
recon-ng
# Inside recon-ng:
marketplace install all
workspaces create myproject
modules load recon/domains-hosts/hackertarget
options set SOURCE example.com
run
```

---

## theHarvester — OSINT Email/Domain Tool

Gathers emails, subdomains, IPs from public sources.

```bash
# Search using multiple sources
theHarvester -d example.com -b google,bing,linkedin

# Limit results
theHarvester -d example.com -b all -l 200

# Save to HTML
theHarvester -d example.com -b all -f output
```

---

## Maltego — Visual Link Analysis

GUI-based OSINT and link analysis tool. Launch from Kali menu or:

```bash
maltego
```

Used for visualizing relationships between people, organizations, domains, IPs.

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
```

---

## Fierce — DNS Scanner

```bash
fierce --domain example.com
fierce --domain example.com --subdomains admin,mail,dev,test
```

---

## Sublist3r — Subdomain Enumeration

```bash
sublist3r -d example.com
sublist3r -d example.com -p 80,443 -e google,bing
sublist3r -d example.com -o subdomains.txt
```

---

## Shodan CLI — Internet Device Search

```bash
# Search for services
shodan search "apache 2.4"
shodan search "port:22 country:US"

# Get host info
shodan host 8.8.8.8

# Count results
shodan count "webcam"
```

---

## Resources
- [How to Discover Hidden Subdomains](https://www.freecodecamp.org/news/how-to-discover-hidden-subdomains-as-an-ethical-hacker/) — freeCodeCamp
- [Nmap Book (Free)](https://nmap.org/book/toc.html)
- [TryHackMe — Nmap Room](https://tryhackme.com/room/furthernmap)
