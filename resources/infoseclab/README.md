# InfoSecLab — Vulnerability Testing Guide

> **Source:** [https://pontocom.gitbook.io/infoseclab/vulntesting/intro](https://pontocom.gitbook.io/infoseclab/vulntesting/intro)  
> **Author:** ESTS — Escola Superior de Tecnologia de Setúbal (Polytechnic of Setúbal, Portugal)  
> **Language:** Portuguese (PT-PT)  
> **Type:** University lab guide for security testing

InfoSecLab is a practical cybersecurity lab guide from a Portuguese university. The vulnerability testing section provides structured, hands-on labs using real tools against Metasploitable 2, making it an excellent complement to the study plan.

---

## Why InfoSecLab

- **Structured methodology:** starts with theory (Cyber Kill Chain, PTES) before tools
- **Metasploitable 2 target:** same target across all labs — consistent environment
- **Step-by-step:** each page is a complete lab with exact commands and expected output
- **Free:** publicly accessible, no login required
- **Portuguese:** native resource for PT-BR/PT-PT learners

---

## Content Map — All Vulntesting Pages

### Theory & Methodology

| Page | URL | Study Plan Month |
|------|-----|-----------------|
| Introduction | [/intro](https://pontocom.gitbook.io/infoseclab/vulntesting/intro) | Week 0 (Foundations) |

The intro page covers:
- Cyber Kill Chain (7 steps)
- PTES phases
- Lab environment setup (VirtualBox + Metasploitable 2)
- Legal and ethical considerations

### Information Gathering (OSINT)

| Page | URL | Study Plan Month | Tools Covered |
|------|-----|-----------------|---------------|
| OSINT Overview | [/osint](https://pontocom.gitbook.io/infoseclab/vulntesting/osint) | Month 1-2 | General OSINT methodology |
| Shodan | [/shodan](https://pontocom.gitbook.io/infoseclab/vulntesting/shodan) | Month 1-2, Week 4 | Shodan CLI, web UI, dorks |
| Maltego | [/maltego](https://pontocom.gitbook.io/infoseclab/vulntesting/maltego) | Month 1-2, Week 4 | Transforms, link analysis |
| Recon-ng | [/recon-ng](https://pontocom.gitbook.io/infoseclab/vulntesting/recon-ng) | Month 1-2, Week 3 | Workspaces, modules, API keys |
| theHarvester | [/theharvester](https://pontocom.gitbook.io/infoseclab/vulntesting/theharvester) | Month 1-2, Week 3 | Email/subdomain harvesting |
| dmitry | [/dmitry](https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry) | Month 1-2, Week 3 | Full OSINT sweep |

### Scanning & Enumeration

| Page | URL | Study Plan Month | Tools Covered |
|------|-----|-----------------|---------------|
| Nmap Scanning | [/scanning](https://pontocom.gitbook.io/infoseclab/vulntesting/scanning) | Month 1-2, Week 1 | All Nmap scan types against MS2 |
| hping3 | [/hping3](https://pontocom.gitbook.io/infoseclab/vulntesting/hping3) | Month 1-2, Week 1 | Packet crafting, firewall testing |

### Vulnerability Analysis

| Page | URL | Study Plan Month | Tools Covered |
|------|-----|-----------------|---------------|
| OpenVAS | [/openvas](https://pontocom.gitbook.io/infoseclab/vulntesting/openvas) | Month 3, Week 2 | GVM setup, scan workflow, reports |
| Nessus | [/nessus](https://pontocom.gitbook.io/infoseclab/vulntesting/nessus) | Month 3, Week 3 | Essentials install, scan types |

---

## Lab Target: Metasploitable 2

InfoSecLab uses Metasploitable 2 as its primary lab target. This repo includes it in the Docker lab.

```
Container:  lab-metasploitable2
IP:         10.10.0.25
Hostname:   metasploitable.localdomain
```

### Starting Metasploitable 2

```bash
# Start the network/exploitation lab
cd docker-lab
./lab.sh start network

# Verify Metasploitable 2 is running
docker ps | grep metasploitable2
ping 10.10.0.25
```

### Known Services (Metasploitable 2)

| Port | Service | Version | Notable |
|------|---------|---------|---------|
| 21 | FTP | vsftpd 2.3.4 | BACKDOOR CVE-2011-2523 |
| 22 | SSH | OpenSSH 4.7p1 | Weak credentials |
| 23 | Telnet | Linux telnetd | Plaintext auth |
| 25 | SMTP | Postfix | VRFY user enum |
| 80 | HTTP | Apache 2.2.8 | DVWA, phpMyAdmin, tikiwiki |
| 139/445 | SMB | Samba 3.0.20 | Multiple exploits |
| 512-514 | r-services | rsh, rexec, rlogin | Legacy remote access |
| 1099 | Java RMI | - | Remote code exec |
| 3306 | MySQL | 5.0.51a | Root no password |
| 5432 | PostgreSQL | 8.3.7 | Default credentials |
| 6667 | IRC | UnrealIRCd 3.2.8.1 | BACKDOOR |
| 8009 | Tomcat AJP | Apache Tomcat | CVE-2020-1938 |
| 8180 | Tomcat HTTP | Apache Tomcat | admin/admin |

### Default Credentials

| Service | Username | Password |
|---------|----------|----------|
| SSH/login | msfadmin | msfadmin |
| MySQL | root | (no password) |
| PostgreSQL | postgres | postgres |
| Tomcat | admin | admin |
| phpMyAdmin | root | (no password) |
| DVWA | admin | password |

---

## Suggested Lab Sequence (Following InfoSecLab)

### Lab 1 — Discovery (Month 1, Week 1)

Following [Nmap scanning guide](https://pontocom.gitbook.io/infoseclab/vulntesting/scanning):

```bash
# Step 1: Host discovery
nmap -sn 10.10.0.0/24

# Step 2: Full port scan
nmap -sV -sC -O -p- -oN lab1-ms2-scan.txt 10.10.0.25

# Step 3: Vuln scripts
nmap --script vuln 10.10.0.25

# Step 4: Compare with hping3
hping3 -S --scan 1-1024 10.10.0.25
```

**Deliverable:** Completed port/service table for Metasploitable 2.

### Lab 2 — OSINT (Month 1, Week 3)

Following [theHarvester](https://pontocom.gitbook.io/infoseclab/vulntesting/theharvester), [dmitry](https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry), [Recon-ng](https://pontocom.gitbook.io/infoseclab/vulntesting/recon-ng) guides:

```bash
# For an in-scope public domain (e.g., a practice/bug bounty target):
theHarvester -d target.com -b all -l 200
dmitry -winsepfb target.com -o dmitry-report
recon-ng  # create workspace, load modules
```

### Lab 3 — OpenVAS Scan (Month 3, Week 2)

Following [OpenVAS guide](https://pontocom.gitbook.io/infoseclab/vulntesting/openvas):

```bash
sudo gvm-start
# Web UI: https://localhost:9392
# Create target: 10.10.0.25
# Create task: Full and Fast scan
# Review results: filter CVSS >= 7.0
# Export PDF report
```

**Deliverable:** PDF vulnerability report with CVE, CVSS, and remediation.

### Lab 4 — Nessus Scan (Month 3, Week 3)

Following [Nessus guide](https://pontocom.gitbook.io/infoseclab/vulntesting/nessus):

```bash
sudo systemctl start nessusd
# Web UI: https://localhost:8834
# New Scan → Basic Network Scan → 10.10.0.25
# Compare findings with OpenVAS
```

---

## Mapping to MITRE ATT&CK

| InfoSecLab Lab | MITRE ATT&CK |
|---------------|-------------|
| Nmap scanning | T1595 Active Scanning |
| theHarvester / dmitry OSINT | T1593 Search Open Websites |
| Shodan | T1596 Search Open Tech Databases |
| OpenVAS / Nessus | T1592 Gather Victim Host Info |
| hping3 firewall testing | T1595.001 Scanning IP Blocks |

---

## Quick Links

| Resource | URL |
|----------|-----|
| InfoSecLab Home | [pontocom.gitbook.io/infoseclab](https://pontocom.gitbook.io/infoseclab) |
| Vuln Testing Intro | [/vulntesting/intro](https://pontocom.gitbook.io/infoseclab/vulntesting/intro) |
| Nmap Guide | [/vulntesting/scanning](https://pontocom.gitbook.io/infoseclab/vulntesting/scanning) |
| hping3 Guide | [/vulntesting/hping3](https://pontocom.gitbook.io/infoseclab/vulntesting/hping3) |
| OSINT Overview | [/vulntesting/osint](https://pontocom.gitbook.io/infoseclab/vulntesting/osint) |
| Shodan | [/vulntesting/shodan](https://pontocom.gitbook.io/infoseclab/vulntesting/shodan) |
| Maltego | [/vulntesting/maltego](https://pontocom.gitbook.io/infoseclab/vulntesting/maltego) |
| Recon-ng | [/vulntesting/recon-ng](https://pontocom.gitbook.io/infoseclab/vulntesting/recon-ng) |
| theHarvester | [/vulntesting/theharvester](https://pontocom.gitbook.io/infoseclab/vulntesting/theharvester) |
| dmitry | [/vulntesting/dmitry](https://pontocom.gitbook.io/infoseclab/vulntesting/dmitry) |
| OpenVAS | [/vulntesting/openvas](https://pontocom.gitbook.io/infoseclab/vulntesting/openvas) |
| Nessus | [/vulntesting/nessus](https://pontocom.gitbook.io/infoseclab/vulntesting/nessus) |
