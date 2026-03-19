# Practice Platforms

Hands-on practice is essential for cybersecurity skills. These platforms provide legal, intentionally vulnerable targets.

---

## Beginner-Friendly

### TryHackMe
- **URL:** https://tryhackme.com
- **Cost:** Free tier available; Pro ~$14/month
- **Format:** Guided rooms with step-by-step instructions
- **Best for:** Complete beginners
- **Runs in browser** — no local setup needed (in-browser Kali VM)
- **Recommended learning paths:**
  - Pre-Security Path (networking, Linux, web fundamentals)
  - Jr Penetration Tester Path
  - SOC Level 1 Path

**Key rooms for this study plan:**
| Room | Topic | Study Plan |
|------|-------|-----------|
| Linux Fundamentals 1–3 | Linux basics | Month 0 |
| Nmap | Port scanning | Month 1 |
| Further Nmap | Advanced Nmap | Month 1 |
| Vulnerability Scanning | Nikto, OpenVAS | Month 3 |
| OWASP Top 10 | Web vulnerabilities | Month 4 |
| SQLMap | SQL injection | Month 4 |
| John the Ripper | Password cracking | Month 5 |
| WiFi Hacking 101 | Wireless attacks | Month 6 |
| Metasploit Intro | Exploitation | Month 7 |
| Wireshark 101 | Packet analysis | Month 8 |
| Linux PrivEsc | Privilege escalation | Month 9 |
| Windows PrivEsc | Windows privesc | Month 10 |

---

## Intermediate

### HackTheBox (HTB)
- **URL:** https://app.hackthebox.com
- **Cost:** Free tier (retired machines); VIP ~$14/month (all machines)
- **Format:** Unguided — figure it out yourself
- **Best for:** Intermediate to advanced
- **Starting Point** — guided beginner machines

**Progression:**
1. Start with **Starting Point** (guided intro machines)
2. Move to **Active Machines** (current, with community hints)
3. Solve **Retired Machines** with IppSec walkthroughs for learning
4. Try **Challenges** (forensics, web, crypto, reverse engineering)

### PentesterLab
- **URL:** https://pentesterlab.com
- **Cost:** Free exercises; Pro ~$20/month
- **Format:** Web application security courses with VMs
- **Excellent for:** Deep web app testing skills
- **Key courses:** Web for Pentester, SQL Injection, Code Review

---

## CTF Platforms

### PicoCTF
- **URL:** https://picoctf.org
- **Cost:** Free
- **Best for:** Beginners and intermediate
- **Topics:** Web, forensics, cryptography, reverse engineering, binary exploitation
- Great for learning CTF methodology

### CTFtime
- **URL:** https://ctftime.org
- **Cost:** Free
- Lists all upcoming CTF competitions worldwide
- Join a team or compete solo

### OverTheWire
- **URL:** https://overthewire.org/wargames/
- **Cost:** Free
- **SSH-based wargames** — each level is a puzzle
- **Recommended progression:**
  1. **Bandit** — Linux command line basics (Month 0)
  2. **Leviathan** — Linux escalation
  3. **Natas** — Web security
  4. **Krypton** — Cryptography
  5. **Narnia** — Binary exploitation

### HackTheBox Sherlocks
- **URL:** https://app.hackthebox.com/sherlocks
- Blue team / DFIR-focused challenges
- Great for forensics months of the study plan

---

## Specialized Platforms

### PortSwigger Web Security Academy
- **URL:** https://portswigger.net/web-security
- **Cost:** Free
- The best free resource for web application security
- Covers every OWASP vulnerability with labs
- Pairs perfectly with Burp Suite learning

### VulnHub
- **URL:** https://www.vulnhub.com
- **Cost:** Free (download VMs)
- Downloadable vulnerable VMs for local practice
- Good alternatives to Docker lab for full-system practice

### DVWA (Damn Vulnerable Web App)
- **URL:** https://github.com/digininja/DVWA
- **Cost:** Free
- Already included in the Docker lab at `http://172.20.0.20`
- Practice SQL injection, XSS, CSRF, file upload, command injection

### OWASP WebGoat
- **URL:** https://github.com/WebGoat/WebGoat
- **Cost:** Free
- Included in Docker lab
- Interactive lessons teaching web vulnerabilities

---

## Certification Practice

### OSCP (Offensive Security Certified Professional)
- **URL:** https://www.offsec.com/courses/pen-200/
- **Cost:** Starts at $1,499 (includes lab time + exam)
- The gold standard entry-level pentesting cert
- Prepare using: HTB, TryHackMe Jr Pentester path, TCM Security courses

### CompTIA Security+
- **URL:** https://www.comptia.org/certifications/security
- **Cost:** ~$392 exam
- Foundation-level security certification
- Good stepping stone before OSCP

### eJPT (eLearnSecurity Junior Penetration Tester)
- **URL:** https://ine.com/learning/certifications/internal/elearnsecurity-junior-penetration-tester-cert
- **Cost:** ~$200
- Beginner-friendly hands-on exam
- Good first cert after completing this study plan's first 3 months

---

## Local Lab Alternatives

| Option | Pros | Cons |
|--------|------|------|
| Docker Lab (this repo) | Fast, lightweight, scriptable | Limited OS diversity |
| VirtualBox VMs | Full OS, realistic | Slow, resource-heavy |
| VulnHub VMs | Purpose-built targets | Need VirtualBox/VMware |
| TryHackMe browser | No setup | Requires internet |
| Cloud VPS | Anywhere access | Small monthly cost |
