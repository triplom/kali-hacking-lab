# dmitry Cheatsheet

> **Legal Notice:** Use dmitry only on systems you own or have explicit written permission to test.

dmitry (Deepmagic Information Gathering Tool) is a self-contained OSINT tool that combines WHOIS lookups, subdomain enumeration, email harvesting, Netcraft queries, and basic TCP port scanning into a single command. No API keys required.

---

## Installation

```bash
sudo apt install dmitry   # pre-installed on Kali
```

---

## Basic Syntax

```bash
dmitry [options] target
```

`target` can be a domain name or IP address.

---

## Flag Reference

| Flag | Description |
|------|-------------|
| `-w` | WHOIS lookup on target domain |
| `-i` | WHOIS lookup on target IP (Arin/RIPE) |
| `-n` | Retrieve Netcraft.com information |
| `-s` | Perform subdomain search |
| `-e` | Perform email address search |
| `-p` | Perform TCP port scan |
| `-f` | Filter subdomains starting with "www" |
| `-b` | Banner grab on open TCP ports |
| `-t 0-9` | Set TTL for TCP scan (default: 2) |
| `-o file` | Save output to file |

---

## Common Usage

### Full Sweep (All Options)

```bash
# Run all OSINT modules
dmitry -winsepfb example.com

# Breakdown:
# -w  WHOIS domain
# -i  WHOIS IP
# -n  Netcraft
# -s  Subdomains
# -e  Emails
# -p  Port scan
# -f  Filter www subdomains
# -b  Banner grab
```

### WHOIS Only

```bash
# Domain WHOIS
dmitry -w example.com

# IP WHOIS (Arin lookup)
dmitry -i 192.168.1.10
```

### Subdomain Enumeration

```bash
# Search for subdomains
dmitry -s example.com

# With www-filter (exclude subdomains starting with www)
dmitry -sf example.com

# Combine with email harvesting
dmitry -se example.com
```

### Email Harvesting

```bash
# Harvest emails from WHOIS, Netcraft, and other sources
dmitry -e example.com

# Combined with WHOIS and Netcraft
dmitry -wne example.com
```

### Netcraft Information

```bash
# Get server history, hosting info, OS
dmitry -n example.com
```

### TCP Port Scan

```bash
# Basic TCP port scan
dmitry -p 192.168.1.10

# Port scan with banner grabbing
dmitry -pb 192.168.1.10

# Port scan with custom TTL (lower = faster, less reliable)
dmitry -p -t 1 192.168.1.10
```

### Save Output

```bash
# Save to file (auto-adds .txt if no extension)
dmitry -winsepfb example.com -o dmitry-report

# Explicit filename
dmitry -winsepfb example.com -o /tmp/dmitry-report.txt
```

---

## Practical Combinations

```bash
# Quick recon: WHOIS + subdomains + emails
dmitry -wse example.com

# Passive OSINT only (no scanning)
dmitry -wine example.com

# Active: port scan + banners
dmitry -pb 10.10.0.25

# Full recon + save report
dmitry -winsepfb example.com -o recon-report

# IP-based full scan (useful when you only have an IP)
dmitry -winsepfb 10.10.0.25
```

---

## dmitry vs Other Tools

| Feature | dmitry | theHarvester | Recon-ng | Nmap |
|---------|--------|--------------|----------|------|
| WHOIS | ✓ | ✗ | ✓ | ✗ |
| Subdomains | ✓ | ✓ | ✓ | ✗ |
| Email harvest | ✓ | ✓ | ✓ | ✗ |
| Port scan | ✓ | ✗ | ✗ | ✓ |
| Banner grab | ✓ | ✗ | ✗ | ✓ |
| API keys needed | No | Some | Some | No |
| Speed | Slow | Medium | Medium | Fast |
| Best for | Quick all-in-one | Email/subdomain | Deep recon | Scanning |

**Use dmitry when:** you want a quick, no-config, offline OSINT sweep on a domain.  
**Use theHarvester when:** you want more email/subdomain sources with API key integration.

---

## Lab Exercises

### Exercise 1: Domain OSINT

```bash
# Full OSINT on a public domain (in-scope only)
dmitry -winsepfb target.com -o target-recon.txt

# Review output:
# - WHOIS registrar, registration date, nameservers
# - Subdomains found
# - Email addresses associated with domain
# - Netcraft hosting history
```

### Exercise 2: Metasploitable 2 Scan

```bash
# Port scan + banner grab on Metasploitable 2
dmitry -pb 10.10.0.25

# Expected output:
# Port 21 open → banner: "220 (vsFTPd 2.3.4)"
# Port 22 open → banner: "SSH-2.0-OpenSSH_4.7p1"
# Port 23 open → telnet
# Port 25 open → "220 metasploitable.localdomain ESMTP Postfix"
# Port 80 open → Apache web server

# Compare with Nmap
nmap -sV -p 21,22,23,25,80 10.10.0.25
```

### Exercise 3: Subdomain + Email Harvest

```bash
# Find subdomains and emails for a bug bounty target (in-scope)
dmitry -se bugbounty-target.com

# Cross-reference with theHarvester
theHarvester -d bugbounty-target.com -b google,bing,crtsh
```

---

## Limitations

- Subdomain search relies on public search engine scraping — may miss subdomains
- TCP port scan is slow and basic (no version detection, no script scanning)
- No support for IPv6
- Email harvesting limited to public sources (WHOIS, web scraping)
- Netcraft queries can be rate-limited

**For deeper work:** use Nmap (port scanning), theHarvester/Amass (subdomains), and Maltego (visualization).

---

## Resources

- [InfoSecLab dmitry Guide](https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry)
- [dmitry Man Page](https://linux.die.net/man/1/dmitry)
- [dmitry Source Code](https://github.com/jaygreig86/dmitry)
