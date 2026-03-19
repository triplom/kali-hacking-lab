# Password Attacks Tools

> **Legal Notice:** Only use these tools on systems you own or have explicit written permission to test.

Password attacks include offline hash cracking, online brute forcing, credential stuffing, and dictionary attacks.

---

## Hashcat — GPU-Accelerated Hash Cracker

The fastest hash cracking tool available, leveraging GPU acceleration.

### Basic Usage

```bash
# Identify hash type (use hash-identifier first)
hash-identifier

# Dictionary attack (-a 0)
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt

# Brute force attack (-a 3)
hashcat -a 3 -m 0 hashes.txt ?a?a?a?a?a?a

# Combination attack (-a 1)
hashcat -a 1 -m 0 hashes.txt wordlist1.txt wordlist2.txt

# Rule-based attack
hashcat -a 0 -m 0 hashes.txt rockyou.txt -r /usr/share/hashcat/rules/best64.rule

# Show cracked passwords
hashcat -m 0 hashes.txt --show
```

### Common Hash Types (-m values)

| Hash | -m value |
|------|----------|
| MD5 | 0 |
| SHA1 | 100 |
| SHA256 | 1400 |
| SHA512 | 1700 |
| bcrypt | 3200 |
| NTLM | 1000 |
| NetNTLMv2 | 5600 |
| WPA2 | 22000 |
| Linux SHA512crypt | 1800 |

### Mask Charsets

| Charset | Characters |
|---------|-----------|
| ?l | lowercase a-z |
| ?u | uppercase A-Z |
| ?d | digits 0-9 |
| ?s | special chars |
| ?a | all above |

```bash
# Crack 8-char password: uppercase + lowercase + digits
hashcat -a 3 -m 0 hash.txt ?u?l?l?l?d?d?d?d

# Crack WPA2 handshake
hashcat -a 0 -m 22000 handshake.hccapx rockyou.txt
```

---

## John the Ripper — Versatile Password Cracker

```bash
# Auto-detect format and crack
john hashes.txt

# Specify format
john --format=md5 hashes.txt
john --format=sha512crypt /etc/shadow

# Dictionary attack
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Show cracked passwords
john --show hashes.txt

# Generate rules
john --wordlist=rockyou.txt --rules hashes.txt

# Crack zip password
zip2john archive.zip > zip.hash
john zip.hash

# Crack PDF password
pdf2john file.pdf > pdf.hash
john pdf.hash

# Crack SSH key passphrase
ssh2john id_rsa > ssh.hash
john ssh.hash --wordlist=rockyou.txt
```

---

## Hydra — Online Password Brute Forcer

```bash
# SSH brute force
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://192.168.1.10

# SSH with username list
hydra -L users.txt -P passwords.txt ssh://192.168.1.10

# FTP brute force
hydra -l admin -P rockyou.txt ftp://192.168.1.10

# HTTP POST form brute force
hydra -l admin -P rockyou.txt 192.168.1.10 http-post-form \
  "/login:username=^USER^&password=^PASS^:Invalid credentials"

# HTTP GET Basic Auth
hydra -l admin -P rockyou.txt http-get://192.168.1.10/protected/

# RDP brute force
hydra -l administrator -P rockyou.txt rdp://192.168.1.10

# MySQL brute force
hydra -l root -P rockyou.txt mysql://192.168.1.10

# Verbose output + stop on first valid
hydra -l admin -P rockyou.txt -V -f ssh://192.168.1.10

# Set threads
hydra -l admin -P rockyou.txt -t 16 ssh://192.168.1.10

# Docker lab targets
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://172.20.0.30
```

---

## Medusa — Parallel Network Login Auditor

```bash
# SSH brute force
medusa -h 192.168.1.10 -u admin -P rockyou.txt -M ssh

# Multiple hosts from file
medusa -H hosts.txt -u admin -P rockyou.txt -M ssh

# HTTP brute force
medusa -h 192.168.1.10 -u admin -P rockyou.txt -M http \
  -m DIR:/admin -m FORM:username=^USER^&password=^PASS^

# FTP
medusa -h 192.168.1.10 -u admin -P rockyou.txt -M ftp

# Set threads
medusa -h 192.168.1.10 -u admin -P rockyou.txt -M ssh -t 10
```

---

## CeWL — Custom Wordlist Generator

Generate wordlists from a website's content.

```bash
# Basic crawl
cewl http://target.com -w wordlist.txt

# Set depth
cewl http://target.com -d 3 -w wordlist.txt

# Minimum word length
cewl http://target.com -m 8 -w wordlist.txt

# Include email addresses
cewl http://target.com -e -w wordlist.txt

# Include numbers
cewl http://target.com -n -w wordlist.txt
```

---

## hash-identifier — Hash Type Identification

```bash
hash-identifier
# Paste hash at prompt, it will suggest the type

# Alternatively use hashid
hashid '$6$rounds=5000$usesomesalt$...'
hashid -m hash.txt   # also output hashcat mode
```

---

## Default Wordlists on Kali

```bash
# Most popular password list
/usr/share/wordlists/rockyou.txt.gz
# Unzip first:
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# SecLists (install separately)
sudo apt install seclists
ls /usr/share/seclists/

# Key SecLists wordlists
/usr/share/seclists/Passwords/Common-Credentials/10-million-password-list-top-100000.txt
/usr/share/seclists/Discovery/Web-Content/common.txt
/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
/usr/share/seclists/Usernames/Names/names.txt
```

---

## Resources
- [How to Crack Hashes with Hashcat](https://www.freecodecamp.org/news/hacking-with-hashcat-a-practical-guide/) — freeCodeCamp
- [How to Use Hydra](https://www.freecodecamp.org/news/how-to-use-hydra-pentesting-tutorial/) — freeCodeCamp
- [Hashcat Wiki](https://hashcat.net/wiki/)
- [TryHackMe — John the Ripper](https://tryhackme.com/room/johntheripper0)
